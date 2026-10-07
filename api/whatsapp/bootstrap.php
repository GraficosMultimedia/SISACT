<?php
declare(strict_types=1);

/*
 * Punto único de arranque.
 * La aplicación no depende de una ruta fija del servidor.
 */

define('WA_API_DIR', __DIR__);
define('WA_ROOT', dirname(__DIR__, 2));

/* Nunca permitir que warnings/notices de PHP rompan el contrato JSON de la API. */
ini_set('display_errors', '0');
ini_set('log_errors', '1');

set_error_handler(static function (int $severity, string $message, string $file, int $line): bool {
    if (!(error_reporting() & $severity)) {
        return false;
    }
    throw new ErrorException($message, 0, $severity, $file, $line);
});

register_shutdown_function(static function (): void {
    $error = error_get_last();
    if (!$error) {
        return;
    }

    $fatalTypes = E_ERROR | E_PARSE | E_CORE_ERROR | E_COMPILE_ERROR;
    if (($error['type'] & $fatalTypes) === 0) {
        return;
    }

    if (!headers_sent()) {
        http_response_code(500);
        header('Content-Type: application/json; charset=utf-8');
        header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
    }

    echo json_encode([
        'ok' => false,
        'status' => 'critical',
        'error' => 'Error interno del servidor.',
        'detail' => $error['message'] ?? 'Fatal PHP error',
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_INVALID_UTF8_SUBSTITUTE);
});

function wa_json(array $payload, int $status = 200): never
{
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

    echo json_encode(
        $payload,
        JSON_UNESCAPED_UNICODE |
        JSON_UNESCAPED_SLASHES |
        JSON_INVALID_UTF8_SUBSTITUTE
    );

    exit;
}

function wa_find_config(): ?string
{
    $candidates = [];

    $env = getenv('COLIBRI_CONFIG');
    if ($env) {
        $candidates[] = $env;
    }

    $candidates[] = WA_ROOT . '/config.php';
    $candidates[] = WA_ROOT . '/config/config.php';
    $candidates[] = dirname(WA_ROOT) . '/config.php';
    $candidates[] = dirname(WA_ROOT) . '/config/config.php';
    $candidates[] = ($_SERVER['DOCUMENT_ROOT'] ?? '') . '/config.php';
    $candidates[] = ($_SERVER['DOCUMENT_ROOT'] ?? '') . '/config/config.php';

    foreach (array_unique($candidates) as $file) {
        if ($file && is_file($file) && is_readable($file)) {
            return realpath($file) ?: $file;
        }
    }

    return null;
}

$configFile = wa_find_config();

if ($configFile === null) {
    wa_json([
        'ok' => false,
        'status' => 'critical',
        'error' => 'No se encontró un config.php válido.',
        'diagnostic' => [
            'api_directory' => WA_API_DIR,
            'root' => WA_ROOT,
            'environment_override_supported' => true,
        ],
    ], 500);
}

$config = require $configFile;

if (!is_array($config)) {
    wa_json([
        'ok' => false,
        'status' => 'critical',
        'error' => 'config.php no devolvió un array válido.',
    ], 500);
}

date_default_timezone_set(
    (string)($config['app']['timezone'] ?? 'America/Chihuahua')
);

function wa_config(): array
{
    global $config;
    return $config;
}

function wa_db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $db = wa_config()['db'] ?? [];

    $dsn = sprintf(
        'mysql:host=%s;dbname=%s;charset=%s',
        $db['host'] ?? 'localhost',
        $db['name'] ?? '',
        $db['charset'] ?? 'utf8mb4'
    );

    $pdo = new PDO(
        $dsn,
        (string)($db['user'] ?? ''),
        (string)($db['pass'] ?? ''),
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]
    );

    return $pdo;
}

function wa_whapi_request(
    string $method,
    string $path,
    ?array $body = null
): array {
    $whapi = wa_config()['whapi'] ?? [];

    $base = rtrim((string)($whapi['base_url'] ?? 'https://gate.whapi.cloud'), '/');
    $token = trim((string)($whapi['token'] ?? ''));

    if ($token === '') {
        throw new RuntimeException('Token Whapi no configurado.');
    }

    $url = $base . '/' . ltrim($path, '/');

    $headers = [
        'Authorization: Bearer ' . $token,
        'Accept: application/json',
    ];

    $options = [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_CUSTOMREQUEST => strtoupper($method),
        CURLOPT_HTTPHEADER => $headers,
        CURLOPT_TIMEOUT => (int)($whapi['timeout'] ?? 15),
        CURLOPT_CONNECTTIMEOUT => min(10, (int)($whapi['timeout'] ?? 15)),
    ];

    if ($body !== null) {
        $headers[] = 'Content-Type: application/json';
        $options[CURLOPT_HTTPHEADER] = $headers;
        $options[CURLOPT_POSTFIELDS] = json_encode(
            $body,
            JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES
        );
    }

    $ch = curl_init($url);
    curl_setopt_array($ch, $options);

    $raw = curl_exec($ch);
    $error = curl_error($ch);
    $status = (int)curl_getinfo($ch, CURLINFO_HTTP_CODE);

    curl_close($ch);

    if ($raw === false) {
        throw new RuntimeException('Error cURL: ' . $error);
    }

    $decoded = json_decode($raw, true);

    return [
        'status' => $status,
        'body' => is_array($decoded) ? $decoded : ['raw' => $raw],
    ];
}
