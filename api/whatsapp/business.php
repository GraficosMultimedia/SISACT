<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/whapi.php';

try {
    $response = whapi_business();

    json_response([
        'ok' => $response['ok'],
        'http_status' => $response['status'],
        'profile' => $response['ok'] ? $response['data'] : null,
        'error' => $response['error'],
        'response_time_ms' => $response['duration_ms'],
    ], $response['ok'] ? 200 : 502);
} catch (Throwable $e) {
    json_response([
        'ok' => false,
        'error' => $e->getMessage(),
    ], 500);
}
