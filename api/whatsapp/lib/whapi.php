<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

function whapi_config(): array
{
    $config = app_config()['whapi'] ?? [];

    return [
        'base_url' => rtrim((string)($config['base_url'] ?? 'https://gate.whapi.cloud'), '/'),
        'token' => trim((string)($config['token'] ?? '')),
        'channel_id' => trim((string)($config['channel_id'] ?? '')),
        'timeout' => max(3, (int)($config['timeout'] ?? 15)),
    ];
}

function whapi_request(
    string $method,
    string $path,
    ?array $body = null,
    array $query = []
): array {
    $cfg = whapi_config();

    if ($cfg['token'] === '') {
        return [
            'ok' => false,
            'status' => 0,
            'error' => 'Token de Whapi no configurado.',
            'data' => null,
            'duration_ms' => 0,
        ];
    }

    $url = $cfg['base_url'] . '/' . ltrim($path, '/');

    if ($query) {
        $url .= '?' . http_build_query($query);
    }

    $started = microtime(true);

    $ch = curl_init($url);

    $headers = [
        'Accept: application/json',
        'Authorization: Bearer ' . $cfg['token'],
    ];

    $options = [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_MAXREDIRS => 3,
        CURLOPT_CONNECTTIMEOUT => min(8, $cfg['timeout']),
        CURLOPT_TIMEOUT => $cfg['timeout'],
        CURLOPT_CUSTOMREQUEST => strtoupper($method),
        CURLOPT_HTTPHEADER => $headers,
    ];

    if ($body !== null) {
        $headers[] = 'Content-Type: application/json';
        $options[CURLOPT_HTTPHEADER] = $headers;
        $options[CURLOPT_POSTFIELDS] = json_encode(
            $body,
            JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
        );
    }

    curl_setopt_array($ch, $options);

    $raw = curl_exec($ch);
    $curlError = curl_error($ch);
    $status = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    $duration = round((microtime(true) - $started) * 1000, 2);

    if ($raw === false || $curlError !== '') {
        return [
            'ok' => false,
            'status' => $status,
            'error' => $curlError !== '' ? $curlError : 'Error cURL desconocido.',
            'data' => null,
            'duration_ms' => $duration,
        ];
    }

    $decoded = json_decode($raw, true);

    return [
        'ok' => $status >= 200 && $status < 300,
        'status' => $status,
        'error' => ($status >= 400 && is_array($decoded))
            ? safe_text($decoded['error'] ?? $decoded['message'] ?? 'Error Whapi', 1000)
            : null,
        'data' => $decoded ?? $raw,
        'duration_ms' => $duration,
    ];
}

function whapi_health(): array
{
    return whapi_request('GET', '/health');
}

function whapi_business(): array
{
    return whapi_request('GET', '/business');
}

function whapi_settings(): array
{
    return whapi_request('GET', '/settings');
}

function whapi_send_text(string $to, string $body): array
{
    return whapi_request('POST', '/messages/text', [
        'to' => $to,
        'body' => $body,
    ]);
}

function whapi_get_stories(array $query = []): array
{
    return whapi_request('GET', '/stories', null, $query);
}

function whapi_send_story_text(string $body): array
{
    return whapi_request('POST', '/stories/send/text', [
        'body' => $body,
    ]);
}

function whapi_webhook_test(string $url, string $mode = 'body', string $type = 'messages'): array
{
    return whapi_request('POST', '/settings/webhook_test', [
        'type' => $type,
        'url' => $url,
        'mode' => $mode,
    ]);
}
