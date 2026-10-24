<?php
declare(strict_types=1);

/**
 * SISACT · Cancelados → Ofertas V1
 *
 * Centraliza la validación para redirigir una orden cancelada desde
 * seguimiento.php hacia cotizacion_pdf_publica.php.
 *
 * La página de destino vuelve a verificar el estado, por lo que
 * ?estado=cancelado no es suficiente para forzar la pantalla.
 */

function cancelled_landing_v1_context_by_order_id(int $orderId): ?array
{
    if ($orderId <= 0) {
        return null;
    }

    $st = db()->prepare(
        "SELECT
            o.id AS order_id,
            o.order_number,
            o.status AS order_status,
            o.quote_id,
            q.quote_number,
            q.status AS quote_status,
            COALESCE(s.stage,'pending') AS production_stage
         FROM cp_orders o
         LEFT JOIN cp_quotes q
           ON q.id=o.quote_id
         LEFT JOIN cp_order_status s
           ON s.order_id=o.id
         WHERE o.id=?
         LIMIT 1"
    );

    $st->execute([$orderId]);
    $row = $st->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        return null;
    }

    return cancelled_landing_v1_normalize_context($row);
}

function cancelled_landing_v1_context_by_tracking_token(string $token): ?array
{
    $token = trim($token);

    if (!preg_match('/^[a-f0-9]{64}$/i', $token)) {
        return null;
    }

    $st = db()->prepare(
        "SELECT
            o.id AS order_id,
            o.order_number,
            o.status AS order_status,
            o.quote_id,
            q.quote_number,
            q.status AS quote_status,
            COALESCE(s.stage,'pending') AS production_stage
         FROM cp_tracking_tokens t
         INNER JOIN cp_orders o
           ON o.id=t.order_id
         LEFT JOIN cp_quotes q
           ON q.id=o.quote_id
         LEFT JOIN cp_order_status s
           ON s.order_id=o.id
         WHERE t.token=?
           AND t.active=1
         LIMIT 1"
    );

    $st->execute([$token]);
    $row = $st->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        return null;
    }

    return cancelled_landing_v1_normalize_context($row);
}

function cancelled_landing_v1_normalize_context(array $row): array
{
    $orderStatus = strtolower(
        trim((string)($row['order_status'] ?? ''))
    );

    $quoteStatus = strtolower(
        trim((string)($row['quote_status'] ?? ''))
    );

    $productionStage = strtolower(
        trim((string)($row['production_stage'] ?? 'pending'))
    );

    $cancelSource = '';

    if ($productionStage === 'cancelled') {
        $cancelSource = 'production';
    } elseif ($orderStatus === 'cancelled') {
        $cancelSource = 'order';
    } elseif ($quoteStatus === 'cancelled') {
        $cancelSource = 'quote';
    }

    return [
        'order_id' => (int)($row['order_id'] ?? 0),
        'order_number' => trim((string)($row['order_number'] ?? '')),
        'order_status' => $orderStatus,
        'quote_id' => (int)($row['quote_id'] ?? 0),
        'quote_number' => trim((string)($row['quote_number'] ?? '')),
        'quote_status' => $quoteStatus,
        'production_stage' => $productionStage,
        'is_cancelled' => $cancelSource !== '',
        'cancel_source' => $cancelSource,
    ];
}

function cancelled_landing_v1_is_cancelled_order(int $orderId): bool
{
    $context = cancelled_landing_v1_context_by_order_id($orderId);

    return (bool)($context['is_cancelled'] ?? false);
}

function cancelled_landing_v1_tracking_redirect_url(string $trackingToken): string
{
    return '/cotizacion_pdf_publica.php?ot='
        . rawurlencode($trackingToken)
        . '&estado=cancelado';
}

function cancelled_landing_v1_title(array $context): string
{
    $order = trim((string)($context['order_number'] ?? ''));

    if ($order !== '') {
        return 'Tu orden ' . $order . ' fue cancelada';
    }

    return 'Este pedido fue cancelado';
}

function cancelled_landing_v1_message(array $context): string
{
    $source = (string)($context['cancel_source'] ?? '');

    if ($source === 'quote') {
        $quote = trim((string)($context['quote_number'] ?? ''));

        return
            ($quote !== ''
                ? 'La cotización ' . $quote . ' vinculada a este pedido fue cancelada. '
                : 'La cotización vinculada a este pedido fue cancelada. ')
            . 'El proceso anterior ya no está vigente, pero puedes solicitar una nueva propuesta '
            . 'y aprovechar nuestros productos y servicios actuales.';
    }

    return
        'El proceso de esta orden fue cancelado y ya no se encuentra vigente. '
        . 'Si deseas retomarlo, solicita una nueva cotización o revisa las opciones '
        . 'y promociones disponibles actualmente.';
}
