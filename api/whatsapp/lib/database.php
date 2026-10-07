<?php
declare(strict_types=1);

require_once __DIR__ . '/bootstrap.php';

function db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $config = app_config()['db'] ?? [];

    $host = (string)($config['host'] ?? 'localhost');
    $name = (string)($config['name'] ?? '');
    $user = (string)($config['user'] ?? '');
    $pass = (string)($config['pass'] ?? '');
    $charset = (string)($config['charset'] ?? 'utf8mb4');

    if ($name === '' || $user === '') {
        throw new RuntimeException('Configuración de base de datos incompleta.');
    }

    $dsn = "mysql:host={$host};dbname={$name};charset={$charset}";

    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    return $pdo;
}

function table_exists(PDO $pdo, string $table): bool
{
    $stmt = $pdo->prepare(
        "SELECT COUNT(*) FROM information_schema.tables
         WHERE table_schema = DATABASE() AND table_name = ?"
    );
    $stmt->execute([$table]);

    return (int)$stmt->fetchColumn() > 0;
}

function whatsapp_table_status(PDO $pdo): array
{
    $tables = [
        'cp_whatsapp_chats',
        'cp_whatsapp_messages',
        'cp_whatsapp_log',
    ];

    $result = [];
    foreach ($tables as $table) {
        $result[$table] = table_exists($pdo, $table);
    }

    return $result;
}

function whatsapp_counts(PDO $pdo): array
{
    $counts = [
        'chats' => null,
        'messages' => null,
        'logs' => null,
    ];

    $map = [
        'chats' => 'cp_whatsapp_chats',
        'messages' => 'cp_whatsapp_messages',
        'logs' => 'cp_whatsapp_log',
    ];

    foreach ($map as $key => $table) {
        if (table_exists($pdo, $table)) {
            $counts[$key] = (int)$pdo->query("SELECT COUNT(*) FROM `{$table}`")->fetchColumn();
        }
    }

    return $counts;
}

function find_chat_by_whatsapp_id(PDO $pdo, string $whatsappChatId): ?array
{
    $stmt = $pdo->prepare(
        'SELECT * FROM cp_whatsapp_chats WHERE chat_id = ? LIMIT 1'
    );
    $stmt->execute([$whatsappChatId]);

    $row = $stmt->fetch();
    return $row ?: null;
}

function upsert_chat_from_message(PDO $pdo, array $message): int
{
    $chatId = safe_text($message['chat_id'] ?? '', 190);
    $phone = safe_text($message['sender_phone'] ?? '', 80);
    $name = safe_text($message['sender_name'] ?? '', 190);

    if ($chatId === '') {
        throw new InvalidArgumentException('Evento sin chat_id.');
    }

    $existing = find_chat_by_whatsapp_id($pdo, $chatId);

    if ($existing) {
        $stmt = $pdo->prepare(
            'UPDATE cp_whatsapp_chats
             SET phone = COALESCE(NULLIF(?, \'\'), phone),
                 contact_name = COALESCE(NULLIF(?, \'\'), contact_name),
                 last_message = ?,
                 last_message_at = ?,
                 unread_count = unread_count + ?
             WHERE id = ?'
        );

        $last = safe_text($message['body'] ?? '…', 500);
        $at = $message['message_at'] ?? date('Y-m-d H:i:s');
        $increment = !empty($message['from_me']) ? 0 : 1;

        $stmt->execute([
            $phone,
            $name,
            $last,
            $at,
            $increment,
            $existing['id'],
        ]);

        return (int)$existing['id'];
    }

    $stmt = $pdo->prepare(
        'INSERT INTO cp_whatsapp_chats
         (chat_id, phone, contact_name, status, last_message, last_message_at, unread_count, created_at, updated_at)
         VALUES (?, ?, ?, \'open\', ?, ?, ?, NOW(), NOW())'
    );

    $last = safe_text($message['body'] ?? '…', 500);
    $at = $message['message_at'] ?? date('Y-m-d H:i:s');
    $increment = !empty($message['from_me']) ? 0 : 1;

    $stmt->execute([
        $chatId,
        $phone,
        $name !== '' ? $name : $phone,
        $last,
        $at,
        $increment,
    ]);

    return (int)$pdo->lastInsertId();
}

function store_message(PDO $pdo, array $message): int
{
    $whatsappId = safe_text($message['whatsapp_message_id'] ?? '', 190);
    $chatId = safe_text($message['chat_id'] ?? '', 190);

    if ($whatsappId === '' || $chatId === '') {
        throw new InvalidArgumentException('Mensaje sin identificadores mínimos.');
    }

    $check = $pdo->prepare(
        'SELECT id FROM cp_whatsapp_messages WHERE whatsapp_message_id = ? LIMIT 1'
    );
    $check->execute([$whatsappId]);
    $existing = $check->fetchColumn();

    if ($existing !== false) {
        return (int)$existing;
    }

    $chatPk = upsert_chat_from_message($pdo, $message);

    $stmt = $pdo->prepare(
        'INSERT INTO cp_whatsapp_messages
        (chat_id, whatsapp_message_id, direction, message_type, body,
         sender_phone, sender_name, from_me, whatsapp_timestamp, message_at, status, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())'
    );

    $stmt->execute([
        $chatPk,
        $whatsappId,
        !empty($message['from_me']) ? 'outgoing' : 'incoming',
        safe_text($message['message_type'] ?? 'text', 30),
        $message['body'] ?? null,
        $message['sender_phone'] ?? null,
        $message['sender_name'] ?? null,
        !empty($message['from_me']) ? 1 : 0,
        $message['whatsapp_timestamp'] ?? null,
        $message['message_at'] ?? date('Y-m-d H:i:s'),
        safe_text($message['status'] ?? 'received', 30),
    ]);

    return (int)$pdo->lastInsertId();
}
