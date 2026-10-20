<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/impresiones_rollos_v3_1_1.php';

require_auth();

$title = 'Administración de rollos';
$error = null;
$success = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        if (!csrf_check($_POST['_csrf'] ?? null)) {
            throw new RuntimeException(
                'La sesión del formulario expiró. Recarga la página.'
            );
        }

        $action = (string)($_POST['action'] ?? '');
        $rollId = (int)($_POST['roll_id'] ?? 0);
        $note = trim((string)($_POST['adjustment_note'] ?? ''));

        if ($action === 'edit') {
            print_roll_v311_update(
                $rollId,
                (string)($_POST['roll_name'] ?? ''),
                (float)($_POST['initial_m'] ?? 0),
                (float)($_POST['remaining_m'] ?? 0),
                (float)($_POST['width_m'] ?? 0),
                (float)($_POST['cost_per_linear_m'] ?? 0),
                $note
            );

            log_activity(
                'update',
                'print_rolls',
                'Rollo actualizado #' . $rollId
            );

            $success = 'Rollo actualizado correctamente.';
        }

        if ($action === 'archive') {
            print_roll_v311_archive(
                $rollId,
                $note !== '' ? $note : 'Archivado desde Administración de rollos'
            );

            log_activity(
                'update',
                'print_rolls',
                'Rollo archivado #' . $rollId
            );

            $success = 'Rollo archivado. Ya no contará como inventario disponible.';
        }

        if ($action === 'restore') {
            print_roll_v311_restore(
                $rollId,
                $note !== '' ? $note : 'Restaurado desde Administración de rollos'
            );

            log_activity(
                'update',
                'print_rolls',
                'Rollo restaurado #' . $rollId
            );

            $success = 'Rollo restaurado correctamente.';
        }

        if ($action === 'delete') {
            print_roll_v311_delete(
                $rollId,
                $note !== '' ? $note : 'Eliminado desde Administración de rollos'
            );

            log_activity(
                'delete',
                'print_rolls',
                'Rollo eliminado #' . $rollId
            );

            $success = 'Rollo eliminado correctamente.';
        }
    } catch (Throwable $e) {
        $error = $e instanceof RuntimeException
            ? $e->getMessage()
            : 'No se pudo completar la operación.';
    }
}

$rows = [];

try {
    $rows = print_roll_v311_management_rows();
} catch (Throwable $e) {
    $error = $error ?: 'No se pudo cargar el inventario de rollos.';
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/impresiones-rollos-v3-1-1.css?v=20261017-1">

<div class="rollmgr-page">
  <div class="rollmgr-heading">
    <div>
      <span class="eyebrow">IMPRESIONES · INVENTARIO</span>
      <h2>Administración de rollos</h2>
      <p class="muted">
        Edita medidas, saldo y costo; archiva rollos con historial o elimina únicamente los que nunca se han utilizado.
      </p>
    </div>

    <a class="btn btn-secondary" href="/admin/impresiones.php">
      ← Control de metraje
    </a>
  </div>

  <?php if ($error): ?>
    <div class="notice danger"><?=e($error)?></div>
  <?php endif; ?>

  <?php if ($success): ?>
    <div class="notice"><span class="ok">✓</span> <?=e($success)?></div>
  <?php endif; ?>

  <div class="card rollmgr-info">
    <strong>Política segura de inventario</strong>
    <span>
      Un rollo sin trabajos puede eliminarse. Si ya tiene movimientos, se archiva para conservar el historial y deja de formar parte del inventario disponible.
    </span>
  </div>

  <div class="card rollmgr-card">
    <div class="section-heading">
      <div>
        <span class="eyebrow">ROLLOS REGISTRADOS</span>
        <h3><?=count($rows)?> rollos</h3>
      </div>
    </div>

    <div class="table-wrap">
      <table class="meter-table rollmgr-table">
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
        <?php foreach ($rows as $r):
          $used = max(
              0.0,
              (float)$r['initial_m'] - (float)$r['remaining_m']
          );
          $archived = (int)$r['is_archived'] === 1;
        ?>
          <tr class="<?=$archived ? 'is-archived' : ''?>">
            <td>#<?=((int)$r['id'])?></td>

            <td>
              <strong><?=e((string)$r['roll_name'])?></strong>
            </td>

            <td><?=number_format((float)$r['initial_m'],3)?> m</td>
            <td><strong><?=number_format((float)$r['remaining_m'],3)?> m</strong></td>
            <td><?=number_format($used,3)?> m</td>
            <td><?=number_format((float)$r['width_m'],3)?> m</td>
            <td>$<?=number_format((float)$r['cost_per_linear_m'],2)?></td>
            <td><?=((int)$r['jobs'])?></td>

            <td>
              <?php if ($archived): ?>
                <span class="rollmgr-badge archived">Archivado</span>
              <?php elseif ((string)$r['status'] === 'empty'): ?>
                <span class="rollmgr-badge empty">Agotado</span>
              <?php else: ?>
                <span class="rollmgr-badge active">Activo</span>
              <?php endif; ?>
            </td>

            <td>
              <div class="rollmgr-actions">
                <button
                  type="button"
                  class="rollmgr-btn edit js-edit-roll"
                  data-id="<?=((int)$r['id'])?>"
                  data-name="<?=e((string)$r['roll_name'])?>"
                  data-initial="<?=e((string)$r['initial_m'])?>"
                  data-remaining="<?=e((string)$r['remaining_m'])?>"
                  data-width="<?=e((string)$r['width_m'])?>"
                  data-cost="<?=e((string)$r['cost_per_linear_m'])?>"
                >
                  Editar
                </button>

                <?php if ($archived): ?>
                  <form method="post">
                    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                    <input type="hidden" name="action" value="restore">
                    <input type="hidden" name="roll_id" value="<?=((int)$r['id'])?>">
                    <button
                      class="rollmgr-btn restore"
                      type="submit"
                      onclick="return confirm('¿Restaurar este rollo al inventario?');"
                    >
                      Restaurar
                    </button>
                  </form>

                <?php elseif ((int)$r['jobs'] > 0): ?>
                  <form method="post">
                    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                    <input type="hidden" name="action" value="archive">
                    <input type="hidden" name="roll_id" value="<?=((int)$r['id'])?>">
                    <button
                      class="rollmgr-btn archive"
                      type="submit"
                      onclick="return confirm('Este rollo tiene historial. Se archivará sin borrar sus movimientos. ¿Continuar?');"
                    >
                      Archivar
                    </button>
                  </form>

                <?php else: ?>
                  <form method="post">
                    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="roll_id" value="<?=((int)$r['id'])?>">
                    <button
                      class="rollmgr-btn delete"
                      type="submit"
                      onclick="return confirm('¿Eliminar definitivamente este rollo?');"
                    >
                      Eliminar
                    </button>
                  </form>
                <?php endif; ?>
              </div>
            </td>
          </tr>
        <?php endforeach; ?>

        <?php if (!$rows): ?>
          <tr>
            <td colspan="10" class="empty">No hay rollos registrados.</td>
          </tr>
        <?php endif; ?>
        </tbody>
      </table>
    </div>
  </div>
</div>

<div class="rollmgr-modal" id="rollEditModal" aria-hidden="true">
  <div class="rollmgr-backdrop" data-roll-close></div>

  <div class="rollmgr-dialog" role="dialog" aria-modal="true" aria-labelledby="rollEditTitle">
    <div class="rollmgr-dialog-head">
      <div>
        <span class="eyebrow">AJUSTE DE INVENTARIO</span>
        <h3 id="rollEditTitle">Editar rollo</h3>
      </div>

      <button type="button" class="rollmgr-close" data-roll-close>×</button>
    </div>

    <form method="post" class="rollmgr-form" id="rollEditForm">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <input type="hidden" name="action" value="edit">
      <input type="hidden" name="roll_id">

      <div class="rollmgr-grid">
        <div class="field wide">
          <label>Nombre / identificación</label>
          <input name="roll_name" required>
        </div>

        <div class="field">
          <label>Metros iniciales</label>
          <input type="number" step="0.001" min="0.001" name="initial_m" required>
        </div>

        <div class="field">
          <label>Metros disponibles</label>
          <input type="number" step="0.001" min="0" name="remaining_m" required>
        </div>

        <div class="field">
          <label>Ancho útil (m)</label>
          <input type="number" step="0.001" min="0.001" name="width_m" required>
        </div>

        <div class="field">
          <label>Costo por metro lineal</label>
          <input type="number" step="0.01" min="0" name="cost_per_linear_m" required>
        </div>

        <div class="field wide">
          <label>Motivo del ajuste</label>
          <textarea
            name="adjustment_note"
            placeholder="Ej. Corrección después de medir físicamente el rollo."
          ></textarea>
        </div>
      </div>

      <div class="rollmgr-warning">
        Si modificas los metros disponibles, SISACT ajustará el inventario actual y guardará una auditoría con el valor anterior y el nuevo.
      </div>

      <div class="rollmgr-dialog-actions">
        <button type="button" class="btn btn-secondary" data-roll-close>
          Cancelar
        </button>
        <button type="submit" class="btn btn-primary">
          Guardar cambios
        </button>
      </div>
    </form>
  </div>
</div>

<script>
(function(){
  const modal=document.getElementById('rollEditModal');
  const form=document.getElementById('rollEditForm');
  if(!modal||!form)return;

  function set(name,value){
    const el=form.querySelector('[name="'+name+'"]');
    if(el)el.value=value??'';
  }

  function open(btn){
    set('roll_id',btn.dataset.id);
    set('roll_name',btn.dataset.name);
    set('initial_m',btn.dataset.initial);
    set('remaining_m',btn.dataset.remaining);
    set('width_m',btn.dataset.width);
    set('cost_per_linear_m',btn.dataset.cost);
    set('adjustment_note','');

    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden','false');

    requestAnimationFrame(()=>{
      form.querySelector('[name="roll_name"]')?.focus();
    });
  }

  function close(){
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden','true');
  }

  document.querySelectorAll('.js-edit-roll').forEach(btn=>{
    btn.addEventListener('click',()=>open(btn));
  });

  modal.querySelectorAll('[data-roll-close]').forEach(el=>{
    el.addEventListener('click',close);
  });

  document.addEventListener('keydown',e=>{
    if(e.key==='Escape'&&modal.classList.contains('is-open')){
      e.preventDefault();
      close();
    }
  });

  form.addEventListener('submit',function(event){
    const initial=parseFloat(form.querySelector('[name="initial_m"]').value||'0');
    const remaining=parseFloat(form.querySelector('[name="remaining_m"]').value||'0');

    if(!(initial>0)){
      event.preventDefault();
      alert('Los metros iniciales deben ser mayores que 0.');
      return;
    }

    if(remaining<0||remaining>initial){
      event.preventDefault();
      alert('Los metros disponibles deben estar entre 0 y los metros iniciales.');
    }
  });
})();
</script>

<?php require __DIR__ . '/../includes/footer.php'; ?>
