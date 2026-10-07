<?php
declare(strict_types=1);

/*
 * Colibrí Print Admin - TikTok
 * Reutiliza la conexión oficial instalada en /tiktok-callback/.
 * Así no duplicamos tokens ni credenciales.
 */
$callbackRoot = rtrim((string)($_SERVER['DOCUMENT_ROOT'] ?? ''), '/') . '/tiktok-callback';

if (!is_file($callbackRoot . '/api.php')) {
    throw new RuntimeException('No se encontró el conector TikTok en /tiktok-callback/.');
}

require_once $callbackRoot . '/api.php';
