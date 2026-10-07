<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/produccion.php';
require_auth();
$title='Producción';
$error=null;

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf'] ?? null)) $error='La sesión del formulario expiró. Recarga la página.';
    elseif(($_POST['action'] ?? '')==='move'){
        $id=(int)($_POST['id'] ?? 0); $stage=(string)($_POST['stage'] ?? ''); $note=trim((string)($_POST['note'] ?? ''));
        try { if($id<1) throw new RuntimeException('Orden inválida.'); production_set_stage($id,$stage,$note); log_activity('update','production','Etapa actualizada para orden #'.$id); header('Location: /admin/produccion.php?updated=1'); exit; }
        catch(Throwable $e){ $error=$e->getMessage()==='Etapa de producción no válida.'?$e->getMessage():'No se pudo actualizar la etapa.'; }
    }
}

$q=trim((string)($_GET['q'] ?? ''));
$filter=(string)($_GET['stage'] ?? '');
$orders=production_orders($q,$filter);
$columns=production_stages();
unset($columns['cancelled'], $columns['delivered']);
$grouped=[]; foreach(array_keys($columns) as $k) $grouped[$k]=[];
foreach($orders as $o){ $s=(string)$o['production_stage']; if(isset($grouped[$s])) $grouped[$s][]=$o; }
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/produccion.css?v=20260917-11">
<div class="production-toolbar">
  <div><span class="eyebrow">FASE 9 · PRODUCCIÓN KANBAN</span><h2>Producción</h2><p class="muted">Visualiza y mueve las órdenes de servicio por cada etapa del trabajo.</p></div>
  <div class="production-actions"><a class="btn btn-secondary" href="/admin/ordenes.php">Órdenes</a><a class="btn btn-secondary" href="/admin/produccion_historial.php">📚 Historial finalizadas</a><a class="btn btn-primary" href="/admin/produccion.php">Actualizar</a></div>
</div>
<?php if($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if(isset($_GET['updated'])): ?><div class="notice"><span class="ok">✓</span> Etapa de producción actualizada.</div><?php endif; ?>
<div class="card production-filters"><form method="get"><div class="production-filter-row"><div class="field"><label>Buscar</label><input name="q" value="<?=e($q)?>" placeholder="Orden, cotización o cliente"></div><div class="field"><label>Filtrar etapa</label><select name="stage"><option value="">Todas</option><?php foreach($columns as $k=>$v): ?><option value="<?=e($k)?>" <?=$filter===$k?'selected':''?>><?=e($v['icon'].' '.$v['label'])?></option><?php endforeach; ?></select></div><div class="filter-actions"><button class="btn btn-secondary" type="submit">Filtrar</button><a class="btn btn-secondary" href="/admin/produccion.php">Limpiar</a></div></div></form></div>
<div class="kanban-board">
<?php foreach($columns as $stage=>$meta): ?>
<section class="kanban-column stage-<?=e($stage)?>">
  <div class="kanban-column-head"><div><span class="stage-icon"><?=e($meta['icon'])?></span><strong><?=e($meta['label'])?></strong></div><span class="count-pill"><?=count($grouped[$stage])?></span></div>
  <div class="kanban-list">
  <?php if(!$grouped[$stage]): ?><div class="kanban-empty">Sin órdenes</div><?php else: foreach($grouped[$stage] as $o): ?>
    <?php $isOverdue=!empty($o['due_date']) && strtotime((string)$o['due_date'].' 23:59:59') < time(); ?>
    <article class="kanban-card<?=$isOverdue?' is-overdue':''?>">
      <div class="kanban-card-top"><a href="/admin/produccion_orden.php?id=<?=((int)$o['id'])?>"><?=e($o['order_number'])?></a><span><?=e($meta['icon'])?></span></div>
      <strong><?=e($o['customer_name'] ?? 'Sin cliente')?></strong>
      <small><?=e($o['quote_number'] ?? 'Sin cotización')?> · <?=quote_money((float)$o['total'])?></small>
      <?php if($o['due_date']): ?><div class="due-line<?=$isOverdue?' overdue':''?>">📅 <?=e(date('d/m/Y',strtotime((string)$o['due_date'])))?><?=$isOverdue?' · Vencida':''?></div><?php endif; ?>
      <div class="kanban-card-actions"><a class="btn btn-sm btn-secondary" href="/admin/produccion_orden.php?id=<?=((int)$o['id'])?>">Abrir</a></div>
    </article>
  <?php endforeach; endif; ?>
  </div>
</section>
<?php endforeach; ?>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
