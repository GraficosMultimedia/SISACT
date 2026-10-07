<?php
declare(strict_types=1);

require_once __DIR__ . '/database.php';
require_once __DIR__ . '/whapi.php';

function health_run(): array
{
    $started = microtime(true);
    $config = app_config();
    $base = app_base_url($config);

    $result = [
        'ok' => true,
        'status' => 'healthy',
        'health_version' => '5.0.1',
        'checked_at' => date('c'),
        'response_time_ms' => null,
        'application' => [
            'name' => $config['app']['name'] ?? 'Colibrí Print',
            'short_name' => $config['app']['short_name'] ?? 'Colibrí Print',
            'timezone' => $config['app']['timezone'] ?? date_default_timezone_get(),
            'base_url_source' => $base['source'],
            'base_url_configured' => $base['configured'],
            'base_url' => $base['base_url'],
        ],
        'config' => config_meta(),
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
        'database' => [
            'connected' => false,
            'database' => $config['db']['name'] ?? null,
            'error' => null,
            'whatsapp' => [
                'tables' => [],
                'counts' => [],
            ],
        ],
        'whapi' => [
            'configured' => false,
            'reachable' => false,
            'http_status' => 0,
            'response_time_ms' => null,
            'error' => null,
            'health' => null,
        ],
    ];

    if ($result['config']['loaded'] === false) {
        $result['ok'] = false;
        $result['status'] = 'critical';
        return $result;
    }

    try {
        $pdo = db();
        $result['database']['connected'] = true;
        $result['database']['whatsapp']['tables'] = whatsapp_table_status($pdo);
        $result['database']['whatsapp']['counts'] = whatsapp_counts($pdo);
    } catch (Throwable $e) {
        $result['database']['error'] = $e->getMessage();
        $result['ok'] = false;
        $result['status'] = 'degraded';
    }

    $whapiCfg = whapi_config();
    $result['whapi']['configured'] = $whapiCfg['token'] !== '';

    if ($result['whapi']['configured']) {
        $health = whapi_health();
        $result['whapi']['reachable'] = $health['ok'];
        $result['whapi']['http_status'] = $health['status'];
        $result['whapi']['response_time_ms'] = $health['duration_ms'];
        $result['whapi']['error'] = $health['error'];
        $result['whapi']['health'] = $health['ok'] ? $health['data'] : null;

        if (!$health['ok']) {
            $result['ok'] = false;
            $result['status'] = 'degraded';
        }
    } else {
        $result['ok'] = false;
        $result['status'] = 'degraded';
    }

    $result['response_time_ms'] = round((microtime(true) - $started) * 1000, 2);

    return $result;
}
