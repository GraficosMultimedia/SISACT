<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

$chatId = trim((string)($_GET['chat_id'] ?? ''));

if ($chatId === '') {
    wa_json([
        'ok' => false,
        'error' => 'Falta chat_id.',
    ], 422);
}

try {
    $pdo = wa_db();

    $stmt = $pdo->prepare("
        SELECT
            id,
            chat_id,
            whatsapp_message_id,
            direction,
            message_type,
            body,
            sender_phone,
            created_at
        FROM cp_whatsapp_messages
        WHERE chat_id = ?
        ORDER BY created_at ASC, id ASC
    ");

    $stmt->execute([$chatId]);
    $rows = $stmt->fetchAll();

    foreach ($rows as &$row) {
        $row['id'] = (int)$row['id'];
        $row['body'] = (string)($row['body'] ?? '');
        $row['direction'] = strtolower((string)($row['direction'] ?? 'incoming'));
        $row['message_type'] = (string)($row['message_type'] ?? 'text');
    }

    wa_json([
        'ok' => true,
        'chat_id' => $chatId,
        'count' => count($rows),
        'messages' => $rows,
    ]);
} catch (Throwable $e) {
    wa_json([
        'ok' => false,
        'error' => 'No se pudieron cargar los mensajes.',
        'detail' => $e->getMessage(),
    ], 500);
}
