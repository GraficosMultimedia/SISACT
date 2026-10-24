<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/tracking_activity.php';
require_auth();

$title = 'Tracking Activity · Corrección V2';

$root = dirname(__DIR__);
$trackingPath = $root . '/includes/tracking_activity.php';
$dashboardPath = $root . '/admin/dashboard.php';

$messages = [];
$error = null;

function tav2_atomic_write(string $path, string $content): void
{
    $tmp = $path . '.tracking-v2.tmp';

    if (file_put_contents($tmp, $content, LOCK_EX) === false) {
        throw new RuntimeException('No se pudo escribir ' . basename($path));
    }

    $perms = @fileperms($path);
    if ($perms !== false) @chmod($tmp, $perms & 0777);

    if (!rename($tmp, $path)) {
        @unlink($tmp);
        throw new RuntimeException('No se pudo reemplazar ' . basename($path));
    }
}

function tav2_table_exists(string $table): bool
{
    try {
        $st = db()->prepare(
            'SELECT COUNT(*) FROM information_schema.tables
             WHERE table_schema = DATABASE() AND table_name = ?'
        );
        $st->execute([$table]);
        return (int)$st->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function tav2_ensure_tables(): array
{
    $created = [];

    if (!tav2_table_exists('cp_tracking_events')) {
        db()->exec(
            "CREATE TABLE IF NOT EXISTS cp_tracking_events (
                id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                order_id INT NOT NULL,
                customer_id INT NULL,
                event_type VARCHAR(40) NOT NULL,
                document_id INT NULL,
                invoice_id INT NULL,
                receipt_id INT NULL,
                visitor_hash CHAR(64) NULL,
                device_type VARCHAR(20) NULL,
                created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (id),
                KEY idx_tracking_events_order_created (order_id, created_at),
                KEY idx_tracking_events_customer_created (customer_id, created_at),
                KEY idx_tracking_events_type_created (event_type, created_at),
                KEY idx_tracking_events_created_id (created_at, id),
                KEY idx_tracking_events_document (document_id),
                KEY idx_tracking_events_invoice (invoice_id),
                KEY idx_tracking_events_receipt (receipt_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
        $created[] = 'cp_tracking_events';
    }

    if (!tav2_table_exists('cp_tracking_event_reads')) {
        db()->exec(
            "CREATE TABLE IF NOT EXISTS cp_tracking_event_reads (
                user_id INT NOT NULL,
                last_event_id BIGINT UNSIGNED NOT NULL DEFAULT 0,
                updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (user_id),
                KEY idx_tracking_event_reads_last (last_event_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
        $created[] = 'cp_tracking_event_reads';
    }

    return $created;
}

function tav2_patch_tracking(string $src): string
{
    if (str_contains($src, 'SISACT_TRACKING_ACTIVITY_V2_WHATSAPP')) {
        return $src;
    }

    $needle = "        'whatsapp', 'skypeuripreview',";
    if (!str_contains($src, $needle)) {
        throw new RuntimeException(
            "tracking_activity.php: no se encontró el filtro actual de WhatsApp. " .
            "No se modificó el archivo."
        );
    }

    /*
     * WhatsApp se elimina del bloqueo genérico de UA.
     * Los previews conocidos siguen bloqueados por purpose/prefetch y los bots
     * explícitos. Esto permite registrar navegaciones humanas dentro del
     * navegador integrado de WhatsApp.
     */
    $replacement = "        /* SISACT_TRACKING_ACTIVITY_V2_WHATSAPP\n" .
                   "         * No bloquear WhatsApp de forma genérica: el navegador integrado\n" .
                   "         * puede usar ese texto en el User-Agent de una visita humana.\n" .
                   "         */\n" .
                   "        'skypeuripreview',";

    return str_replace($needle, $replacement, $src);
}

function tav2_patch_dashboard(string $src): string
{
    if (str_contains($src, 'dashboard-intelligence.js?v=1.1.0')) {
        return $src;
    }

    $old = 'dashboard-intelligence.js?v=1.0.0';
    if (!str_contains($src, $old)) {
        throw new RuntimeException(
            'dashboard.php: no se encontró la versión 1.0.0 del JavaScript.'
        );
    }

    return str_replace(
        $old,
        'dashboard-intelligence.js?v=1.1.0',
        $src
    );
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        $action = (string)($_POST['action'] ?? '');

        try {
            if ($action === 'install') {
                if (!is_file($trackingPath) || !is_file($dashboardPath)) {
                    throw new RuntimeException('Falta tracking_activity.php o dashboard.php.');
                }

                $tracking = file_get_contents($trackingPath);
                $dashboard = file_get_contents($dashboardPath);

                if ($tracking === false || $dashboard === false) {
                    throw new RuntimeException('No se pudieron leer los archivos actuales.');
                }

                // Se construyen ambos cambios antes de escribir.
                $trackingNew = tav2_patch_tracking($tracking);
                $dashboardNew = tav2_patch_dashboard($dashboard);

                $trackingBackup = $trackingPath . '.bak_tracking_notificaciones_v2';
                $dashboardBackup = $dashboardPath . '.bak_tracking_notificaciones_v2';

                if (!is_file($trackingBackup) && !copy($trackingPath, $trackingBackup)) {
                    throw new RuntimeException('No se pudo respaldar tracking_activity.php.');
                }
                if (!is_file($dashboardBackup) && !copy($dashboardPath, $dashboardBackup)) {
                    throw new RuntimeException('No se pudo respaldar dashboard.php.');
                }

                tav2_atomic_write($trackingPath, $trackingNew);
                tav2_atomic_write($dashboardPath, $dashboardNew);

                $created = tav2_ensure_tables();

                $messages[] = 'Filtro de WhatsApp corregido.';
                $messages[] = 'Cache bust del Dashboard actualizado a v=1.1.0.';

                if ($created) {
                    $messages[] = 'Se crearon las tablas faltantes: ' . implode(', ', $created) . '.';
                } else {
                    $messages[] = 'Las tablas Tracking Activity ya estaban presentes.';
                }

                $messages[] = 'Abre el diagnóstico para verificar eventos reales.';
            }

            if ($action === 'revert') {
                $trackingBackup = $trackingPath . '.bak_tracking_notificaciones_v2';
                $dashboardBackup = $dashboardPath . '.bak_tracking_notificaciones_v2';

                if (!is_file($trackingBackup) || !is_file($dashboardBackup)) {
                    throw new RuntimeException('No existen ambos respaldos V2.');
                }

                if (!copy($trackingBackup, $trackingPath)) {
                    throw new RuntimeException('No se pudo restaurar tracking_activity.php.');
                }
                if (!copy($dashboardBackup, $dashboardPath)) {
                    throw new RuntimeException('No se pudo restaurar dashboard.php.');
                }

                $messages[] = 'Archivos restaurados desde respaldo V2.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$tablesReady =
    tav2_table_exists('cp_tracking_events') &&
    tav2_table_exists('cp_tracking_event_reads');

$trackingInstalled = false;
$dashboardInstalled = false;

if (is_file($trackingPath)) {
    $txt = @file_get_contents($trackingPath);
    $trackingInstalled = is_string($txt)
        && str_contains($txt, 'SISACT_TRACKING_ACTIVITY_V2_WHATSAPP');
}
if (is_file($dashboardPath)) {
    $txt = @file_get_contents($dashboardPath);
    $dashboardInstalled = is_string($txt)
        && str_contains($txt, 'dashboard-intelligence.js?v=1.1.0');
}

require __DIR__ . '/../includes/header.php';
?>
<div class="card" style="max-width:940px;margin:20px auto;padding:22px">
    <span class="eyebrow">TRACKING ACTIVITY</span>
    <h2>Corrección de notificaciones · V2</h2>

    <p class="muted">
        Corrige el bloqueo de visitas desde WhatsApp, renueva el JavaScript
        del Dashboard y verifica/crea las dos tablas de Tracking Activity.
    </p>

    <?php if ($error): ?>
        <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
        <div class="notice"><?=e($message)?></div>
    <?php endforeach; ?>

    <div style="display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:10px;margin:18px 0">
        <div class="card" style="padding:14px">
            <small class="muted">Filtro WhatsApp</small><br>
            <strong><?=$trackingInstalled?'✓ V2':'Pendiente'?></strong>
        </div>
        <div class="card" style="padding:14px">
            <small class="muted">JS Dashboard</small><br>
            <strong><?=$dashboardInstalled?'✓ v1.1.0':'Pendiente'?></strong>
        </div>
        <div class="card" style="padding:14px">
            <small class="muted">Tablas 021</small><br>
            <strong><?=$tablesReady?'✓ listas':'Faltantes'?></strong>
        </div>
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap">
        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
        <button class="btn btn-primary" type="submit" name="action" value="install">
            Aplicar corrección V2
        </button>

        <a class="btn btn-secondary" href="/admin/tracking_activity_diagnostico.php">
            Abrir diagnóstico
        </a>

        <button
            class="btn btn-secondary"
            type="submit"
            name="action"
            value="revert"
            onclick="return confirm('¿Restaurar los archivos anteriores?');"
        >
            Revertir V2
        </button>
    </form>

    <p class="muted" style="margin-top:18px">
        Después de validar el sistema, elimina
        <code>admin/aplicar_tracking_notificaciones_v2.php</code>.
    </p>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
