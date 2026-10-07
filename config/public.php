<?php
declare(strict_types=1);

if (!function_exists('cp_public_base_path')) {
    function cp_public_base_path(): string
    {
        static $base = null;
        if ($base !== null) return $base;
        $doc = isset($_SERVER['DOCUMENT_ROOT']) ? realpath((string)$_SERVER['DOCUMENT_ROOT']) : false;
        $root = realpath(__DIR__ . '/..');
        if ($doc && $root) {
            $doc = rtrim(str_replace('\\', '/', $doc), '/');
            $root = str_replace('\\', '/', $root);
            if ($root === $doc) return $base = '';
            $prefix = $doc . '/';
            if (str_starts_with($root, $prefix)) {
                $relative = trim(substr($root, strlen($prefix)), '/');
                return $base = $relative !== '' ? '/' . $relative : '';
            }
        }
        $script = str_replace('\\', '/', (string)($_SERVER['SCRIPT_NAME'] ?? '/'));
        $candidate = trim(dirname($script), '/.');
        return $base = $candidate !== '' ? '/' . $candidate : '';
    }
}
if (!function_exists('cp_public_url')) {
    function cp_public_url(string $path = ''): string
    {
        $path = trim($path);
        if ($path === '') return cp_public_base_path() !== '' ? cp_public_base_path() . '/' : '/';
        if (preg_match('#^(?:https?:)?//#i', $path)) return $path;
        return cp_public_base_path() . '/' . ltrim($path, '/');
    }
}
if (!function_exists('cp_public_asset')) {
    function cp_public_asset(string $path): string { return cp_public_url($path); }
}
