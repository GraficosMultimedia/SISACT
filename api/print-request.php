<?php
declare(strict_types=1);

/*
 * Endpoint público del receptor de archivos de impresión.
 * Se integra con la misma DB usada por index.php mediante config/runtime.php.
 */
require_once __DIR__ . '/../config/runtime.php';

header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    pr_json(['ok'=>false,'error'=>'Método no permitido.'],405);
}

function pr_json(array $data, int $status=200): never {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
    exit;
}
function pr_post(string $key): string {
    return trim((string)($_POST[$key] ?? ''));
}
function pr_normalize_phone(string $phone): string {
    return preg_replace('/\D+/', '', $phone) ?? '';
}
function pr_safe_filename(string $name): string {
    $name=basename($name);
    $name=preg_replace('/[^A-Za-z0-9._-]+/u','_',$name) ?? 'archivo';
    return trim($name,'._') ?: 'archivo';
}
function pr_table_exists(PDO $pdo,string $table): bool {
    $s=$pdo->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?");
    $s->execute([$table]);
    return (bool)$s->fetchColumn();
}
function pr_find_customer(PDO $pdo,string $name,string $email,string $phone): ?int {
    if ($email !== '') {
        $s=$pdo->prepare('SELECT id FROM cp_customers WHERE email=? ORDER BY id DESC LIMIT 1');
        $s->execute([$email]);
        if ($id=$s->fetchColumn()) return (int)$id;
    }

    $digits=pr_normalize_phone($phone);
    if ($digits !== '') {
        $s=$pdo->prepare(
            'SELECT id FROM cp_customers
             WHERE REPLACE(REPLACE(REPLACE(REPLACE(phone," ",""),"-",""),"+",""),"(","") LIKE ?
             ORDER BY id DESC LIMIT 1'
        );
        $s->execute(['%'.$digits.'%']);
        if ($id=$s->fetchColumn()) return (int)$id;
    }

    $s=$pdo->prepare(
        'INSERT INTO cp_customers
         (source_type,name,email,phone,enabled,created_at,updated_at)
         VALUES (?,?,?,?,1,NOW(),NOW())'
    );
    $s->execute(['web_print_request',$name,$email ?: null,$phone ?: null]);
    return (int)$pdo->lastInsertId();
}
function pr_pdf_pages(string $path): int {
    if (function_exists('shell_exec')) {
        $cmd='pdfinfo '.escapeshellarg($path).' 2>/dev/null';
        $out=@shell_exec($cmd);
        if (is_string($out) && preg_match('/^Pages:\s+(\d+)/mi',$out,$m)) {
            return max(1,(int)$m[1]);
        }
    }

    $raw=@file_get_contents($path);
    if ($raw===false) return 1;

    $count=preg_match_all('/\/Type\s*\/Page\b/',$raw,$dummy);
    return max(1,(int)$count);
}

$name=pr_post('name');
$email=pr_post('email');
$phone=pr_post('phone');
$items=json_decode((string)($_POST['items'] ?? '[]'),true);

if ($name==='') pr_json(['ok'=>false,'error'=>'Ingresa tu nombre completo.'],422);
if ($email!=='' && !filter_var($email,FILTER_VALIDATE_EMAIL)) {
    pr_json(['ok'=>false,'error'=>'El correo electrónico no es válido.'],422);
}
if ($phone==='') pr_json(['ok'=>false,'error'=>'Ingresa un teléfono de contacto.'],422);
if (!is_array($items) || !$items) pr_json(['ok'=>false,'error'=>'Agrega al menos un archivo.'],422);

$upload=$_FILES['files'] ?? null;
if (!$upload || !isset($upload['name']) || !is_array($upload['name'])) {
    pr_json(['ok'=>false,'error'=>'No se recibieron archivos.'],422);
}

$maxFiles=10;
$maxBytes=20*1024*1024;
$allowed=[
    'application/pdf'=>'pdf',
    'image/jpeg'=>'jpg',
    'image/png'=>'png',
];

if (count($upload['name'])>$maxFiles) {
    pr_json(['ok'=>false,'error'=>"Máximo {$maxFiles} archivos por solicitud."],422);
}
if (count($items)!==count($upload['name'])) {
    pr_json(['ok'=>false,'error'=>'La configuración no coincide con los archivos enviados.'],422);
}

$pdo=db();
$pdo->beginTransaction();
$stored=[];

try {
    $customerId=pr_find_customer($pdo,$name,$email,$phone);
    $token=bin2hex(random_bytes(32));

    $requestStmt=$pdo->prepare(
        'INSERT INTO cp_web_quote_requests
        (request_token,customer_id,service_key,customer_name,email,phone,request_text,quantity,attachment_name,status,created_at,updated_at)
        VALUES (?,?,?,?,?,?,?,?,?,?,NOW(),NOW())'
    );
    $requestStmt->execute([
        $token,$customerId,'impresion',$name,$email ?: null,$phone,
        'Solicitud de impresión recibida desde Colibrí Print',
        (string)count($upload['name']),
        null,'new'
    ]);
    $requestId=(int)$pdo->lastInsertId();

    /*
     * Se guarda dentro del mismo proyecto para no depender de rutas absolutas
     * de otro servidor. La ruta pública coincide con cp_web_quote_files.
     */
    $projectRoot=dirname(__DIR__);
    $baseDir=$projectRoot.'/uploads/cotizador/impresiones';
    $requestDir=$baseDir.'/'.$requestId;

    if (!is_dir($baseDir) && !mkdir($baseDir,0755,true)) {
        throw new RuntimeException('No se pudo crear el directorio de archivos.');
    }
    if (!is_dir($requestDir) && !mkdir($requestDir,0755,true)) {
        throw new RuntimeException('No se pudo crear la carpeta de la solicitud.');
    }

    $sizeStmt=$pdo->prepare(
        'SELECT id,name,width_mm,height_mm,orientation
         FROM cp_print_sizes WHERE id=? AND enabled=1 LIMIT 1'
    );
    $materialStmt=$pdo->prepare(
        'SELECT id,name FROM cp_print_materials WHERE id=? AND enabled=1 LIMIT 1'
    );
    $finishStmt=$pdo->prepare(
        'SELECT id,name FROM cp_print_finishes WHERE id=? AND enabled=1 LIMIT 1'
    );

    /*
     * Primero busca el nivel de cantidad correspondiente. Si no existe una
     * tarifa exacta por acabado, permite la tarifa base de la misma combinación.
     */
    $priceStmt=$pdo->prepare(
        'SELECT id,unit_price,pricing_mode,min_qty
         FROM cp_print_prices
         WHERE enabled=1
           AND size_id=?
           AND material_id=?
           AND finish_id=?
           AND color_mode=?
           AND min_qty<=?
         ORDER BY min_qty DESC,id DESC
         LIMIT 1'
    );
    $priceFallback=$pdo->prepare(
        'SELECT id,unit_price,pricing_mode,min_qty
         FROM cp_print_prices
         WHERE enabled=1
           AND size_id=?
           AND material_id=?
           AND color_mode=?
           AND min_qty<=?
         ORDER BY min_qty DESC,id DESC
         LIMIT 1'
    );

    // cp_print_request_items.price_rule_id apunta a cp_print_price_rules,
    // mientras que el precio calculado de este cotizador proviene de cp_print_prices.
    // Buscamos una regla compatible para guardar su ID; si no existe, dejamos NULL
    // porque la columna permite NULL y no debemos guardar el ID de cp_print_prices.
    $ruleStmt=$pdo->prepare(
        'SELECT id,unit_price,pricing_mode
         FROM cp_print_price_rules
         WHERE enabled=1
           AND service_type=?
           AND (size_id=? OR size_id IS NULL)
           AND (material_id=? OR material_id IS NULL)
           AND (finish_id=? OR finish_id IS NULL)
           AND (color_mode=? OR color_mode=\'both\' OR color_mode IS NULL OR color_mode=\'\')
           AND min_quantity<=?
         ORDER BY
           (size_id IS NULL), (material_id IS NULL), (finish_id IS NULL),
           (color_mode IS NULL OR color_mode=\'both\'),
           min_quantity DESC, id DESC
         LIMIT 1'
    );

    $fileStmt=$pdo->prepare(
        'INSERT INTO cp_web_quote_files
        (request_id,original_name,stored_path,mime_type,extension,size_bytes,sha256,source,created_at,page_count)
        VALUES (?,?,?,?,?,?,?,?,NOW(),?)'
    );

    $itemStmt=$pdo->prepare(
        'INSERT INTO cp_print_request_items
        (request_id,file_id,service_key,size_id,size_name,width_mm,height_mm,orientation,
         material_id,material_name,color_mode,finish_id,finish_name,copies,pages,
         price_rule_id,unit_price,subtotal,pricing_status,notes,created_at,updated_at,
         page_count,print_sides,sheet_count,billable_units,service_type,pricing_mode,quantity)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW(),?,?,?,?,?,?,?)'
    );

    $total=0.0;
    $summary=[];

    foreach ($upload['name'] as $i=>$rawName) {
        if (($upload['error'][$i] ?? UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_OK) {
            throw new RuntimeException('Error al subir: '.pr_safe_filename((string)$rawName));
        }

        $sizeBytes=(int)($upload['size'][$i] ?? 0);
        if ($sizeBytes<=0 || $sizeBytes>$maxBytes) {
            throw new RuntimeException(pr_safe_filename((string)$rawName).' supera el límite de 20 MB o está vacío.');
        }

        $tmp=(string)$upload['tmp_name'][$i];
        $mime=(new finfo(FILEINFO_MIME_TYPE))->file($tmp) ?: 'application/octet-stream';
        if (!isset($allowed[$mime])) {
            throw new RuntimeException('Formato no permitido: '.pr_safe_filename((string)$rawName));
        }

        $ext=$allowed[$mime];
        $original=pr_safe_filename((string)$rawName);
        $storedName=bin2hex(random_bytes(8)).'_'.$original;
        $destination=$requestDir.'/'.$storedName;

        if (!move_uploaded_file($tmp,$destination)) {
            throw new RuntimeException('No se pudo guardar '.$original);
        }
        $stored[]=$destination;

        $pages=$mime==='application/pdf' ? pr_pdf_pages($destination) : 1;

        $it=is_array($items[$i] ?? null) ? $items[$i] : [];
        $sizeId=(int)($it['size_id'] ?? 0);
        $materialId=(int)($it['material_id'] ?? 0);
        $finishId=(int)($it['finish_id'] ?? 0);
        $color=($it['color_mode'] ?? 'color')==='bw' ? 'bw' : 'color';
        $copies=max(1,min(9999,(int)($it['copies'] ?? 1)));
        $notes=mb_substr(trim((string)($it['notes'] ?? '')),0,1000);

        $sizeStmt->execute([$sizeId]);
        $size=$sizeStmt->fetch();
        $materialStmt->execute([$materialId]);
        $material=$materialStmt->fetch();
        $finishStmt->execute([$finishId]);
        $finish=$finishStmt->fetch();

        if (!$size || !$material || !$finish) {
            throw new RuntimeException('Configuración inválida para '.$original);
        }

        $priceStmt->execute([$sizeId,$materialId,$finishId,$color,$copies]);
        $price=$priceStmt->fetch();

        if (!$price) {
            $priceFallback->execute([$sizeId,$materialId,$color,$copies]);
            $price=$priceFallback->fetch();
        }

        if (!$price) {
            throw new RuntimeException('No existe una tarifa para '.$original.' con la configuración seleccionada.');
        }

        $pricingMode=(string)($price['pricing_mode'] ?? 'per_page');
        $billableUnits=$pages*$copies;
        $subtotal=(float)$price['unit_price']*$billableUnits;
        $total+=$subtotal;

        $publicPath='/uploads/cotizador/impresiones/'.$requestId.'/'.$storedName;
        $hash=hash_file('sha256',$destination);

        $fileStmt->execute([
            $requestId,$original,$publicPath,$mime,$ext,$sizeBytes,$hash,'public',$pages
        ]);
        $fileId=(int)$pdo->lastInsertId();

        if ($i===0) {
            $pdo->prepare(
                'UPDATE cp_web_quote_requests SET attachment_name=?,updated_at=NOW() WHERE id=?'
            )->execute([$original,$requestId]);
        }

        $sheetCount=$pages*$copies;

        // El ID de cp_print_prices NO puede ir en price_rule_id porque
        // esa columna tiene FK hacia cp_print_price_rules.
        $priceRuleId=null;
        $ruleStmt->execute(['impresion',$sizeId,$materialId,$finishId,$color,$copies]);
        if ($rule=$ruleStmt->fetch()) {
            // Solo asociamos la regla si corresponde al precio que realmente
            // usamos para calcular el subtotal.
            if (abs((float)$rule['unit_price'] - (float)$price['unit_price']) < 0.00001) {
                $priceRuleId=(int)$rule['id'];
            }
        }

        $itemStmt->execute([
            $requestId,$fileId,'document',
            $size['id'],$size['name'],(float)$size['width_mm'],(float)$size['height_mm'],$size['orientation'],
            $material['id'],$material['name'],$color,
            $finish['id'],$finish['name'],
            $copies,$pages,$priceRuleId,(float)$price['unit_price'],$subtotal,
            'calculated',$notes,
            $pages,'single',$sheetCount,$billableUnits,'impresion',$pricingMode,$copies
        ]);

        $summary[]=[
            'file'=>$original,
            'pages'=>$pages,
            'copies'=>$copies,
            'size'=>$size['name'],
            'material'=>$material['name'],
            'finish'=>$finish['name'],
            'color_mode'=>$color,
            'unit_price'=>(float)$price['unit_price'],
            'subtotal'=>$subtotal
        ];
    }

    $requestText="Solicitud de impresión desde la página web\n".
        json_encode([
            'version'=>2,
            'service'=>'impresion',
            'items'=>$summary,
            'total'=>$total
        ],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);

    $pdo->prepare(
        'UPDATE cp_web_quote_requests
         SET request_text=?,quantity=?,updated_at=NOW()
         WHERE id=?'
    )->execute([$requestText,(string)count($upload['name']),$requestId]);

    if (pr_table_exists($pdo,'cp_print_requests')) {
        $pdo->prepare(
            'INSERT INTO cp_print_requests
             (customer_name,customer_email,customer_phone,status,total_estimate,created_at,updated_at)
             VALUES (?,?,?,?,?,NOW(),NOW())'
        )->execute([$name,$email,$phone,'new',$total]);
    }

    if (pr_table_exists($pdo,'cp_web_quote_notifications')) {
        $title=sprintf('CPQ-%06d · %s',$requestId,$name);
        $message='Impresión · '.$phone.' · '.count($upload['name']).' archivo(s) · $'.number_format($total,2,'.',',').' MXN';
        $pdo->prepare(
            'INSERT INTO cp_web_quote_notifications
             (request_id,event_type,title,message,created_at)
             VALUES (?,?,?,?,NOW())'
        )->execute([$requestId,'new_request',$title,$message]);
    }

    $pdo->commit();

    pr_json([
        'ok'=>true,
        'request_id'=>$requestId,
        'request_token'=>$token,
        'total'=>$total,
        'items'=>$summary
    ]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    foreach ($stored as $path) @unlink($path);

    error_log('[Colibri Print] print-request.php: '.$e->getMessage());
    pr_json(['ok'=>false,'error'=>$e->getMessage()],500);
}
