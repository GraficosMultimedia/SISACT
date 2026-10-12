<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cfdi.php';
require_once __DIR__ . '/tracking_activity.php';

function tracking_cfdi_table_ready(): bool {
    try {
        return (bool)db()->query("SHOW TABLES LIKE 'cp_invoice_documents'")->fetchColumn();
    } catch (Throwable $e) {
        return false;
    }
}

function tracking_cfdi_for_order(int $orderId): array {
    // seguimiento.php llama esta función una vez por visita válida.
    // El registrador filtra HEAD, previews y bots conocidos.
    tracking_activity_log_tracking_view($orderId);

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
            o.customer_id,
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

function tracking_cfdi_public_stream(array $doc, string $kind): never {
    $key = $kind === 'pdf' ? 'pdf_path' : 'xml_path';
    $path = (string)($doc[$key] ?? '');

    if ($path === '') {
        http_response_code(404);
        exit('Documento no disponible.');
    }

    $full = dirname(__DIR__) . '/' . ltrim($path, '/');
    if (!is_file($full)) {
        http_response_code(404);
        exit('Archivo no encontrado.');
    }

    $mime = $kind === 'pdf' ? 'application/pdf' : 'application/xml';
    $safeName = preg_replace('/[^A-Za-z0-9._-]+/', '_', basename($full));
    $disposition = $kind === 'pdf' ? 'inline' : 'attachment';

    header('Content-Type: ' . $mime);
    header('Content-Length: ' . (string)filesize($full));
    header('Content-Disposition: ' . $disposition . '; filename="' . $safeName . '"');
    header('X-Content-Type-Options: nosniff');

    readfile($full);
    exit;
}

function tracking_cfdi_download(int $documentId, string $token, string $kind): void {
    $doc = tracking_cfdi_public_get($documentId, $token);
    if (!$doc) {
        http_response_code(404);
        exit('Documento fiscal no disponible.');
    }

    $kind = $kind === 'pdf' ? 'pdf' : 'xml';

    tracking_activity_log(
        $kind === 'pdf' ? 'cfdi_pdf_opened' : 'cfdi_xml_downloaded',
        (int)$doc['linked_order_id'],
        (int)($doc['customer_id'] ?? 0) ?: null,
        $documentId,
        (int)($doc['invoice_id'] ?? 0) ?: null,
        null,
        $token
    );

    tracking_cfdi_public_stream($doc, $kind);
}
?>
