<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/quote_conditions.php';
require_once __DIR__ . '/../includes/public_quote_links.php';
require_auth();

function cpqconv_h($v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}
function cpqconv_fail(string $message): never {
    http_response_code(500);
    ?>
    <!doctype html>
    <html lang="es-MX">
    <head>
      <meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
      <title>Conversión · Colibrí Print</title>
      <style>
        body{margin:0;background:#071321;color:#fff;font-family:Arial,sans-serif;padding:30px}
        .box{max-width:820px;margin:50px auto;background:#0c1d2b;border:1px solid #284d66;border-radius:16px;padding:25px}
        h1{margin:0 0 10px;color:#ff657e}.msg{background:#07111a;border:1px solid #31485a;border-radius:10px;padding:14px;white-space:pre-wrap;font:13px/1.5 Consolas,monospace}
        a{display:inline-block;margin-top:16px;background:#1dbfe8;color:#04131c;text-decoration:none;font-weight:800;padding:11px 15px;border-radius:9px}
      </style>
    </head>
    <body><div class="box"><h1>No se pudo convertir</h1><p><?=cpqconv_h($message)?></p><a href="/admin/cotizaciones_web.php">← Volver a solicitudes web</a></div></body>
    </html>
    <?php
    exit;
}
function cpqconv_json(string $text): array {
    $pos=strpos($text,'[CPQ_JSON]');
    if($pos===false)return[];
    $decoded=json_decode(trim(substr($text,$pos+strlen('[CPQ_JSON]'))),true);
    return is_array($decoded)?$decoded:[];
}
function cpqconv_scalar_text(array $data): string {
    $lines=[];
    foreach($data as $key=>$value){
        if(!is_scalar($value))continue;
        $value=trim((string)$value);
        if($value==='')continue;
        $lines[]=ucwords(str_replace(['_','-'],' ',(string)$key)).': '.$value;
    }
    return implode(' · ',$lines);
}
function cpqconv_customer(PDO $pdo,array $request): ?array {
    $customerId=(int)($request['customer_id']??0);
    if($customerId>0){
        $st=$pdo->prepare('SELECT id,name,email,phone,address,city,state,zip_code,tax_number,country FROM cp_customers WHERE id=? AND enabled=1 LIMIT 1');
        $st->execute([$customerId]);
        if($row=$st->fetch(PDO::FETCH_ASSOC))return$row;
    }
    $email=trim((string)($request['email']??''));
    if($email!==''){
        $st=$pdo->prepare('SELECT id,name,email,phone,address,city,state,zip_code,tax_number,country FROM cp_customers WHERE enabled=1 AND LOWER(email)=LOWER(?) ORDER BY id LIMIT 1');
        $st->execute([$email]);
        if($row=$st->fetch(PDO::FETCH_ASSOC))return$row;
    }
    $digits=preg_replace('/\D+/','',(string)($request['phone']??''))?:'';
    if($digits!==''){
        $last10=strlen($digits)>10?substr($digits,-10):$digits;
        $st=$pdo->prepare("SELECT id,name,email,phone,address,city,state,zip_code,tax_number,country
            FROM cp_customers
            WHERE enabled=1 AND phone IS NOT NULL
              AND REPLACE(REPLACE(REPLACE(REPLACE(phone,' ',''),'-',''),'(',''),')','') LIKE ?
            ORDER BY id LIMIT 1");
        $st->execute(['%'.$last10]);
        if($row=$st->fetch(PDO::FETCH_ASSOC))return$row;
    }
    return null;
}
function cpqconv_create_customer(PDO $pdo,array $request): int {
    $st=$pdo->prepare('INSERT INTO cp_customers
      (source_type,source_id,name,email,phone,country,enabled,created_at,updated_at)
      VALUES(?,?,?,?,?,?,1,NOW(),NOW())');
    $st->execute([
      'web',null,
      trim((string)($request['customer_name']??''))?:'Cliente web',
      trim((string)($request['email']??''))?:null,
      trim((string)($request['phone']??''))?:null,
      'MX'
    ]);
    return(int)$pdo->lastInsertId();
}
function cpqconv_quote_number(PDO $pdo): string {
    $prefix='CP-'.date('Y').'-';
    $st=$pdo->prepare('SELECT quote_number FROM cp_quotes WHERE quote_number LIKE ? ORDER BY id DESC LIMIT 1');
    $st->execute([$prefix.'%']);
    $last=$st->fetchColumn();
    $seq=1;
    if(is_string($last)&&preg_match('/-(\d+)$/',$last,$m))$seq=(int)$m[1]+1;
    return$prefix.str_pad((string)$seq,5,'0',STR_PAD_LEFT);
}

if($_SERVER['REQUEST_METHOD']!=='POST')cpqconv_fail('Método no permitido.');
if(!csrf_check($_POST['_csrf']??null))cpqconv_fail('La sesión expiró. Recarga la página.');

$requestId=(int)($_POST['request_id']??0);
if($requestId<=0)cpqconv_fail('Solicitud web inválida.');

$pdo=db();

/*
 * IMPORTANTE:
 * quote_condition_default() puede crear la tabla de condiciones si todavía
 * no existe. MySQL ejecuta DDL con COMMIT implícito, así que debe resolverse
 * ANTES de abrir la transacción principal.
 */
$condition=function_exists('quote_condition_default')?quote_condition_default():null;
$payment=(string)($condition['payment_terms']??'');
$terms=(string)($condition['terms']??'');
$deliveryTime=(string)($condition['delivery_time']??'');
$defaultDeliveryPlace=(string)($condition['delivery_place']??'');

try{
    $pdo->beginTransaction();

    $st=$pdo->prepare('SELECT * FROM cp_web_quote_requests WHERE id=? FOR UPDATE');
    $st->execute([$requestId]);
    $request=$st->fetch(PDO::FETCH_ASSOC);
    if(!$request)throw new RuntimeException('No se encontró la solicitud web.');

    $convertedId=(int)($request['converted_quote_id']??0);
    if($convertedId>0){
        $pdo->commit();
        redirect('/admin/cotizacion.php?id='.$convertedId.'&from_web=1');
    }

    $payload=cpqconv_json((string)$request['request_text']);
    $serviceName=(string)($payload['service']['name']??$request['service_key']??'Solicitud web');
    $serviceKey=(string)($payload['service']['key']??$request['service_key']??'web');
    $details=is_array($payload['details']??null)?$payload['details']:[];
    $production=is_array($payload['production']??null)?$payload['production']:[];
    $delivery=is_array($payload['delivery']??null)?$payload['delivery']:[];
    $attachment=is_array($payload['attachment']??null)?$payload['attachment']:[];

    $customer=cpqconv_customer($pdo,$request);
    if(!$customer){
        $customerId=cpqconv_create_customer($pdo,$request);
        $st=$pdo->prepare('SELECT id,name,email,phone,address,city,state,zip_code,tax_number,country FROM cp_customers WHERE id=? LIMIT 1');
        $st->execute([$customerId]);
        $customer=$st->fetch(PDO::FETCH_ASSOC)?:null;
    }else{
        $customerId=(int)$customer['id'];
    }
    if(!$customer)throw new RuntimeException('No fue posible asociar o crear el cliente.');

    $quoteNumber=cpqconv_quote_number($pdo);
    $issueDate=date('Y-m-d');
    $validUntil=date('Y-m-d',strtotime('+15 days'));
    $uid=0;
    if(function_exists('current_user'))$uid=(int)(current_user()['id']??0);

    $qtyRaw=(string)($details['quantity']??$request['quantity']??'1');
    $quantity=is_numeric($qtyRaw)?max(0.001,(float)$qtyRaw):1.0;

    $description=$serviceName;
    $detailText=cpqconv_scalar_text($details);
    if($detailText!=='')$description.=' | '.$detailText;
    if(function_exists('mb_substr'))$description=mb_substr($description,0,500);else$description=substr($description,0,500);

    $notes=['Solicitud recibida desde la web: CPQ-'.str_pad((string)$requestId,6,'0',STR_PAD_LEFT).'.'];
    if(!empty($request['desired_date']))$notes[]='Fecha solicitada: '.$request['desired_date'].'.';
    if(!empty($delivery['method']))$notes[]='Forma de entrega: '.$delivery['method'].'.';
    if(!empty($production['notes']))$notes[]=trim((string)$production['notes']);

    $internal=[
      'ORIGEN: Solicitud web CPQ-'.str_pad((string)$requestId,6,'0',STR_PAD_LEFT),
      'Solicitud web ID: '.$requestId,
      'Servicio: '.$serviceName.' ('.$serviceKey.')',
      'Cliente capturado: '.($request['customer_name']??''),
      'WhatsApp: '.($request['phone']??'No indicado'),
      'Correo: '.($request['email']??'No indicado'),
      'Fecha solicitada: '.($request['desired_date']??'No indicada')
    ];
    if($detailText!=='')$internal[]='DETALLES: '.$detailText;
    if($production)$internal[]='PRODUCCIÓN: '.cpqconv_scalar_text($production);
    if($delivery)$internal[]='ENTREGA: '.cpqconv_scalar_text($delivery);
    if($attachment)$internal[]='ARCHIVO: '.((string)($attachment['original_name']??''));
    $internal[]='PAYLOAD WEB: '.json_encode($payload,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES);

    $deliveryPlace=(string)($delivery['method']??$defaultDeliveryPlace);

    $sourceData=[
      'source'=>'web',
      'title'=>$serviceName,
      'input'=>$details,
      'result'=>[],
      'web_request_id'=>$requestId,
      'request_token'=>(string)$request['request_token'],
      'payload'=>$payload,
      'attachment'=>$attachment,
      'created_at'=>date('c')
    ];

    $st=$pdo->prepare('INSERT INTO cp_quotes
      (quote_number,customer_id,status,issue_date,valid_until,client_reference,payment_terms,
       delivery_time,delivery_place,notes,terms,internal_notes,source_calculator,source_data,
       created_by,updated_by,created_at,updated_at)
      VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');
    $st->execute([
      $quoteNumber,$customerId,'draft',$issueDate,$validUntil,
      'Solicitud web CPQ-'.str_pad((string)$requestId,6,'0',STR_PAD_LEFT),
      $payment?:null,$deliveryTime?:null,$deliveryPlace?:null,
      implode("\n",$notes),$terms?:null,implode("\n",$internal),
      'web',json_encode($sourceData,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),
      $uid?:null,$uid?:null
    ]);
    $quoteId=(int)$pdo->lastInsertId();
    if($quoteId<=0)throw new RuntimeException('La cotización no devolvió un ID válido.');
    cp_ensure_quote_public_token($pdo,$quoteId);

    $st=$pdo->prepare('INSERT INTO cp_quote_items
      (quote_id,description,quantity,unit_price,subtotal,calculator_source,sort_order,created_at,updated_at)
      VALUES(?,?,?,?,?,?,?,NOW(),NOW())');
    $st->execute([$quoteId,$description,$quantity,0.00,0.00,'web',0]);

    $st=$pdo->prepare('INSERT INTO cp_quote_totals
      (quote_id,subtotal,discount,tax,total,internal_cost,profit,margin_pct,created_at,updated_at)
      VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())');
    $st->execute([$quoteId,0,0,0,0,0,0,0]);

    $st=$pdo->prepare('UPDATE cp_web_quote_requests
      SET converted_quote_id=?,converted_at=NOW(),status=?,updated_at=NOW()
      WHERE id=?');
    $st->execute([$quoteId,'reviewing',$requestId]);

    /*
     * Importante:
     * No ejecutar log_activity() después del COMMIT. En esta instalación
     * esa función puede abrir/cerrar su propia transacción y provocar el
     * mensaje engañoso "There is no active transaction".
     */
    if (!$pdo->inTransaction()) {
        throw new RuntimeException('La transacción dejó de estar activa antes de COMMIT. No se confirmó la operación.');
    }
    $pdo->commit();

    redirect('/admin/cotizacion.php?id='.$quoteId.'&from_web=1&web_request_id='.$requestId.'&converted=1');

}catch(Throwable $e){
    if($pdo->inTransaction())$pdo->rollBack();
    error_log('[ColibriPrint][CPQ->QUOTE] '.$e->getMessage());
    cpqconv_fail('La conversión falló y fue revertida. '.$e->getMessage());
}
