<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cotizaciones.php';

/**
 * Devuelve el desglose comercial de la cotización SOLO cuando la orden
 * todavía coincide con los conceptos y el total de esa cotización.
 *
 * Esto evita imprimir IVA/descuento obsoleto después de una edición manual
 * de la orden de servicio.
 */
function order_commercial_breakdown(
    int $orderId,
    ?array $orderItems = null,
    ?float $orderTotal = null
): array {
    $empty = [
        'available' => false,
        'aligned' => false,
        'quote_id' => 0,
        'subtotal' => 0.0,
        'discount' => 0.0,
        'discount_pct' => 0.0,
        'discount_label' => '',
        'tax' => 0.0,
        'tax_pct' => 0.0,
        'tax_label' => '',
        'total' => 0.0,
        'has_discount' => false,
        'has_tax' => false,
    ];

    if ($orderId <= 0) return $empty;

    try {
        $st = db()->prepare('SELECT quote_id,total FROM cp_orders WHERE id=? LIMIT 1');
        $st->execute([$orderId]);
        $order = $st->fetch(PDO::FETCH_ASSOC);
        if (!$order) return $empty;

        $quoteId = (int)($order['quote_id'] ?? 0);
        if ($quoteId <= 0) return $empty;

        $orderTotal = $orderTotal ?? (float)($order['total'] ?? 0);
        $orderItems = $orderItems ?? order_commercial_order_items($orderId);

        $qTotals = quote_totals($quoteId);
        $qItems = quote_items($quoteId);

        $subtotal = round((float)($qTotals['subtotal'] ?? 0), 2);
        $discount = round((float)($qTotals['discount'] ?? 0), 2);
        $tax = round((float)($qTotals['tax'] ?? 0), 2);
        $quoteTotal = round((float)($qTotals['total'] ?? 0), 2);

        $aligned = order_commercial_items_match($qItems, $orderItems)
            && abs(round($orderTotal, 2) - $quoteTotal) <= 0.01;

        if (!$aligned) {
            $empty['quote_id'] = $quoteId;
            return $empty;
        }

        $discountPct = ($discount > 0.0 && $subtotal > 0.0)
            ? ($discount / $subtotal) * 100
            : 0.0;

        $taxBase = max(0.0, $subtotal - $discount);
        $taxPct = ($tax > 0.0 && $taxBase > 0.0)
            ? ($tax / $taxBase) * 100
            : 0.0;

        return [
            'available' => true,
            'aligned' => true,
            'quote_id' => $quoteId,
            'subtotal' => $subtotal,
            'discount' => $discount,
            'discount_pct' => $discountPct,
            'discount_label' => order_commercial_percent_label($discountPct),
            'tax' => $tax,
            'tax_pct' => $taxPct,
            'tax_label' => order_commercial_percent_label($taxPct),
            'total' => $quoteTotal,
            'has_discount' => $discount > 0.009,
            'has_tax' => $tax > 0.009,
        ];
    } catch (Throwable $e) {
        error_log('[SISACT][order_commercial_breakdown] ' . $e->getMessage());
        return $empty;
    }
}

function order_commercial_order_items(int $orderId): array
{
    $st = db()->prepare(
        'SELECT description,quantity,unit_price,subtotal
         FROM cp_order_items
         WHERE order_id=?
         ORDER BY sort_order,id'
    );
    $st->execute([$orderId]);
    return $st->fetchAll(PDO::FETCH_ASSOC) ?: [];
}

function order_commercial_items_match(array $quoteItems, array $orderItems): bool
{
    if (count($quoteItems) !== count($orderItems)) return false;

    foreach ($quoteItems as $i => $q) {
        $o = $orderItems[$i] ?? null;
        if (!$o) return false;

        if (trim((string)($q['description'] ?? '')) !== trim((string)($o['description'] ?? ''))) {
            return false;
        }

        if (abs((float)($q['quantity'] ?? 0) - (float)($o['quantity'] ?? 0)) > 0.0005) {
            return false;
        }

        if (abs((float)($q['unit_price'] ?? 0) - (float)($o['unit_price'] ?? 0)) > 0.01) {
            return false;
        }

        if (abs((float)($q['subtotal'] ?? 0) - (float)($o['subtotal'] ?? 0)) > 0.01) {
            return false;
        }
    }

    return true;
}

function order_commercial_percent_label(float $pct): string
{
    if ($pct <= 0) return '';
    $formatted = number_format($pct, 2, '.', '');
    $formatted = rtrim(rtrim($formatted, '0'), '.');
    return $formatted . '%';
}
