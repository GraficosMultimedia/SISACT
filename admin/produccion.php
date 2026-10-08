<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/produccion.php';
require_auth();

$title='Producción';
$error=null;

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf'] ?? null)) {
        $error='La sesión del formulario expiró. Recarga la página.';
    } elseif(($_POST['action'] ?? '')==='move'){
        $id=(int)($_POST['id'] ?? 0);
        $stage=(string)($_POST['stage'] ?? '');
        $note=trim((string)($_POST['note'] ?? ''));

        try {
            if($id<1) throw new RuntimeException('Orden inválida.');
            production_set_stage($id,$stage,$note);
            log_activity('update','production','Etapa actualizada para orden #'.$id);
            header('Location: /admin/produccion.php?updated=1');
            exit;
        } catch(Throwable $e){
            $error=$e->getMessage()==='Etapa de producción no válida.'
                ? $e->getMessage()
                : 'No se pudo actualizar la etapa.';
        }
    }
}

$q=trim((string)($_GET['q'] ?? ''));
$filter=(string)($_GET['stage'] ?? '');
$orders=production_orders($q,$filter);
$columns=production_stages();
unset($columns['cancelled'], $columns['delivered']);

$grouped=[];
foreach(array_keys($columns) as $k) {
    $grouped[$k]=[];
}

foreach($orders as $o){
    $s=(string)$o['production_stage'];
    if(isset($grouped[$s])) {
        $grouped[$s][]=$o;
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/produccion.css?v=20260917-11">
<link rel="stylesheet" href="/assets/css/sisact-design-system-v1.css?v=1.0.1">
<link rel="stylesheet" href="/assets/css/produccion-workspace-professional-v1.css?v=1.0.0">

<div class="pw-page">
<div class="production-toolbar pw-hero">
  <div>
    <span class="eyebrow">PRODUCCIÓN · KANBAN</span>
    <h2>Producción</h2>
    <p class="muted">Visualiza el flujo del taller y abre cada orden para actualizar su etapa, archivos y seguimiento.</p>
  </div>

  <div class="production-actions">
    <a class="btn btn-secondary" href="/admin/ordenes.php">Órdenes</a>
    <a class="btn btn-secondary" href="/admin/produccion_historial.php">📚 Historial finalizadas</a>
    <a class="btn btn-primary" href="/admin/produccion.php">↻ Actualizar</a>
  </div>
</div>

<?php if($error): ?>
  <div class="notice danger"><?=e($error)?></div>
<?php endif; ?>

<?php if(isset($_GET['updated'])): ?>
  <div class="notice"><span class="ok">✓</span> Etapa de producción actualizada.</div>
<?php endif; ?>

<div class="pw-stage-summary" aria-label="Resumen de producción">
  <?php foreach($columns as $stage=>$meta): ?>
    <a class="pw-stage-chip <?=$filter===$stage?'is-active':''?>"
       href="/admin/produccion.php?stage=<?=e($stage)?><?= $q!=='' ? '&q='.rawurlencode($q) : '' ?>">
      <span><?=e($meta['icon'])?></span>
      <b><?=e($meta['label'])?></b>
      <strong><?=count($grouped[$stage])?></strong>
    </a>
  <?php endforeach; ?>
</div>

<div class="card production-filters pw-filters">
  <form method="get">
    <div class="production-filter-row">
      <div class="field">
        <label for="productionSearch">Buscar</label>
        <input id="productionSearch" name="q" value="<?=e($q)?>" placeholder="Orden, cotización o cliente">
      </div>

      <div class="field">
        <label for="productionStage">Filtrar etapa</label>
        <select id="productionStage" name="stage">
          <option value="">Todas</option>
          <?php foreach($columns as $k=>$v): ?>
            <option value="<?=e($k)?>" <?=$filter===$k?'selected':''?>>
              <?=e($v['icon'].' '.$v['label'])?>
            </option>
          <?php endforeach; ?>
        </select>
      </div>

      <div class="filter-actions">
        <button class="btn btn-secondary" type="submit">Filtrar</button>
        <a class="btn btn-secondary" href="/admin/produccion.php">Limpiar</a>
      </div>
    </div>
  </form>
</div>

<div class="pw-mobile-hint no-print">
  <span>Desliza entre etapas</span>
  <b>← →</b>
</div>

<div class="kanban-board pw-kanban">
<?php foreach($columns as $stage=>$meta): ?>
  <section class="kanban-column stage-<?=e($stage)?>" id="stage-<?=e($stage)?>">
    <div class="kanban-column-head">
      <div>
        <span class="stage-icon"><?=e($meta['icon'])?></span>
        <strong><?=e($meta['label'])?></strong>
      </div>
      <span class="count-pill"><?=count($grouped[$stage])?></span>
    </div>

    <div class="kanban-list">
    <?php if(!$grouped[$stage]): ?>
      <div class="kanban-empty">
        <span>Sin órdenes</span>
        <small>No hay trabajos actualmente en esta etapa.</small>
      </div>
    <?php else: foreach($grouped[$stage] as $o): ?>
      <?php
        $isOverdue=!empty($o['due_date'])
            && strtotime((string)$o['due_date'].' 23:59:59') < time();
      ?>
      <article class="kanban-card<?=$isOverdue?' is-overdue':''?>">
        <div class="kanban-card-top">
          <a href="/admin/produccion_orden.php?id=<?=((int)$o['id'])?>"><?=e($o['order_number'])?></a>
          <span class="pw-card-stage" title="<?=e($meta['label'])?>"><?=e($meta['icon'])?></span>
        </div>

        <div class="pw-card-client">
          <strong><?=e($o['customer_name'] ?? 'Sin cliente')?></strong>
          <small><?=e($o['quote_number'] ?? 'Sin cotización')?></small>
        </div>

        <div class="pw-card-meta">
          <div>
            <span>Total</span>
            <strong><?=quote_money((float)$o['total'])?></strong>
          </div>

          <div>
            <span>Responsable</span>
            <strong><?=e($o['responsible_name'] ?: 'Sin asignar')?></strong>
          </div>
        </div>

        <?php if($o['due_date']): ?>
          <div class="due-line<?=$isOverdue?' overdue':''?>">
            <span>📅 Entrega</span>
            <strong><?=e(date('d/m/Y',strtotime((string)$o['due_date'])))?></strong>
            <?php if($isOverdue): ?><b>VENCIDA</b><?php endif; ?>
          </div>
        <?php else: ?>
          <div class="due-line pw-no-date">
            <span>📅 Entrega</span>
            <strong>Sin fecha</strong>
          </div>
        <?php endif; ?>

        <div class="kanban-card-actions">
          <a class="btn btn-sm btn-secondary" href="/admin/produccion_orden.php?id=<?=((int)$o['id'])?>">
            Abrir orden
          </a>
        </div>
      </article>
    <?php endforeach; endif; ?>
    </div>
  </section>
<?php endforeach; ?>
</div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
