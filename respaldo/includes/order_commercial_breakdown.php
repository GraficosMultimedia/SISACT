<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cotizaciones.php';

/**
 * Desglose comercial para PDFs de Orden y Seguimiento.
 *
 * FUENTE:
 * cp_orders.quote_id -> quote_totals($quoteId)
 *
 * Es el mismo origen utilizado por admin/cotizacion_pdf_2paginas.php:
 * subtotal, discount, tax y total.
 */
function order_commercial_breakdown(
    int $orderId,
    ?array $unusedItems = null,
    ?float $unusedOrderTotal = null
): array {
    $empty = [
        'available' => false,
        'quote_id' => 0,
        'subtotal' => 0.0,
        'discount' => 0.0,
        'discount_pct' => 0.0,
        'discount_label' => '',
        'tax' => 0.0,
        'tax_pct' => 0.0,
        'tax_label' => '',
        'quote_total' => 0.0,
        'has_discount' => false,
        'has_tax' => false,
    ];

    if ($orderId <= 0) return $empty;

    try {
        $st = db()->prepare('SELECT quote_id FROM cp_orders WHERE id=? LIMIT 1');
        $st->execute([$orderId]);
        $quoteId = (int)($st->fetchColumn() ?: 0);
        if ($quoteId <= 0) return $empty;

        $totals = quote_totals($quoteId);

        $subtotal = round((float)($totals['subtotal'] ?? 0), 2);
        $discount = round((float)($totals['discount'] ?? 0), 2);
        $tax = round((float)($totals['tax'] ?? 0), 2);
        $quoteTotal = round((float)($totals['total'] ?? 0), 2);

        $discountPct = ($subtotal > 0 && $discount > 0)
            ? ($discount / $subtotal) * 100
            : 0.0;

        $taxBase = max(0.0, $subtotal - $discount);
        $taxPct = ($taxBase > 0 && $tax > 0)
            ? ($tax / $taxBase) * 100
            : 0.0;

        return [
            'available' => true,
            'quote_id' => $quoteId,
            'subtotal' => $subtotal,
            'discount' => $discount,
            'discount_pct' => $discountPct,
            'discount_label' => order_commercial_percent_label($discountPct),
            'tax' => $tax,
            'tax_pct' => $taxPct,
            'tax_label' => order_commercial_percent_label($taxPct),
            'quote_total' => $quoteTotal,
            'has_discount' => $discount > 0.009,
            'has_tax' => $tax > 0.009,
        ];
    } catch (Throwable $e) {
        error_log('[SISACT][order_commercial_breakdown_v2] ' . $e->getMessage());
        return $empty;
    }
}

function order_commercial_percent_label(float $pct): string
{
    if ($pct <= 0) return '';
    $formatted = number_format($pct, 2, '.', '');
    return rtrim(rtrim($formatted, '0'), '.') . '%';
}
