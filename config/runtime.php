<?php
declare(strict_types=1);

/*
 * Runtime compatible con la configuración actual de Colibrí Print.
 *
 * Este archivo puede cargarse después de config/bootstrap.php sin volver
 * a declarar las funciones de config.php.
 */

$configFile = __DIR__ . '/config.php';

/*
 * config.php actualmente define constantes y funciones (incluyendo cp_db()).
 * Si bootstrap.php ya lo cargó, NO volver a incluirlo.
 *
 * También mantenemos compatibilidad con una configuración antigua que
 * retornara un array desde config.php.
 */
$config = null;

if (defined('CP_DB_HOST')) {
    $config = [
        'app' => [
            'name' => defined('CP_APP_NAME') ? CP_APP_NAME : 'Colibrí Print México',
            'short_name' => defined('CP_APP_SHORT_NAME') ? CP_APP_SHORT_NAME : 'Colibrí Print',
            'timezone' => defined('CP_TIMEZONE') ? CP_TIMEZONE : 'America/Chihuahua',
        ],
        'db' => [
            'host' => CP_DB_HOST,
            'name' => CP_DB_NAME,
            'user' => CP_DB_USER,
            'pass' => CP_DB_PASS,
            'charset' => CP_DB_CHARSET,
        ],
        'akaunting' => [
            'host' => defined('CP_AKAUNTING_DB_HOST') ? CP_AKAUNTING_DB_HOST : CP_DB_HOST,
            'name' => defined('CP_AKAUNTING_DB_NAME') ? CP_AKAUNTING_DB_NAME : CP_DB_NAME,
            'user' => defined('CP_AKAUNTING_DB_USER') ? CP_AKAUNTING_DB_USER : CP_DB_USER,
            'pass' => defined('CP_AKAUNTING_DB_PASS') ? CP_AKAUNTING_DB_PASS : CP_DB_PASS,
            'charset' => defined('CP_AKAUNTING_DB_CHARSET') ? CP_AKAUNTING_DB_CHARSET : CP_DB_CHARSET,
        ],
        'security' => [
            'session_name' => defined('CP_SESSION_NAME') ? CP_SESSION_NAME : 'colibri_admin',
        ],
    ];
} else {
    $loadedConfig = require_once $configFile;
    $config = is_array($loadedConfig) ? $loadedConfig : [];
}

function app_config(?string $key = null)
{
    global $config;

    if ($key === null) {
        return $config;
    }

    $parts = explode('.', $key);
    $value = $config;

    foreach ($parts as $part) {
        if (!is_array($value) || !array_key_exists($part, $value)) {
            return null;
        }
        $value = $value[$part];
    }

    return $value;
}

$timezone = (string)(app_config('app.timezone') ?: 'America/Chihuahua');
date_default_timezone_set($timezone);

if (session_status() !== PHP_SESSION_ACTIVE) {
    $sessionName = (string)(app_config('security.session_name') ?: 'colibri_admin');
    session_name($sessionName);
    session_start();
}

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    if (function_exists('cp_db')) {
        $pdo = cp_db();
        return $pdo;
    }

    $dsn = 'mysql:host=' . app_config('db.host')
        . ';dbname=' . app_config('db.name')
        . ';charset=' . app_config('db.charset');

    $pdo = new PDO(
        $dsn,
        (string)app_config('db.user'),
        (string)app_config('db.pass'),
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );

    return $pdo;
}

function akaunting_db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn = 'mysql:host=' . app_config('akaunting.host')
        . ';dbname=' . app_config('akaunting.name')
        . ';charset=' . app_config('akaunting.charset');

    $pdo = new PDO(
        $dsn,
        (string)app_config('akaunting.user'),
        (string)app_config('akaunting.pass'),
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );

    return $pdo;
}

function e(?string $value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function redirect(string $url): void
{
    header('Location: ' . $url);
    exit;
}

function csrf_token(): string
{
    if (empty($_SESSION['_csrf'])) {
        $_SESSION['_csrf'] = bin2hex(random_bytes(24));
    }

    return $_SESSION['_csrf'];
}

function csrf_check(?string $token): bool
{
    return is_string($token)
        && hash_equals((string)($_SESSION['_csrf'] ?? ''), $token);
}

function current_user(): ?array
{
    return $_SESSION['user'] ?? null;
}

function require_auth(): void
{
    if (!current_user()) {
        redirect('/admin/');
    }
}

function log_activity(
    string $action,
    string $module,
    ?string $description = null
): void {
    try {
        $stmt = db()->prepare(
            'INSERT INTO cp_activity_log
            (user_id, action, module, description, ip_address, created_at)
            VALUES (?, ?, ?, ?, ?, NOW())'
        );

        $stmt->execute([
            current_user()['id'] ?? null,
            $action,
            $module,
            $description,
            $_SERVER['REMOTE_ADDR'] ?? null,
        ]);
    } catch (Throwable $e) {
        // El registro de actividad no debe impedir la operación principal.
    }
}
