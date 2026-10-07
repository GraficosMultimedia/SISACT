<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/whapi.php';
require_once __DIR__ . '/lib/database.php';

try {
    $health = whapi_health();
    $business = whapi_business();
    $settings = whapi_settings();

    $local = [
        'chats' => null,
        'messages' => null,
        'logs' => null,
    ];

    try {
        $local = whatsapp_counts(db());
    } catch (Throwable $e) {
        // Keep Whapi status usable even if local DB has a temporary issue.
    }

    $data = [
        'ok' => $health['ok'],
        'status_version' => '5.0.0',
        'checked_at' => date('c'),
        'channel' => [
            'reachable' => $health['ok'],
            'http_status' => $health['status'],
            'response_time_ms' => $health['duration_ms'],
            'health' => $health['data'],
            'error' => $health['error'],
        ],
        'business' => [
            'available' => $business['ok'],
            'http_status' => $business['status'],
            'profile' => $business['ok'] ? $business['data'] : null,
            'error' => $business['error'],
        ],
        'settings' => [
            'available' => $settings['ok'],
            'http_status' => $settings['status'],
            'data' => $settings['ok'] ? $settings['data'] : null,
            'error' => $settings['error'],
        ],
        'local' => $local,
    ];

    json_response($data, $health['ok'] ? 200 : 503);
} catch (Throwable $e) {
    json_response([
        'ok' => false,
        'status' => 'critical',
        'error' => $e->getMessage(),
    ], 500);
}
