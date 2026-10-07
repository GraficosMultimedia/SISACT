<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';
if($_SERVER['REQUEST_METHOD']!=='POST'){http_response_code(405);exit('Método no permitido.');}
cp_check_csrf($_POST['csrf']??null);$name=trim((string)($_POST['customer_name']??''));$email=trim((string)($_POST['customer_email']??''));$phone=trim((string)($_POST['customer_phone']??''));$token=trim((string)($_POST['upload_token']??''));$items=json_decode((string)($_POST['items_json']??'[]'),true);
if($name===''||!filter_var($email,FILTER_VALIDATE_EMAIL)||$phone===''||!preg_match('/^[a-f0-9]{32}$/',$token)){http_response_code(422);exit('Datos de solicitud incompletos.');}if(!is_array($items)||!$items){http_response_code(422);exit('No se recibieron archivos.');}
$db=cp_db();$tmpDir=CP_TMP_DIR.'/'.$token;if(!is_dir($tmpDir)){http_response_code(422);exit('La sesión de archivos expiró. Vuelve a seleccionar los archivos.');}
$sizeStmt=$db->prepare("SELECT * FROM cp_print_sizes WHERE id=? AND enabled=1 LIMIT 1");$matStmt=$db->prepare("SELECT * FROM cp_print_materials WHERE id=? AND enabled=1 LIMIT 1");$finStmt=$db->prepare("SELECT * FROM cp_print_finishes WHERE id=? AND enabled=1 LIMIT 1");$priceStmt=$db->prepare("SELECT * FROM cp_print_prices WHERE size_id=? AND material_id=? AND finish_id=? AND color_mode=? AND pricing_mode=? AND enabled=1 LIMIT 1");$validated=[];$total=0.0;
foreach($items as $item){if(!is_array($item))continue;$stored=basename((string)($item['token_name']??''));$path=$tmpDir.'/'.$stored;if(!$stored||!is_file($path))continue;$sizeId=(int)($item['size_id']??0);$matId=(int)($item['material_id']??0);$finId=(int)($item['finish_id']??0);$color=($item['color_mode']??'color')==='bw'?'bw':'color';$mode=($item['pricing_mode']??'per_page')==='per_sheet'?'per_sheet':'per_page';$copies=max(1,min(9999,(int)($item['copies']??1)));$source='manual';$sizeStmt->execute([$sizeId]);$sizeRow=$sizeStmt->fetch();$matStmt->execute([$matId]);$matRow=$matStmt->fetch();$finStmt->execute([$finId]);$finRow=$finStmt->fetch();$priceStmt->execute([$sizeId,$matId,$finId,$color,$mode]);$priceRow=$priceStmt->fetch();if(!$sizeRow||!$matRow||!$finRow||!$priceRow){http_response_code(422);exit('Una de las combinaciones seleccionadas no tiene una tarifa activa.');}
    // El conteo automático de páginas queda desactivado.
    // El cliente debe indicar manualmente cuántas páginas tiene cada archivo.
    $pages = max(1, min(100000, (int)($item['pages'] ?? 0)));
    if($pages < 1){
        http_response_code(422);
        exit('Indica manualmente cuántas páginas tiene cada archivo antes de enviar la solicitud.');
    }
    $qty=$mode==='per_sheet'?(int)ceil($pages/2):$pages;$unit=(float)$priceRow['unit_price'];$subtotal=$unit*$qty*$copies;$total+=$subtotal;$mime='';if(function_exists('finfo_open')){$f=finfo_open(FILEINFO_MIME_TYPE);if($f){$mime=(string)finfo_file($f,$path);finfo_close($f);}}if($mime==='')$mime='application/octet-stream';$validated[]=['stored'=>$stored,'path'=>$path,'name'=>basename((string)($item['original_name']??$stored)),'mime'=>$mime,'size'=>(int)filesize($path),'pages'=>$pages,'sheets'=>$mode==='per_sheet'?(int)ceil($pages/2)*$copies:$pages*$copies,'size_id'=>$sizeId,'material_id'=>$matId,'finish_id'=>$finId,'color'=>$color,'copies'=>$copies,'mode'=>$mode,'unit'=>$unit,'page_source'=>'manual','subtotal'=>$subtotal];}
if(!$validated){http_response_code(422);exit('No hay archivos válidos para registrar.');}
$db->beginTransaction();try{$st=$db->prepare("INSERT INTO cp_print_requests(customer_name,customer_email,customer_phone,status,total_estimate) VALUES(?,?,?,?,?)");$st->execute([$name,$email,$phone,'new',$total]);$requestId=(int)$db->lastInsertId();$itemSt=$db->prepare("INSERT INTO cp_print_request_items (request_id,original_name,stored_path,mime_type,file_size,page_count,sheet_count,size_id,material_id,finish_id,color_mode,copies,pricing_mode,unit_price,subtotal) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");$finalDir=CP_UPLOAD_DIR.'/'.$requestId;if(!is_dir($finalDir)&&!mkdir($finalDir,0775,true)&&!is_dir($finalDir))throw new RuntimeException('No fue posible crear la carpeta de la solicitud.');foreach($validated as $v){$finalPath=$finalDir.'/'.$v['stored'];if(!rename($v['path'],$finalPath)){
    if(!copy($v['path'],$finalPath) || !is_file($finalPath)){
        throw new RuntimeException('No fue posible guardar el archivo '.$v['name']);
    }
    @unlink($v['path']);
}$relative='uploads/print_requests/'.$requestId.'/'.$v['stored'];$itemSt->execute([$requestId,$v['name'],$relative,$v['mime'],$v['size'],$v['pages'],$v['sheets'],$v['size_id'],$v['material_id'],$v['finish_id'],$v['color'],$v['copies'],$v['mode'],$v['unit'],$v['subtotal']]);}$db->commit();}catch(Throwable $e){if($db->inTransaction())$db->rollBack();$errorId=bin2hex(random_bytes(4));
error_log('Colibri Print submit_request ['.$errorId.']: '.$e->getMessage().' @ '.$e->getFile().':'.$e->getLine());
http_response_code(500);
exit('No fue posible registrar la solicitud. Código de error: '.$errorId);}
@rmdir($tmpDir);cp_redirect('../solicitud_enviada.php?id='.$requestId);