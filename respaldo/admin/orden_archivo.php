<?php
declare(strict_types=1);
require_once __DIR__.'/../config/runtime.php';
require_once __DIR__.'/../includes/order_media.php';
require_auth();

$id=(int)($_GET['id']??0);
if($id<=0){http_response_code(400);exit('Archivo inválido.');}

$st=db()->prepare('SELECT p.* FROM cp_order_photos p WHERE p.id=? LIMIT 1');
$st->execute([$id]);
$row=$st->fetch();
if(!$row){http_response_code(404);exit('Archivo no encontrado.');}

$base=realpath(__DIR__.'/../uploads/orders/'.(int)$row['order_id']);
$file=realpath(__DIR__.'/..'.(string)$row['file_path']);
if(!$base||!$file||!str_starts_with($file,$base.DIRECTORY_SEPARATOR)||!is_file($file)){
    http_response_code(404);exit('Archivo no disponible.');
}

$mime=(string)($row['mime_type']??'application/octet-stream');
$name=preg_replace('/[^A-Za-z0-9._-]+/','_',((string)$row['original_name']?:'archivo'));
$inline=order_file_is_image($row)||$mime==='application/pdf';
$download=($_GET['download']??'')==='1';

header('X-Content-Type-Options: nosniff');
header('Cache-Control: private,no-store,no-cache,must-revalidate,max-age=0');
header('Content-Type: '.$mime);
header('Content-Length: '.filesize($file));
header('Content-Disposition: '.(($inline&&!$download)?'inline':'attachment').'; filename="'.$name.'"');
readfile($file);
exit;
