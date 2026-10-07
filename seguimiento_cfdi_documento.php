<?php
declare(strict_types=1);
require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/seguimiento.php';
require_once __DIR__ . '/includes/seguimiento_cfdi.php';

$token = trim((string)($_GET['t'] ?? ''));
$docId = (int)($_GET['id'] ?? 0);
$kind = (string)($_GET['download'] ?? '');
if (!preg_match('/^[a-f0-9]{64}$/i', $token) || $docId <= 0 || !in_array($kind, ['xml','pdf'], true)) {
    http_response_code(400);
    exit('Solicitud no válida.');
}

$order = tracking_order_by_token($token);
if (!$order) {
    http_response_code(404);
    exit('Seguimiento no encontrado.');
}

try {
    $st = db()->prepare(
        'SELECT d.id,d.order_id,d.uuid,d.xml_path,d.pdf_path
         FROM cp_invoice_documents d
         WHERE d.id=? AND d.order_id=? LIMIT 1'
    );
    $st->execute([$docId, (int)$order['id']]);
    $doc = $st->fetch();
} catch (Throwable $e) {
    $doc = false;
}

if (!$doc) {
    http_response_code(404);
    exit('Documento fiscal no encontrado.');
}

$relative = (string)($doc[$kind . '_path'] ?? '');
if ($relative === '') {
    http_response_code(404);
    exit('El archivo solicitado no está disponible.');
}

$root = realpath(__DIR__);
$full = realpath(__DIR__ . '/' . ltrim($relative, '/'));
$storageRoot = realpath(__DIR__ . '/storage/cfdi');
if (!$root || !$full || !$storageRoot || !str_starts_with($full, $storageRoot . DIRECTORY_SEPARATOR) || !is_file($full)) {
    http_response_code(404);
    exit('Archivo fiscal no encontrado.');
}

$mime = $kind === 'pdf' ? 'application/pdf' : 'application/xml; charset=utf-8';
$ext = $kind === 'pdf' ? 'pdf' : 'xml';
$uuid = preg_replace('/[^A-Za-z0-9._-]+/', '_', (string)($doc['uuid'] ?: 'cfdi'));
$filename = $uuid . '.' . $ext;
header('Content-Type: ' . $mime);
header('Content-Length: ' . (string)filesize($full));
header('Content-Disposition: attachment; filename="' . $filename . '"');
header('X-Content-Type-Options: nosniff');
readfile($full);
exit;
