<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/seguimiento.php';
require_once __DIR__ . '/../includes/tracking_activity_verified.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('X-Robots-Tag: noindex, nofollow', true);

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['ok'=>false]);
    exit;
}

$token = trim((string)($_POST['token'] ?? ''));
if (!preg_match('/^[a-f0-9]{64}$/i', $token)) {
    http_response_code(400);
    echo json_encode(['ok'=>false]);
    exit;
}

$order = tracking_order_by_token($token);
if (!$order) {
    http_response_code(404);
    echo json_encode(['ok'=>false]);
    exit;
}

$orderId = (int)($order['id'] ?? 0);
if ($orderId <= 0) {
    http_response_code(404);
    echo json_encode(['ok'=>false]);
    exit;
}

$eventId = tracking_activity_log_verified(
    'tracking_view',
    $orderId,
    (int)($order['customer_id'] ?? 0) ?: null,
    null,
    null,
    null,
    $token,
    120
);

echo json_encode(
    ['ok'=>$eventId !== null,'event_id'=>$eventId],
    JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
);
