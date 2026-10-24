<?php
declare(strict_types=1);

require_once __DIR__ . '/../includes/mercadopago.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('X-Robots-Tag: noindex, nofollow', true);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok'=>false]);
    exit;
}

$raw = file_get_contents('php://input');
$payload = json_decode((string)$raw, true);
if (!is_array($payload)) $payload = [];

$dataId = trim((string)(
    $_GET['data_id']
    ?? ($_GET['data.id'] ?? '')
    ?: ($payload['data']['id'] ?? '')
));

$type = trim((string)($payload['type'] ?? ($_GET['type'] ?? '')));

if ($type !== 'order' || $dataId === '') {
    http_response_code(200);
    echo json_encode(['ok'=>true,'ignored'=>true]);
    exit;
}

if (!mp_validate_webhook_signature($dataId)) {
    http_response_code(401);
    echo json_encode(['ok'=>false,'error'=>'invalid_signature']);
    exit;
}

try {
    $st = db()->prepare(
        'UPDATE cp_mercadopago_orders
         SET last_webhook_at=NOW(),updated_at=NOW()
         WHERE mp_order_id=?'
    );
    $st->execute([$dataId]);

    $local = mp_sync_remote_order($dataId);

    http_response_code(200);
    echo json_encode([
        'ok'=>true,
        'matched'=>$local !== null,
    ]);
} catch (Throwable $e) {
    error_log('[SISACT][MercadoPago][webhook] ' . $e->getMessage());
    http_response_code(500);
    echo json_encode(['ok'=>false]);
}
