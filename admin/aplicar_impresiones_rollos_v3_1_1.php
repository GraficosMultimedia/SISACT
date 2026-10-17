<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Impresiones · Hotfix V3.1.1';

$root = dirname(__DIR__);
$adminPath = $root . '/admin/impresiones.php';
$apiPath = $root . '/api/registrar_impresion.php';

$error = null;
$messages = [];
$warnings = [];

function v311_column_exists(string $table, string $column): bool
{
    $st = db()->prepare(
        'SELECT COUNT(*)
         FROM information_schema.columns
         WHERE table_schema=DATABASE()
           AND table_name=?
           AND column_name=?'
    );
    $st->execute([$table, $column]);

    return (int)$st->fetchColumn() > 0;
}

function v311_table_exists(string $table): bool
{
    $st = db()->prepare(
        'SELECT COUNT(*)
         FROM information_schema.tables
         WHERE table_schema=DATABASE()
           AND table_name=?'
    );
    $st->execute([$table]);

    return (int)$st->fetchColumn() > 0;
}

function v311_migrate(): void
{
    if (!v311_column_exists('cp_print_rolls', 'is_archived')) {
        db()->exec(
            "ALTER TABLE cp_print_rolls
             ADD COLUMN is_archived TINYINT(1) NOT NULL DEFAULT 0 AFTER status"
        );
    }

    if (!v311_table_exists('cp_print_roll_adjustments')) {
        db()->exec(
            "CREATE TABLE cp_print_roll_adjustments (
                id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                roll_id BIGINT UNSIGNED NULL,
                action_name VARCHAR(30) NOT NULL,
                before_json LONGTEXT NULL,
                after_json LONGTEXT NULL,
                note VARCHAR(255) NULL,
                created_by BIGINT UNSIGNED NULL,
                created_at DATETIME NOT NULL,
                PRIMARY KEY (id),
                KEY idx_print_roll_adjustments_roll (roll_id),
                KEY idx_print_roll_adjustments_created (created_at)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }
}

function v311_backup(string $path): void
{
    if (!is_file($path)) {
        return;
    }

    $backup = $path . '.bak_rollos_v3_1_1';

    if (!is_file($backup)) {
        @copy($path, $backup);
    }
}

function v311_write(string $path, string $content): void
{
    $tmp = $path . '.v311.tmp';

    if (file_put_contents($tmp, $content, LOCK_EX) === false) {
        throw new RuntimeException(
            'No se pudo escribir ' . basename($path) . '.'
        );
    }

    $perms = @fileperms($path);

    if ($perms !== false) {
        @chmod($tmp, $perms & 0777);
    }

    if (!rename($tmp, $path)) {
        @unlink($tmp);

        throw new RuntimeException(
            'No se pudo reemplazar ' . basename($path) . '.'
        );
    }

    if (function_exists('opcache_invalidate')) {
        @opcache_invalidate($path, true);
    }
}

function v311_patch_admin(string $src, array &$warnings): string
{
    /*
     * No tocamos create_roll ni las funciones V3 de cálculo.
     * Ese fue el punto que falló en V3.1.
     */
    if (!str_contains($src, 'impresiones_rollos_v3_1_1.php')) {
        $needles = [
            "require_once __DIR__ . '/../includes/impresiones_v3.php';",
            "require_once __DIR__ . '/../includes/impresiones.php';",
        ];

        $inserted = false;

        foreach ($needles as $needle) {
            if (str_contains($src, $needle)) {
                $src = str_replace(
                    $needle,
                    $needle . "\n"
                    . "require_once __DIR__ . '/../includes/impresiones_rollos_v3_1_1.php';",
                    $src
                );

                $inserted = true;
                break;
            }
        }

        if (!$inserted) {
            $warnings[] =
                'No se pudo insertar automáticamente el include CRUD en impresiones.php.';
        }
    }

    /*
     * Rollos visibles/seleccionables.
     */
    $rollCalls = [
        '$rolls = print_meter_v3_active_rolls();',
        '$rolls = print_meter_active_rolls();',
    ];

    foreach ($rollCalls as $call) {
        if (str_contains($src, $call)) {
            $src = str_replace(
                $call,
                '$rolls = print_roll_v311_selectable_rolls();',
                $src
            );
            break;
        }
    }

    $activeCalls = [
        '$activeRoll = print_meter_active_roll();',
    ];

    foreach ($activeCalls as $call) {
        if (str_contains($src, $call)) {
            $src = str_replace(
                $call,
                '$activeRoll = print_roll_v311_active_roll();',
                $src
            );
            break;
        }
    }

    $usageCalls = [
        '$usageBreakdown = print_meter_usage_breakdown();',
    ];

    foreach ($usageCalls as $call) {
        if (str_contains($src, $call)) {
            $src = str_replace(
                $call,
                '$usageBreakdown = print_roll_v311_usage_breakdown();',
                $src
            );
            break;
        }
    }

    /*
     * Botón hacia la administración de rollos.
     * Si no encontramos el botón actual, la página sigue accesible directamente.
     */
    if (!str_contains($src, '/admin/impresiones_rollos.php')) {
        $button =
            '<button type="button" class="btn btn-primary capture-open-btn" id="openPrintCapture">＋ Registrar impresión</button>';

        if (str_contains($src, $button)) {
            $src = str_replace(
                $button,
                '<div style="display:flex;gap:10px;flex-wrap:wrap">'
                . $button
                . '<a class="btn btn-secondary" href="/admin/impresiones_rollos.php">Administrar rollos</a>'
                . '</div>',
                $src
            );
        } else {
            $warnings[] =
                'No se agregó el botón Administrar rollos automáticamente. '
                . 'Puedes abrir /admin/impresiones_rollos.php directamente.';
        }
    }

    return $src;
}

function v311_patch_api(string $src, array &$warnings): string
{
    if (!str_contains($src, 'impresiones_rollos_v3_1_1.php')) {
        $needles = [
            "require_once __DIR__.'/../includes/impresiones_v3.php';",
            "require_once __DIR__.'/../includes/impresiones.php';",
        ];

        $inserted = false;

        foreach ($needles as $needle) {
            if (str_contains($src, $needle)) {
                $src = str_replace(
                    $needle,
                    $needle . "\n"
                    . "require_once __DIR__.'/../includes/impresiones_rollos_v3_1_1.php';",
                    $src
                );

                $inserted = true;
                break;
            }
        }

        if (!$inserted) {
            $warnings[] =
                'No se pudo insertar automáticamente el include CRUD en registrar_impresion.php.';
        }
    }

    if (!str_contains($src, 'print_roll_v311_assert_selectable')) {
        $markers = [
            '$payload=print_meter_v3_normalize($_POST);',
            '$payload=print_meter_normalize($_POST);',
        ];

        $inserted = false;

        foreach ($markers as $marker) {
            if (str_contains($src, $marker)) {
                $src = str_replace(
                    $marker,
                    $marker . "\n"
                    . "    print_roll_v311_assert_selectable((int)(\$payload['roll_id'] ?? 0));",
                    $src
                );

                $inserted = true;
                break;
            }
        }

        if (!$inserted) {
            $warnings[] =
                'No se pudo agregar automáticamente la validación de rollo archivado en la API.';
        }
    }

    return $src;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action = (string)($_POST['action'] ?? '');

            if ($action === 'install') {
                /*
                 * Esta vez la migración se ejecuta PRIMERO.
                 * No depende de encontrar la llamada create_roll.
                 */
                v311_migrate();

                $messages[] = 'Columna is_archived lista.';
                $messages[] = 'Tabla de auditoría lista.';

                if (is_file($adminPath)) {
                    $adminCurrent = (string)file_get_contents($adminPath);
                    $adminNew = v311_patch_admin($adminCurrent, $warnings);

                    v311_backup($adminPath);

                    if ($adminNew !== $adminCurrent) {
                        v311_write($adminPath, $adminNew);
                        $messages[] = 'Control de metraje enlazado con Administración de rollos.';
                    }
                }

                if (is_file($apiPath)) {
                    $apiCurrent = (string)file_get_contents($apiPath);
                    $apiNew = v311_patch_api($apiCurrent, $warnings);

                    v311_backup($apiPath);

                    if ($apiNew !== $apiCurrent) {
                        v311_write($apiPath, $apiNew);
                        $messages[] = 'API protegida contra rollos archivados.';
                    }
                }

                $messages[] =
                    'Hotfix V3.1.1 instalado. No se modificó la llamada create_roll V3 que ya funciona.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$status = [
    'archived' => v311_column_exists('cp_print_rolls', 'is_archived'),
    'audit' => v311_table_exists('cp_print_roll_adjustments'),
    'page' => is_file($root . '/admin/impresiones_rollos.php'),
    'helper' => is_file($root . '/includes/impresiones_rollos_v3_1_1.php'),
];

require __DIR__ . '/../includes/header.php';
?>
<style>
.v311{max-width:980px;margin:20px auto}
.v311-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin:18px 0}
.v311-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:11px}
.v311-stat small{display:block;color:var(--muted)}
.v311-stat strong{display:block;margin-top:5px}
.v311-ok{color:#67e7be}
@media(max-width:760px){.v311-grid{grid-template-columns:1fr 1fr}}
</style>

<div class="v311">
  <div class="card" style="padding:22px">
    <span class="eyebrow">IMPRESIONES · HOTFIX</span>
    <h2>Rollos CRUD V3.1.1</h2>

    <p class="muted">
      Completa únicamente la administración de rollos. No vuelve a parchear la creación de rollos ni el Wizard V3 que ya está funcionando.
    </p>

    <?php if ($error): ?>
      <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
      <div class="notice"><span class="ok">✓</span> <?=e($message)?></div>
    <?php endforeach; ?>

    <?php foreach ($warnings as $warning): ?>
      <div class="notice danger"><?=e($warning)?></div>
    <?php endforeach; ?>

    <div class="v311-grid">
      <div class="v311-stat">
        <small>Archivado</small>
        <strong class="<?=$status['archived']?'v311-ok':''?>">
          <?=$status['archived']?'✓ listo':'pendiente'?>
        </strong>
      </div>

      <div class="v311-stat">
        <small>Auditoría</small>
        <strong class="<?=$status['audit']?'v311-ok':''?>">
          <?=$status['audit']?'✓ listo':'pendiente'?>
        </strong>
      </div>

      <div class="v311-stat">
        <small>Página Rollos</small>
        <strong class="<?=$status['page']?'v311-ok':''?>">
          <?=$status['page']?'✓ lista':'faltante'?>
        </strong>
      </div>

      <div class="v311-stat">
        <small>Helper CRUD</small>
        <strong class="<?=$status['helper']?'v311-ok':''?>">
          <?=$status['helper']?'✓ listo':'faltante'?>
        </strong>
      </div>
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">

      <button
        class="btn btn-primary"
        type="submit"
        name="action"
        value="install"
      >
        Aplicar Hotfix V3.1.1
      </button>

      <a
        class="btn btn-secondary"
        href="/admin/impresiones_rollos.php"
      >
        Administrar rollos
      </a>

      <a
        class="btn btn-secondary"
        href="/admin/impresiones.php"
      >
        Control de metraje
      </a>
    </form>
  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
