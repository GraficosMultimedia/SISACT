<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/web_print_flow.php';

require_auth();

$fileId = (int)($_GET['id'] ?? 0);
$mode = (string)($_GET['mode'] ?? 'inline');

if ($fileId <= 0) {
    http_response_code(404);
    exit('Archivo no encontrado.');
}

$row = web_flow_file_row($fileId);

if (!$row) {
    http_response_code(404);
    exit('Archivo no encontrado.');
}

try {
    $path = web_flow_resolve_source_file($row);
} catch (Throwable $e) {
    http_response_code(404);
    exit('El archivo no está disponible en el almacenamiento.');
}

$name = trim((string)($row['original_name'] ?? 'archivo'));

if ($name === '') {
    $name = basename($path);
}

$mime = trim((string)($row['mime_type'] ?? ''));

if ($mime === '') {
    $mime = (string)(
        (new finfo(FILEINFO_MIME_TYPE))
        ->file($path)
    );
}

$size = (int)(
    filesize($path)
    ?: 0
);

$disposition = $mode === 'download'
    ? 'attachment'
    : 'inline';

header('Content-Type: ' . ($mime !== '' ? $mime : 'application/octet-stream'));
header('Content-Length: ' . $size);
header(
    'Content-Disposition: '
    . $disposition
    . '; filename="'
    . addcslashes($name, '"\\')
    . '"; filename*=UTF-8\'\''
    . rawurlencode($name)
);
header('X-Content-Type-Options: nosniff');
header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');

readfile($path);
exit;
