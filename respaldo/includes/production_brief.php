<?php
declare(strict_types=1);

/**
 * Colibrí Print · Ficha Interna de Producción
 * Datos exclusivamente internos. Nunca deben exponerse al seguimiento público.
 */

function production_brief_table_ready(): bool {
    static $ready = null;
    if ($ready !== null) return $ready;
    try {
        $st = db()->query("SHOW TABLES LIKE 'cp_order_production_briefs'");
        $ready = (bool)$st->fetchColumn();
    } catch (Throwable $e) {
        $ready = false;
    }
    return $ready;
}

function production_checklist_table_ready(): bool {
    static $ready = null;
    if ($ready !== null) return $ready;
    try {
        $st = db()->query("SHOW TABLES LIKE 'cp_order_production_checklist'");
        $ready = (bool)$st->fetchColumn();
    } catch (Throwable $e) {
        $ready = false;
    }
    return $ready;
}

function production_brief_get(int $orderId): ?array {
    if ($orderId <= 0 || !production_brief_table_ready()) return null;
    $st = db()->prepare(
        'SELECT b.*, u1.name AS updated_by_name, u2.name AS approved_by_name
         FROM cp_order_production_briefs b
         LEFT JOIN cp_users u1 ON u1.id=b.updated_by
         LEFT JOIN cp_users u2 ON u2.id=b.design_approved_by
         WHERE b.order_id=? LIMIT 1'
    );
    $st->execute([$orderId]);
    return $st->fetch() ?: null;
}

function production_brief_default(): array {
    return [
        'service_type'=>'',
        'product'=>'',
        'quantity'=>'',
        'dimensions'=>'',
        'material'=>'',
        'thickness'=>'',
        'color'=>'',
        'technique'=>'',
        'finish'=>'',
        'sizes'=>'',
        'customer_request'=>'',
        'design_status'=>'pending',
        'design_version'=>'',
        'priority'=>'normal',
        'instructions'=>'',
        'critical_instructions'=>'',
        'packaging'=>'',
        'delivery_internal'=>'',
        'extra_data'=>'',
    ];
}

function production_service_profiles(): array {
    return [
        'playeras'=>[
            'label'=>'Playeras / Textiles',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'DTF / Bordado / Sublimación / Vinil',
            'finish'=>'',
            'sizes'=>'Ej. CH 5 · M 8 · G 10 · XG 2',
            'customer_request'=>'',
            'hint'=>'Prenda, color, tallas, técnica, ubicación y medida del estampado.'
        ],
        'impresion'=>[
            'label'=>'Impresión',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'',
            'thickness'=>'',
            'color'=>'CMYK / Pantone / Especial',
            'technique'=>'Impresión digital / gran formato',
            'finish'=>'Laminado / Barniz / Corte / Doblez',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Producto, tamaño, material, cantidad, acabado y archivo final.'
        ],
        'gran_formato'=>[
            'label'=>'Gran formato / Vinil',
            'product'=>'Lona / Vinil / Banner / Pendón',
            'dimensions'=>'',
            'material'=>'',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'Impresión / Corte de vinil',
            'finish'=>'Ojillos / Dobladillo / Instalación',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Medidas exactas, superficie, acabado y si requiere instalación.'
        ],
        'cnc'=>[
            'label'=>'Corte CNC',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'MDF / Melamina / Madera / Acrílico',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'Corte / Perforado / Grabado',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Material, espesor, medidas, número de piezas, tipo de corte y archivo CNC.'
        ],
        'laser'=>[
            'label'=>'Grabado láser',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'Madera / Acrílico / Metal / Otro',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'Grabado / Corte',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Artículo, material, área de trabajo, medidas, cantidad y detalle del grabado.'
        ],
        'corporea'=>[
            'label'=>'Letras corpóreas',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'PVC / Acrílico / Aluminio / Madera',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'CNC / Fabricación 3D',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Texto, altura, material, profundidad, color, fijación e instalación.'
        ],
        'diseno'=>[
            'label'=>'Diseño / Branding',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'Digital',
            'thickness'=>'No aplica',
            'color'=>'',
            'technique'=>'Diseño gráfico',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Objetivo, piezas, formato final, referencias y versión aprobada.'
        ],
        'promo'=>[
            'label'=>'Promocionales / Souvenirs',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'Sublimación / Grabado / Impresión',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Artículo, cantidad, personalización, posición y referencia visual.'
        ],
        'comestible'=>[
            'label'=>'Impresión comestible',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'Oblea de azúcar / Arroz / Papa',
            'thickness'=>'No aplica',
            'color'=>'',
            'technique'=>'Impresión comestible',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Tipo de oblea, medidas, cantidad, evento y archivo.'
        ],
        'otro'=>[
            'label'=>'Otro proyecto',
            'product'=>'',
            'dimensions'=>'',
            'material'=>'',
            'thickness'=>'',
            'color'=>'',
            'technique'=>'',
            'finish'=>'',
            'sizes'=>'',
            'customer_request'=>'',
            'hint'=>'Describe con libertad el trabajo y todo lo que el cliente necesita.'
        ]
    ];
}

function production_brief_save(int $orderId, int $userId, array $data): void {
    if ($orderId <= 0) throw new RuntimeException('Orden no válida.');
    if (!production_brief_table_ready()) {
        throw new RuntimeException('La Ficha Interna de Producción no está instalada. Ejecuta la migración 019_order_production.sql.');
    }

    $allowedServices = production_service_profiles();
    $serviceType = (string)($data['service_type'] ?? 'otro');
    if (!isset($allowedServices[$serviceType])) $serviceType='otro';

    $fields=production_brief_default();
    foreach($fields as $key=>$unused){
        if(array_key_exists($key,$data)) $fields[$key]=trim((string)$data[$key]);
    }

    $allowedPriority=['normal','alta','urgente'];
    if(!in_array($fields['priority'],$allowedPriority,true)) $fields['priority']='normal';

    $allowedDesign=['pending','in_design','review','approved','changes','not_required'];
    if(!in_array($fields['design_status'],$allowedDesign,true)) $fields['design_status']='pending';

    $fields['extra_data']=substr($fields['extra_data'],0,10000);
    foreach(['service_type','product','quantity','dimensions','material','thickness','color','technique','finish','sizes','customer_request','design_version','priority','instructions','critical_instructions','packaging','delivery_internal'] as $key){
        $fields[$key]=substr($fields[$key],0,5000);
    }

    $pdo=db();
    $existing=production_brief_get($orderId);

    $approvedBy=null;
    $approvedAt=null;
    if($fields['design_status']==='approved'){
        $approvedBy = (int)($existing['design_approved_by'] ?? 0) ?: $userId;
        $approvedAt = $existing['design_approved_at'] ?? date('Y-m-d H:i:s');
    }

    if($existing){
        $sql='UPDATE cp_order_production_briefs SET
              service_type=?,product=?,quantity=?,dimensions=?,material=?,thickness=?,color=?,technique=?,finish=?,sizes=?,
              customer_request=?,design_status=?,design_version=?,design_approved_by=?,design_approved_at=?,priority=?,
              instructions=?,critical_instructions=?,packaging=?,delivery_internal=?,extra_data=?,updated_by=?,updated_at=NOW()
              WHERE order_id=?';
        $pdo->prepare($sql)->execute([
            $fields['service_type'],$fields['product'],$fields['quantity'],$fields['dimensions'],$fields['material'],
            $fields['thickness'],$fields['color'],$fields['technique'],$fields['finish'],$fields['sizes'],
            $fields['customer_request'],$fields['design_status'],$fields['design_version'],$approvedBy,$approvedAt,$fields['priority'],
            $fields['instructions'],$fields['critical_instructions'],$fields['packaging'],$fields['delivery_internal'],$fields['extra_data'],
            $userId ?: null,$orderId
        ]);
    } else {
        $sql='INSERT INTO cp_order_production_briefs
             (order_id,service_type,product,quantity,dimensions,material,thickness,color,technique,finish,sizes,customer_request,
              design_status,design_version,design_approved_by,design_approved_at,priority,instructions,critical_instructions,packaging,
              delivery_internal,extra_data,created_by,updated_by,created_at,updated_at)
             VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,NOW(),NOW())';
        $pdo->prepare($sql)->execute([
            $orderId,$fields['service_type'],$fields['product'],$fields['quantity'],$fields['dimensions'],$fields['material'],
            $fields['thickness'],$fields['color'],$fields['technique'],$fields['finish'],$fields['sizes'],$fields['customer_request'],
            $fields['design_status'],$fields['design_version'],$approvedBy,$approvedAt,$fields['priority'],
            $fields['instructions'],$fields['critical_instructions'],$fields['packaging'],$fields['delivery_internal'],$fields['extra_data'],
            $userId ?: null,$userId ?: null
        ]);
    }
}

function production_checklist_defaults(): array {
    return [
        ['preproduction','brief_complete','Brief / datos técnicos completos',1],
        ['preproduction','files_received','Archivo o referencia recibido',1],
        ['preproduction','measurements_checked','Medidas verificadas',1],
        ['preproduction','material_confirmed','Material confirmado',1],
        ['preproduction','design_approved','Diseño / archivo aprobado',1],
        ['production','material_prepared','Material preparado',0],
        ['production','production_started','Producción iniciada',0],
        ['production','production_finished','Producción terminada',0],
        ['quality','quantity_checked','Cantidad revisada',0],
        ['quality','quality_checked','Calidad, color y acabado revisados',0],
        ['quality','approved','Control de calidad aprobado',0],
        ['delivery','packed','Producto empacado / preparado',0],
        ['delivery','customer_notified','Cliente notificado',0],
        ['delivery','delivered','Entrega realizada',0],
    ];
}

function production_checklist_seed(int $orderId): void {
    if($orderId<=0 || !production_checklist_table_ready()) return;
    $pdo=db();
    $st=$pdo->prepare('SELECT COUNT(*) FROM cp_order_production_checklist WHERE order_id=?');
    $st->execute([$orderId]);
    if((int)$st->fetchColumn()>0) return;

    $insert=$pdo->prepare(
        'INSERT INTO cp_order_production_checklist
         (order_id,area,item_key,label,status,is_blocking,sort_order,created_at,updated_at)
         VALUES(?,?,?,?,?,?,?,?,?)'
    );
    $sort=10;
    foreach(production_checklist_defaults() as $row){
        [$area,$key,$label,$blocking]=$row;
        $insert->execute([$orderId,$area,$key,$label,'pending',$blocking,$sort,date('Y-m-d H:i:s'),date('Y-m-d H:i:s')]);
        $sort+=10;
    }
}

function production_checklist_get(int $orderId): array {
    if($orderId<=0 || !production_checklist_table_ready()) return [];
    production_checklist_seed($orderId);
    $st=db()->prepare(
        'SELECT c.*,u.name AS completed_by_name
         FROM cp_order_production_checklist c
         LEFT JOIN cp_users u ON u.id=c.completed_by
         WHERE c.order_id=?
         ORDER BY c.sort_order ASC,c.id ASC'
    );
    $st->execute([$orderId]);
    return $st->fetchAll();
}

function production_checklist_save(int $orderId,int $userId,array $statuses): void {
    if($orderId<=0) throw new RuntimeException('Orden no válida.');
    if(!production_checklist_table_ready()) {
        throw new RuntimeException('El checklist de producción no está instalado. Ejecuta la migración 019_order_production.sql.');
    }
    production_checklist_seed($orderId);
    $allowed=['pending','done','na'];
    $pdo=db();

    $st=$pdo->prepare('SELECT id FROM cp_order_production_checklist WHERE order_id=?');
    $st->execute([$orderId]);
    $ids=$st->fetchAll(PDO::FETCH_COLUMN);

    foreach($ids as $cid){
        $status=(string)($statuses[(string)$cid] ?? 'pending');
        if(!in_array($status,$allowed,true)) $status='pending';
        $done=($status==='done') ? ($userId ?: null) : null;
        $doneAt=($status==='done') ? date('Y-m-d H:i:s') : null;
        $pdo->prepare('UPDATE cp_order_production_checklist SET status=?,completed_by=?,completed_at=?,updated_at=NOW() WHERE id=? AND order_id=?')
            ->execute([$status,$done,$doneAt,(int)$cid,$orderId]);
    }
}

function production_readiness(int $orderId): array {
    $brief=production_brief_get($orderId);
    $checklist=production_checklist_get($orderId);

    $missing=[];
    if(!$brief){
        $missing[]='Crear la ficha técnica interna.';
    }else{
        foreach([
            'service_type'=>'Tipo de servicio',
            'product'=>'Producto / trabajo',
            'quantity'=>'Cantidad'
        ] as $field=>$label){
            if(trim((string)($brief[$field]??''))==='') $missing[]=$label;
        }

        $design=(string)($brief['design_status']??'pending');
        if(!in_array($design,['approved','not_required'],true)){
            $missing[]='Diseño / archivo aprobado o marcado como no requerido.';
        }
    }

    foreach($checklist as $item){
        if((int)$item['is_blocking']===1 && !in_array((string)$item['status'],['done','na'],true)){
            $missing[]=(string)$item['label'];
        }
    }

    $status='incomplete';
    $label='Faltan datos para producción';
    if(!$missing){
        $status='ready';
        $label='Listo para producción';
    }elseif($brief && (string)$brief['priority']==='urgente'){
        $status='urgent';
        $label='Urgente · revisar antes de producir';
    }

    return [
        'status'=>$status,
        'label'=>$label,
        'missing'=>array_values(array_unique($missing)),
        'brief'=>$brief,
        'checklist'=>$checklist
    ];
}
