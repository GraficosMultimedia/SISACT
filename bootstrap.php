<?php
declare(strict_types=1);

$config = require __DIR__ . '/config.php';
date_default_timezone_set($config['app']['timezone'] ?? 'America/Chihuahua');

function db(): PDO {
    static $pdo = null;
    global $config;
    if ($pdo instanceof PDO) return $pdo;
    $d = $config['db'];
    $dsn = "mysql:host={$d['host']};dbname={$d['name']};charset={$d['charset']}";
    $pdo = new PDO($dsn, $d['user'], $d['pass'], [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);
    return $pdo;
}

function json_response(array $data, int $status = 200): never {
    http_response_code($status);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

function post_string(string $key, string $default = ''): string {
    return trim((string)($_POST[$key] ?? $default));
}

function money(float $n): string {
    return '$' . number_format($n, 2, '.', ',');
}

function normalize_phone(string $phone): string {
    return preg_replace('/\D+/', '', $phone) ?? '';
}

function safe_filename(string $name): string {
    $name = basename($name);
    $name = preg_replace('/[^A-Za-z0-9._-]+/u', '_', $name) ?? 'archivo';
    return trim($name, '._') ?: 'archivo';
}

function pdf_page_count(string $path): int {
    // Prefer pdfinfo when available on cPanel/Linux.
    if (function_exists('shell_exec')) {
        $cmd = 'pdfinfo ' . escapeshellarg($path) . ' 2>/dev/null';
        $out = @shell_exec($cmd);
        if (is_string($out) && preg_match('/^Pages:\s+(\d+)/mi', $out, $m)) {
            return max(1, (int)$m[1]);
        }
    }
    $raw = @file_get_contents($path);
    if ($raw === false) return 1;
    // Fallback: count page objects. It is intentionally conservative.
    $count = preg_match_all('/\/Type\s*\/Page\b/', $raw, $dummy);
    return max(1, (int)$count);
}

function image_page_count(string $path): int { return 1; }

function table_exists(PDO $pdo, string $table): bool {
    $stmt = $pdo->prepare('SHOW TABLES LIKE ?');
    $stmt->execute([$table]);
    return (bool)$stmt->fetchColumn();
}

function find_or_create_customer(PDO $pdo, string $name, string $email, string $phone): ?int {
    if ($email !== '') {
        $s = $pdo->prepare('SELECT id FROM cp_customers WHERE email = ? ORDER BY id DESC LIMIT 1');
        $s->execute([$email]);
        if ($id = $s->fetchColumn()) return (int)$id;
    }
    $digits = normalize_phone($phone);
    if ($digits !== '') {
        $s = $pdo->prepare('SELECT id FROM cp_customers WHERE REPLACE(REPLACE(REPLACE(REPLACE(phone," ",""),"-",""),"+",""),"(","") LIKE ? ORDER BY id DESC LIMIT 1');
        $s->execute(['%' . $digits . '%']);
        if ($id = $s->fetchColumn()) return (int)$id;
    }
    $s = $pdo->prepare('INSERT INTO cp_customers (source_type,name,email,phone,enabled,created_at,updated_at) VALUES (?,?,?,?,1,NOW(),NOW())');
    $s->execute(['web_print_request', $name, $email ?: null, $phone ?: null]);
    return (int)$pdo->lastInsertId();
}
