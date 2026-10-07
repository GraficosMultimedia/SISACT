<?php
declare(strict_types=1);

/**
 * Portable bootstrap.
 * Never assumes /homeX/user/public_html.
 */

require_once __DIR__ . '/response.php';

function colibri_candidate_config_paths(): array
{
    $candidates = [];

    // 1) Explicit override. This is the most portable option for migrations.
    $env = getenv('COLIBRI_CONFIG');
    if (is_string($env) && trim($env) !== '') {
        $candidates[] = trim($env);
    }

    // 2) Walk upward from this library directory. At every level check both
    //    config.php and config/config.php, which covers common shared-hosting layouts.
    $start = realpath(__DIR__);
    if ($start !== false) {
        $dir = $start;
        for ($i = 0; $i < 18; $i++) {
            $candidates[] = $dir . DIRECTORY_SEPARATOR . 'config.php';
            $candidates[] = $dir . DIRECTORY_SEPARATOR . 'config' . DIRECTORY_SEPARATOR . 'config.php';

            $parent = dirname($dir);
            if ($parent === $dir) {
                break;
            }
            $dir = $parent;
        }
    }

    // 3) Document root and its parents. Useful when /api is nested below the web root.
    $docRoot = $_SERVER['DOCUMENT_ROOT'] ?? '';
    if (is_string($docRoot) && trim($docRoot) !== '') {
        $docRoot = realpath($docRoot) ?: rtrim(trim($docRoot), DIRECTORY_SEPARATOR);
        $dir = $docRoot;
        for ($i = 0; $i < 12; $i++) {
            $candidates[] = $dir . DIRECTORY_SEPARATOR . 'config.php';
            $candidates[] = $dir . DIRECTORY_SEPARATOR . 'config' . DIRECTORY_SEPARATOR . 'config.php';

            $parent = dirname($dir);
            if ($parent === $dir) {
                break;
            }
            $dir = $parent;
        }
    }

    // 4) A few relative paths resolved from the executing script. These are cheap
    //    and make deployment inside a subfolder considerably more forgiving.
    foreach ([
        dirname(__DIR__, 3) . '/config.php',
        dirname(__DIR__, 3) . '/config/config.php',
        dirname(__DIR__, 4) . '/config.php',
        dirname(__DIR__, 4) . '/config/config.php',
    ] as $path) {
        $candidates[] = $path;
    }

    $unique = [];
    foreach ($candidates as $path) {
        $path = is_string($path) ? trim($path) : '';
        if ($path !== '' && !isset($unique[$path])) {
            $unique[$path] = true;
        }
    }

    return array_keys($unique);
}

function load_colibri_config(): array
{
    foreach (colibri_candidate_config_paths() as $path) {
        if (is_file($path) && is_readable($path)) {
            $config = require $path;
            if (is_array($config) && isset($config['db'])) {
                return [
                    'config' => $config,
                    'file' => $path,
                    'discovery_method' => getenv('COLIBRI_CONFIG')
                        ? 'environment_override'
                        : 'portable_parent_search',
                ];
            }
        }
    }

    throw new RuntimeException('No se encontró un config.php válido.');
}

function app_config(): array
{
    static $loaded = null;

    if ($loaded === null) {
        $loaded = load_colibri_config();
    }

    return $loaded['config'];
}

function config_meta(): array
{
    static $loaded = null;

    if ($loaded === null) {
        $loaded = load_colibri_config();
    }

    return [
        'loaded' => true,
        'file' => basename($loaded['file']),
        'discovery_method' => $loaded['discovery_method'],
    ];
}

function app_base_url(array $config): array
{
    $configured = trim((string)($config['app']['base_url'] ?? ''));

    if ($configured !== '') {
        return [
            'base_url' => rtrim($configured, '/'),
            'source' => 'config',
            'configured' => true,
        ];
    }

    $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'] ?? '';

    if ($host !== '') {
        return [
            'base_url' => $scheme . '://' . $host,
            'source' => 'request',
            'configured' => true,
        ];
    }

    return [
        'base_url' => null,
        'source' => null,
        'configured' => false,
    ];
}

function start_admin_session(): void
{
    $config = app_config();
    $name = (string)($config['security']['session_name'] ?? 'colibri_admin');

    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_name($name);
        session_start();
    }
}

function require_admin_session(): void
{
    start_admin_session();

    $config = app_config();
    $keys = $config['security']['admin_session_keys']
        ?? ['user_id', 'admin_id', 'auth_user'];

    $authenticated = false;

    foreach ($keys as $key) {
        if (array_key_exists((string)$key, $_SESSION) && $_SESSION[$key] !== null && $_SESSION[$key] !== '') {
            $authenticated = true;
            break;
        }
    }

    if (!$authenticated) {
        json_response([
            'ok' => false,
            'error' => 'Sesión administrativa requerida.',
        ], 401);
    }
}

function get_webhook_secret(array $config): string
{
    return trim((string)($config['whapi']['webhook_secret'] ?? ''));
}
