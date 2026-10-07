<?php
declare(strict_types=1);

/**
 * Colibrí Print México
 * Centro de WhatsApp
 *
 * Esta pantalla NO implementa bandeja, inbox ni envío mediante API de WhatsApp.
 * Su responsabilidad es preparar mensajes, abrir WhatsApp mediante wa.me,
 * consultar el historial de mensajes preparados y administrar plantillas.
 */

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/whatsapp.php';

require_auth();

$title = 'Centro de WhatsApp';
$error = null;
$success = null;

$sourceType = (string)($_GET['source'] ?? $_POST['source'] ?? 'quote');
$sourceId = (int)($_GET['id'] ?? $_POST['id'] ?? 0);
$templateKey = (string)($_GET['template'] ?? $_POST['template_key'] ?? '');
$allowedSourceTypes = ['quote', 'order', 'promotion'];

if (!in_array($sourceType, $allowedSourceTypes, true)) {
    $sourceType = 'quote';
}

/* --------------------------------------------------------------------------
 * Acciones
 * -------------------------------------------------------------------------- */

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } else {
        $action = (string)($_POST['action'] ?? '');

        try {
            if ($action === 'log_whatsapp_open') {
                // El navegador abre wa.me directamente desde el clic del usuario.
                // Este POST solo registra la preparación y NO redirige a WhatsApp.
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

                http_response_code(204);
                exit;
            }

            // Fallback para navegadores sin JavaScript: conserva el flujo tradicional.
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

                header('Location: ' . $built['url'], true, 303);
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

                $success = 'Plantilla restaurada correctamente.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

/* --------------------------------------------------------------------------
 * Datos compactos para preparar mensajes e historial
 * -------------------------------------------------------------------------- */

$quotes = [];
$orders = [];
$promotions = [];
$logs = [];

try {
    $quotes = db()->query(
        "SELECT q.id, q.quote_number, q.issue_date, q.status, c.name AS customer_name
         FROM cp_quotes q
         LEFT JOIN cp_customers c ON c.id = q.customer_id
         ORDER BY q.id DESC LIMIT 25"
    )->fetchAll();
} catch (Throwable $e) {
    $quotes = [];
}

try {
    $orders = db()->query(
        "SELECT o.id, o.order_number, o.status, o.due_date, c.name AS customer_name
         FROM cp_orders o
         LEFT JOIN cp_customers c ON c.id = o.customer_id
         ORDER BY o.id DESC LIMIT 25"
    )->fetchAll();
} catch (Throwable $e) {
    $orders = [];
}

try {
    $promotions = promotion_active_list('whatsapp', 25);
} catch (Throwable $e) {
    $promotions = [];
}

try {
    $logs = db()->query(
        "SELECT l.*, u.name AS user_name, o.order_number, q.quote_number
         FROM cp_whatsapp_log l
         LEFT JOIN cp_users u ON u.id = l.prepared_by
         LEFT JOIN cp_orders o ON o.id = l.order_id
         LEFT JOIN cp_quotes q ON q.id = l.quote_id
         ORDER BY l.id DESC LIMIT 30"
    )->fetchAll();
} catch (Throwable $e) {
    $logs = [];
}

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
$serviceTemplates = array_values(array_filter(
    $templates,
    static fn(array $template): bool => (string)($template['category'] ?? '') === 'service'
));
$commercialTemplates = array_values(array_filter(
    $templates,
    static fn(array $template): bool => (string)($template['category'] ?? '') === 'commercial'
));

function wa_format_date(?string $value, string $format = 'd/m/Y H:i'): string
{
    if (!$value) return '';
    $timestamp = strtotime($value);
    return $timestamp ? date($format, $timestamp) : '';
}

function wa_source_url(string $source, int $id = 0, string $template = ''): string
{
    $query = ['source' => $source];
    if ($id > 0) $query['id'] = $id;
    if ($template !== '') $query['template'] = $template;
    return '/admin/whatsapp.php?' . http_build_query($query);
}

function wa_record_label(string $sourceType, array $record): string
{
    if ($sourceType === 'quote') {
        return trim((string)($record['quote_number'] ?? '') . ' · ' . (string)($record['customer_name'] ?? 'Sin cliente'));
    }
    if ($sourceType === 'order') {
        return trim((string)($record['order_number'] ?? '') . ' · ' . (string)($record['customer_name'] ?? 'Sin cliente'));
    }
    return trim((string)($record['title'] ?? '') . ' · ' . (string)($record['label'] ?? ''));
}

require __DIR__ . '/../includes/header.php';
?>

<link rel="stylesheet" href="/assets/css/admin-whatsapp-v5.css?v=20260927">

<div class="wa4">
    <div class="wa4-toolbar no-print">
        <div>
            <span class="eyebrow">CENTRO DE COMUNICACIONES</span>
            <h2>WhatsApp</h2>
            <p class="muted">Prepara un mensaje, revisa el contenido y abre WhatsApp. Sin bandeja, sin ventanas emergentes y sin API de mensajes.</p>
        </div>
        <div class="wa4-actions">
            <button class="wa4-btn" type="button" data-dialog-open="waHistory">🕘 Historial <span class="wa4-count"><?= count($logs) ?></span></button>
            <button class="wa4-btn" type="button" data-dialog-open="waTemplates">⚙ Plantillas</button>
        </div>
    </div>

    <div class="wa4-status no-print"><span class="wa4-dot"></span> WhatsApp listo para abrir desde este equipo</div>

    <?php if ($error): ?>
        <div class="notice danger no-print"><?= e($error) ?></div>
    <?php endif; ?>

    <?php if ($success): ?>
        <div class="notice no-print"><span class="ok">✓</span> <?= e($success) ?></div>
    <?php endif; ?>

    <div class="wa4-layout">
        <section class="wa4-card no-print">
            <div class="wa4-card-head">
                <div>
                    <span class="wa4-step">PASO 1 · CONTEXTO</span>
                    <h3>¿Qué quieres comunicar?</h3>
                </div>
            </div>
            <div class="wa4-card-body">
                <div class="wa4-field">
                    <label for="waSourceType">Tipo de comunicación</label>
                    <select id="waSourceType">
                        <option value="quote" <?= $sourceType === 'quote' ? 'selected' : '' ?>>🧾 Cotización</option>
                        <option value="order" <?= $sourceType === 'order' ? 'selected' : '' ?>>🛠️ Orden</option>
                        <option value="promotion" <?= $sourceType === 'promotion' ? 'selected' : '' ?>>🏷️ Promoción</option>
                    </select>
                    <div class="wa4-helper">Selecciona el origen. Después elige el registro y la plantilla.</div>
                </div>

                <div class="wa4-field">
                    <label for="waRecord">Registro</label>
                    <select id="waRecord">
                        <option value="">Seleccionar <?= $sourceType === 'quote' ? 'cotización' : ($sourceType === 'order' ? 'orden' : 'promoción') ?>…</option>
                        <?php if ($sourceType === 'quote'): ?>
                            <?php foreach ($quotes as $record): ?>
                                <option value="<?= (int)$record['id'] ?>" data-template="quote_sent" <?= $sourceId === (int)$record['id'] ? 'selected' : '' ?>>
                                    <?= e(wa_record_label('quote', $record)) ?> · <?= e(wa_format_date((string)$record['issue_date'], 'd/m/Y')) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php elseif ($sourceType === 'order'): ?>
                            <?php foreach ($orders as $record): ?>
                                <option value="<?= (int)$record['id'] ?>" data-template="<?= e(whatsapp_stage_template_key((string)$record['status'])) ?>" <?= $sourceId === (int)$record['id'] ? 'selected' : '' ?>>
                                    <?= e(wa_record_label('order', $record)) ?> · <?= e((string)$record['status']) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <?php foreach ($promotions as $record): ?>
                                <option value="<?= (int)$record['id'] ?>" data-template="promotion_offer" <?= $sourceId === (int)$record['id'] ? 'selected' : '' ?>>
                                    <?= e(wa_record_label('promotion', $record)) ?>
                                </option>
                            <?php endforeach; ?>
                        <?php endif; ?>
                    </select>
                    <?php if (($sourceType === 'quote' && !$quotes) || ($sourceType === 'order' && !$orders) || ($sourceType === 'promotion' && !$promotions)): ?>
                        <div class="wa4-helper">No hay registros disponibles para este tipo.</div>
                    <?php endif; ?>
                </div>

                <div class="wa4-field">
                    <label for="waTemplate">Plantilla</label>
                    <select id="waTemplate" <?= $sourceId > 0 ? '' : 'disabled' ?>>
                        <option value="">Seleccionar plantilla…</option>
                        <?php $templateList = $sourceType === 'promotion' ? $commercialTemplates : $serviceTemplates; ?>
                        <?php foreach ($templateList as $template): ?>
                            <option value="<?= e((string)$template['template_key']) ?>" <?= $templateKey === $template['template_key'] ? 'selected' : '' ?>>
                                <?= e((string)$template['name']) ?><?= !$template['active'] ? ' · Inactiva' : '' ?>
                            </option>
                        <?php endforeach; ?>
                    </select>
                    <div class="wa4-helper">¿Necesitas modificar una plantilla? Usa <button type="button" class="wa4-btn" class="wa4-btn wa4-btn--compact" data-dialog-open="waTemplates">⚙ Plantillas</button>.</div>
                </div>
            </div>
        </section>

        <section class="wa4-card">
            <div class="wa4-card-head">
                <div>
                    <span class="wa4-step">PASO 2 · REVISAR Y ABRIR</span>
                    <h3>Mensaje listo para WhatsApp</h3>
                </div>
                <?php if ($built): ?>
                    <span class="count-pill"><?= e($built['template']['category'] === 'commercial' ? 'COMERCIAL' : 'SERVICIO') ?></span>
                <?php endif; ?>
            </div>
            <div class="wa4-card-body">
                <?php if (!$built): ?>
                    <div class="wa4-empty">
                        <div class="wa4-empty-icon">💬</div>
                        <strong>Selecciona un registro</strong>
                        <p>El mensaje se construirá automáticamente y podrás revisarlo antes de abrir WhatsApp.</p>
                    </div>
                <?php else: ?>
                    <div class="wa4-meta">
                        <div class="wa4-meta-item"><span>Origen</span><strong><?= e((string)$built['source']['label']) ?></strong></div>
                        <div class="wa4-meta-item"><span>Plantilla</span><strong><?= e((string)$built['template']['name']) ?></strong></div>
                        <div class="wa4-meta-item"><span>Destino</span><strong><?= e((string)($built['source']['phone'] ?? '') ?: 'Sin teléfono') ?></strong></div>
                    </div>

                    <?php if ($sourceType === 'quote'): ?>
                        <div class="wa4-note">📄 El mensaje incluye automáticamente el enlace público del PDF de la cotización.</div>
                    <?php endif; ?>

                    <div class="wa4-preview-wrap">
                        <textarea class="wa4-preview" readonly><?= e((string)$built['message']) ?></textarea>
                    </div>

                    <div class="wa4-send" data-wa-open-wrap>
                        <button
                            type="button"
                            class="wa4-btn primary"
                            data-copy-message
                            data-copy-text="<?= e((string)$built['message']) ?>"
                            aria-label="Copiar mensaje"
                        >📋 Copiar mensaje</button>
                        <a
                            class="wa4-btn green"
                            href="<?= e((string)$built['url']) ?>"
                            data-wa-open-link
                            data-wa-log-url="/admin/whatsapp.php"
                            data-wa-csrf="<?= e(csrf_token()) ?>"
                            data-wa-source="<?= e($sourceType) ?>"
                            data-wa-id="<?= $sourceId ?>"
                            data-wa-template="<?= e($templateKey) ?>"
                            aria-label="Abrir WhatsApp"
                        >💬 Abrir WhatsApp</a>
                        <a class="wa4-btn" href="<?= e(wa_source_url($sourceType)) ?>">Limpiar</a>
                    </div>
                    <div class="wa4-mobile-note">En móvil puedes copiar el mensaje y pegarlo directamente en WhatsApp. Si el botón de WhatsApp funciona, también puedes abrir el chat con el mensaje preparado.</div>
                <?php endif; ?>
            </div>
        </section>
    </div>

    <section class="wa4-card no-print">
        <div class="wa4-summary">
            <div class="wa4-summary-text">
                <strong>Herramientas del Centro</strong>
                <span>Elige una herramienta solo cuando la necesites. La pantalla principal permanece limpia.</span>
            </div>
            <div class="wa4-tools">
                <button class="wa4-btn" type="button" data-dialog-open="waHistory">🕘 Ver historial</button>
                <button class="wa4-btn" type="button" data-dialog-open="waTemplates">⚙ Administrar plantillas</button>
            </div>
        </div>
    </section>
</div>

<!-- -----------------------------------------------------------------------
     MODAL: HISTORIAL
     ----------------------------------------------------------------------- -->
<dialog class="wa4-dialog" id="waHistory">
    <div class="wa4-dialog-head">
        <div><span class="eyebrow">REGISTRO</span><h3>Historial de comunicaciones preparadas</h3></div>
        <button class="wa4-close" type="button" data-dialog-close aria-label="Cerrar">×</button>
    </div>
    <div class="wa4-dialog-body">
        <?php if (!$logs): ?>
            <div class="wa4-empty"><strong>Aún no hay comunicaciones preparadas.</strong><p>Cuando abras un mensaje desde este centro aparecerá aquí.</p></div>
        <?php else: ?>
            <div class="wa4-log-wrap">
                <table class="wa4-log-table">
                    <thead><tr><th>Fecha</th><th>Tipo</th><th>Origen</th><th>Teléfono</th><th>Usuario</th></tr></thead>
                    <tbody>
                    <?php foreach ($logs as $log): ?>
                        <tr>
                            <td><?= e(wa_format_date((string)$log['created_at'])) ?></td>
                            <td><?= e((string)$log['template_key']) ?></td>
                            <td><?= e(trim((string)($log['order_number'] ?? '') . ' ' . (string)($log['quote_number'] ?? '')) ?: '—') ?></td>
                            <td><?= e((string)($log['phone'] ?? '')) ?: '—' ?></td>
                            <td><?= e($log['user_name'] ?? 'Sistema') ?></td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </div>
</dialog>

<!-- -----------------------------------------------------------------------
     MODAL: PLANTILLAS
     ----------------------------------------------------------------------- -->
<dialog class="wa4-dialog" id="waTemplates">
    <div class="wa4-dialog-head">
        <div><span class="eyebrow">CONFIGURACIÓN</span><h3>Plantillas de WhatsApp</h3></div>
        <button class="wa4-close" type="button" data-dialog-close aria-label="Cerrar">×</button>
    </div>
    <div class="wa4-dialog-body">
        <p class="muted wa4-dialog-note">Modifica aquí los mensajes reutilizables. Los cambios se aplican al selector de plantillas del Centro.</p>
        <div class="wa4-template-grid">
            <?php foreach ($templates as $template): ?>
                <form class="wa4-template-card" method="post">
                    <input type="hidden" name="_csrf" value="<?= e(csrf_token()) ?>">
                    <input type="hidden" name="action" value="save_template">
                    <input type="hidden" name="template_key" value="<?= e((string)$template['template_key']) ?>">
                    <div class="wa4-template-top">
                        <div>
                            <span class="wa4-step"><?= e($template['category'] === 'commercial' ? 'COMERCIAL' : 'SERVICIO') ?></span>
                            <h4><?= e((string)$template['name']) ?></h4>
                        </div>
                        <label class="wa4-active"><input type="checkbox" name="active" <?= $template['active'] ? 'checked' : '' ?>> Activa</label>
                    </div>
                    <textarea name="body" required><?= e((string)$template['body']) ?></textarea>
                    <div class="wa4-template-actions">
                        <button class="wa4-btn" type="submit" name="action" value="reset_template">Restaurar</button>
                        <button class="wa4-btn primary" type="submit">Guardar</button>
                    </div>
                </form>
            <?php endforeach; ?>
        </div>
    </div>
</dialog>

<script>
(function(){
    'use strict';

    const sourceType = document.getElementById('waSourceType');
    const record = document.getElementById('waRecord');
    const template = document.getElementById('waTemplate');

    function goToSelection(){
        const source = sourceType.value;
        const id = record.value;
        const key = template.value || (record.selectedOptions[0]?.dataset.template || '');
        const params = new URLSearchParams({source});
        if (id) params.set('id', id);
        if (key) params.set('template', key);
        window.location.href = '/admin/whatsapp.php?' + params.toString();
    }

    sourceType?.addEventListener('change', () => {
        window.location.href = '/admin/whatsapp.php?source=' + encodeURIComponent(sourceType.value);
    });

    record?.addEventListener('change', () => {
        if (!record.value) return;
        const autoTemplate = record.selectedOptions[0]?.dataset.template || '';
        if (template) {
            template.disabled = false;
            if (autoTemplate) template.value = autoTemplate;
        }
        goToSelection();
    });

    template?.addEventListener('change', () => {
        if (!record.value) return;
        goToSelection();
    });

    document.querySelectorAll('[data-copy-message]').forEach(button => {
        button.addEventListener('click', async () => {
            const text = button.dataset.copyText || '';
            if (!text) return;

            const original = button.textContent;
            try {
                if (navigator.clipboard && window.isSecureContext) {
                    await navigator.clipboard.writeText(text);
                } else {
                    const helper = document.createElement('textarea');
                    helper.value = text;
                    helper.setAttribute('readonly', '');
                    helper.style.position = 'fixed';
                    helper.style.opacity = '0';
                    document.body.appendChild(helper);
                    helper.focus();
                    helper.select();
                    helper.setSelectionRange(0, helper.value.length);
                    const copied = document.execCommand('copy');
                    helper.remove();
                    if (!copied) throw new Error('copy-failed');
                }

                button.textContent = '✓ Mensaje copiado';
                button.classList.add('is-copied');
                window.setTimeout(() => {
                    button.textContent = original;
                    button.classList.remove('is-copied');
                }, 1800);
            } catch (_) {
                button.textContent = '⚠ Selecciona y copia';
                window.setTimeout(() => { button.textContent = original; }, 2200);
            }
        });
    });

    document.querySelectorAll('[data-wa-open-link]').forEach(link => {
        link.addEventListener('click', () => {
            const payload = new URLSearchParams({
                _csrf: link.dataset.waCsrf || '',
                action: 'log_whatsapp_open',
                source: link.dataset.waSource || '',
                id: link.dataset.waId || '0',
                template_key: link.dataset.waTemplate || ''
            });

            // Registra la preparación sin bloquear la navegación.
            try {
                if (navigator.sendBeacon) {
                    navigator.sendBeacon(link.dataset.waLogUrl || '/admin/whatsapp.php', payload);
                }
            } catch (_) {}

            /*
             * Android: Chrome puede tratar wa.me como una navegación web y no
             * entregar siempre el enlace a la aplicación instalada.
             *
             * Usamos un Android Intent como primera vía, manteniendo wa.me como
             * fallback. No abrimos ventanas, no mostramos popups y no pedimos
             * confirmación desde nuestro sitio. El gesto sigue siendo el clic
             * directo del usuario.
             */
            const ua = navigator.userAgent || '';
            const isAndroid = /Android/i.test(ua);
            const target = link.getAttribute('href') || '';

            if (isAndroid && /^https:\/\/wa\.me\//i.test(target)) {
                try {
                    const url = new URL(target);
                    const path = url.pathname.replace(/^\//, '');
                    const query = url.search ? url.search.slice(1) : '';
                    const intentTarget = 'intent://send/' + path +
                        (query ? '?' + query : '') +
                        '#Intent;scheme=whatsapp;action=android.intent.action.VIEW;' +
                        'S.browser_fallback_url=' + encodeURIComponent(target) +
                        ';end';
                    link.setAttribute('href', intentTarget);
                } catch (_) {}
            }

            link.setAttribute('aria-busy', 'true');
            link.classList.add('is-opening');
            link.textContent = '💬 Abriendo WhatsApp…';
            // No preventDefault(): Android/Chrome procesa el enlace desde el clic.
        });
    });

    document.querySelectorAll('[data-dialog-open]').forEach(button => {
        button.addEventListener('click', () => {
            const dialog = document.getElementById(button.dataset.dialogOpen);
            if (dialog?.showModal) dialog.showModal();
        });
    });

    document.querySelectorAll('[data-dialog-close]').forEach(button => {
        button.addEventListener('click', () => button.closest('dialog')?.close());
    });

    document.querySelectorAll('dialog.wa4-dialog').forEach(dialog => {
        dialog.addEventListener('click', event => {
            if (event.target === dialog) dialog.close();
        });
    });
})();
</script>

<?php require __DIR__ . '/../includes/footer.php'; ?>
