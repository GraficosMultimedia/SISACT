<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/includes/public_catalog.php';

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: public, max-age=60, stale-while-revalidate=300');

try {
    $pdo = db();
    $payload = cp_catalog_payload($pdo, $_GET);
    echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'success' => false,
        'error' => 'No fue posible generar el catálogo público.',
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
}
