<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/mercadopago.php';

$returnToken = trim((string)($_GET['r'] ?? ''));
$result = trim((string)($_GET['result'] ?? ''));
$local = mp_transaction_by_return_token($returnToken);

if (!$local) {
    http_response_code(404);
    exit('No se encontró la operación de pago.');
}

try {
    if (!empty($local['mp_order_id'])) {
        $local = mp_sync_remote_order((string)$local['mp_order_id']) ?: $local;
    }
} catch (Throwable $e) {
    error_log('[SISACT][MercadoPago][retorno] ' . $e->getMessage());
}

$orderId = (int)$local['order_id'];
$trackingUrl = tracking_url_for_order($orderId);
$finance = tracking_payment_summary($orderId);
$balance = round((float)$finance['balance'], 2);

$status = (string)($local['status'] ?? '');
$detail = (string)($local['status_detail'] ?? '');

$isApproved = $balance <= 0.009 || ($status === 'processed' && $detail === 'accredited');
$isPending = in_array($status, ['created','processing','action_required'], true) || $result === 'pending';

$title = $isApproved ? 'Pago confirmado' : ($isPending ? 'Pago en proceso' : 'Pago no confirmado');
$message = $isApproved
    ? 'Mercado Pago confirmó el pago y SISACT lo registró automáticamente en tu orden.'
    : ($isPending
        ? 'Tu operación fue recibida. Actualizaremos tu orden automáticamente cuando Mercado Pago confirme la acreditación.'
        : 'El pago no pudo confirmarse. Puedes regresar a tu seguimiento e intentarlo nuevamente.');

$color = $isApproved ? '#0f9f62' : ($isPending ? '#d49317' : '#d74d61');

header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title><?=htmlspecialchars($title,ENT_QUOTES,'UTF-8')?></title>
<style>
*{box-sizing:border-box}body{margin:0;background:#f4f7fb;color:#172b4d;font-family:Inter,system-ui,-apple-system,"Segoe UI",sans-serif}
.wrap{min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px}
.card{width:min(560px,100%);background:#fff;border:1px solid #e3ebf5;border-radius:22px;padding:30px;box-shadow:0 18px 55px rgba(16,42,86,.1);text-align:center}
.icon{width:64px;height:64px;margin:0 auto 18px;border-radius:50%;display:flex;align-items:center;justify-content:center;background:<?=htmlspecialchars($color,ENT_QUOTES,'UTF-8')?>18;color:<?=htmlspecialchars($color,ENT_QUOTES,'UTF-8')?>;font-size:30px}
h1{margin:0;color:#102a56;font-size:28px}.message{margin:12px auto 20px;color:#63748c;line-height:1.6;font-size:14px}
.amount{margin:18px 0;padding:14px;background:#f7faff;border:1px solid #e4edf7;border-radius:13px}
.amount span{display:block;color:#718096;font-size:11px}.amount strong{display:block;margin-top:5px;color:#102a56;font-size:24px}
.btn{display:inline-flex;align-items:center;justify-content:center;padding:12px 18px;border-radius:11px;background:#087bd9;color:#fff;text-decoration:none;font-weight:800;font-size:13px}
small{display:block;margin-top:16px;color:#8a98aa}
</style>
</head>
<body>
<div class="wrap">
<div class="card">
<div class="icon"><?=$isApproved?'✓':($isPending?'⌛':'!')?></div>
<h1><?=htmlspecialchars($title,ENT_QUOTES,'UTF-8')?></h1>
<p class="message"><?=htmlspecialchars($message,ENT_QUOTES,'UTF-8')?></p>
<div class="amount"><span>Saldo pendiente actual</span><strong>$<?=number_format($balance,2,'.',',')?></strong></div>
<a class="btn" href="<?=htmlspecialchars($trackingUrl,ENT_QUOTES,'UTF-8')?>">Volver a mi seguimiento</a>
<small>No cierres tu orden de servicio hasta confirmar que el saldo aparezca actualizado.</small>
</div>
</div>
</body>
</html>
