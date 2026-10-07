<?php
declare(strict_types=1);

/*
 * TikTok Content Posting webhooks.
 * No inicia sesión ni requiere CSRF porque el llamado proviene de TikTok.
 * La validación/firma debe completarse según la configuración vigente de la app
 * antes de usar este endpoint en producción.
 */

$raw = file_get_contents('php://input') ?: '';
$data = json_decode($raw, true);

if (!is_array($data)) {
    http_response_code(400);
    echo 'invalid';
    exit;
}

// Punto de extensión para persistir eventos en cp_tiktok_posts.
// Se mantiene idempotente por publish_id para evitar duplicados.

http_response_code(200);
echo 'ok';
