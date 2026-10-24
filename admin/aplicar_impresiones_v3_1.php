<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Impresiones · V3.1';

$root = dirname(__DIR__);
$adminPath = $root . '/admin/impresiones.php';
$apiPath = $root . '/api/registrar_impresion.php';

$error = null;
$messages = [];

function impv31_column_exists(string $table, string $column): bool
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

function impv31_add_column(
    string $table,
    string $column,
    string $definition
): void {
    if (impv31_column_exists($table, $column)) {
        return;
    }

    db()->exec(
        "ALTER TABLE `{$table}`
         ADD COLUMN `{$column}` {$definition}"
    );
}

function impv31_table_exists(string $table): bool
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

function impv31_migrate(): void
{
    impv31_add_column(
        'cp_print_rolls',
        'width_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `remaining_m`"
    );

    impv31_add_column(
        'cp_print_rolls',
        'cost_per_linear_m',
        "DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `width_m`"
    );

    impv31_add_column(
        'cp_print_rolls',
        'is_archived',
        "TINYINT(1) NOT NULL DEFAULT 0 AFTER `status`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'job_width_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `job_length_mm`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'job_length_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `job_width_m`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'area_m2',
        "DECIMAL(12,3) NOT NULL DEFAULT 0.000 AFTER `job_length_m`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'panels',
        "INT UNSIGNED NOT NULL DEFAULT 1 AFTER `area_m2`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'roll_width_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `panels`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'linear_m_before',
        "DECIMAL(12,3) NOT NULL DEFAULT 0.000 AFTER `roll_width_m`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'linear_m_after',
        "DECIMAL(12,3) NOT NULL DEFAULT 0.000 AFTER `linear_m`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'cost_per_linear_m',
        "DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `linear_m_after`"
    );

    impv31_add_column(
        'cp_print_meter_logs',
        'material_cost',
        "DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `cost_per_linear_m`"
    );

    if (!impv31_table_exists('cp_print_roll_adjustments')) {
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

function impv31_backup(string $path): void
{
    $backup = $path . '.bak_impresiones_v3_1';

    if (!is_file($backup) && !copy($path, $backup)) {
        throw new RuntimeException(
            'No se pudo respaldar ' . basename($path) . '.'
        );
    }
}

function impv31_atomic_write(string $path, string $content): void
{
    $tmp = $path . '.v31.tmp';

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

function impv31_regex_once(
    string $src,
    string $pattern,
    string $replacement,
    string $label
): string {
    $count = preg_match_all($pattern, $src);

    if ($count !== 1) {
        throw new RuntimeException(
            $label .
            ': se esperaba 1 coincidencia y se encontraron ' .
            $count .
            '. El archivo NO fue modificado.'
        );
    }

    $out = preg_replace($pattern, $replacement, $src, 1);

    if (!is_string($out)) {
        throw new RuntimeException(
            $label . ': no se pudo aplicar el cambio.'
        );
    }

    return $out;
}

function impv31_patch_admin(string $src): string
{
    /*
     * Si una instalación V3 previa dejó un include, se sustituye.
     */
    $src = str_replace(
        "require_once __DIR__ . '/../includes/impresiones_v3.php';\n",
        '',
        $src
    );

    if (!str_contains($src, "impresiones_v3_1.php")) {
        $src = impv31_regex_once(
            $src,
            "#require_once __DIR__ \\. '/\\.\\./includes/impresiones\\.php';#",
            "require_once __DIR__ . '/../includes/impresiones.php';\n"
            . "require_once __DIR__ . '/../includes/impresiones_v3_1.php';\n"
            . "// SISACT_IMPRESIONES_V3_1",
            'Include V3.1'
        );
    }

    if (!str_contains($src, "action === 'edit_roll'")) {
        $marker = "\$action = (string)(\$_POST['action'] ?? '');";

        if (!str_contains($src, $marker)) {
            throw new RuntimeException(
                'Acciones V3.1: no se encontró el marcador de POST.'
            );
        }

        $actions = <<<'PHP'

        if ($action === 'edit_roll') {
            $rollId = (int)($_POST['roll_id'] ?? 0);

            print_meter_v31_update_roll(
                $rollId,
                (string)($_POST['roll_name'] ?? ''),
                (float)($_POST['initial_m'] ?? 0),
                (float)($_POST['remaining_m'] ?? 0),
                (float)($_POST['width_m'] ?? 0),
                (float)($_POST['cost_per_linear_m'] ?? 0),
                (string)($_POST['adjustment_note'] ?? '')
            );

            log_activity(
                'update',
                'print_rolls',
                'Rollo actualizado #' . $rollId
            );

            redirect('/admin/impresiones.php?roll_updated=1');
        }

        if ($action === 'archive_roll') {
            $rollId = (int)($_POST['roll_id'] ?? 0);

            print_meter_v31_archive_roll(
                $rollId,
                (string)($_POST['adjustment_note'] ?? 'Archivado desde Control de metraje')
            );

            log_activity(
                'update',
                'print_rolls',
                'Rollo archivado #' . $rollId
            );

            redirect('/admin/impresiones.php?roll_archived=1');
        }

        if ($action === 'restore_roll') {
            $rollId = (int)($_POST['roll_id'] ?? 0);

            print_meter_v31_restore_roll(
                $rollId,
                (string)($_POST['adjustment_note'] ?? 'Restaurado desde Control de metraje')
            );

            log_activity(
                'update',
                'print_rolls',
                'Rollo restaurado #' . $rollId
            );

            redirect('/admin/impresiones.php?roll_restored=1');
        }

        if ($action === 'delete_roll') {
            $rollId = (int)($_POST['roll_id'] ?? 0);

            print_meter_v31_delete_roll(
                $rollId,
                (string)($_POST['adjustment_note'] ?? 'Eliminado desde Control de metraje')
            );

            log_activity(
                'delete',
                'print_rolls',
                'Rollo eliminado #' . $rollId
            );

            redirect('/admin/impresiones.php?roll_deleted=1');
        }
PHP;

        $src = str_replace(
            $marker,
            $marker . $actions,
            $src
        );
    }

    $src = preg_replace(
        "#\\$id\\s*=\\s*print_meter_(?:v3_)?create_roll\\s*\\(.*?\\);#s",
        "\$id = print_meter_v31_create_roll(\n"
        . "                (string)(\$_POST['roll_name'] ?? ''),\n"
        . "                (float)(\$_POST['initial_m'] ?? 0),\n"
        . "                (float)(\$_POST['width_m'] ?? 0),\n"
        . "                (float)(\$_POST['cost_per_linear_m'] ?? 0)\n"
        . "            );",
        $src,
        1,
        $createCount
    );

    if ($createCount !== 1) {
        throw new RuntimeException(
            'Crear rollo V3.1: no se pudo reemplazar la llamada actual.'
        );
    }

    $src = preg_replace(
        "#\\$payload\\s*=\\s*print_meter_(?:v3_)?normalize\\s*\\(\\$_POST\\);#",
        "\$payload = print_meter_v31_normalize(\$_POST);",
        $src,
        1,
        $normalizeCount
    );

    if ($normalizeCount !== 1) {
        throw new RuntimeException(
            'Normalización V3.1: no se encontró la llamada actual.'
        );
    }

    $src = preg_replace(
        "#\\$id\\s*=\\s*print_meter_(?:v3_)?register(?:_safe)?\\s*\\(\\$payload\\);#",
        "\$id = print_meter_v31_register_safe(\$payload);",
        $src,
        1,
        $registerCount
    );

    if ($registerCount !== 1) {
        throw new RuntimeException(
            'Registro V3.1: no se encontró la llamada actual.'
        );
    }

    $replacements = [
        '$rolls = print_meter_active_rolls();'
            => '$rolls = print_meter_v31_active_rolls();',
        '$rolls = print_meter_v3_active_rolls();'
            => '$rolls = print_meter_v31_active_rolls();',
        '$activeRoll = print_meter_active_roll();'
            => '$activeRoll = print_meter_v31_active_roll();',
        '$rows = print_meter_rows();'
            => '$rows = print_meter_v31_rows();',
        '$rows = print_meter_v3_rows();'
            => '$rows = print_meter_v31_rows();',
        '$usageBreakdown = print_meter_usage_breakdown();'
            => '$usageBreakdown = print_meter_v31_usage_breakdown();',
    ];

    foreach ($replacements as $old => $new) {
        if (str_contains($src, $old)) {
            $src = str_replace($old, $new, $src);
        }
    }

    if (!str_contains($src, '$rollManagement = [];')) {
        $src = str_replace(
            '$rollAnalytics = [];',
            "\$rollAnalytics = [];\n\$rollManagement = [];\n\$rollProfiles = [];",
            $src
        );
    }

    if (!str_contains($src, 'print_meter_v31_rolls_for_management')) {
        $src = str_replace(
            "\$rollAnalytics = \$usageBreakdown['rolls'];",
            "\$rollAnalytics = \$usageBreakdown['rolls'];\n"
            . "\$rollManagement = print_meter_v31_rolls_for_management();\n"
            . "\$rollProfiles = print_meter_v31_roll_profiles();",
            $src
        );
    }

    /*
     * Assets: acepta V2, V3 o una instalación parcial anterior.
     */
    $src = preg_replace(
        '#<link rel="stylesheet" href="/assets/css/impresiones-wizard-v[^"]+">#',
        '<link rel="stylesheet" href="/assets/css/impresiones-wizard-v3-1.css?v=20261017-2">',
        $src,
        1,
        $cssCount
    );

    if ($cssCount !== 1) {
        throw new RuntimeException(
            'CSS V3.1: no se encontró la referencia del wizard actual.'
        );
    }

    $src = preg_replace(
        '#<script src="/assets/js/impresiones-wizard-v[^"]+" defer></script>#',
        '<script src="/assets/js/impresiones-wizard-v3-1.js?v=20261017-2" defer></script>',
        $src,
        1,
        $jsCount
    );

    if ($jsCount !== 1) {
        throw new RuntimeException(
            'JS V3.1: no se encontró la referencia del wizard actual.'
        );
    }

    if (!str_contains($src, 'SISACT_PRINT_ROLLS')) {
        $assetMarker =
            '<script src="/assets/js/impresiones-wizard-v3-1.js?v=20261017-2" defer></script>';

        $src = str_replace(
            $assetMarker,
            $assetMarker . "\n"
            . "<script>window.SISACT_PRINT_ROLLS=<?=json_encode(\$rollProfiles,JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES)?>;</script>",
            $src
        );
    }

    $src = str_replace(
        'Solo registra los metros lineales consumidos por cada trabajo y descuéntalos del rollo utilizado.',
        'Registra medidas, metros lineales, saldo, costos y administra cada rollo desde el mismo módulo.',
        $src
    );

    /*
     * Formulario de alta de rollo.
     */
    $rollFormPattern =
        '#<form method="post" class="meter-roll-form(?: meter-roll-form-v3)?">.*?'
        . '<input type="hidden" name="action" value="create_roll">.*?</form>#s';

    $rollForm = <<<'HTML'
<form method="post" class="meter-roll-form meter-roll-form-v3">
  <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
  <input type="hidden" name="action" value="create_roll">

  <div class="field">
    <label>Nuevo rollo</label>
    <input name="roll_name" placeholder="Ej. Lona Pro Max 50.4 · #3" required>
  </div>

  <div class="field">
    <label>Metros iniciales</label>
    <input type="number" step="0.001" min="0.001" name="initial_m" placeholder="50.000" required>
  </div>

  <div class="field">
    <label>Ancho útil (m)</label>
    <input type="number" step="0.001" min="0.001" name="width_m" placeholder="1.520" required>
  </div>

  <div class="field">
    <label>Costo / metro</label>
    <input type="number" step="0.01" min="0" name="cost_per_linear_m" placeholder="45.00" required>
  </div>

  <button class="btn btn-primary" type="submit">+ Abrir rollo</button>
</form>
HTML;

    $src = preg_replace(
        $rollFormPattern,
        $rollForm,
        $src,
        1,
        $rollFormCount
    );

    if ($rollFormCount !== 1) {
        throw new RuntimeException(
            'Formulario de rollo V3.1: no se pudo localizar el formulario actual.'
        );
    }

    /*
     * Avisos CRUD.
     */
    if (!str_contains($src, 'roll_updated')) {
        $noticeMarker =
            '<?php if ($rollCreated): ?><div class="notice"><span class="ok">✓</span> Rollo creado correctamente.</div><?php endif; ?>';

        if (str_contains($src, $noticeMarker)) {
            $extraNotices = <<<'HTML'
<?php if (isset($_GET['roll_updated'])): ?><div class="notice"><span class="ok">✓</span> Rollo actualizado correctamente.</div><?php endif; ?>
<?php if (isset($_GET['roll_archived'])): ?><div class="notice"><span class="ok">✓</span> Rollo archivado. Ya no aparecerá para nuevas impresiones.</div><?php endif; ?>
<?php if (isset($_GET['roll_restored'])): ?><div class="notice"><span class="ok">✓</span> Rollo restaurado.</div><?php endif; ?>
<?php if (isset($_GET['roll_deleted'])): ?><div class="notice"><span class="ok">✓</span> Rollo eliminado correctamente.</div><?php endif; ?>
HTML;

            $src = str_replace(
                $noticeMarker,
                $noticeMarker . "\n" . $extraNotices,
                $src
            );
        }
    }

    /*
     * Sección Administración de rollos, antes del historial.
     */
    if (!str_contains($src, 'ADMINISTRACIÓN DE ROLLOS')) {
        $historyMarker =
            '<section class="card meter-history-card">';

        if (!str_contains($src, $historyMarker)) {
            throw new RuntimeException(
                'Administración V3.1: no se encontró el historial para insertar la sección.'
            );
        }

        $rollAdmin = <<<'HTML'
<section class="card roll-admin-card">
  <div class="section-heading">
    <div>
      <span class="eyebrow">ADMINISTRACIÓN DE ROLLOS</span>
      <h3>Editar, archivar o eliminar rollos</h3>
      <p class="muted">
        Los rollos con historial no se eliminan físicamente: se archivan para conservar la trazabilidad.
      </p>
    </div>
  </div>

  <div class="table-wrap">
    <table class="meter-table roll-admin-table">
      <thead>
        <tr>
          <th>ID</th>
          <th>Rollo</th>
          <th>Inicial</th>
          <th>Disponible</th>
          <th>Consumido</th>
          <th>Ancho</th>
          <th>$/ml</th>
          <th>Trabajos</th>
          <th>Estado</th>
          <th>Acciones</th>
        </tr>
      </thead>

      <tbody>
      <?php foreach($rollManagement as $roll):
        $used=max(0,(float)$roll['initial_m']-(float)$roll['remaining_m']);
        $archived=(int)$roll['is_archived']===1;
      ?>
        <tr class="roll-admin-row <?=$archived?'is-archived':''?>">
          <td>#<?=((int)$roll['id'])?></td>

          <td>
            <div class="roll-admin-name">
              <strong><?=e((string)$roll['roll_name'])?></strong>
            </div>
          </td>

          <td><?=number_format((float)$roll['initial_m'],3)?> m</td>
          <td><strong><?=number_format((float)$roll['remaining_m'],3)?> m</strong></td>
          <td><?=number_format($used,3)?> m</td>
          <td><?=number_format((float)$roll['width_m'],3)?> m</td>
          <td>$<?=number_format((float)$roll['cost_per_linear_m'],2)?></td>
          <td><?=((int)$roll['jobs'])?></td>

          <td>
            <?php if($archived): ?>
              <span class="roll-admin-badge archived">Archivado</span>
            <?php elseif((string)$roll['status']==='empty'): ?>
              <span class="roll-admin-badge empty">Agotado</span>
            <?php else: ?>
              <span class="roll-admin-badge active">Activo</span>
            <?php endif; ?>
          </td>

          <td>
            <div class="roll-admin-actions">
              <button
                type="button"
                class="roll-admin-btn edit roll-edit-btn"
                data-id="<?=((int)$roll['id'])?>"
                data-name="<?=e((string)$roll['roll_name'])?>"
                data-initial="<?=e((string)$roll['initial_m'])?>"
                data-remaining="<?=e((string)$roll['remaining_m'])?>"
                data-width="<?=e((string)$roll['width_m'])?>"
                data-cost="<?=e((string)$roll['cost_per_linear_m'])?>"
              >
                Editar
              </button>

              <?php if($archived): ?>
                <form method="post">
                  <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                  <input type="hidden" name="action" value="restore_roll">
                  <input type="hidden" name="roll_id" value="<?=((int)$roll['id'])?>">
                  <button
                    class="roll-admin-btn restore"
                    type="submit"
                    onclick="return confirm('¿Restaurar este rollo al inventario?');"
                  >
                    Restaurar
                  </button>
                </form>

              <?php elseif((int)$roll['jobs']>0): ?>
                <form method="post">
                  <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                  <input type="hidden" name="action" value="archive_roll">
                  <input type="hidden" name="roll_id" value="<?=((int)$roll['id'])?>">
                  <button
                    class="roll-admin-btn archive"
                    type="submit"
                    onclick="return confirm('Este rollo tiene historial. Se archivará sin borrar sus registros. ¿Continuar?');"
                  >
                    Archivar
                  </button>
                </form>

              <?php else: ?>
                <form method="post">
                  <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                  <input type="hidden" name="action" value="delete_roll">
                  <input type="hidden" name="roll_id" value="<?=((int)$roll['id'])?>">
                  <button
                    class="roll-admin-btn delete"
                    type="submit"
                    onclick="return confirm('¿Eliminar definitivamente este rollo? Esta acción solo se permite si no tiene trabajos registrados.');"
                  >
                    Eliminar
                  </button>
                </form>
              <?php endif; ?>
            </div>
          </td>
        </tr>
      <?php endforeach; ?>

      <?php if(!$rollManagement): ?>
        <tr>
          <td colspan="10" class="empty">Todavía no hay rollos registrados.</td>
        </tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</section>

<div class="roll-edit-modal" id="rollEditModal" aria-hidden="true">
  <div class="roll-edit-backdrop" data-close-roll-edit></div>

  <div class="roll-edit-dialog" role="dialog" aria-modal="true" aria-labelledby="rollEditTitle">
    <div class="roll-edit-head">
      <div>
        <span class="eyebrow">CONTROL DE INVENTARIO</span>
        <h3 id="rollEditTitle">Editar rollo</h3>
      </div>

      <button
        type="button"
        class="roll-edit-close"
        data-close-roll-edit
        aria-label="Cerrar"
      >×</button>
    </div>

    <form method="post" class="roll-edit-form" id="rollEditForm">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <input type="hidden" name="action" value="edit_roll">
      <input type="hidden" name="roll_id" value="">

      <div class="roll-edit-grid">
        <div class="roll-edit-field is-wide">
          <label>Nombre / identificación</label>
          <input name="roll_name" required>
        </div>

        <div class="roll-edit-field">
          <label>Metros iniciales</label>
          <input type="number" step="0.001" min="0.001" name="initial_m" required>
        </div>

        <div class="roll-edit-field">
          <label>Metros disponibles</label>
          <input type="number" step="0.001" min="0" name="remaining_m" required>
        </div>

        <div class="roll-edit-field">
          <label>Ancho útil (m)</label>
          <input type="number" step="0.001" min="0.001" name="width_m" required>
        </div>

        <div class="roll-edit-field">
          <label>Costo por metro lineal</label>
          <input type="number" step="0.01" min="0" name="cost_per_linear_m" required>
        </div>

        <div class="roll-edit-field is-wide">
          <label>Motivo / nota del ajuste</label>
          <textarea
            name="adjustment_note"
            placeholder="Ej. Corrección por medición física del rollo."
          ></textarea>
        </div>
      </div>

      <div class="roll-edit-warning">
        Cambiar el saldo disponible modifica el inventario actual.
        SISACT guardará una auditoría con los valores anteriores y nuevos.
      </div>

      <div class="roll-edit-actions">
        <button
          type="button"
          class="btn btn-secondary"
          data-close-roll-edit
        >
          Cancelar
        </button>

        <button
          type="submit"
          class="btn btn-primary"
        >
          Guardar cambios
        </button>
      </div>
    </form>
  </div>
</div>

HTML;

        $src = str_replace(
            $historyMarker,
            $rollAdmin . $historyMarker,
            $src
        );
    }

    /*
     * Historial V3.1
     */
    $historyStart = strpos(
        $src,
        '<section class="card meter-history-card">'
    );

    if ($historyStart === false) {
        throw new RuntimeException(
            'Historial V3.1: no se encontró el inicio.'
        );
    }

    $historyEnd = strpos(
        $src,
        '</section>',
        $historyStart
    );

    if ($historyEnd === false) {
        throw new RuntimeException(
            'Historial V3.1: no se encontró el cierre.'
        );
    }

    $historyEnd += strlen('</section>');

    $history = <<<'HTML'
<section class="card meter-history-card">
  <div class="section-heading">
    <div>
      <span class="eyebrow">HISTORIAL Y COSTOS</span>
      <h3>Trabajos impresos</h3>
      <p class="muted">Dimensiones, consumo, saldo y costo histórico por trabajo.</p>
    </div>
  </div>

  <div class="table-wrap">
    <table class="meter-table meter-table-v3">
      <thead>
        <tr>
          <th>ID</th>
          <th>Fecha</th>
          <th>Rollo</th>
          <th>Trabajo</th>
          <th>Medida</th>
          <th>Área</th>
          <th>Paneles</th>
          <th>Metros</th>
          <th>Saldo</th>
          <th>$/ml</th>
          <th>Costo</th>
          <th>Resultado</th>
          <th>Merma</th>
        </tr>
      </thead>
      <tbody>
      <?php foreach($rows as $r): ?>
        <tr>
          <td><span class="meter-log-id">#<?=((int)$r['id'])?></span></td>
          <td><?=e(date('d/m/Y H:i',strtotime((string)$r['printed_at'])))?></td>
          <td><?=e((string)$r['roll_name'])?></td>
          <td><?=e((string)$r['job_name'])?></td>

          <td>
            <?php if((float)$r['job_width_m']>0 && (float)$r['job_length_m']>0): ?>
              <?=number_format((float)$r['job_width_m'],3)?> ×
              <?=number_format((float)$r['job_length_m'],3)?> m
            <?php else: ?>
              <?=number_format((float)$r['job_length_mm'],2)?> mm
            <?php endif; ?>
          </td>

          <td><?=number_format((float)$r['area_m2'],3)?> m²</td>
          <td><?=((int)$r['panels'])?></td>
          <td><strong><?=number_format((float)$r['linear_m'],3)?> m</strong></td>

          <td>
            <?=number_format((float)$r['linear_m_before'],3)?> →
            <strong><?=number_format((float)$r['linear_m_after'],3)?> m</strong>
          </td>

          <td>$<?=number_format((float)$r['cost_per_linear_m'],2)?></td>
          <td><strong>$<?=number_format((float)$r['material_cost'],2)?></strong></td>

          <td>
            <span class="meter-status meter-status-<?=e((string)$r['result_status'])?>">
              <?=e(print_meter_result_label((string)$r['result_status']))?>
            </span>
          </td>

          <td><?=number_format((float)$r['waste_m'],3)?> m</td>
        </tr>
      <?php endforeach; ?>

      <?php if(!$rows): ?>
        <tr>
          <td colspan="13" class="empty">Todavía no hay trabajos registrados.</td>
        </tr>
      <?php endif; ?>
      </tbody>
    </table>
  </div>
</section>
HTML;

    $src =
        substr($src, 0, $historyStart)
        . $history
        . substr($src, $historyEnd);

    /*
     * El main actual carga footer.php dos veces.
     * Se conserva solo la última inclusión.
     */
    $footerNeedle =
        "<?php require __DIR__ . '/../includes/footer.php'; ?>";

    if (substr_count($src, $footerNeedle) > 1) {
        $pos = strpos($src, $footerNeedle);

        if ($pos !== false) {
            $src =
                substr($src, 0, $pos)
                . substr(
                    $src,
                    $pos + strlen($footerNeedle)
                );
        }
    }

    return $src;
}

function impv31_patch_api(string $src): string
{
    $src = str_replace(
        "require_once __DIR__.'/../includes/impresiones_v3.php';\n",
        '',
        $src
    );

    if (!str_contains($src, 'impresiones_v3_1.php')) {
        $src = impv31_regex_once(
            $src,
            "#require_once __DIR__\\.'/\\.\\./includes/impresiones\\.php';#",
            "require_once __DIR__.'/../includes/impresiones.php';\n"
            . "require_once __DIR__.'/../includes/impresiones_v3_1.php';\n"
            . "// SISACT_IMPRESIONES_API_V3_1",
            'API include V3.1'
        );
    }

    $src = preg_replace(
        "#\\$payload\\s*=\\s*print_meter_(?:v3_)?normalize\\s*\\(\\$_POST\\);#",
        "\$payload=print_meter_v31_normalize(\$_POST);",
        $src,
        1,
        $normalizeCount
    );

    if ($normalizeCount !== 1) {
        throw new RuntimeException(
            'API V3.1: no se encontró la normalización actual.'
        );
    }

    $src = preg_replace(
        "#\\$id\\s*=\\s*print_meter_(?:v3_)?register(?:_safe)?\\s*\\(\\$payload\\);#",
        "\$id=print_meter_v31_register_safe(\$payload);",
        $src,
        1,
        $registerCount
    );

    if ($registerCount !== 1) {
        throw new RuntimeException(
            'API V3.1: no se encontró el registro actual.'
        );
    }

    return $src;
}

function impv31_status(): array
{
    return [
        'width' => impv31_column_exists('cp_print_rolls', 'width_m'),
        'cost' => impv31_column_exists('cp_print_rolls', 'cost_per_linear_m'),
        'archived' => impv31_column_exists('cp_print_rolls', 'is_archived'),
        'material_cost' => impv31_column_exists('cp_print_meter_logs', 'material_cost'),
        'audit' => impv31_table_exists('cp_print_roll_adjustments'),
    ];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action = (string)($_POST['action'] ?? '');

            if ($action === 'install') {
                if (!is_file($adminPath)) {
                    throw new RuntimeException(
                        'No se encontró admin/impresiones.php.'
                    );
                }

                if (!is_file($apiPath)) {
                    throw new RuntimeException(
                        'No se encontró api/registrar_impresion.php.'
                    );
                }

                /*
                 * Primero construir ambos parches en memoria.
                 * Si algo no coincide, no se escribe ninguno.
                 */
                $adminCurrent = (string)file_get_contents($adminPath);
                $apiCurrent = (string)file_get_contents($apiPath);

                $adminNew = impv31_patch_admin($adminCurrent);
                $apiNew = impv31_patch_api($apiCurrent);

                /*
                 * Migración idempotente.
                 */
                impv31_migrate();

                /*
                 * Respaldos.
                 */
                impv31_backup($adminPath);
                impv31_backup($apiPath);

                /*
                 * Escritura.
                 */
                impv31_atomic_write($adminPath, $adminNew);
                impv31_atomic_write($apiPath, $apiNew);

                $messages[] = 'V3.1 instalada correctamente.';
                $messages[] = 'Scroll interno del popup activado.';
                $messages[] = 'Wizard de dimensiones y costos activado.';
                $messages[] = 'Administración de rollos: editar, archivar, restaurar y eliminar.';
                $messages[] = 'Auditoría de ajustes creada.';
            }

            if ($action === 'revert') {
                foreach ([$adminPath, $apiPath] as $path) {
                    $backup =
                        $path . '.bak_impresiones_v3_1';

                    if (!is_file($backup)) {
                        throw new RuntimeException(
                            'No existe el respaldo de '
                            . basename($path) . '.'
                        );
                    }

                    if (!copy($backup, $path)) {
                        throw new RuntimeException(
                            'No se pudo restaurar '
                            . basename($path) . '.'
                        );
                    }

                    if (function_exists('opcache_invalidate')) {
                        @opcache_invalidate($path, true);
                    }
                }

                $messages[] =
                    'Interfaz y API restauradas desde respaldo V3.1.';

                $messages[] =
                    'Las columnas y auditorías V3.1 se conservaron para evitar pérdida de datos.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$status = impv31_status();

require __DIR__ . '/../includes/header.php';
?>
<style>
.v31-wrap{max-width:980px;margin:20px auto}
.v31-grid{display:grid;grid-template-columns:repeat(5,minmax(0,1fr));gap:10px;margin:18px 0}
.v31-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:11px}
.v31-stat small{display:block;color:var(--muted)}
.v31-stat strong{display:block;margin-top:5px}
.v31-ok{color:#67e7be}
.v31-box{padding:14px;border:1px solid rgba(82,208,255,.20);border-radius:12px;background:rgba(82,208,255,.05);line-height:1.6}
@media(max-width:850px){.v31-grid{grid-template-columns:1fr 1fr}}
</style>

<div class="v31-wrap">
  <div class="card" style="padding:22px">
    <span class="eyebrow">IMPRESIONES · FIX + INVENTARIO</span>
    <h2>Wizard y Rollos V3.1</h2>

    <p class="muted">
      Corrige el popup sin scroll y agrega administración segura de rollos.
    </p>

    <?php if($error): ?>
      <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach($messages as $message): ?>
      <div class="notice"><?=e($message)?></div>
    <?php endforeach; ?>

    <div class="v31-grid">
      <div class="v31-stat"><small>Ancho</small><strong class="<?=$status['width']?'v31-ok':''?>"><?=$status['width']?'✓ listo':'pendiente'?></strong></div>
      <div class="v31-stat"><small>Costo / ml</small><strong class="<?=$status['cost']?'v31-ok':''?>"><?=$status['cost']?'✓ listo':'pendiente'?></strong></div>
      <div class="v31-stat"><small>Archivado</small><strong class="<?=$status['archived']?'v31-ok':''?>"><?=$status['archived']?'✓ listo':'pendiente'?></strong></div>
      <div class="v31-stat"><small>Costo histórico</small><strong class="<?=$status['material_cost']?'v31-ok':''?>"><?=$status['material_cost']?'✓ listo':'pendiente'?></strong></div>
      <div class="v31-stat"><small>Auditoría</small><strong class="<?=$status['audit']?'v31-ok':''?>"><?=$status['audit']?'✓ listo':'pendiente'?></strong></div>
    </div>

    <div class="v31-box">
      <strong>Política de eliminación segura</strong><br>
      Rollo sin trabajos: puede eliminarse.<br>
      Rollo con trabajos: se archiva, conservando todo el historial.
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">

      <button
        class="btn btn-primary"
        type="submit"
        name="action"
        value="install"
      >
        Instalar V3.1
      </button>

      <a
        class="btn btn-secondary"
        href="/admin/impresiones.php"
      >
        Abrir Control de metraje
      </a>

      <button
        class="btn btn-secondary"
        type="submit"
        name="action"
        value="revert"
        onclick="return confirm('¿Restaurar los archivos anteriores? La migración y auditoría se conservarán.');"
      >
        Revertir archivos
      </button>
    </form>
  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
