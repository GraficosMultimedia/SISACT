<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/mercadopago.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit('Método no permitido.');
}

$token = trim((string)($_POST['tracking_token'] ?? ''));
$order = tracking_order_by_token($token);

if (!$order) {
    http_response_code(404);
    exit('El enlace de seguimiento no es válido.');
}

try {
    $checkout = mp_create_checkout((int)$order['id'], $token);
    $url = trim((string)($checkout['checkout_url'] ?? ''));
    if ($url === '') throw new RuntimeException('No se obtuvo la URL de pago.');

    header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
    header('Location: ' . $url, true, 303);
    exit;
} catch (Throwable $e) {
    error_log('[SISACT][MercadoPago][iniciar] ' . $e->getMessage());

    $back = '/seguimiento.php?t=' . rawurlencode($token)
        . '&mp_error=' . rawurlencode('No fue posible iniciar el pago. Intenta nuevamente.');
    header('Location: ' . $back, true, 303);
    exit;
}
