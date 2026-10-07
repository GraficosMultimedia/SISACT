<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

/**
 * Utilidades del módulo Colibrí Print.
 * Las consultas a las tablas propias del módulo son dinámicas para tolerar
 * instalaciones que todavía tengan columnas antiguas.
 */
function print_allowed_tables(): array {
    return [
        'cp_print_sizes',
        'cp_print_materials',
        'cp_print_finishes',
        'cp_print_price_rules',
        'cp_print_request_items',
        'cp_web_quote_files',
        'cp_web_quote_requests',
    ];
}

function print_table_columns(string $table): array {
    static $cache = [];
    if (!in_array($table, print_allowed_tables(), true)) return [];
    if (isset($cache[$table])) return $cache[$table];

    try {
        $rows = db()->query('SHOW COLUMNS FROM `' . $table . '`')->fetchAll();
    } catch (Throwable $e) {
        return $cache[$table] = [];
    }

    $out = [];
    foreach ($rows as $row) {
        $field = (string)($row['Field'] ?? '');
        if ($field !== '') $out[$field] = $row;
    }
    return $cache[$table] = $out;
}

function print_table_has_column(string $table, string $column): bool {
    return isset(print_table_columns($table)[$column]);
}

function print_catalog_query(string $table, array $select): string {
    $cols = print_table_columns($table);
    if (!$cols) return '';

    $safe = [];
    foreach ($select as $column) {
        if (isset($cols[$column])) $safe[] = '`' . $column . '`';
    }
    if (!$safe) return '';

    $sql = 'SELECT ' . implode(',', $safe) . ' FROM `' . $table . '`';
    if (isset($cols['enabled'])) $sql .= ' WHERE `enabled`=1';

    $order = [];
    if (isset($cols['sort_order'])) $order[] = '`sort_order` ASC';
    if (isset($cols['name'])) $order[] = '`name` ASC';
    elseif (isset($cols['id'])) $order[] = '`id` ASC';
    if ($order) $sql .= ' ORDER BY ' . implode(',', $order);
    return $sql;
}

function print_price_catalog(): array {
    $catalog = ['sizes'=>[],'materials'=>[],'finishes'=>[]];
    foreach ([
        'sizes'=>['cp_print_sizes',['id','name','width_mm','height_mm','orientation']],
        'materials'=>['cp_print_materials',['id','name','unit_label']],
        'finishes'=>['cp_print_finishes',['id','name']],
    ] as $key => [$table,$select]) {
        $sql = print_catalog_query($table,$select);
        if ($sql !== '') {
            try { $catalog[$key] = db()->query($sql)->fetchAll(); } catch (Throwable $e) {}
        }
    }
    return $catalog;
}


function print_default_options(array $catalog): array {
    $defaults = [
        'size_id' => $catalog['sizes'][0]['id'] ?? '',
        'material_id' => $catalog['materials'][0]['id'] ?? '',
        'finish_id' => '',
        'color_mode' => 'color',
        'print_sides' => 'single',
        'copies' => 1,
    ];

    foreach ($catalog['finishes'] as $finish) {
        if (mb_strtolower(trim((string)($finish['name'] ?? ''))) === 'sin acabado') {
            $defaults['finish_id'] = $finish['id'];
            break;
        }
    }
    if ($defaults['finish_id'] === '' && !empty($catalog['finishes'])) {
        $defaults['finish_id'] = $catalog['finishes'][0]['id'];
    }

    try {
        $cols = print_table_columns('cp_print_price_rules');
        if (!isset($cols['id'], $cols['unit_price'])) return $defaults;

        $where = [];
        if (isset($cols['enabled'])) $where[] = 'enabled=1';
        if (isset($cols['service_type'])) $where[] = "(service_type='impresion' OR service_type='' OR service_type IS NULL)";
        $sql = 'SELECT * FROM cp_print_price_rules';
        if ($where) $sql .= ' WHERE ' . implode(' AND ', $where);
        $sql .= ' ORDER BY id ASC LIMIT 20';
        $rules = db()->query($sql)->fetchAll();

        foreach ($rules as $rule) {
            if (!empty($rule['size_id'])) $defaults['size_id'] = (int)$rule['size_id'];
            if (!empty($rule['material_id'])) $defaults['material_id'] = (int)$rule['material_id'];
            if (!empty($rule['finish_id'])) $defaults['finish_id'] = (int)$rule['finish_id'];
            if (isset($rule['color_mode']) && in_array($rule['color_mode'], ['color','bw'], true)) $defaults['color_mode'] = $rule['color_mode'];
            break;
        }
    } catch (Throwable $e) {}

    return $defaults;
}

function print_find_price(array $data): ?array {
    try {
        $cols = print_table_columns('cp_print_price_rules');
        if (!$cols || !isset($cols['id'], $cols['unit_price'])) return null;

        $where = [];
        if (isset($cols['enabled'])) $where[] = '`enabled`=1';
        $sql = 'SELECT * FROM `cp_print_price_rules`';
        if ($where) $sql .= ' WHERE '.implode(' AND ', $where);
        $sql .= ' ORDER BY `id` ASC LIMIT 500';
        $rules = db()->query($sql)->fetchAll();

        $wantedColor = (string)($data['color_mode'] ?? 'color');
        $wanted = [
            'size_id' => (($data['size_id'] ?? '') !== '') ? (int)$data['size_id'] : null,
            'material_id' => (($data['material_id'] ?? '') !== '') ? (int)$data['material_id'] : null,
            'finish_id' => (($data['finish_id'] ?? '') !== '') ? (int)$data['finish_id'] : null,
        ];

        $matches = [];
        foreach ($rules as $rule) {
            if (isset($cols['service_type'])) {
                $service = strtolower(trim((string)($rule['service_type'] ?? '')));
                if ($service !== '' && $service !== 'impresion') continue;
            }
            if (isset($cols['service_key'])) {
                $serviceKey = strtolower(trim((string)($rule['service_key'] ?? '')));
                if ($serviceKey !== '' && !in_array($serviceKey, ['document','impresion'], true)) continue;
            }

            $ruleColor = strtolower(trim((string)($rule['color_mode'] ?? '')));
            if ($ruleColor !== '' && $ruleColor !== 'both' && $ruleColor !== $wantedColor) continue;

            $score = 0;
            $valid = true;
            foreach (['size_id','material_id','finish_id'] as $field) {
                if (!isset($cols[$field])) continue;
                $rv = isset($rule[$field]) && $rule[$field] !== '' ? (int)$rule[$field] : 0;
                $wv = $wanted[$field];
                if ($rv === 0) continue;
                if ($wv === null || $rv !== $wv) { $valid = false; break; }
                $score += 10;
            }
            if (!$valid) continue;
            if ($ruleColor !== '' && $ruleColor !== 'both') $score += 5;
            if ($ruleColor === 'both' || $ruleColor === '') $score += 1;
            $matches[] = ['score'=>$score,'min'=>(float)($rule['min_quantity'] ?? 1),'sort'=>(int)($rule['sort_order'] ?? 0),'id'=>(int)$rule['id'],'rule'=>$rule];
        }

        if (!$matches) return null;
        usort($matches, function($a,$b){
            return ($b['score'] <=> $a['score']) ?: (($a['min'] <=> $b['min']) ?: (($a['sort'] <=> $b['sort']) ?: ($a['id'] <=> $b['id'])));
        });
        $rule = $matches[0]['rule'];

        if (isset($cols['size_id'])) {
            $st = db()->prepare('SELECT name,width_mm,height_mm FROM cp_print_sizes WHERE id=? LIMIT 1');
            $st->execute([(int)($rule['size_id'] ?? 0)]);
            if ($r=$st->fetch()) { $rule['size_name']=$r['name']; $rule['width_mm']=$r['width_mm']; $rule['height_mm']=$r['height_mm']; }
        }
        if (isset($cols['material_id'])) {
            $st = db()->prepare('SELECT name FROM cp_print_materials WHERE id=? LIMIT 1');
            $st->execute([(int)($rule['material_id'] ?? 0)]);
            if ($r=$st->fetch()) $rule['material_name']=$r['name'];
        }
        if (isset($cols['finish_id'])) {
            $st = db()->prepare('SELECT name FROM cp_print_finishes WHERE id=? LIMIT 1');
            $st->execute([(int)($rule['finish_id'] ?? 0)]);
            if ($r=$st->fetch()) $rule['finish_name']=$r['name'];
        }
        return $rule;
    } catch (Throwable $e) {
        return null;
    }
}

/**
 * Cuenta páginas de un PDF.
 * 1) pdfinfo, si está disponible en el servidor.
 * 2) Conteo de objetos /Type /Page como respaldo.
 * Para imágenes, una imagen equivale a una página.
 */
function print_count_pdf_pages(string $path): int {
    if (!is_file($path)) throw new RuntimeException('No se encontró el PDF para contar sus páginas.');
    $fh = fopen($path,'rb');
    if (!$fh) throw new RuntimeException('No se pudo leer el PDF.');
    $head = fread($fh, 8);
    fclose($fh);
    if ($head === false || strpos($head,'%PDF-') !== 0) {
        throw new RuntimeException('El archivo PDF no parece ser válido.');
    }

    $pdfinfo = trim((string)@shell_exec('command -v pdfinfo 2>/dev/null'));
    if ($pdfinfo !== '') {
        $cmd = escapeshellcmd($pdfinfo).' '.escapeshellarg($path).' 2>/dev/null';
        $out = (string)@shell_exec($cmd);
        if (preg_match('/^Pages:\s*(\d+)/mi',$out,$m)) {
            $n=(int)$m[1];
            if ($n>0) return $n;
        }
    }

    $data = @file_get_contents($path);
    if ($data !== false) {
        $count=0;
        if (preg_match_all('/\/Type\s*\/Page\b/i',$data,$m)) $count=count($m[0]);
        if ($count>0) return $count;

        if (preg_match_all('/\/Count\s+(\d+)/i',$data,$m)) {
            $max=0;
            foreach ($m[1] as $v) $max=max($max,(int)$v);
            if ($max>0) return $max;
        }
    }

    throw new RuntimeException('No fue posible determinar cuántas páginas tiene el PDF. Puedes solicitar revisión manual.');
}

function print_count_uploaded_pages(string $path, string $ext): int {
    return strtolower($ext)==='pdf' ? print_count_pdf_pages($path) : 1;
}

function print_billable_units(array $data, int $pageCount): array {
    $copies=max(1,(int)($data['copies'] ?? $data['quantity'] ?? 1));
    $sides=(string)($data['print_sides'] ?? 'single');
    $sides=in_array($sides,['single','double'],true)?$sides:'single';
    $effectivePages=max(1,$pageCount)*$copies;
    $sheets=$sides==='double' ? (int)ceil($effectivePages/2) : $effectivePages;

    $mode=(string)($data['pricing_mode'] ?? 'page');
    if (!in_array($mode,['page','sheet','piece','unit'],true)) $mode='page';

    $units = match($mode) {
        'sheet' => $sheets,
        'piece','unit' => $copies,
        default => $effectivePages,
    };

    return [
        'copies'=>$copies,
        'page_count'=>max(1,$pageCount),
        'print_sides'=>$sides,
        'sheet_count'=>$sheets,
        'billable_units'=>$units,
        'pricing_mode'=>$mode,
    ];
}

function print_calculate(array $data, ?int $pageCount=null): array {
    $pageCount=max(1,(int)($pageCount ?? ($data['page_count'] ?? 1)));
    $rule=print_find_price($data);

    if (!$rule) {
        return [
            'ok'=>false,'message'=>'No existe una tarifa configurada para esta combinación.',
            'page_count'=>$pageCount,'copies'=>max(1,(int)($data['copies'] ?? $data['quantity'] ?? 1)),
            'unit_price'=>0,'billable_units'=>0,'subtotal'=>0,'pricing_mode'=>'page'
        ];
    }

    $calc=print_billable_units([
        'copies'=>$data['copies'] ?? $data['quantity'] ?? 1,
        'print_sides'=>$data['print_sides'] ?? 'single',
        'pricing_mode'=>$rule['pricing_mode'] ?? ($rule['price_type'] ?? 'page'),
    ],$pageCount);

    $minQuantity=max(1,(float)($rule['min_quantity'] ?? 1));
    $unit=(float)($rule['unit_price'] ?? 0);

    if ($calc['billable_units'] < $minQuantity) {
        return array_merge($calc,[
            'ok'=>false,
            'message'=>'La cantidad mínima para esta tarifa es '.$minQuantity.'.',
            'unit_price'=>$unit,'subtotal'=>0,'rule'=>$rule
        ]);
    }

    return array_merge($calc,[
        'ok'=>true,
        'message'=>'OK',
        'unit_price'=>$unit,
        'subtotal'=>round($unit*$calc['billable_units'],2),
        'rule'=>$rule
    ]);
}

function print_calculate_files(array $options): array {
    $items=[];
    $total=0;
    $pages=0;
    $sheets=0;

    foreach ($options as $index=>$data) {
        if (!is_array($data)) continue;
        $pc=max(1,(int)($data['page_count'] ?? 1));
        $calc=print_calculate($data,$pc);
        $calc['index']=$index;
        $items[]=$calc;
        $total+=(float)$calc['subtotal'];
        $pages += $pc * max(1,(int)($data['copies'] ?? 1));
        $sheets += (int)($calc['sheet_count'] ?? $pc);
    }

    return [
        'ok'=>count($items)>0 && !array_filter($items,fn($x)=>empty($x['ok'])),
        'items'=>$items,
        'total'=>round($total,2),
        'pages'=>$pages,
        'sheets'=>$sheets,
        'message'=>count($items)?'OK':'Agrega al menos un archivo.'
    ];
}

function print_dynamic_insert(string $table,array $values,array $timestampColumns=['created_at','updated_at']): int {
    $cols=print_table_columns($table);
    $insertCols=[];$params=[];
    foreach($values as $column=>$value){
        if(isset($cols[$column])){
            $insertCols[]='`'.$column.'`';
            $params[]=$value;
        }
    }
    foreach($timestampColumns as $column){
        if(isset($cols[$column]) && !in_array('`'.$column.'`',$insertCols,true)) $insertCols[]='`'.$column.'`';
    }
    if(!$insertCols) throw new RuntimeException('La tabla '.$table.' no tiene columnas compatibles.');

    $placeholders=[];
    foreach($insertCols as $column){
        $placeholders[]=in_array(trim($column,'`'),$timestampColumns,true)?'NOW()':'?';
    }
    $sql='INSERT INTO `'.$table.'` ('.implode(',',$insertCols).') VALUES ('.implode(',',$placeholders).')';
    $st=db()->prepare($sql);
    $st->execute($params);
    return (int)db()->lastInsertId();
}

function print_dynamic_update(string $table,int $id,array $values): void {
    $cols=print_table_columns($table);
    if(!isset($cols['id'])) throw new RuntimeException('La tabla '.$table.' no tiene ID.');
    $set=[];$params=[];
    foreach($values as $column=>$value){
        if($column==='id' || !isset($cols[$column])) continue;
        $set[]='`'.$column.'`=?'; $params[]=$value;
    }
    if(isset($cols['updated_at'])) $set[]='`updated_at`=NOW()';
    if(!$set) return;
    $params[]=$id;
    db()->prepare('UPDATE `'.$table.'` SET '.implode(',',$set).' WHERE id=?')->execute($params);
}

function print_dynamic_delete(string $table,int $id): void {
    if(!print_table_has_column($table,'id')) throw new RuntimeException('Tabla no compatible.');
    db()->prepare('DELETE FROM `'.$table.'` WHERE id=?')->execute([$id]);
}

function print_mode_label(string $mode): string {
    return match($mode){
        'page'=>'página',
        'sheet'=>'hoja',
        'piece'=>'pieza',
        default=>'unidad',
    };
}
