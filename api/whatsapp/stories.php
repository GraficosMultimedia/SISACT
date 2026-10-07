<?php
declare(strict_types=1);

require_once __DIR__ . '/lib/whapi.php';

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $response = whapi_get_stories([
        'count' => min(50, max(1, (int)($_GET['count'] ?? 20))),
    ]);

    json_response([
        'ok' => $response['ok'],
        'http_status' => $response['status'],
        'stories' => $response['ok'] ? $response['data'] : null,
        'error' => $response['error'],
        'response_time_ms' => $response['duration_ms'],
    ], $response['ok'] ? 200 : 502);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    require_admin_session();

    $data = request_json();
    $body = safe_text($data['body'] ?? '', 700);

    if ($body === '') {
        json_response([
            'ok' => false,
            'error' => 'Falta body.',
        ], 400);
    }

    $response = whapi_send_story_text($body);

    json_response([
        'ok' => $response['ok'],
        'http_status' => $response['status'],
        'story' => $response['ok'] ? $response['data'] : null,
        'error' => $response['error'],
        'response_time_ms' => $response['duration_ms'],
    ], $response['ok'] ? 200 : 502);
}

json_response([
    'ok' => false,
    'error' => 'Método no permitido.',
], 405);
