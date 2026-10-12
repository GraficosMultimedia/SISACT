<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/expense_cfdi.php';
require_auth();

$id = (int)($_GET['id'] ?? 0);
$doc = expense_cfdi_document_get($id);

if (!$doc) {
    http_response_code(404);
    exit('CFDI de egreso no encontrado.');
}

$relative = trim((string)($doc['xml_path'] ?? ''));
$root = realpath(dirname(__DIR__));
$full = realpath(dirname(__DIR__) . '/' . ltrim($relative, '/'));

if (
    !$root ||
    !$full ||
    !is_file($full) ||
    !str_starts_with($full, $root . DIRECTORY_SEPARATOR)
) {
    http_response_code(404);
    exit('Archivo XML no disponible.');
}

$uuid = trim((string)($doc['uuid'] ?? ''));
$name = $uuid !== '' ? $uuid . '.xml' : 'egreso-' . (int)$doc['expense_id'] . '.xml';
$name = preg_replace('/[^A-Za-z0-9._-]+/', '_', $name);

header('Content-Type: application/xml; charset=UTF-8');
header('Content-Length: ' . (string)filesize($full));
header('Content-Disposition: attachment; filename="' . $name . '"');
header('X-Content-Type-Options: nosniff');
header('Cache-Control: private, no-store');

readfile($full);
exit;
