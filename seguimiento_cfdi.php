<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/tracking_cfdi.php';

$token = trim((string)($_GET['t'] ?? ''));
$documentId = (int)($_GET['id'] ?? 0);
$kind = (string)($_GET['file'] ?? 'xml');

tracking_cfdi_download($documentId, $token, $kind);
