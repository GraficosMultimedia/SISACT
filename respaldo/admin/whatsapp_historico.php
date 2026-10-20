<?php
declare(strict_types=1);

/**
 * Colibrí Print México
 * Centro de WhatsApp
 *
 * Responsabilidades:
 * - Preparar mensajes desde cotizaciones, órdenes y promociones.
 * - Mostrar la bandeja de WhatsApp recibida por el webhook.
 * - Actualizar la bandeja automáticamente mediante los endpoints API.
 * - Administrar plantillas.
 *
 * El envío real por WhatsApp continúa separado de esta pantalla.
 */

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/whatsapp.php';

require_auth();

$title = 'Centro de WhatsApp';
$error = null;
$success = null;

/* --------------------------------------------------------------------------
 * Parámetros
 * -------------------------------------------------------------------------- */

$sourceType = (string)($_GET['source'] ?? $_POST['source'] ?? 'quote');
$sourceId = (int)($_GET['id'] ?? $_POST['id'] ?? 0);
$templateKey = (string)($_GET['template'] ?? $_POST['template_key'] ?? '');
$selectedChatId = (int)($_GET['chat_id'] ?? 0);

$allowedSourceTypes = ['quote', 'order', 'promotion'];

if (!in_array($sourceType, $allowedSourceTypes, true)) {
    $sourceType = 'quote';
}

/* --------------------------------------------------------------------------
 * Acciones POST
 * -------------------------------------------------------------------------- */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } else {
        $action = (string)($_POST['action'] ?? '');

        try {
            if ($action === 'open_whatsapp') {
                $built = whatsapp_build_message($sourceType, $sourceId, $templateKey);

                $src = $built['source'];

                whatsapp_log_prepared(
                    $built['template_key'],
                    $sourceType === 'order' ? $sourceId : 0,
                    $sourceType === 'quote' ? $sourceId : 0,
                    (int)$src['customer_id'],
                    (string)$src['phone'],
                    (string)$built['message']
                );

                header('Location: ' . $built['url'], true, 302);
                exit;
            }

            if ($action === 'save_template') {
                $key = (string)($_POST['template_key'] ?? '');
                $body = trim((string)($_POST['body'] ?? ''));
                $active = isset($_POST['active']) ? 1 : 0;

                $defaults = whatsapp_default_templates();

                if (!isset($defaults[$key])) {
                    throw new RuntimeException('Plantilla no válida.');
                }

                if ($body === '') {
                    throw new RuntimeException('El mensaje no puede quedar vacío.');
                }

                db()->prepare(
                    'INSERT INTO cp_whatsapp_templates
                        (template_key, name, category, body, active, created_at, updated_at)
                     VALUES (?, ?, ?, ?, ?, NOW(), NOW())
                     ON DUPLICATE KEY UPDATE
                        name = VALUES(name),
                        category = VALUES(category),
                        body = VALUES(body),
                        active = VALUES(active),
                        updated_at = NOW()'
                )->execute([
                    $key,
                    $defaults[$key]['name'],
                    $defaults[$key]['category'],
                    $body,
                    $active,
                ]);

                $success = 'Plantilla guardada correctamente.';
            }

            if ($action === 'reset_template') {
                $key = (string)($_POST['template_key'] ?? '');
                $defaults = whatsapp_default_templates();

                if (!isset($defaults[$key])) {
                    throw new RuntimeException('Plantilla no válida.');
                }

                db()->prepare(
                    'INSERT INTO cp_whatsapp_templates
                        (template_key, name, category, body, active, created_at, updated_at)
                     VALUES (?, ?, ?, ?, 1, NOW(), NOW())
                     ON DUPLICATE KEY UPDATE
                        body = VALUES(body),
                        active = 1,
                        updated_at = NOW()'
                )->execute([
                    $key,
                    $defaults[$key]['name'],
                    $defaults[$key]['category'],
                    $defaults[$key]['body'],
                ]);

                $success = 'Mensaje restaurado correctamente.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

/* --------------------------------------------------------------------------
 * Datos para el centro de comunicaciones
 * -------------------------------------------------------------------------- */

$quotes = [];
$orders = [];
$promotions = [];
$logs = [];

try {
    $quotes = db()->query(
        "SELECT
            q.id,
            q.quote_number,
            q.issue_date,
            q.status,
            c.name AS customer_name
         FROM cp_quotes q
         LEFT JOIN cp_customers c ON c.id = q.customer_id
         ORDER BY q.id DESC
         LIMIT 12"
    )->fetchAll();
} catch (Throwable $e) {
    $quotes = [];
}

try {
    $orders = db()->query(
        "SELECT
            o.id,
            o.order_number,
            o.status,
            o.due_date,
            c.name AS customer_name
         FROM cp_orders o
         LEFT JOIN cp_customers c ON c.id = o.customer_id
         ORDER BY o.id DESC
         LIMIT 12"
    )->fetchAll();
} catch (Throwable $e) {
    $orders = [];
}

try {
    $promotions = promotion_active_list('whatsapp', 12);
} catch (Throwable $e) {
    $promotions = [];
}

try {
    $logs = db()->query(
        "SELECT
            l.*,
            u.name AS user_name,
            o.order_number,
            q.quote_number
         FROM cp_whatsapp_log l
         LEFT JOIN cp_users u ON u.id = l.prepared_by
         LEFT JOIN cp_orders o ON o.id = l.order_id
         LEFT JOIN cp_quotes q ON q.id = l.quote_id
         ORDER BY l.id DESC
         LIMIT 15"
    )->fetchAll();
} catch (Throwable $e) {
    $logs = [];
}

/* --------------------------------------------------------------------------
 * Bandeja WhatsApp
 *
 * La primera carga se hace desde MySQL.
 * Después JavaScript consulta:
 *   /api/whatsapp/chats.php
 *   /api/whatsapp/messages.php?chat_id=X
 * -------------------------------------------------------------------------- */

$waChats = [];
$waMessages = [];

try {
    $waChats = db()->query(
        "SELECT
            id,
            chat_id,
            phone,
            contact_name,
            status,
            last_message,
            last_message_at,
            unread_count,
            created_at,
            updated_at
         FROM cp_whatsapp_chats
         ORDER BY updated_at DESC, id DESC
         LIMIT 100"
    )->fetchAll();
} catch (Throwable $e) {
    $waChats = [];
}

if ($selectedChatId <= 0 && $waChats) {
    $selectedChatId = (int)$waChats[0]['id'];
}

if ($selectedChatId > 0) {
    try {
        $stmt = db()->prepare(
            "SELECT
                id,
                chat_id,
                whatsapp_message_id,
                direction,
                message_type,
                body,
                sender_phone,
                sender_name,
                from_me,
                whatsapp_timestamp,
                message_at,
                status,
                created_at
             FROM cp_whatsapp_messages
             WHERE chat_id = ?
             ORDER BY id ASC
             LIMIT 300"
        );

        $stmt->execute([$selectedChatId]);
        $waMessages = $stmt->fetchAll();
    } catch (Throwable $e) {
        $waMessages = [];
    }
}

/* --------------------------------------------------------------------------
 * Vista previa / plantillas
 * -------------------------------------------------------------------------- */

$built = null;

if ($sourceId > 0) {
    try {
        $built = whatsapp_build_message($sourceType, $sourceId, $templateKey);
        $templateKey = (string)$built['template_key'];
    } catch (Throwable $e) {
        $error = $error ?: $e->getMessage();
    }
}

$templates = whatsapp_templates(true);

$serviceTemplates = array_values(
    array_filter(
        $templates,
        static fn(array $template): bool =>
            (string)($template['category'] ?? '') === 'service'
    )
);

$commercialTemplates = array_values(
    array_filter(
        $templates,
        static fn(array $template): bool =>
            (string)($template['category'] ?? '') === 'commercial'
    )
);

/* --------------------------------------------------------------------------
 * Helpers de presentación
 * -------------------------------------------------------------------------- */

function wa_format_date(?string $value, string $format = 'd/m/Y H:i'): string
{
    if (!$value) {
        return '';
    }

    $timestamp = strtotime($value);

    return $timestamp ? date($format, $timestamp) : '';
}

function wa_chat_label(array $chat): string
{
    $name = trim((string)($chat['contact_name'] ?? ''));
    $phone = trim((string)($chat['phone'] ?? ''));

    return $name !== '' ? $name : ($phone !== '' ? $phone : 'Sin contacto');
}

function wa_message_preview(array $chat): string
{
    $message = trim((string)($chat['last_message'] ?? ''));

    return $message !== '' ? $message : 'Sin mensajes';
}

require __DIR__ . '/../includes/header.php';
?>

<link rel="stylesheet" href="/assets/css/whatsapp.css?v=20260924-inbox-2">

<style>
/* ==========================================================================
   WhatsApp Inbox
   ========================================================================== */

.wa-inbox {
    margin: 22px 0;
}

.wa-inbox-toolbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 14px;
    flex-wrap: wrap;
}

.wa-inbox-actions {
    display: flex;
    align-items: center;
    gap: 8px;
}

.wa-sync-time {
    color: #94a3b8;
    font-size: 10px;
    white-space: nowrap;
}

.wa-live-status {
    display: inline-flex;
    align-items: center;
    gap: 7px;
    color: #64748b;
    font-size: 12px;
}

.wa-live-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #22c55e;
    box-shadow: 0 0 0 4px rgba(34, 197, 94, .12);
}

.wa-live-dot.loading {
    background: #f59e0b;
    box-shadow: 0 0 0 4px rgba(245, 158, 11, .12);
}

.wa-live-dot.error {
    background: #ef4444;
    box-shadow: 0 0 0 4px rgba(239, 68, 68, .12);
}

.wa-inbox-grid {
    display: grid;
    grid-template-columns: 350px minmax(0, 1fr);
    min-height: 600px;
    height: min(720px, 72vh);
    border: 1px solid #dfe5eb;
    border-radius: 18px;
    overflow: hidden;
    background: #fff;
}

.wa-chat-list {
    border-right: 1px solid #e5e7eb;
    background: #fbfcfd;
    overflow-y: auto;
}

.wa-chat-search {
    position: sticky;
    top: 0;
    z-index: 2;
    padding: 12px;
    background: rgba(251, 252, 253, .96);
    border-bottom: 1px solid #e5e7eb;
    backdrop-filter: blur(8px);
}

.wa-chat-search input {
    width: 100%;
    border: 1px solid #d8dee6;
    border-radius: 10px;
    padding: 10px 12px;
    background: #fff;
    outline: none;
}

.wa-chat-search input:focus {
    border-color: #22c55e;
    box-shadow: 0 0 0 3px rgba(34, 197, 94, .10);
}

.wa-chat-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 13px 14px;
    border-bottom: 1px solid #edf0f2;
    text-decoration: none;
    color: inherit;
    transition: background .15s ease;
    cursor: pointer;
}

.wa-chat-item:hover {
    background: #f0fdf4;
}

.wa-chat-item.active {
    background: #ecfdf5;
    box-shadow: inset 3px 0 0 #16a34a;
}

.wa-chat-avatar {
    width: 44px;
    height: 44px;
    flex: 0 0 44px;
    display: grid;
    place-items: center;
    border-radius: 50%;
    background: linear-gradient(135deg, #dcfce7, #bbf7d0);
    color: #166534;
    font-size: 19px;
}

.wa-chat-main {
    min-width: 0;
    flex: 1;
}

.wa-chat-top,
.wa-chat-bottom {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 10px;
}

.wa-chat-top strong,
.wa-chat-bottom span {
    min-width: 0;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

.wa-chat-top strong {
    color: #0f172a;
    font-size: 14px;
}

.wa-chat-top small {
    flex: 0 0 auto;
    white-space: nowrap;
    color: #94a3b8;
    font-size: 10px;
}

.wa-chat-bottom {
    margin-top: 5px;
    color: #64748b;
    font-size: 12px;
}

.wa-chat-bottom b {
    min-width: 20px;
    text-align: center;
    background: #16a34a;
    color: #fff;
    border-radius: 999px;
    padding: 2px 6px;
    font-size: 10px;
}

.wa-message-pane {
    min-width: 0;
    display: flex;
    flex-direction: column;
    background:
        radial-gradient(circle at 20% 20%, rgba(34, 197, 94, .035) 0, transparent 30%),
        #f7faf9;
}

.wa-message-header {
    flex: 0 0 auto;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 15px;
    padding: 13px 18px;
    background: rgba(255,255,255,.95);
    border-bottom: 1px solid #e5e7eb;
}

.wa-message-contact {
    min-width: 0;
}

.wa-message-contact strong {
    display: block;
    color: #0f172a;
    font-size: 14px;
}

.wa-message-contact span {
    display: block;
    color: #64748b;
    font-size: 11px;
    margin-top: 2px;
}

.wa-message-list {
    flex: 1;
    min-height: 0;
    overflow-y: auto;
    padding: 22px;
    scroll-behavior: smooth;
}

.wa-day-divider {
    display: flex;
    justify-content: center;
    margin: 12px 0 18px;
}

.wa-day-divider span {
    background: rgba(255,255,255,.92);
    color: #64748b;
    border: 1px solid #e2e8f0;
    border-radius: 999px;
    padding: 4px 10px;
    font-size: 10px;
}

.wa-bubble-row {
    display: flex;
    margin: 8px 0;
}

.wa-bubble-row.incoming {
    justify-content: flex-start;
}

.wa-bubble-row.outgoing {
    justify-content: flex-end;
}

.wa-bubble {
    max-width: min(72%, 620px);
    padding: 10px 13px 8px;
    border-radius: 15px;
    background: #fff;
    border: 1px solid rgba(15, 23, 42, .05);
    box-shadow: 0 2px 8px rgba(15, 23, 42, .06);
    line-height: 1.45;
    color: #1e293b;
    word-break: break-word;
}

.wa-bubble-row.incoming .wa-bubble {
    border-top-left-radius: 5px;
}

.wa-bubble-row.outgoing .wa-bubble {
    background: #dcfce7;
    border-color: #bbf7d0;
    border-top-right-radius: 5px;
}

.wa-sender {
    display: block;
    color: #15803d;
    font-weight: 700;
    margin-bottom: 4px;
    font-size: 11px;
}

.wa-time {
    display: block;
    text-align: right;
    color: #94a3b8;
    font-size: 9px;
    margin-top: 5px;
}

.wa-readonly-note {
    flex: 0 0 auto;
    padding: 9px 16px;
    border-top: 1px solid #e5e7eb;
    background: #fff;
    color: #64748b;
    font-size: 11px;
    text-align: center;
}

.wa-empty-state {
    min-height: 300px;
    height: 100%;
    display: grid;
    place-content: center;
    justify-items: center;
    text-align: center;
    padding: 35px;
    color: #64748b;
}

.wa-empty-icon {
    width: 64px;
    height: 64px;
    display: grid;
    place-items: center;
    margin-bottom: 12px;
    border-radius: 20px;
    background: #ecfdf5;
    font-size: 28px;
}

.wa-empty-state strong {
    display: block;
    color: #334155;
    font-size: 15px;
}

.wa-empty-state p {
    max-width: 420px;
    margin: 6px 0 0;
    font-size: 12px;
}

.wa-inbox-error {
    margin: 12px 0;
    padding: 10px 12px;
    border-radius: 10px;
    background: #fef2f2;
    color: #991b1b;
    border: 1px solid #fecaca;
    font-size: 12px;
}

.wa-count-online {
    display: inline-flex;
    align-items: center;
    gap: 6px;
}

@media (max-width: 900px) {
    .wa-inbox-grid {
        grid-template-columns: 300px minmax(0, 1fr);
    }
}

@media (max-width: 720px) {
    .wa-inbox-grid {
        grid-template-columns: 1fr;
        height: auto;
        min-height: 0;
    }

    .wa-chat-list {
        max-height: 330px;
        border-right: 0;
        border-bottom: 1px solid #e5e7eb;
    }

    .wa-message-pane {
        min-height: 520px;
    }

    .wa-bubble {
        max-width: 88%;
    }
}
</style>

<div class="wa-toolbar no-print">
    <div>
        <span class="eyebrow">CENTRO DE COMUNICACIONES</span>
        <h2>WhatsApp</h2>
        <p class="muted">
            Bandeja de entrada, mensajes preparados y plantillas en un solo lugar.
        </p>
    </div>
</div>

<?php if ($error): ?>
    <div class="notice danger no-print"><?= e($error) ?></div>
<?php endif; ?>

<?php if ($success): ?>
    <div class="notice no-print">
        <span class="ok">✓</span>
        <?= e($success) ?>
    </div>
<?php endif; ?>

<section class="card wa-intro no-print">
    <div>
        <span class="eyebrow">CENTRALIZADO</span>
        <h3>Una sola bandeja para servicio y promociones</h3>
        <p>
            Las comunicaciones operativas y comerciales usan el mismo centro,
            mientras las plantillas y registros permanecen separados.
        </p>
    </div>

    <div class="wa-legend">
        <span>🧾 Cotización</span>
        <span>🛠️ Orden</span>
        <span>🏭 Producción</span>
        <span>🏷️ Promoción</span>
    </div>
</section>

<!-- =======================================================================
     BANDEJA DE WHATSAPP
     ======================================================================= -->

<section class="card wa-inbox no-print" id="wa-inbox">
    <div class="section-heading">
        <div>
            <span class="eyebrow">BANDEJA EN VIVO</span>
            <h3>Conversaciones de WhatsApp</h3>
            <p class="muted">
                Los mensajes recibidos por el webhook se muestran aquí y se
                actualizan automáticamente.
            </p>
        </div>

        <div class="wa-inbox-actions">
            <span class="wa-live-status">
                <span class="wa-live-dot" id="wa-live-dot"></span>
                <span id="wa-live-text">Conectado</span>
            </span>

            <button type="button" class="btn btn-secondary" id="wa-refresh-btn">
                ↻ Actualizar
            </button>

            <span class="wa-sync-time" id="wa-last-sync">Sin sincronizar</span>

            <span class="count-pill" id="wa-chat-count">
                <?= count($waChats) ?>
            </span>
        </div>
    </div>

    <div id="wa-inbox-error" class="wa-inbox-error" hidden></div>

    <div class="wa-inbox-grid">
        <aside class="wa-chat-list" id="wa-chat-list">

            <div class="wa-chat-search">
                <input
                    type="search"
                    id="wa-chat-search"
                    placeholder="Buscar conversación..."
                    autocomplete="off"
                >
            </div>

            <div id="wa-chat-items">
                <?php if (!$waChats): ?>
                    <div class="wa-empty-state">
                        <div class="wa-empty-icon">💬</div>
                        <strong>Todavía no hay conversaciones</strong>
                        <p>
                            Cuando el webhook reciba un mensaje aparecerá
                            automáticamente aquí.
                        </p>
                    </div>
                <?php else: ?>
                    <?php foreach ($waChats as $chat): ?>
                        <?php $chatId = (int)$chat['id']; ?>
                        <a
                            href="/admin/whatsapp.php?chat_id=<?= $chatId ?>#wa-inbox"
                            class="wa-chat-item <?= $selectedChatId === $chatId ? 'active' : '' ?>"
                            data-chat-id="<?= $chatId ?>"
                            data-search="<?= e(
                                strtolower(
                                    wa_chat_label($chat) . ' ' .
                                    (string)($chat['phone'] ?? '')
                                )
                            ) ?>"
                        >
                            <div class="wa-chat-avatar">💬</div>

                            <div class="wa-chat-main">
                                <div class="wa-chat-top">
                                    <strong><?= e(wa_chat_label($chat)) ?></strong>

                                    <small>
                                        <?= e(
                                            wa_format_date(
                                                $chat['last_message_at'] ?? null,
                                                'd/m H:i'
                                            )
                                        ) ?>
                                    </small>
                                </div>

                                <div class="wa-chat-bottom">
                                    <span><?= e(wa_message_preview($chat)) ?></span>

                                    <?php if ((int)($chat['unread_count'] ?? 0) > 0): ?>
                                        <b><?= (int)$chat['unread_count'] ?></b>
                                    <?php endif; ?>
                                </div>
                            </div>
                        </a>
                    <?php endforeach; ?>
                <?php endif; ?>
            </div>
        </aside>

        <main class="wa-message-pane" id="wa-message-pane">

            <?php if ($selectedChatId > 0 && $waMessages): ?>

                <?php
                $selectedChat = null;

                foreach ($waChats as $chat) {
                    if ((int)$chat['id'] === $selectedChatId) {
                        $selectedChat = $chat;
                        break;
                    }
                }
                ?>

                <header class="wa-message-header" id="wa-message-header">
                    <div class="wa-message-contact">
                        <strong>
                            <?= e(
                                $selectedChat
                                    ? wa_chat_label($selectedChat)
                                    : 'Conversación'
                            ) ?>
                        </strong>

                        <span>
                            <?= e(
                                $selectedChat['phone'] ?? ''
                            ) ?>
                        </span>
                    </div>

                    <span class="wa-count-online">
                        <span class="wa-live-dot"></span>
                        En vivo
                    </span>
                </header>

                <div class="wa-message-list" id="wa-message-list">
                    <?php foreach ($waMessages as $msg): ?>
                        <div
                            class="wa-bubble-row <?= (
                                (string)$msg['direction'] === 'outgoing' ||
                                (int)$msg['from_me'] === 1
                            ) ? 'outgoing' : 'incoming' ?>"
                        >
                            <div class="wa-bubble">

                                <?php if ((string)($msg['sender_name'] ?? '') !== ''): ?>
                                    <small class="wa-sender">
                                        <?= e((string)$msg['sender_name']) ?>
                                    </small>
                                <?php endif; ?>

                                <div>
                                    <?= nl2br(e((string)($msg['body'] ?? ''))) ?>
                                </div>

                                <small class="wa-time">
                                    <?= e(
                                        wa_format_date(
                                            $msg['message_at'] ?? null,
                                            'd/m/Y H:i'
                                        )
                                    ) ?>
                                </small>
                            </div>
                        </div>
                    <?php endforeach; ?>
                </div>

                <div class="wa-readonly-note">
                    🔒 Bandeja de lectura. El envío se conectará posteriormente.
                </div>

            <?php elseif ($selectedChatId > 0): ?>

                <div class="wa-empty-state">
                    <div class="wa-empty-icon">📭</div>
                    <strong>Conversación sin mensajes</strong>
                    <p>
                        El chat existe, pero todavía no hay mensajes registrados.
                    </p>
                </div>

            <?php else: ?>

                <div class="wa-empty-state">
                    <div class="wa-empty-icon">💬</div>
                    <strong>Selecciona una conversación</strong>
                    <p>
                        Los mensajes entrantes aparecerán en esta zona.
                    </p>
                </div>

            <?php endif; ?>

        </main>
    </div>
</section>

<!-- =======================================================================
     PREPARACIÓN DE MENSAJES
     ======================================================================= -->

<section class="wa-center-grid no-print">
    <div>

        <section class="card wa-source-card">
            <div class="section-heading">
                <div>
                    <span class="eyebrow">1 · SELECCIONA</span>
                    <h3>Qué quieres comunicar</h3>
                </div>
            </div>

            <div class="wa-source-tabs">
                <a
                    class="<?= $sourceType === 'quote' ? 'active' : '' ?>"
                    href="/admin/whatsapp.php?source=quote"
                >
                    🧾 Cotización
                </a>

                <a
                    class="<?= $sourceType === 'order' ? 'active' : '' ?>"
                    href="/admin/whatsapp.php?source=order"
                >
                    🛠️ Orden
                </a>

                <a
                    class="<?= $sourceType === 'promotion' ? 'active' : '' ?>"
                    href="/admin/whatsapp.php?source=promotion"
                >
                    🏷️ Promoción
                </a>
            </div>

            <div class="wa-record-list">

                <?php if ($sourceType === 'quote'): ?>

                    <?php foreach ($quotes as $record): ?>
                        <a
                            class="wa-record <?= $sourceId === (int)$record['id'] ? 'selected' : '' ?>"
                            href="/admin/whatsapp.php?source=quote&id=<?= (int)$record['id'] ?>&template=quote_sent"
                        >
                            <div>
                                <strong><?= e((string)$record['quote_number']) ?></strong>
                                <span><?= e($record['customer_name'] ?? 'Sin cliente') ?></span>
                            </div>

                            <small>
                                <?= e(
                                    wa_format_date(
                                        (string)$record['issue_date'],
                                        'd/m/Y'
                                    )
                                ) ?>
                            </small>
                        </a>
                    <?php endforeach; ?>

                <?php elseif ($sourceType === 'order'): ?>

                    <?php foreach ($orders as $record): ?>
                        <a
                            class="wa-record <?= $sourceId === (int)$record['id'] ? 'selected' : '' ?>"
                            href="/admin/whatsapp.php?source=order&id=<?= (int)$record['id'] ?>&template=<?= e(
                                whatsapp_stage_template_key((string)$record['status'])
                            ) ?>"
                        >
                            <div>
                                <strong><?= e((string)$record['order_number']) ?></strong>
                                <span><?= e($record['customer_name'] ?? 'Sin cliente') ?></span>
                            </div>

                            <small><?= e((string)$record['status']) ?></small>
                        </a>
                    <?php endforeach; ?>

                <?php else: ?>

                    <?php foreach ($promotions as $record): ?>
                        <a
                            class="wa-record <?= $sourceId === (int)$record['id'] ? 'selected' : '' ?>"
                            href="/admin/whatsapp.php?source=promotion&id=<?= (int)$record['id'] ?>&template=promotion_offer"
                        >
                            <div>
                                <strong><?= e((string)$record['title']) ?></strong>
                                <span><?= e((string)$record['label']) ?></span>
                            </div>

                            <small>
                                <?= e(
                                    promotion_effective_state_label(
                                        promotion_effective_state($record)
                                    )
                                ) ?>
                            </small>
                        </a>
                    <?php endforeach; ?>

                <?php endif; ?>

                <?php
                $noRecords =
                    ($sourceType === 'quote' && !$quotes) ||
                    ($sourceType === 'order' && !$orders) ||
                    ($sourceType === 'promotion' && !$promotions);
                ?>

                <?php if ($noRecords): ?>
                    <div class="empty">No hay registros disponibles.</div>
                <?php endif; ?>

            </div>
        </section>

        <section class="card wa-template-select no-print">
            <div class="section-heading">
                <div>
                    <span class="eyebrow">2 · PLANTILLA</span>
                    <h3>Mensaje que se utilizará</h3>
                </div>
            </div>

            <div class="wa-template-pills">
                <?php
                $templateList =
                    $sourceType === 'promotion'
                        ? $commercialTemplates
                        : $serviceTemplates;
                ?>

                <?php foreach ($templateList as $template): ?>
                    <a
                        class="wa-template-pill <?= $templateKey === $template['template_key'] ? 'active' : '' ?>"
                        href="/admin/whatsapp.php?source=<?= e($sourceType) ?>&id=<?= $sourceId ?>&template=<?= e((string)$template['template_key']) ?>"
                    >
                        <?= e((string)$template['name']) ?>
                    </a>
                <?php endforeach; ?>
            </div>
        </section>

    </div>

    <div>

        <section class="card wa-compose <?= $built ? 'has-preview' : '' ?>">
            <div class="section-heading">
                <div>
                    <span class="eyebrow">3 · REVISAR</span>
                    <h3>Vista previa</h3>
                </div>

                <?php if ($built): ?>
                    <span class="wa-category-pill <?= $built['template']['category'] === 'commercial' ? 'commercial' : 'service' ?>">
                        <?= e(
                            $built['template']['category'] === 'commercial'
                                ? 'COMERCIAL'
                                : 'SERVICIO'
                        ) ?>
                    </span>
                <?php endif; ?>
            </div>

            <?php if (!$built): ?>

                <div class="wa-empty-state">
                    <div class="wa-empty-icon">💬</div>
                    <strong>Selecciona una comunicación</strong>
                    <p>
                        El mensaje se construirá automáticamente aquí.
                    </p>
                </div>

            <?php else: ?>

                <div class="wa-preview-meta">
                    <div>
                        <span>Origen</span>
                        <strong><?= e((string)$built['source']['label']) ?></strong>
                    </div>

                    <div>
                        <span>Plantilla</span>
                        <strong><?= e((string)$built['template']['name']) ?></strong>
                    </div>

                    <div>
                        <span>Destino</span>
                        <strong>
                            <?= e(
                                (string)($built['source']['phone'] ?? '')
                                    ?: 'Seleccionar contacto en WhatsApp'
                            ) ?>
                        </strong>
                    </div>
                </div>

                <?php if ($sourceType === 'quote'): ?>
                    <div class="wa-pdf-note">
                        📄 El mensaje incluye automáticamente el enlace público
                        del PDF de la cotización.
                    </div>
                <?php endif; ?>

                <textarea
                    class="wa-message-preview"
                    readonly
                ><?= e((string)$built['message']) ?></textarea>

                <form method="post" class="wa-send-form">
                    <input
                        type="hidden"
                        name="_csrf"
                        value="<?= e(csrf_token()) ?>"
                    >

                    <input
                        type="hidden"
                        name="action"
                        value="open_whatsapp"
                    >

                    <input
                        type="hidden"
                        name="source"
                        value="<?= e($sourceType) ?>"
                    >

                    <input
                        type="hidden"
                        name="id"
                        value="<?= $sourceId ?>"
                    >

                    <input
                        type="hidden"
                        name="template_key"
                        value="<?= e($templateKey) ?>"
                    >

                    <button
                        class="btn btn-primary wa-open-btn"
                        type="submit"
                    >
                        💬 Abrir WhatsApp
                    </button>

                    <a
                        class="btn btn-secondary"
                        href="/admin/whatsapp.php?source=<?= e($sourceType) ?>"
                    >
                        Limpiar
                    </a>
                </form>

            <?php endif; ?>
        </section>

    </div>
</section>

<!-- =======================================================================
     HISTORIAL
     ======================================================================= -->

<section class="card wa-log-card no-print">
    <div class="section-heading">
        <div>
            <span class="eyebrow">HISTORIAL</span>
            <h3>Últimas comunicaciones preparadas</h3>
        </div>

        <span class="count-pill"><?= count($logs) ?></span>
    </div>

    <?php if (!$logs): ?>

        <div class="empty">
            Todavía no hay mensajes preparados.
        </div>

    <?php else: ?>

        <div class="table-wrap">
            <table class="table">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Tipo</th>
                        <th>Origen</th>
                        <th>Teléfono</th>
                        <th>Usuario</th>
                    </tr>
                </thead>

                <tbody>
                    <?php foreach ($logs as $log): ?>
                        <tr>
                            <td>
                                <?= e(
                                    wa_format_date(
                                        (string)$log['created_at']
                                    )
                                ) ?>
                            </td>

                            <td>
                                <?= e((string)$log['template_key']) ?>
                            </td>

                            <td>
                                <?= e(
                                    trim(
                                        (string)($log['order_number'] ?? '') .
                                        ' ' .
                                        (string)($log['quote_number'] ?? '')
                                    ) ?: '—'
                                ) ?>
                            </td>

                            <td>
                                <?= e((string)($log['phone'] ?? '')) ?: '—' ?>
                            </td>

                            <td>
                                <?= e($log['user_name'] ?? 'Sistema') ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

    <?php endif; ?>
</section>

<!-- =======================================================================
     PLANTILLAS
     ======================================================================= -->

<section class="wa-template-management no-print">
    <div class="section-heading">
        <div>
            <span class="eyebrow">CONFIGURACIÓN</span>
            <h3>Plantillas</h3>
            <p class="muted">
                Edita los mensajes una sola vez y reutilízalos en todo el sistema.
            </p>
        </div>
    </div>

    <div class="wa-template-grid">

        <?php foreach ($templates as $template): ?>

            <form class="card wa-template" method="post">

                <input
                    type="hidden"
                    name="_csrf"
                    value="<?= e(csrf_token()) ?>"
                >

                <input
                    type="hidden"
                    name="action"
                    value="save_template"
                >

                <input
                    type="hidden"
                    name="template_key"
                    value="<?= e((string)$template['template_key']) ?>"
                >

                <div class="wa-template-head">
                    <div>
                        <span class="eyebrow">
                            <?= e(
                                $template['category'] === 'commercial'
                                    ? 'COMERCIAL'
                                    : 'SERVICIO'
                            ) ?>
                        </span>

                        <h3><?= e((string)$template['name']) ?></h3>
                    </div>

                    <label class="wa-active">
                        <input
                            type="checkbox"
                            name="active"
                            <?= $template['active'] ? 'checked' : '' ?>
                        >
                        Activa
                    </label>
                </div>

                <textarea
                    name="body"
                    rows="7"
                    class="wa-body"
                ><?= e((string)$template['body']) ?></textarea>

                <div class="wa-template-actions">
                    <button
                        class="btn btn-secondary"
                        type="submit"
                    >
                        Guardar
                    </button>

                    <button
                        class="btn btn-secondary"
                        type="submit"
                        name="action"
                        value="reset_template"
                    >
                        Restaurar
                    </button>
                </div>

            </form>

        <?php endforeach; ?>

    </div>
</section>

<script>
(() => {
    'use strict';

    /* =====================================================================
       CONFIGURACIÓN DEL FRONTEND
       ===================================================================== */
    const CONFIG = Object.freeze({
        chatsUrl: '/api/whatsapp/chats.php',
        messagesUrl: '/api/whatsapp/messages.php',
        pollMs: 5000,
        requestTimeoutMs: 10000,
        initialChatId: <?= (int)$selectedChatId ?>
    });

    /* =====================================================================
       ESTADO CENTRAL
       ===================================================================== */
    const state = {
        selectedChatId: Number(CONFIG.initialChatId) || 0,
        chats: [],
        messages: [],
        search: '',
        busy: false,
        initialized: false,
        lastSyncAt: null,
        controller: null
    };

    /* =====================================================================
       REFERENCIAS DOM
       ===================================================================== */
    const els = {
        chatItems: document.getElementById('wa-chat-items'),
        chatSearch: document.getElementById('wa-chat-search'),
        messagePane: document.getElementById('wa-message-pane'),
        count: document.getElementById('wa-chat-count'),
        refresh: document.getElementById('wa-refresh-btn'),
        error: document.getElementById('wa-inbox-error'),
        liveDot: document.getElementById('wa-live-dot'),
        liveText: document.getElementById('wa-live-text'),
        lastSync: document.getElementById('wa-last-sync')
    };

    /* =====================================================================
       UTILIDADES
       ===================================================================== */
    function escapeHtml(value) {
        return String(value ?? '')
            .replaceAll('&', '&amp;')
            .replaceAll('<', '&lt;')
            .replaceAll('>', '&gt;')
            .replaceAll('"', '&quot;')
            .replaceAll("'", '&#039;');
    }

    function nl2br(value) {
        return escapeHtml(value).replace(/\r?\n/g, '<br>');
    }

    function formatDate(value, withDate = false) {
        if (!value) return '';

        const raw = String(value).trim();
        const date = new Date(raw.includes('T') ? raw : raw.replace(' ', 'T'));

        if (Number.isNaN(date.getTime())) return raw;

        return new Intl.DateTimeFormat('es-MX', withDate
            ? {
                day: '2-digit',
                month: '2-digit',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            }
            : {
                day: '2-digit',
                month: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            }
        ).format(date);
    }

    function chatLabel(chat) {
        const name = String(chat?.contact_name ?? '').trim();
        const phone = String(chat?.phone ?? '').trim();
        return name || phone || 'Sin contacto';
    }

    function messagePreview(chat) {
        const text = String(chat?.last_message ?? '').trim();
        return text || 'Sin mensajes';
    }

    function getSelectedChat() {
        return state.chats.find(
            chat => Number(chat.id) === Number(state.selectedChatId)
        ) || null;
    }

    function setLiveStatus(type, text) {
        if (!els.liveDot || !els.liveText) return;

        els.liveDot.classList.remove('loading', 'error');

        if (type === 'loading') els.liveDot.classList.add('loading');
        if (type === 'error') els.liveDot.classList.add('error');

        els.liveText.textContent = text;
    }

    function showError(message) {
        if (!els.error) return;
        els.error.textContent = String(message || 'No se pudo actualizar la bandeja.');
        els.error.hidden = false;
    }

    function hideError() {
        if (!els.error) return;
        els.error.hidden = true;
        els.error.textContent = '';
    }

    function updateLastSync() {
        if (!els.lastSync || !state.lastSyncAt) return;

        els.lastSync.textContent = `Actualizado ${new Intl.DateTimeFormat('es-MX', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        }).format(state.lastSyncAt)}`;
    }

    function isNearBottom(element, threshold = 120) {
        if (!element) return true;
        return element.scrollHeight - element.scrollTop - element.clientHeight <= threshold;
    }

    function setSelectedChatUrl(chatId) {
        const url = new URL(window.location.href);
        url.searchParams.set('chat_id', String(chatId));
        url.hash = 'wa-inbox';
        window.history.replaceState(null, '', url.toString());
    }

    /* =====================================================================
       API
       ===================================================================== */
    async function fetchJson(url) {
        if (state.controller) state.controller.abort();

        const controller = new AbortController();
        state.controller = controller;
        const timeout = window.setTimeout(() => controller.abort(), CONFIG.requestTimeoutMs);

        try {
            const response = await fetch(url, {
                method: 'GET',
                credentials: 'same-origin',
                cache: 'no-store',
                signal: controller.signal,
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            });

            const text = await response.text();
            let data;

            try {
                data = JSON.parse(text);
            } catch {
                throw new Error(`La API devolvió una respuesta no válida (${response.status}).`);
            }

            if (!response.ok || data?.ok === false) {
                throw new Error(data?.message || `Error HTTP ${response.status}.`);
            }

            return data;
        } catch (error) {
            if (error?.name === 'AbortError') {
                throw new Error('La consulta tardó demasiado o fue reemplazada por una nueva.');
            }
            throw error;
        } finally {
            window.clearTimeout(timeout);
            if (state.controller === controller) state.controller = null;
        }
    }

    async function fetchChats() {
        const data = await fetchJson(CONFIG.chatsUrl);
        return Array.isArray(data?.chats) ? data.chats : [];
    }

    async function fetchMessages(chatId) {
        if (!chatId) return [];
        const url = `${CONFIG.messagesUrl}?chat_id=${encodeURIComponent(chatId)}`;
        const data = await fetchJson(url);
        return Array.isArray(data?.messages) ? data.messages : [];
    }

    /* =====================================================================
       CONVERSACIONES
       ===================================================================== */
    function filteredChats() {
        const query = state.search.trim().toLowerCase();
        if (!query) return state.chats;

        return state.chats.filter(chat => {
            const haystack = [
                chatLabel(chat),
                chat.phone ?? '',
                chat.last_message ?? ''
            ].join(' ').toLowerCase();

            return haystack.includes(query);
        });
    }

    function renderChats() {
        if (!els.chatItems) return;

        const chats = filteredChats();
        if (els.count) els.count.textContent = String(state.chats.length);

        if (!chats.length) {
            els.chatItems.innerHTML = `
                <div class="wa-empty-state">
                    <div class="wa-empty-icon">🔎</div>
                    <strong>${state.chats.length ? 'No hay coincidencias' : 'Todavía no hay conversaciones'}</strong>
                    <p>${state.chats.length
                        ? 'Prueba con otro nombre, número o mensaje.'
                        : 'Cuando el webhook reciba un mensaje aparecerá automáticamente aquí.'
                    }</p>
                </div>
            `;
            return;
        }

        els.chatItems.innerHTML = chats.map(chat => {
            const id = Number(chat.id);
            const active = id === Number(state.selectedChatId);
            const unread = Number(chat.unread_count ?? 0);

            return `
                <a
                    href="/admin/whatsapp.php?chat_id=${id}#wa-inbox"
                    class="wa-chat-item ${active ? 'active' : ''}"
                    data-chat-id="${id}"
                >
                    <div class="wa-chat-avatar">💬</div>
                    <div class="wa-chat-main">
                        <div class="wa-chat-top">
                            <strong>${escapeHtml(chatLabel(chat))}</strong>
                            <small>${escapeHtml(formatDate(chat.last_message_at, false))}</small>
                        </div>
                        <div class="wa-chat-bottom">
                            <span>${escapeHtml(messagePreview(chat))}</span>
                            ${unread > 0 ? `<b>${unread}</b>` : ''}
                        </div>
                    </div>
                </a>
            `;
        }).join('');

        els.chatItems.querySelectorAll('[data-chat-id]').forEach(item => {
            item.addEventListener('click', async event => {
                event.preventDefault();

                const id = Number(item.dataset.chatId);
                if (!id || id === Number(state.selectedChatId)) return;

                state.selectedChatId = id;
                state.messages = [];
                setSelectedChatUrl(id);
                renderChats();
                renderEmptyMessageState(
                    'Cargando conversación…',
                    'Consultando los mensajes más recientes.',
                    '⏳'
                );

                try {
                    setLiveStatus('loading', 'Cargando…');
                    state.messages = await fetchMessages(id);
                    renderMessages(true);
                    setLiveStatus('ok', 'Conectado');
                } catch (error) {
                    console.error(error);
                    setLiveStatus('error', 'Error de conexión');
                    showError(error instanceof Error ? error.message : 'No se pudo cargar la conversación.');
                    renderEmptyMessageState(
                        'No se pudo cargar',
                        'Pulsa «Actualizar» para intentarlo de nuevo.',
                        '⚠️'
                    );
                }
            });
        });
    }

    /* =====================================================================
       MENSAJES
       ===================================================================== */
    function renderEmptyMessageState(title, text, icon = '💬') {
        if (!els.messagePane) return;

        els.messagePane.innerHTML = `
            <div class="wa-empty-state">
                <div class="wa-empty-icon">${icon}</div>
                <strong>${escapeHtml(title)}</strong>
                <p>${escapeHtml(text)}</p>
            </div>
        `;
    }

    function renderMessages(forceBottom = false) {
        if (!els.messagePane) return;

        const chat = getSelectedChat();

        if (!state.selectedChatId) {
            renderEmptyMessageState(
                'Selecciona una conversación',
                'Los mensajes entrantes aparecerán en esta zona.',
                '💬'
            );
            return;
        }

        if (!state.messages.length) {
            renderEmptyMessageState(
                'Conversación sin mensajes',
                'El chat existe, pero todavía no hay mensajes registrados.',
                '📭'
            );
            return;
        }

        const oldList = document.getElementById('wa-message-list');
        const shouldStayAtBottom = forceBottom || !oldList || isNearBottom(oldList);

        els.messagePane.innerHTML = `
            <header class="wa-message-header">
                <div class="wa-message-contact">
                    <strong>${escapeHtml(chat ? chatLabel(chat) : 'Conversación')}</strong>
                    <span>${escapeHtml(chat?.phone ?? '')}</span>
                </div>
                <span class="wa-count-online">
                    <span class="wa-live-dot"></span>
                    En vivo
                </span>
            </header>

            <div class="wa-message-list" id="wa-message-list">
                ${state.messages.map(message => {
                    const outgoing =
                        String(message.direction ?? '') === 'outgoing' ||
                        Number(message.from_me ?? 0) === 1;
                    const sender = String(message.sender_name ?? '').trim();
                    const body = String(message.body ?? '');

                    return `
                        <div class="wa-bubble-row ${outgoing ? 'outgoing' : 'incoming'}">
                            <div class="wa-bubble">
                                ${sender ? `<small class="wa-sender">${escapeHtml(sender)}</small>` : ''}
                                <div>${nl2br(body)}</div>
                                <small class="wa-time">
                                    ${escapeHtml(formatDate(message.message_at, true))}
                                </small>
                            </div>
                        </div>
                    `;
                }).join('')}
            </div>

            <div class="wa-readonly-note">
                🔒 Bandeja de lectura. El envío se conectará posteriormente.
            </div>
        `;

        const list = document.getElementById('wa-message-list');
        if (list && shouldStayAtBottom) {
            requestAnimationFrame(() => {
                list.scrollTop = list.scrollHeight;
            });
        }
    }

    /* =====================================================================
       SINCRONIZACIÓN
       ===================================================================== */
    async function refreshInbox({manual = false, preserveMessages = true} = {}) {
        if (state.busy || document.hidden) return;

        state.busy = true;
        setLiveStatus('loading', manual ? 'Actualizando…' : 'Sincronizando…');

        try {
            hideError();

            const previousSelectedId = Number(state.selectedChatId);
            const previousMessageCount = state.messages.length;

            state.chats = await fetchChats();

            if (!state.selectedChatId && state.chats.length) {
                state.selectedChatId = Number(state.chats[0].id);
            }

            const selectedStillExists = state.chats.some(
                chat => Number(chat.id) === Number(state.selectedChatId)
            );

            if (!selectedStillExists) {
                state.selectedChatId = state.chats.length
                    ? Number(state.chats[0].id)
                    : 0;
            }

            renderChats();

            if (state.selectedChatId) {
                const messages = await fetchMessages(state.selectedChatId);
                const changed =
                    messages.length !== previousMessageCount ||
                    previousSelectedId !== Number(state.selectedChatId) ||
                    !preserveMessages;

                state.messages = messages;
                renderMessages(changed || manual);
            } else {
                state.messages = [];
                renderMessages(false);
            }

            state.lastSyncAt = new Date();
            updateLastSync();
            state.initialized = true;
            setLiveStatus('ok', 'Conectado');
        } catch (error) {
            console.error('WhatsApp inbox:', error);
            setLiveStatus('error', 'Error de conexión');
            showError(error instanceof Error ? error.message : 'No se pudo actualizar la bandeja.');

            /* Mantener la información visible durante fallos temporales. */
            if (!state.initialized) {
                renderChats();
                renderMessages(false);
            }
        } finally {
            state.busy = false;
        }
    }

    /* =====================================================================
       EVENTOS
       ===================================================================== */
    els.refresh?.addEventListener('click', () => {
        refreshInbox({manual: true, preserveMessages: false});
    });

    els.chatSearch?.addEventListener('input', event => {
        state.search = String(event.target?.value ?? '').toLowerCase();
        renderChats();
    });

    document.addEventListener('visibilitychange', () => {
        if (!document.hidden) refreshInbox({preserveMessages: true});
    });

    window.addEventListener('online', () => {
        refreshInbox({preserveMessages: true});
    });

    /* =====================================================================
       INICIO
       ===================================================================== */
    renderChats();
    renderMessages(false);
    refreshInbox({preserveMessages: true});

    window.setInterval(() => {
        refreshInbox({preserveMessages: true});
    }, CONFIG.pollMs);
})();
</script>


<?php require __DIR__ . '/../includes/footer.php'; ?>
