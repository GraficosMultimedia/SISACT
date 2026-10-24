<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Impresiones · Wizard V3';

$root = dirname(__DIR__);
$adminPath = $root . '/admin/impresiones.php';
$apiPath = $root . '/api/registrar_impresion.php';

$error = null;
$messages = [];

function impv3_column_exists(
    string $table,
    string $column
): bool {
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

function impv3_add_column(
    string $table,
    string $column,
    string $definition
): void {
    if (impv3_column_exists($table, $column)) {
        return;
    }

    db()->exec(
        "ALTER TABLE `{$table}`
         ADD COLUMN `{$column}` {$definition}"
    );
}

function impv3_migrate(): void
{
    impv3_add_column(
        'cp_print_rolls',
        'width_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `remaining_m`"
    );

    impv3_add_column(
        'cp_print_rolls',
        'cost_per_linear_m',
        "DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `width_m`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'job_width_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `job_length_mm`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'job_length_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `job_width_m`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'area_m2',
        "DECIMAL(12,3) NOT NULL DEFAULT 0.000 AFTER `job_length_m`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'panels',
        "INT UNSIGNED NOT NULL DEFAULT 1 AFTER `area_m2`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'roll_width_m',
        "DECIMAL(10,3) NOT NULL DEFAULT 0.000 AFTER `panels`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'linear_m_before',
        "DECIMAL(12,3) NOT NULL DEFAULT 0.000 AFTER `roll_width_m`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'linear_m_after',
        "DECIMAL(12,3) NOT NULL DEFAULT 0.000 AFTER `linear_m`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'cost_per_linear_m',
        "DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `linear_m_after`"
    );

    impv3_add_column(
        'cp_print_meter_logs',
        'material_cost',
        "DECIMAL(12,2) NOT NULL DEFAULT 0.00 AFTER `cost_per_linear_m`"
    );
}

function impv3_atomic_write(
    string $path,
    string $content
): void {
    $tmp = $path . '.impv3.tmp';

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

function impv3_backup(
    string $path
): void {
    $backup = $path . '.bak_impresiones_v3';

    if (!is_file($backup) && !copy($path, $backup)) {
        throw new RuntimeException(
            'No se pudo respaldar ' . basename($path) . '.'
        );
    }
}

function impv3_replace_once(
    string $src,
    string $old,
    string $new,
    string $label
): string {
    $count = substr_count($src, $old);

    if ($count !== 1) {
        throw new RuntimeException(
            $label .
            ': se esperaba exactamente 1 coincidencia y se encontraron ' .
            $count .
            '. No se modificó el archivo.'
        );
    }

    return str_replace($old, $new, $src);
}

function impv3_patch_admin(
    string $src
): string {
    if (str_contains($src, 'SISACT_IMPRESIONES_V3_INSTALLED')) {
        return $src;
    }

    $src = impv3_replace_once(
        $src,
        "require_once __DIR__ . '/../includes/impresiones.php';",
        "require_once __DIR__ . '/../includes/impresiones.php';\n"
        . "require_once __DIR__ . '/../includes/impresiones_v3.php';\n"
        . "// SISACT_IMPRESIONES_V3_INSTALLED",
        'Include V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$id = print_meter_create_roll((string)(\$_POST['roll_name'] ?? ''), (float)(\$_POST['initial_m'] ?? 0));",
        "\$id = print_meter_v3_create_roll(\n"
        . "                (string)(\$_POST['roll_name'] ?? ''),\n"
        . "                (float)(\$_POST['initial_m'] ?? 0),\n"
        . "                (float)(\$_POST['width_m'] ?? 0),\n"
        . "                (float)(\$_POST['cost_per_linear_m'] ?? 0)\n"
        . "            );",
        'Crear rollo V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$payload = print_meter_normalize(\$_POST);",
        "\$payload = print_meter_v3_normalize(\$_POST);",
        'Normalización V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$id = print_meter_register(\$payload);",
        "\$id = print_meter_v3_register_safe(\$payload);",
        'Registro V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$rolls = print_meter_active_rolls();",
        "\$rolls = print_meter_v3_active_rolls();",
        'Rollos V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$rows = print_meter_rows();",
        "\$rows = print_meter_v3_rows();",
        'Historial V3'
    );

    $src = impv3_replace_once(
        $src,
        '<link rel="stylesheet" href="/assets/css/impresiones-wizard-v2.css?v=20260920-2">',
        '<link rel="stylesheet" href="/assets/css/impresiones-wizard-v3.css?v=20261017-1">',
        'CSS Wizard V3'
    );

    $src = impv3_replace_once(
        $src,
        '<script src="/assets/js/impresiones-wizard-v2.js?v=20260920-2" defer></script>',
        '<script src="/assets/js/impresiones-wizard-v3.js?v=20261017-1" defer></script>',
        'JS Wizard V3'
    );

    $src = str_replace(
        'Solo registra los metros lineales consumidos por cada trabajo y descuéntalos del rollo utilizado.',
        'Registra medidas, metros lineales, saldo de rollo y costo real de material por cada trabajo.',
        $src
    );

    $oldRollForm = <<<'HTML'
    <form method="post" class="meter-roll-form">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <input type="hidden" name="action" value="create_roll">
      <div class="field"><label>Nuevo rollo</label><input name="roll_name" placeholder="Ej. Rollo Lona 1" required></div>
      <div class="field"><label>Metros iniciales</label><input type="number" step="0.001" min="0.001" name="initial_m" placeholder="50.000" required></div>
      <button class="btn btn-primary" type="submit">+ Abrir rollo</button>
    </form>
HTML;

    $newRollForm = <<<'HTML'
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

    $src = impv3_replace_once(
        $src,
        $oldRollForm,
        $newRollForm,
        'Formulario de rollo V3'
    );

    $oldOption = <<<'HTML'
<option data-roll-id="<?=((int)$r['id'])?>" data-roll-name="<?=e($r['roll_name'])?>" data-remaining="<?=e((string)$r['remaining_m'])?>" value="<?=((int)$r['id'])?>" <?=($activeRoll && (int)$activeRoll['id']===(int)$r['id'])?'selected':''?>><?=e($r['roll_name'])?> · <?=number_format((float)$r['remaining_m'],3)?> m disponibles</option>
HTML;

    $newOption = <<<'HTML'
<option
  data-roll-id="<?=((int)$r['id'])?>"
  data-roll-name="<?=e($r['roll_name'])?>"
  data-remaining="<?=e((string)$r['remaining_m'])?>"
  data-roll-width="<?=e((string)($r['width_m'] ?? 0))?>"
  data-cost-per-m="<?=e((string)($r['cost_per_linear_m'] ?? 0))?>"
  data-status="<?=e((string)$r['status'])?>"
  value="<?=((int)$r['id'])?>"
  <?=($activeRoll && (int)$activeRoll['id']===(int)$r['id'])?'selected':''?>
  <?=((string)$r['status']!=='active')?'disabled':''?>
><?=e($r['roll_name'])?> · <?=number_format((float)$r['remaining_m'],3)?> m disponibles<?=((float)($r['width_m'] ?? 0)>0)?' · ancho '.number_format((float)$r['width_m'],3).' m':''?></option>
HTML;

    $src = impv3_replace_once(
        $src,
        $oldOption,
        $newOption,
        'Datos del rollo V3'
    );

    $historyStart = strpos(
        $src,
        '<section class="card meter-history-card">'
    );

    if ($historyStart === false) {
        throw new RuntimeException(
            'Historial V3: no se encontró el inicio de la sección.'
        );
    }

    $historyEnd = strpos(
        $src,
        '</section>',
        $historyStart
    );

    if ($historyEnd === false) {
        throw new RuntimeException(
            'Historial V3: no se encontró el final de la sección.'
        );
    }

    $historyEnd += strlen('</section>');

    $newHistory = <<<'HTML'
<section class="card meter-history-card">
  <div class="section-heading">
    <div>
      <span class="eyebrow">HISTORIAL Y COSTOS</span>
      <h3>Trabajos impresos</h3>
      <p class="muted">Consumo, saldo de material y costo histórico por trabajo.</p>
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
          <th>Costo material</th>
          <th>Resultado</th>
          <th>Merma</th>
        </tr>
      </thead>
      <tbody>
      <?php foreach($rows as $r): ?>
        <tr>
          <td><span class="meter-log-id">#<?=((int)$r['id'])?></span></td>
          <td><?=e(date('d/m/Y H:i',strtotime((string)$r['printed_at'])))?></td>
          <td><?=e($r['roll_name'])?></td>
          <td><?=e($r['job_name'])?></td>
          <td>
            <?php if((float)$r['job_width_m']>0 && (float)$r['job_length_m']>0): ?>
              <?=number_format((float)$r['job_width_m'],3)?> × <?=number_format((float)$r['job_length_m'],3)?> m
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
        . $newHistory
        . substr($src, $historyEnd);

    /*
     * El archivo actual de GitHub carga footer.php dos veces.
     * Eliminamos únicamente la primera inclusión, dejando la final.
     */
    $duplicateFooter = <<<'PHP'
</script>
<?php require __DIR__ . '/../includes/footer.php'; ?>

<script>
(function(){
PHP;

    if (substr_count($src, $duplicateFooter) === 1) {
        $src = str_replace(
            $duplicateFooter,
            "</script>\n\n<script>\n(function(){",
            $src
        );
    }

    return $src;
}

function impv3_patch_api(
    string $src
): string {
    if (str_contains($src, 'SISACT_IMPRESIONES_API_V3')) {
        return $src;
    }

    $src = impv3_replace_once(
        $src,
        "require_once __DIR__.'/../includes/impresiones.php';",
        "require_once __DIR__.'/../includes/impresiones.php';\n"
        . "require_once __DIR__.'/../includes/impresiones_v3.php';\n"
        . "// SISACT_IMPRESIONES_API_V3",
        'API include V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$payload=print_meter_normalize(\$_POST);",
        "\$payload=print_meter_v3_normalize(\$_POST);",
        'API normalize V3'
    );

    $src = impv3_replace_once(
        $src,
        "\$id=print_meter_register_safe(\$payload);",
        "\$id=print_meter_v3_register_safe(\$payload);",
        'API register V3'
    );

    return $src;
}

function impv3_status(): array
{
    return [
        'roll_width' => impv3_column_exists(
            'cp_print_rolls',
            'width_m'
        ),
        'roll_cost' => impv3_column_exists(
            'cp_print_rolls',
            'cost_per_linear_m'
        ),
        'log_area' => impv3_column_exists(
            'cp_print_meter_logs',
            'area_m2'
        ),
        'log_cost' => impv3_column_exists(
            'cp_print_meter_logs',
            'material_cost'
        ),
    ];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action = (string)($_POST['action'] ?? '');

            if ($action === 'install') {
                foreach ([$adminPath, $apiPath] as $path) {
                    if (!is_file($path)) {
                        throw new RuntimeException(
                            'No se encontró ' . basename($path) . '.'
                        );
                    }
                }

                /*
                 * 1. Primero validamos que los parches puedan construirse.
                 */
                $adminCurrent = (string)file_get_contents($adminPath);
                $apiCurrent = (string)file_get_contents($apiPath);

                $adminNew = impv3_patch_admin($adminCurrent);
                $apiNew = impv3_patch_api($apiCurrent);

                /*
                 * 2. Migración idempotente.
                 */
                impv3_migrate();

                /*
                 * 3. Respaldos y escritura.
                 */
                impv3_backup($adminPath);
                impv3_backup($apiPath);

                impv3_atomic_write(
                    $adminPath,
                    $adminNew
                );

                impv3_atomic_write(
                    $apiPath,
                    $apiNew
                );

                $messages[] =
                    'Migración V3 aplicada correctamente.';

                $messages[] =
                    'Wizard V3 instalado en admin/impresiones.php.';

                $messages[] =
                    'API de registro actualizada con cálculo y costo V3.';

                $messages[] =
                    'Se eliminó la inclusión duplicada de footer.php cuando estaba presente.';
            }

            if ($action === 'revert') {
                foreach ([$adminPath, $apiPath] as $path) {
                    $backup = $path . '.bak_impresiones_v3';

                    if (!is_file($backup)) {
                        throw new RuntimeException(
                            'Falta respaldo de ' . basename($path) . '.'
                        );
                    }

                    if (!copy($backup, $path)) {
                        throw new RuntimeException(
                            'No se pudo restaurar ' . basename($path) . '.'
                        );
                    }

                    if (function_exists('opcache_invalidate')) {
                        @opcache_invalidate($path, true);
                    }
                }

                $messages[] =
                    'Archivos principales restaurados.';

                $messages[] =
                    'Las columnas V3 NO fueron eliminadas para no perder historial.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$status = impv3_status();

require __DIR__ . '/../includes/header.php';
?>
<style>
.impv3-wrap{max-width:980px;margin:20px auto}
.impv3-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px;margin:18px 0}
.impv3-stat{padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:11px}
.impv3-stat small{display:block;color:var(--muted)}
.impv3-stat strong{display:block;margin-top:5px}
.impv3-ok{color:#67e7be}
.impv3-flow{padding:15px;border:1px solid rgba(82,208,255,.20);background:rgba(82,208,255,.05);border-radius:12px;line-height:1.6}
@media(max-width:760px){.impv3-grid{grid-template-columns:1fr 1fr}}
</style>

<div class="impv3-wrap">
  <div class="card" style="padding:22px">
    <span class="eyebrow">IMPRESIONES · CONTROL DE METRAJE</span>
    <h2>Wizard V3 · Dimensiones y costos</h2>

    <p class="muted">
      Mejora el popup, agrega scroll interno y footer visible,
      calcula paneles y metros lineales, guarda saldo antes/después
      y conserva el costo histórico de material por impresión.
    </p>

    <?php if($error): ?>
      <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach($messages as $message): ?>
      <div class="notice"><?=e($message)?></div>
    <?php endforeach; ?>

    <div class="impv3-grid">
      <div class="impv3-stat">
        <small>Ancho del rollo</small>
        <strong class="<?=$status['roll_width']?'impv3-ok':''?>">
          <?=$status['roll_width']?'✓ listo':'pendiente'?>
        </strong>
      </div>

      <div class="impv3-stat">
        <small>Costo / metro</small>
        <strong class="<?=$status['roll_cost']?'impv3-ok':''?>">
          <?=$status['roll_cost']?'✓ listo':'pendiente'?>
        </strong>
      </div>

      <div class="impv3-stat">
        <small>Área / paneles</small>
        <strong class="<?=$status['log_area']?'impv3-ok':''?>">
          <?=$status['log_area']?'✓ listo':'pendiente'?>
        </strong>
      </div>

      <div class="impv3-stat">
        <small>Costo histórico</small>
        <strong class="<?=$status['log_cost']?'impv3-ok':''?>">
          <?=$status['log_cost']?'✓ listo':'pendiente'?>
        </strong>
      </div>
    </div>

    <div class="impv3-flow">
      <strong>Fórmulas V3</strong><br>
      Área = ancho × largo (m²)<br>
      Paneles = ancho del trabajo ÷ ancho útil del rollo, redondeado hacia arriba<br>
      Metros lineales = largo × paneles<br>
      Saldo = metros disponibles − metros lineales<br>
      Costo de material = metros lineales × costo por metro lineal
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">

      <button
        class="btn btn-primary"
        type="submit"
        name="action"
        value="install"
      >
        Instalar Impresiones V3
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
        onclick="return confirm('¿Restaurar los archivos anteriores? Las columnas y el historial V3 se conservarán.');"
      >
        Revertir interfaz
      </button>
    </form>
  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
