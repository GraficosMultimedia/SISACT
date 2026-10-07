<?php
declare(strict_types=1);

require_once __DIR__.'/../config/runtime.php';
require_once __DIR__.'/../includes/impresiones.php';
require_auth();

if($_SERVER['REQUEST_METHOD']!=='POST'){
    http_response_code(405);
    exit('Método no permitido.');
}

try{
    if(!csrf_check($_POST['_csrf']??null)){
        throw new RuntimeException('La sesión del formulario expiró. Recarga la página e intenta nuevamente.');
    }

    $payload=print_meter_normalize($_POST);
    $payload['roll_name']=trim((string)($_POST['roll_name']??''));

    if($payload['roll_id']<=0 || $payload['linear_m']<=0 || $payload['job_name']===''){
        throw new RuntimeException('Completa rollo, trabajo y metros lineales.');
    }

    $id=print_meter_register_safe($payload);

    log_activity(
        'create',
        'print_meter_logs',
        'Trabajo impreso #'.$id.' · '.$payload['job_name'].' · '.$payload['linear_m'].' m'
    );

    header(
        'Location: /admin/impresiones.php?saved=1&log_id=' .
        $id .
        '&roll_id=' . (int)$payload['roll_id'] .
        '&_=' . rawurlencode((string)time())
    );
    exit;

}catch(Throwable $e){
    $msg=$e instanceof RuntimeException
        ? $e->getMessage()
        : 'No se pudo guardar el registro de impresión.';

    $encoded=rawurlencode($msg);
    header('Location: /admin/impresiones.php?save_error='.$encoded.'&_='.time());
    exit;
}
?>
