<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    wa_json([
        'ok' => false,
        'error' => 'Método no permitido.',
    ], 405);
}

$rawInput = file_get_contents('php://input');
$input = json_decode($rawInput ?: '', true);

if (json_last_error() !== JSON_ERROR_NONE) {
    wa_json([
        'ok' => false,
        'error' => 'JSON de entrada inválido.',
        'detail' => json_last_error_msg(),
    ], 400);
}

if (!is_array($input)) {
    wa_json([
        'ok' => false,
        'error' => 'JSON inválido.',
    ], 400);
}

$chatId = trim((string)($input['chat_id'] ?? ''));
$message = trim((string)($input['message'] ?? ''));

if ($chatId === '') {
    wa_json([
        'ok' => false,
        'error' => 'Falta chat_id.',
    ], 422);
}

if ($message === '') {
    wa_json([
        'ok' => false,
        'error' => 'El mensaje está vacío.',
    ], 422);
}

if (mb_strlen($message) > 4096) {
    wa_json([
        'ok' => false,
        'error' => 'El mensaje supera los 4096 caracteres.',
    ], 422);
}

try {
    $response = wa_whapi_request(
        'POST',
        '/messages/text',
        [
            'to' => $chatId,
            'body' => $message,
        ]
    );

    if ($response['status'] < 200 || $response['status'] >= 300) {
        wa_json([
            'ok' => false,
            'error' => 'Whapi rechazó el mensaje.',
            'detail' => 'La API respondió con un estado HTTP no exitoso.',
            'status_code' => $response['status'],
            'response' => $response['body'],
        ], 502);
    }

    wa_json([
        'ok' => true,
        'chat_id' => $chatId,
        'message' => $response['body'],
    ]);
} catch (Throwable $e) {
    wa_json([
        'ok' => false,
        'error' => $e->getMessage(),
    ], 502);
}
