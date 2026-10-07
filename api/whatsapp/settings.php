<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/whapi.php';

try {
    $response = whapi_settings();

    $data = $response['ok'] ? $response['data'] : null;

    // Do not echo authorization material if a provider ever returns it.
    if (is_array($data)) {
        unset($data['token'], $data['authorization'], $data['headers']);
    }

    json_response([
        'ok' => $response['ok'],
        'http_status' => $response['status'],
        'settings' => $data,
        'error' => $response['error'],
        'response_time_ms' => $response['duration_ms'],
    ], $response['ok'] ? 200 : 502);
} catch (Throwable $e) {
    json_response([
        'ok' => false,
        'error' => $e->getMessage(),
    ], 500);
}
