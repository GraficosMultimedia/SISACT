<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

$id=(int)($_GET['id'] ?? 0);
if($id<=0){http_response_code(404);exit('Archivo no encontrado.');}

try{
    $st=db()->prepare('SELECT original_name,stored_path,mime_type,size_bytes FROM cp_web_quote_files WHERE id=? LIMIT 1');
    $st->execute([$id]);
    $file=$st->fetch(PDO::FETCH_ASSOC);
    if(!$file){http_response_code(404);exit('Archivo no encontrado.');}

    $path=realpath(__DIR__.'/..'.(string)$file['stored_path']);
    $base=realpath(__DIR__.'/../uploads/cotizador');
    if(!$path||!$base||!str_starts_with($path,$base.DIRECTORY_SEPARATOR)||!is_file($path)){
        http_response_code(404);exit('Archivo no disponible.');
    }

    header('X-Content-Type-Options: nosniff');
    header('Content-Type: '.((string)$file['mime_type'] ?: 'application/octet-stream'));
    header('Content-Length: '.(string)filesize($path));
    header("Content-Disposition: inline; filename*=UTF-8''".rawurlencode((string)$file['original_name']));
    readfile($path);
}catch(Throwable $e){
    http_response_code(500);
    exit('No se pudo abrir el archivo.');
}
