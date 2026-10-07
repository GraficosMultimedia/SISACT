<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

$started = microtime(true);
$cfg = wa_config();

$result = [
    'ok' => true,
    'status' => 'healthy',
    'health_version' => '6.0.0',
    'checked_at' => date('c'),
    'response_time_ms' => 0,
    'application' => [
        'name' => $cfg['app']['name'] ?? 'Colibrí Print',
        'short_name' => $cfg['app']['short_name'] ?? 'Colibrí Print',
        'timezone' => date_default_timezone_get(),
        'base_url' => $cfg['app']['base_url'] ?? '',
        'base_url_configured' => !empty($cfg['app']['base_url']),
    ],
    'php' => [
        'version' => PHP_VERSION,
        'sapi' => PHP_SAPI,
        'extensions' => [
            'pdo' => extension_loaded('pdo'),
            'pdo_mysql' => extension_loaded('pdo_mysql'),
            'json' => extension_loaded('json'),
            'mbstring' => extension_loaded('mbstring'),
            'curl' => extension_loaded('curl'),
        ],
    ],
    'config' => [
        'loaded' => true,
        'file' => basename(wa_find_config() ?? 'config.php'),
    ],
    'database' => [
        'connected' => false,
        'database' => $cfg['db']['name'] ?? null,
        'error' => null,
        'whatsapp' => [
            'tables' => [
                'cp_whatsapp_chats' => false,
                'cp_whatsapp_messages' => false,
                'cp_whatsapp_log' => false,
            ],
            'counts' => [
                'chats' => 0,
                'messages' => 0,
                'logs' => 0,
            ],
        ],
    ],
    'whapi' => [
        'configured' => false,
        'reachable' => false,
        'http_status' => null,
        'response_time_ms' => null,
        'error' => null,
        'health' => null,
    ],
];

try {
    $pdo = wa_db();
    $result['database']['connected'] = true;

    $tables = $pdo->query('SHOW TABLES')->fetchAll(PDO::FETCH_COLUMN);

    foreach (array_keys($result['database']['whatsapp']['tables']) as $table) {
        $result['database']['whatsapp']['tables'][$table] =
            in_array($table, $tables, true);
    }

    foreach ([
        'chats' => 'cp_whatsapp_chats',
        'messages' => 'cp_whatsapp_messages',
        'logs' => 'cp_whatsapp_log',
    ] as $key => $table) {
        if ($result['database']['whatsapp']['tables'][$table]) {
            $result['database']['whatsapp']['counts'][$key] =
                (int)$pdo->query("SELECT COUNT(*) FROM `$table`")->fetchColumn();
        }
    }
} catch (Throwable $e) {
    $result['ok'] = false;
    $result['status'] = 'degraded';
    $result['database']['error'] = $e->getMessage();
}

$token = trim((string)($cfg['whapi']['token'] ?? ''));

if ($token !== '' && extension_loaded('curl')) {
    $whapiStarted = microtime(true);

    try {
        $r = wa_whapi_request('GET', '/health');

        $result['whapi']['configured'] = true;
        $result['whapi']['reachable'] =
            $r['status'] >= 200 && $r['status'] < 300;
        $result['whapi']['http_status'] = $r['status'];
        $result['whapi']['response_time_ms'] =
            round((microtime(true) - $whapiStarted) * 1000, 2);
        $result['whapi']['health'] = $r['body'];

        if (!$result['whapi']['reachable']) {
            $result['ok'] = false;
            $result['status'] = 'degraded';
        }
    } catch (Throwable $e) {
        $result['ok'] = false;
        $result['status'] = 'degraded';
        $result['whapi']['error'] = $e->getMessage();
    }
} else {
    $result['ok'] = false;
    $result['status'] = 'degraded';
    $result['whapi']['error'] = 'Whapi no configurado o cURL no disponible.';
}

$result['response_time_ms'] =
    round((microtime(true) - $started) * 1000, 2);

wa_json($result, $result['ok'] ? 200 : 503);
