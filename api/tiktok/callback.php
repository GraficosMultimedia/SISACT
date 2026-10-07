<?php
declare(strict_types=1);

require_once __DIR__ . '/../../config/runtime.php';
require_once __DIR__ . '/../../includes/tiktok.php';

require_auth();

$state = (string)($_GET['state'] ?? '');
$expected = (string)($_SESSION['tiktok_oauth_state'] ?? '');
unset($_SESSION['tiktok_oauth_state']);

if ($state === '' || $expected === '' || !hash_equals($expected, $state)) {
    http_response_code(400);
    exit('Estado OAuth inválido.');
}

if (isset($_GET['error'])) {
    $message = (string)($_GET['error_description'] ?? $_GET['error']);
    header('Location: /admin/tiktok.php?error=' . rawurlencode($message));
    exit;
}

$code = trim((string)($_GET['code'] ?? ''));
if ($code === '') {
    header('Location: /admin/tiktok.php?error=' . rawurlencode('TikTok no devolvió un código de autorización.'));
    exit;
}

try {
    $token = tiktok_token_request('authorization_code', $code);
    tiktok_save_tokens($token);

    try {
        tiktok_profile_info();
    } catch (Throwable $e) {
        // La publicación puede continuar si el token y open_id ya fueron emitidos.
    }

    try {
        tiktok_creator_info();
    } catch (Throwable $e) {
        // Se valida de nuevo desde la pantalla de administración.
    }

    log_activity('update', 'tiktok', 'Cuenta de TikTok conectada mediante OAuth');
    header('Location: /admin/tiktok.php?connected=1');
    exit;
} catch (Throwable $e) {
    header('Location: /admin/tiktok.php?error=' . rawurlencode($e->getMessage()));
    exit;
}
