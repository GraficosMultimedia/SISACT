<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_auth();

// Estas pantallas dependen de filtros y estados en tiempo real.
if(!headers_sent()){
    header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
    header('Pragma: no-cache');
    header('Expires: 0');
}

$title='Cotizaciones';
$error=null;

if ($_SERVER['REQUEST_METHOD']==='POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error='La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['action'] ?? '') === 'delete') {
        $id=(int)($_POST['id']??0);
        if($id>0){
            try {
                $stmt=db()->prepare('DELETE FROM cp_quotes WHERE id=?');
                $stmt->execute([$id]);
                log_activity('delete','quotes','Cotización eliminada #' . $id);
                redirect('/admin/cotizaciones.php?deleted=1');
            } catch(Throwable $e) {
                $error='No se pudo eliminar la cotización. Si ya está relacionada con una orden, primero gestiona esa orden.';
            }
        }
    }
}

$q=trim((string)($_GET['q']??''));
$status=(string)($_GET['status']??'');
$view=(string)($_GET['view']??'list');
if(!in_array($view,['list','grid'],true)) $view='list';

$statusFilters=[
    ''=>'Todas',
    'approved'=>'Aprobadas',
    'sent'=>'En espera',
    'draft'=>'Borradores',
    'rejected'=>'Rechazadas',
    'expired'=>'Vencidas',
    'cancelled'=>'Canceladas',
];

$sql='SELECT q.*, c.name AS customer_name, t.total, t.internal_cost, t.profit
      FROM cp_quotes q
      LEFT JOIN cp_customers c ON c.id=q.customer_id
      LEFT JOIN cp_quote_totals t ON t.quote_id=q.id
      WHERE 1=1';
$params=[];
if($q!==''){
    $sql.=' AND (q.quote_number LIKE ? OR c.name LIKE ? OR q.notes LIKE ?)';
    $params[]='%'.$q.'%';
    $params[]='%'.$q.'%';
    $params[]='%'.$q.'%';
}
if(array_key_exists($status,$statusFilters) && $status!==''){
    $sql.=' AND q.status=?';
    $params[]=$status;
}
$sql.=' ORDER BY q.id DESC LIMIT 200';
$stmt=db()->prepare($sql);
$stmt->execute($params);
$quotes=$stmt->fetchAll();
$pending=!empty($_SESSION['cp_pending_quote']);

function quote_list_url(array $changes=[]): string {
    $params=$_GET;
    foreach($changes as $k=>$v){
        if($v===null || $v==='') unset($params[$k]); else $params[$k]=$v;
    }
    return '/admin/cotizaciones.php'.($params?'?'.http_build_query($params):'');
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizaciones.css?v=20260917-10">

<div class="quote-toolbar">
  <div>
    <span class="eyebrow">FASE 5 · COTIZACIONES</span>
    <h2>Gestión de cotizaciones</h2>
    <p class="muted">Consulta, filtra y administra todas las cotizaciones comerciales desde un solo lugar.</p>
  </div>
  <div class="quote-toolbar-actions">
    <?=action_button('Nueva cotización','/admin/cotizacion_nueva.php','btn btn-primary')?>
    <?php if($pending): ?><?=action_button('Usar cálculo pendiente','/admin/cotizacion_nueva.php?from=calculator','btn btn-secondary')?><?php endif; ?>
  </div>
</div>

<?php if($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if(isset($_GET['saved'])): ?><div class="notice"><span class="ok">✓</span> Cotización guardada correctamente.</div><?php endif; ?>
<?php if(isset($_GET['deleted'])): ?><div class="notice"><span class="ok">✓</span> Cotización eliminada.</div><?php endif; ?>

<div class="card quote-control-panel">
  <form method="get" class="quote-filter-form">
    <div class="quote-search-field field">
      <label for="quoteSearch">Buscar</label>
      <input id="quoteSearch" name="q" value="<?=e($q)?>" placeholder="Folio, cliente o notas">
    </div>
    <div class="quote-status-field field">
      <label for="quoteStatus">Estado</label>
      <select id="quoteStatus" name="status">
        <?php foreach($statusFilters as $key=>$label): ?>
          <option value="<?=e($key)?>" <?=$status===$key?'selected':''?>><?=e($label)?></option>
        <?php endforeach; ?>
      </select>
    </div>
    <input type="hidden" name="view" value="<?=e($view)?>">
    <div class="filter-actions">
      <button class="btn btn-primary" type="submit">Buscar</button>
      <a class="btn btn-secondary" href="/admin/cotizaciones.php">Limpiar</a>
    </div>
  </form>

  <div class="quote-filter-bar">
    <div class="quick-filters">
      <span class="quick-label">Filtros rápidos</span>
      <?php foreach($statusFilters as $key=>$label): ?>
        <a class="filter-chip <?=$status===$key?'is-active':''?>" href="<?=e(quote_list_url(['status'=>$key,'view'=>$view]))?>"><?=e($label)?></a>
      <?php endforeach; ?>
    </div>
    <div class="view-switch" aria-label="Vista">
      <span class="quick-label">Vista</span>
      <a class="view-btn <?=$view==='list'?'is-active':''?>" href="<?=e(quote_list_url(['view'=>'list']))?>" title="Vista de lista">☷ Lista</a>
      <a class="view-btn <?=$view==='grid'?'is-active':''?>" href="<?=e(quote_list_url(['view'=>'grid']))?>" title="Vista de cuadrícula">▦ Cuadros</a>
    </div>
  </div>
</div>

<div class="card quote-results-card">
  <div class="section-heading">
    <div>
      <span class="eyebrow">REGISTROS</span>
      <h3><?=e($statusFilters[$status] ?? 'Cotizaciones')?></h3>
      <?php if($q!==''): ?><p class="muted result-context">Resultados para: <strong><?=e($q)?></strong></p><?php endif; ?>
    </div>
    <span class="count-pill"><?=count($quotes)?></span>
  </div>

  <?php if(!$quotes): ?>
    <div class="empty quote-empty">
      <div class="empty-icon">🧾</div>
      <strong>No hay cotizaciones para estos filtros.</strong>
      <p>Prueba con otro estado o limpia la búsqueda para ver todos los registros.</p>
      <a class="btn btn-secondary" href="/admin/cotizaciones.php">Ver todas</a>
    </div>
  <?php elseif($view==='grid'): ?>
    <div class="quote-grid">
      <?php foreach($quotes as $row):
        $rowStatus=(string)$row['status'];
        $isApproved=$rowStatus==='approved';
      ?>
      <article class="quote-card <?= $isApproved?'quote-card-approved':'' ?>">
        <div class="quote-card-top">
          <div>
            <span class="quote-card-source"><?=e(quote_source_label($row['source_calculator']))?></span>
            <a class="quote-number" href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>"><?=e($row['quote_number'])?></a>
          </div>
          <span class="status-badge status-<?=e($rowStatus)?>"><?=e(quote_status_label($rowStatus))?></span>
        </div>
        <div class="quote-card-customer">
          <span class="quote-meta-label">CLIENTE</span>
          <strong><?=e($row['customer_name']??'Sin cliente')?></strong>
        </div>
        <div class="quote-card-details">
          <div><small>Fecha</small><strong><?=e(date('d/m/Y',strtotime((string)$row['issue_date'])))?></strong></div>
          <div><small>Vigencia</small><strong><?=!empty($row['valid_until'])?e(date('d/m/Y',strtotime((string)$row['valid_until']))):'—'?></strong></div>
        </div>
        <div class="quote-card-bottom">
          <div><small>Total</small><strong class="quote-card-total"><?=quote_money((float)($row['total']??0))?></strong></div>
          <div class="actions quote-card-actions">
            <a class="btn btn-sm btn-secondary" href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>">Ver</a>
            <a class="btn btn-sm btn-edit" href="/admin/cotizacion_nueva.php?id=<?=((int)$row['id'])?>">Editar</a>
          </div>
        </div>
        <?php if($isApproved): ?><div class="approved-hint">✓ Disponible para crear orden de servicio</div><?php endif; ?>
      </article>
      <?php endforeach; ?>
    </div>
  <?php else: ?>
    <div class="table-wrap">
      <table class="table quote-table">
        <thead><tr><th>Folio</th><th>Cliente</th><th>Fecha</th><th>Vigencia</th><th>Estado</th><th>Total</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach($quotes as $row): ?>
          <tr>
            <td>
              <a class="quote-number" href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>"><?=e($row['quote_number'])?></a>
              <small><?=e(quote_source_label($row['source_calculator']))?></small>
            </td>
            <td><?=e($row['customer_name']??'Sin cliente')?></td>
            <td><?=e(date('d/m/Y',strtotime((string)$row['issue_date'])))?></td>
            <td><?=!empty($row['valid_until'])?e(date('d/m/Y',strtotime((string)$row['valid_until']))):'—'?></td>
            <td><span class="status-badge status-<?=e((string)$row['status'])?>"><?=e(quote_status_label((string)$row['status']))?></span></td>
            <td class="money-cell"><?=quote_money((float)($row['total']??0))?></td>
            <td class="actions-cell">
              <a class="btn btn-sm btn-secondary" href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>">Ver</a>
              <a class="btn btn-sm btn-edit" href="/admin/cotizacion_nueva.php?id=<?=((int)$row['id'])?>">Editar</a>
              <form class="inline-form" method="post" onsubmit="return confirm('¿Seguro que deseas borrar esta cotización?');">
                <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<?=((int)$row['id'])?>">
                <button class="btn btn-sm btn-delete" type="submit">Borrar</button>
              </form>
            </td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>
  <?php endif; ?>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
