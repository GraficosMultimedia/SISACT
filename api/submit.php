<?php
declare(strict_types=1);
require __DIR__ . '/../bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') json_response(['ok'=>false,'error'=>'Método no permitido.'],405);

$name = post_string('name');
$email = post_string('email');
$phone = post_string('phone');
$itemsJson = (string)($_POST['items'] ?? '[]');
$items = json_decode($itemsJson, true);

if ($name === '') json_response(['ok'=>false,'error'=>'Ingresa tu nombre completo.'],422);
if ($email !== '' && !filter_var($email, FILTER_VALIDATE_EMAIL)) json_response(['ok'=>false,'error'=>'El correo electrónico no es válido.'],422);
if ($phone === '') json_response(['ok'=>false,'error'=>'Ingresa un teléfono de contacto.'],422);
if (!is_array($items) || count($items) < 1) json_response(['ok'=>false,'error'=>'Agrega al menos un archivo.'],422);

$files = $_FILES['files'] ?? null;
if (!$files || !isset($files['name']) || !is_array($files['name'])) json_response(['ok'=>false,'error'=>'No se recibieron archivos.'],422);
if (count($files['name']) > $config['upload']['max_files']) json_response(['ok'=>false,'error'=>'Máximo '.$config['upload']['max_files'].' archivos por solicitud.'],422);

$pdo = db();
$pdo->beginTransaction();
$stored = [];
try {
    $customerId = find_or_create_customer($pdo, $name, $email, $phone);
    $token = bin2hex(random_bytes(32));
    $summary = [];
    $total = 0.0;

    $insertReq = $pdo->prepare('INSERT INTO cp_web_quote_requests (request_token,customer_id,service_key,customer_name,email,phone,request_text,quantity,attachment_name,status,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');
    $insertReq->execute([$token,$customerId,'impresion',$name,$email ?: null,$phone,"Solicitud de impresión desde formulario público",(string)count($files['name']),null,'new']);
    $requestId = (int)$pdo->lastInsertId();

    if (!is_dir($config['upload']['directory']) && !mkdir($config['upload']['directory'], 0755, true)) {
        throw new RuntimeException('No se pudo crear el directorio de archivos.');
    }
    $requestDir = $config['upload']['directory'] . '/' . $requestId;
    if (!is_dir($requestDir) && !mkdir($requestDir, 0755, true)) throw new RuntimeException('No se pudo crear la carpeta de la solicitud.');

    $sizeStmt = $pdo->prepare('SELECT id,name,width_mm,height_mm,orientation,is_custom FROM cp_print_sizes WHERE id=? AND enabled=1');
    $matStmt = $pdo->prepare('SELECT id,name FROM cp_print_materials WHERE id=? AND enabled=1');
    $finStmt = $pdo->prepare('SELECT id,name FROM cp_print_finishes WHERE id=? AND enabled=1');
    $priceStmt = $pdo->prepare('SELECT id,unit_price,pricing_mode FROM cp_print_prices WHERE enabled=1 AND size_id=? AND material_id=? AND finish_id=? AND color_mode=? ORDER BY min_qty ASC,id ASC LIMIT 1');
    $priceFallback = $pdo->prepare('SELECT id,unit_price,pricing_mode FROM cp_print_prices WHERE enabled=1 AND size_id=? AND material_id=? AND color_mode=? ORDER BY (finish_id=?) DESC,min_qty ASC,id ASC LIMIT 1');
    $fileStmt = $pdo->prepare('INSERT INTO cp_web_quote_files (request_id,original_name,stored_path,mime_type,extension,size_bytes,sha256,source,created_at,page_count) VALUES (?,?,?,?,?,?,?,?,NOW(),?)');
    $itemStmt = $pdo->prepare('INSERT INTO cp_print_request_items (request_id,file_id,service_key,size_id,size_name,width_mm,height_mm,orientation,material_id,material_name,color_mode,finish_id,finish_name,copies,pages,price_rule_id,unit_price,subtotal,pricing_status,notes,created_at,updated_at,page_count,print_sides,sheet_count,billable_units,service_type,pricing_mode,quantity) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW(),?,?,?,?,?,?,?)');

    $fileCount = count($files['name']);
    if (count($items) !== $fileCount) throw new RuntimeException('La configuración de archivos no coincide con los archivos enviados.');

    for ($i=0; $i<$fileCount; $i++) {
        if ($files['error'][$i] !== UPLOAD_ERR_OK) throw new RuntimeException('Error al subir: '.$files['name'][$i]);
        if ((int)$files['size'][$i] > $config['upload']['max_file_bytes']) throw new RuntimeException('El archivo '.$files['name'][$i].' supera el límite de 20 MB.');
        $tmp = $files['tmp_name'][$i];
        $mime = (new finfo(FILEINFO_MIME_TYPE))->file($tmp) ?: 'application/octet-stream';
        if (!isset($config['upload']['allowed_mimes'][$mime])) throw new RuntimeException('Formato no permitido: '.$files['name'][$i]);
        $ext = $config['upload']['allowed_mimes'][$mime];
        $original = safe_filename($files['name'][$i]);
        $storedName = bin2hex(random_bytes(8)) . '_' . $original;
        $dest = $requestDir . '/' . $storedName;
        if (!move_uploaded_file($tmp, $dest)) throw new RuntimeException('No se pudo guardar '.$original);
        $stored[] = $dest;
        $hash = hash_file('sha256',$dest);
        $pages = $mime === 'application/pdf' ? pdf_page_count($dest) : image_page_count($dest);

        $it = $items[$i] ?? [];
        $sizeId = (int)($it['size_id'] ?? 0);
        $materialId = (int)($it['material_id'] ?? 0);
        $finishId = (int)($it['finish_id'] ?? 0);
        $color = ($it['color_mode'] ?? 'color') === 'bw' ? 'bw' : 'color';
        $copies = max(1, (int)($it['copies'] ?? 1));

        $sizeStmt->execute([$sizeId]); $size = $sizeStmt->fetch();
        $matStmt->execute([$materialId]); $mat = $matStmt->fetch();
        $finStmt->execute([$finishId]); $fin = $finStmt->fetch();
        if (!$size || !$mat || !$fin) throw new RuntimeException('Configuración inválida para '.$original);

        $priceStmt->execute([$sizeId,$materialId,$finishId,$color]);
        $price = $priceStmt->fetch();
        if (!$price) {
            $priceFallback->execute([$sizeId,$materialId,$color,$finishId]);
            $price = $priceFallback->fetch();
        }
        if (!$price) throw new RuntimeException('No existe una tarifa para '.$original.' con la configuración seleccionada.');

        $pricingMode = $price['pricing_mode'] ?? 'per_page';
        $billable = $pricingMode === 'per_sheet' ? $pages * $copies : $pages * $copies;
        $subtotal = (float)$price['unit_price'] * $billable;
        $total += $subtotal;
        $summary[] = ['file'=>$original,'pages'=>$pages,'copies'=>$copies,'subtotal'=>$subtotal];

        $publicPath = rtrim($config['upload']['public_prefix'],'/') . '/' . $requestId . '/' . $storedName;
        $fileStmt->execute([$requestId,$original,$publicPath,$mime,$ext,(int)$files['size'][$i],$hash,'public',$pages]);
        $fileId = (int)$pdo->lastInsertId();
        if ($i === 0) {
            $pdo->prepare('UPDATE cp_web_quote_requests SET attachment_name=? WHERE id=?')->execute([$original,$requestId]);
        }

        $sheetCount = $pages * $copies;
        $itemStmt->execute([
            $requestId,$fileId,'document',$size['id'],$size['name'],(float)$size['width_mm'],(float)$size['height_mm'],$size['orientation'],
            $mat['id'],$mat['name'],$color,$fin['id'],$fin['name'],$copies,$pages,(int)$price['id'],(float)$price['unit_price'],$subtotal,
            'calculated',(string)($it['notes'] ?? ''),$pages,'single',$sheetCount,$sheetCount,'impresion',$pricingMode,$copies
        ]);
    }

    $requestText = "Solicitud de impresión desde formulario público\n" . json_encode(['version'=>1,'items'=>$summary,'total'=>$total], JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);
    $pdo->prepare('UPDATE cp_web_quote_requests SET request_text=?, quantity=?, updated_at=NOW() WHERE id=?')->execute([$requestText,(string)$fileCount,$requestId]);
    // Keep the dedicated summary table in sync when present. Its schema predates the web-quote parent.
    if (table_exists($pdo,'cp_print_requests')) {
        $pdo->prepare('INSERT INTO cp_print_requests (customer_name,customer_email,customer_phone,status,total_estimate,created_at,updated_at) VALUES (?,?,?,?,?,NOW(),NOW())')
            ->execute([$name,$email,$phone,'new',$total]);
    }
    if (table_exists($pdo,'cp_web_quote_notifications')) {
        $title = sprintf('CPQ-%06d · %s', $requestId, $name);
        $message = 'Impresión · ' . $phone . ' · ' . $fileCount . ' archivo(s) · ' . money($total);
        $pdo->prepare('INSERT INTO cp_web_quote_notifications (request_id,event_type,title,message,created_at) VALUES (?,?,?,?,NOW())')
            ->execute([$requestId,'new_request',$title,$message]);
    }
    $pdo->commit();
    json_response(['ok'=>true,'request_id'=>$requestId,'request_token'=>$token,'total'=>$total,'items'=>$summary]);
} catch (Throwable $e) {
    if ($pdo->inTransaction()) $pdo->rollBack();
    foreach ($stored as $p) @unlink($p);
    json_response(['ok'=>false,'error'=>$e->getMessage()],500);
}
