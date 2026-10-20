<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

if($_SERVER['REQUEST_METHOD']!=='POST'){
 redirect('/admin/cotizaciones_web.php');
}
if(!csrf_check($_POST['_csrf']??null)){
 die('La sesión expiró. Recarga la página.');
}

$ids=[];
foreach((array)($_POST['ids']??[]) as $id){
 $id=(int)$id;
 if($id>0)$ids[$id]=true;
}
$ids=array_keys($ids);
if(!$ids)redirect('/admin/cotizaciones_web.php');

$pdo=db();
$deleted=0;
$blocked=0;

try{
 $pdo->beginTransaction();

 $hasConversion=false;
 $c=$pdo->prepare("SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cp_web_quote_requests' AND COLUMN_NAME='converted_quote_id'");
 $c->execute();
 $hasConversion=(int)$c->fetchColumn()===1;

 foreach($ids as $id){
   $st=$pdo->prepare('SELECT request_token,request_text'.($hasConversion?',converted_quote_id':'').' FROM cp_web_quote_requests WHERE id=? FOR UPDATE');
   $st->execute([$id]);
   $row=$st->fetch(PDO::FETCH_ASSOC);
   if(!$row)continue;

   if($hasConversion && (int)($row['converted_quote_id']??0)>0){
      $blocked++;
      continue;
   }

   $path='';
   $text=(string)($row['request_text']??'');
   $pos=strpos($text,'[CPQ_JSON]');
   if($pos!==false){
      $json=json_decode(trim(substr($text,$pos+strlen('[CPQ_JSON]'))),true);
      if(is_array($json))$path=(string)($json['attachment']['relative_path']??'');
   }

   $st=$pdo->prepare('DELETE FROM cp_web_quote_requests WHERE id=?');
   $st->execute([$id]);
   if($st->rowCount()>0){
      $deleted++;
      if(preg_match('#^/uploads/cotizador/[A-Za-z0-9/_\.-]+$#',$path)){
        $absolute=realpath(__DIR__.'/..'.$path);
        $base=realpath(__DIR__.'/../uploads/cotizador');
        if($absolute && $base && str_starts_with($absolute,$base.DIRECTORY_SEPARATOR) && is_file($absolute)){
          @unlink($absolute);
        }
      }
      if(function_exists('log_activity')){
        log_activity('delete','web_quote_requests','Solicitud web CPQ-'.str_pad((string)$id,6,'0',STR_PAD_LEFT).' eliminada');
      }
   }
 }

 $pdo->commit();
}catch(Throwable $e){
 if($pdo->inTransaction())$pdo->rollBack();
 http_response_code(500);
 die('No se pudieron eliminar las solicitudes seleccionadas. Ningún cambio parcial fue confirmado.');
}

$url='/admin/cotizaciones_web.php?deleted='.urlencode((string)$deleted);
if($blocked>0)$url.='&blocked='.urlencode((string)$blocked);
redirect($url);
