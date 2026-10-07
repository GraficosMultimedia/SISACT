<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cfdi.php';

function tracking_cfdi_table_ready(): bool {
    try {
        return (bool)db()->query("SHOW TABLES LIKE 'cp_invoice_documents'")->fetchColumn();
    } catch (Throwable $e) {
        return false;
    }
}

function tracking_cfdi_for_order(int $orderId): array {
    if ($orderId <= 0 || !tracking_cfdi_table_ready()) return [];

    $st = db()->prepare(
        'SELECT
            d.id AS document_id,
            d.invoice_id,
            d.order_id,
            d.uuid,
            d.version,
            d.serie,
            d.folio,
            d.issued_at,
            d.moneda,
            d.subtotal,
            d.tax,
            d.total,
            d.xml_path,
            d.pdf_path,
            d.xml_sha256,
            i.invoice_number,
            i.status AS invoice_status
         FROM cp_invoice_documents d
         INNER JOIN cp_invoices i ON i.id=d.invoice_id
         WHERE d.order_id=?
         ORDER BY COALESCE(d.issued_at, d.created_at) DESC, d.id DESC'
    );
    $st->execute([$orderId]);
    return $st->fetchAll() ?: [];
}

function tracking_cfdi_public_get(int $documentId, string $token): ?array {
    if (
        $documentId <= 0 ||
        !preg_match('/^[a-f0-9]{64}$/i', $token) ||
        !tracking_cfdi_table_ready()
    ) {
        return null;
    }

    $st = db()->prepare(
        'SELECT
            d.*,
            i.invoice_number,
            i.status AS invoice_status,
            o.order_number,
            o.id AS linked_order_id,
            c.name AS customer_name
         FROM cp_invoice_documents d
         INNER JOIN cp_invoices i ON i.id=d.invoice_id
         INNER JOIN cp_orders o ON o.id=d.order_id
         LEFT JOIN cp_customers c ON c.id=o.customer_id
         INNER JOIN cp_tracking_tokens tt
             ON tt.order_id=d.order_id
            AND tt.token=?
            AND tt.active=1
         WHERE d.id=?
         LIMIT 1'
    );
    $st->execute([$token, $documentId]);

    return $st->fetch() ?: null;
}

function tracking_cfdi_download(int $documentId, string $token, string $kind): void {
    $doc = tracking_cfdi_public_get($documentId, $token);
    if (!$doc) {
        http_response_code(404);
        exit('Documento fiscal no disponible.');
    }

    $kind = $kind === 'pdf' ? 'pdf' : 'xml';
    cfdi_stream_file($doc, $kind);
}
?>
