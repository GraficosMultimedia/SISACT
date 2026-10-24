<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/payment_receipts.php';
require_once __DIR__ . '/../includes/tracking_activity.php';
require_once __DIR__ . '/../includes/seguimiento.php';
require_once __DIR__ . '/../includes/seguimiento_cancelacion_kanban_v1.php';

// SISACT_RECEIPT_CANCEL_GUARD_V1
// Endpoint público protegido por token de seguimiento.
// Una orden/cotización cancelada no puede recibir nuevos comprobantes.

function prc_track_redirect(string $token, string $extra = ''): never
{
    header(
        'Location: /seguimiento.php?t=' . rawurlencode($token) . $extra,
        true,
        302
    );
    exit;
}

function prc_error_page(string $token, string $message, int $status = 400): never
{
    http_response_code($status);

    $safeMessage = htmlspecialchars(
        $message,
        ENT_QUOTES,
        'UTF-8'
    );

    $safeUrl = '/seguimiento.php?t=' . rawurlencode($token);

    echo '<!doctype html>'
        . '<html lang="es-MX">'
        . '<head>'
        . '<meta charset="utf-8">'
        . '<meta name="viewport" content="width=device-width,initial-scale=1">'
        . '<meta name="robots" content="noindex,nofollow">'
        . '<title>Comprobante de pago · Colibrí Print</title>'
        . '<style>'
        . 'body{font-family:system-ui,-apple-system,"Segoe UI",sans-serif;background:#f4f7fb;padding:28px;color:#18222d;margin:0}'
        . '.box{max-width:580px;margin:40px auto;background:#fff;border:1px solid #dfe7ef;border-radius:18px;padding:24px;box-shadow:0 18px 50px rgba(18,44,74,.08)}'
        . '.eyebrow{display:block;color:#0d88ca;font-size:11px;font-weight:900;letter-spacing:.10em;text-transform:uppercase;margin-bottom:8px}'
        . 'h1{font-size:22px;line-height:1.2;margin:0 0 10px;color:#102a56}'
        . 'p{color:#61758d;line-height:1.65;margin:0}'
        . 'a{display:inline-flex;align-items:center;justify-content:center;margin-top:18px;min-height:44px;background:linear-gradient(135deg,#098ed8,#20c3e9);color:#fff;padding:0 16px;border-radius:11px;text-decoration:none;font-weight:800}'
        . '</style>'
        . '</head>'
        . '<body>'
        . '<div class="box">'
        . '<span class="eyebrow">PAGO · SEGUIMIENTO</span>'
        . '<h1>No se pudo enviar el comprobante</h1>'
        . '<p>' . $safeMessage . '</p>'
        . '<a href="' . htmlspecialchars($safeUrl, ENT_QUOTES, 'UTF-8') . '">Volver al seguimiento</a>'
        . '</div>'
        . '</body>'
        . '</html>';

    exit;
}

if (strtoupper((string)($_SERVER['REQUEST_METHOD'] ?? 'GET')) !== 'POST') {
    http_response_code(405);
    header('Allow: POST');
    exit('Método no permitido.');
}

$token = trim(
    (string)(
        $_POST['tracking_token']
        ?? ''
    )
);

if (!preg_match('/^[a-f0-9]{64}$/i', $token)) {
    http_response_code(400);
    exit('Enlace de seguimiento no válido.');
}

$st = db()->prepare(
    'SELECT order_id
     FROM cp_tracking_tokens
     WHERE token=?
       AND active=1
     LIMIT 1'
);

$st->execute([$token]);
$orderId = (int)$st->fetchColumn();

if ($orderId <= 0) {
    http_response_code(404);
    exit('Seguimiento no encontrado.');
}

try {
    /*
     * PROTECCIÓN CRÍTICA
     * -------------------
     * El helper verifica las tres fuentes de cancelación usadas por SISACT:
     *
     * - cp_orders.status = cancelled
     * - cp_order_status.stage = cancelled
     * - cp_quotes.status = cancelled
     *
     * Debe ejecutarse ANTES de guardar cualquier archivo o registrar
     * el comprobante.
     */
    tracking_guard_v1_assert_active($orderId);

    $receipt = payment_receipt_upload(
        $orderId,
        is_array($_FILES['receipt'] ?? null)
            ? $_FILES['receipt']
            : [],
        (string)($_POST['note'] ?? '')
    );

    /*
     * La analítica es posterior a la carga exitosa. Si tracking_activity_log()
     * falla internamente, su propio helper no interrumpe el flujo del pago.
     */
    tracking_activity_log(
        'payment_receipt_uploaded',
        $orderId,
        null,
        null,
        null,
        (int)($receipt['id'] ?? 0) ?: null,
        $token
    );

    prc_track_redirect(
        $token,
        '&receipt_sent=1#comprobantes-pago'
    );
} catch (Throwable $e) {
    $message = trim($e->getMessage());

    if ($message === '') {
        $message = 'No fue posible procesar el comprobante de pago.';
    }

    error_log(
        '[SISACT][comprobante_pago_cliente] order_id=' . $orderId
        . ' ' . $message
    );

    prc_error_page(
        $token,
        $message,
        400
    );
}
