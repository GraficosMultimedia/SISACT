<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
header('Content-Type: application/json; charset=utf-8');
$out=['app'=>'Colibrí Print','phase'=>'1','time'=>date('c'),'database'=>false,'akaunting_read'=>false];
try{db()->query('SELECT 1');$out['database']=true;}catch(Throwable $e){}
try{akaunting_db()->query('SELECT 1');$out['akaunting_read']=true;}catch(Throwable $e){}
echo json_encode($out, JSON_UNESCAPED_UNICODE|JSON_PRETTY_PRINT);
