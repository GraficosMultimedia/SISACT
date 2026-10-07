<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';
header('Content-Type: application/json; charset=utf-8');
if($_SERVER['REQUEST_METHOD']!=='POST'){http_response_code(405);echo json_encode(['ok'=>false,'message'=>'Método no permitido.']);exit;}
cp_check_csrf($_POST['csrf']??null);$token=trim((string)($_POST['token']??''));$stored=basename(trim((string)($_POST['token_name']??'')));
if(!preg_match('/^[a-f0-9]{32}$/',$token)||$stored===''){http_response_code(422);echo json_encode(['ok'=>false,'message'=>'Sesión de análisis inválida.']);exit;}
$path=CP_TMP_DIR.'/'.$token.'/'.$stored;if(!is_file($path)){http_response_code(404);echo json_encode(['ok'=>false,'message'=>'El archivo temporal ya no está disponible.']);exit;}
$ext=strtolower(pathinfo($stored,PATHINFO_EXTENSION));$mime='';if(function_exists('finfo_open')){$f=finfo_open(FILEINFO_MIME_TYPE);if($f){$mime=(string)finfo_file($f,$path);finfo_close($f);}}
try{$pages=cp_detect_pages($path,$mime,$ext);if($pages<1)throw new RuntimeException('No se pudo determinar la cantidad de páginas.');echo json_encode(['ok'=>true,'token'=>$token,'token_name'=>$stored,'pages'=>$pages,'sheets'=>$pages],JSON_UNESCAPED_UNICODE);}catch(Throwable $e){http_response_code(422);echo json_encode(['ok'=>false,'message'=>'No se pudo contar automáticamente este archivo.']);}