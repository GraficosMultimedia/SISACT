<?php
declare(strict_types=1);

require_once __DIR__ . '/config.php';

/*
 * Los módulos administrativos usan la sesión colibri_admin.
 * bootstrap.php también debe usar esa misma sesión para que los
 * formularios POST que no cargan header.php compartan el CSRF.
 */
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_name((string) (defined('CP_SESSION_NAME') ? CP_SESSION_NAME : 'colibri_admin'));
    session_start();
}

function cp_e(mixed $value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function cp_json(mixed $value): string
{
    return json_encode(
        $value,
        JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT
    );
}

function cp_money(float|int $value): string
{
    return '$' . number_format((float)$value, 2);
}

function cp_redirect(string $url): never
{
    header('Location: ' . $url);
    exit;
}

function cp_csrf(): string
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_name((string) (defined('CP_SESSION_NAME') ? CP_SESSION_NAME : 'colibri_admin'));
        session_start();
    }
    if (empty($_SESSION['cp_csrf'])) {
        $_SESSION['cp_csrf'] = bin2hex(random_bytes(24));
    }
    return $_SESSION['cp_csrf'];
}

function cp_check_csrf(?string $token): void
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_name((string) (defined('CP_SESSION_NAME') ? CP_SESSION_NAME : 'colibri_admin'));
        session_start();
    }
    if (!$token || empty($_SESSION['cp_csrf']) || !hash_equals($_SESSION['cp_csrf'], $token)) {
        http_response_code(419);
        exit('Token de seguridad inválido.');
    }
}

function cp_price_key(int $sizeId, int $materialId, int $finishId, string $color): string
{
    return implode(':', [$sizeId, $materialId, $finishId, $color]);
}

function cp_count_pdf_pages(string $path): int
{
    $pages = 0;
    $pdfinfo = trim((string)shell_exec('command -v pdfinfo 2>/dev/null'));
    if ($pdfinfo !== '') {
        $cmd = escapeshellcmd($pdfinfo) . ' ' . escapeshellarg($path) . ' 2>/dev/null';
        $output = shell_exec($cmd);
        if (is_string($output) && preg_match('/^\s*Pages:\s*(\d+)\s*$/mi', $output, $m)) {
            $pages = (int)$m[1];
        }
    }
    if ($pages < 1) {
        $raw = @file_get_contents($path);
        if ($raw !== false) {
            $pages = preg_match_all('/\/Type\s*\/Page\b/', $raw, $dummy);
        }
    }
    return max(1, (int)$pages);
}

function cp_detect_pages(string $path, string $mime, string $extension): int
{
    if ($extension === 'pdf' || $mime === 'application/pdf') {
        return cp_count_pdf_pages($path);
    }
    return 1;
}

function cp_random_name(string $extension): string
{
    return bin2hex(random_bytes(16)) . '.' . strtolower($extension);
}

function cp_allowed_file(array $file): bool
{
    $ext = strtolower(pathinfo((string)($file['name'] ?? ''), PATHINFO_EXTENSION));
    $mime = strtolower((string)($file['type'] ?? ''));
    $allowedExt = ['pdf', 'jpg', 'jpeg', 'png'];
    if (!in_array($ext, $allowedExt, true)) return false;
    if (($file['size'] ?? 0) > CP_MAX_FILE_BYTES) return false;
    if ($ext === 'pdf' && $mime && !in_array($mime, ['application/pdf', 'application/octet-stream'], true)) {
    }
    return true;
}
