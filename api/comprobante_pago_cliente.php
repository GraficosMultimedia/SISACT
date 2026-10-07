<?php
declare(strict_types=1);

require_once __DIR__.'/../config/runtime.php';
require_once __DIR__.'/../includes/payment_receipts.php';

function prc_track_redirect(string $token,string $extra=''): never {
    header('Location: /seguimiento.php?t='.rawurlencode($token).$extra);
    exit;
}

$token=trim((string)($_POST['tracking_token']??''));
if(!preg_match('/^[a-f0-9]{64}$/i',$token)){
    http_response_code(400);
    exit('Enlace de seguimiento no válido.');
}

$st=db()->prepare('SELECT order_id FROM cp_tracking_tokens WHERE token=? AND active=1 LIMIT 1');
$st->execute([$token]);
$orderId=(int)$st->fetchColumn();
if($orderId<=0){http_response_code(404);exit('Seguimiento no encontrado.');}

try{
    payment_receipt_upload(
        $orderId,
        is_array($_FILES['receipt']??null)?$_FILES['receipt']:[],
        (string)($_POST['note']??'')
    );
    prc_track_redirect($token,'&receipt_sent=1#comprobantes-pago');
}catch(Throwable $e){
    http_response_code(400);
    echo '<!doctype html><html lang="es"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Comprobante</title><style>body{font-family:system-ui;background:#f4f6f8;padding:28px;color:#18222d}.box{max-width:560px;margin:auto;background:#fff;border:1px solid #dfe5eb;border-radius:16px;padding:22px}a{display:inline-block;margin-top:15px;background:#ff1751;color:#fff;padding:11px 14px;border-radius:10px;text-decoration:none;font-weight:800}</style></head><body><div class="box"><strong>No se pudo enviar el comprobante.</strong><p>'.htmlspecialchars($e->getMessage(),ENT_QUOTES,'UTF-8').'</p><a href="/seguimiento.php?t='.rawurlencode($token).'">Volver</a></div></body></html>';
}
