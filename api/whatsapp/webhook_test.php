<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/whapi.php';

require_admin_session();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    json_response(['ok' => false, 'error' => 'Método no permitido.'], 405);
}

$config = app_config();
$base = app_base_url($config);

$configured = trim((string)($config['whapi']['webhook_url'] ?? ''));

$url = $configured;

if ($url === '' && $base['base_url']) {
    $url = rtrim($base['base_url'], '/') . '/api/whatsapp/webhook.php';
}

if ($url === '') {
    json_response([
        'ok' => false,
        'error' => 'No se pudo determinar webhook_url.',
    ], 400);
}

$input = request_json();

$type = safe_text($input['type'] ?? 'messages', 50);
$mode = safe_text($input['mode'] ?? 'body', 20);

$response = whapi_webhook_test($url, $mode, $type);

json_response([
    'ok' => $response['ok'],
    'http_status' => $response['status'],
    'webhook_url' => $url,
    'type' => $type,
    'mode' => $mode,
    'response' => $response['data'],
    'error' => $response['error'],
    'response_time_ms' => $response['duration_ms'],
], $response['ok'] ? 200 : 502);
