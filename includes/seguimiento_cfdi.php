<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

/**
 * CFDI públicos vinculados a una orden.
 * La consulta queda limitada por order_id para que el enlace de seguimiento
 * nunca exponga facturas de otra orden.
 */
function tracking_invoice_documents(int $orderId): array {
    if ($orderId <= 0) return [];

    try {
        $st = db()->prepare(
            'SELECT d.id AS document_id, d.uuid, d.version, d.serie, d.folio,
                    d.issued_at, d.subtotal, d.tax, d.total, d.xml_path, d.pdf_path,
                    i.id AS invoice_id, i.invoice_number, i.status AS invoice_status,
                    i.invoice_date
             FROM cp_invoice_documents d
             INNER JOIN cp_invoices i ON i.id=d.invoice_id
             WHERE d.order_id=?
             ORDER BY d.issued_at DESC, d.id DESC'
        );
        $st->execute([$orderId]);
        return $st->fetchAll() ?: [];
    } catch (Throwable $e) {
        return [];
    }
}

/**
 * Alias de compatibilidad para seguimiento.php.
 * Mantiene la función existente y evita el fatal:
 * Call to undefined function tracking_cfdi_for_order()
 */
function tracking_cfdi_for_order(int $orderId): array {
    return tracking_invoice_documents($orderId);
}
