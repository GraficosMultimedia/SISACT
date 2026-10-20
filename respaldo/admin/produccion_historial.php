<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/produccion.php';
require_auth();

// Estas pantallas dependen de filtros y estados en tiempo real.
if(!headers_sent()){
    header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
    header('Pragma: no-cache');
    header('Expires: 0');
}

$title='Historial de producción';
$error=null;
$q=trim((string)($_GET['q'] ?? ''));
$page=max(1,(int)($_GET['page'] ?? 1));
$perPage=20;
$offset=($page-1)*$perPage;

try {
    $pdo=db();
    $where="(o.status='delivered' OR (COALESCE(s.stage,'pending')='delivered' AND o.status<>'cancelled'))";
    $params=[];
    if($q!==''){
        $where.=" AND (o.order_number LIKE ? OR q.quote_number LIKE ? OR c.name LIKE ?)";
        $like='%'.$q.'%';
        $params=[$like,$like,$like];
    }

    $st=$pdo->prepare("SELECT COUNT(*) FROM cp_orders o
        LEFT JOIN cp_quotes q ON q.id=o.quote_id
        LEFT JOIN cp_customers c ON c.id=o.customer_id
        LEFT JOIN cp_order_status s ON s.order_id=o.id
        WHERE $where");
    $st->execute($params);
    $total=(int)$st->fetchColumn();
    $pages=max(1,(int)ceil($total/$perPage));
    if($page>$pages){$page=$pages;$offset=($page-1)*$perPage;}

    $sql="SELECT o.id,o.order_number,o.order_date,o.due_date,o.total,o.quote_id,o.status,
                 q.quote_number,c.name AS customer_name,
                 u.name AS responsible_name,
                 s.updated_at AS delivered_at
          FROM cp_orders o
          LEFT JOIN cp_quotes q ON q.id=o.quote_id
          LEFT JOIN cp_customers c ON c.id=o.customer_id
          LEFT JOIN cp_users u ON u.id=o.responsible_user_id
          INNER JOIN cp_order_status s ON s.order_id=o.id
          WHERE $where
          ORDER BY s.updated_at DESC,o.id DESC
          LIMIT $perPage OFFSET $offset";
    $st=$pdo->prepare($sql);
    $st->execute($params);
    $orders=$st->fetchAll();
} catch(Throwable $e){
    $orders=[];$total=0;$pages=1;$page=1;
    $error='No se pudo cargar el historial de producción.';
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/produccion.css?v=20260917-7">
<link rel="stylesheet" href="/assets/css/produccion_historial.css?v=20260917-7h">
<div class="production-toolbar">
  <div>
    <span class="eyebrow">FASE 9 · BITÁCORA DE ÓRDENES</span>
    <h2>Órdenes finalizadas</h2>
    <p class="muted">Las órdenes entregadas salen del Kanban y quedan aquí como registro histórico.</p>
  </div>
  <div class="production-actions">
    <a class="btn btn-secondary" href="/admin/produccion.php">← Producción</a>
    <a class="btn btn-secondary" href="/admin/ordenes.php">Órdenes</a>
  </div>
</div>
<?php if($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>

<section class="card production-filters history-filter">
  <form method="get">
    <div class="production-filter-row">
      <div class="field">
        <label>Buscar orden finalizada</label>
        <input name="q" value="<?=e($q)?>" placeholder="Orden, cotización o cliente">
      </div>
      <div class="history-summary">
        <span>REGISTROS</span>
        <strong><?=number_format($total)?></strong>
      </div>
      <div class="filter-actions">
        <button class="btn btn-primary" type="submit">Buscar</button>
        <a class="btn btn-secondary" href="/admin/produccion_historial.php">Limpiar</a>
      </div>
    </div>
  </form>
</section>

<section class="card history-table-card">
  <div class="section-heading">
    <div><span class="eyebrow">HISTORIAL</span><h3>Bitácora de órdenes entregadas</h3></div>
    <span class="history-page">Página <?=number_format($page)?> de <?=number_format($pages)?></span>
  </div>

  <?php if(!$orders): ?>
    <div class="history-empty"><div>📦</div><strong>No hay órdenes finalizadas</strong><p>Cuando una orden pase a <b>Entregado</b>, aparecerá automáticamente en esta bitácora.</p></div>
  <?php else: ?>
    <div class="table-wrap">
      <table class="table production-history-table">
        <thead><tr><th>ORDEN</th><th>CLIENTE</th><th>COTIZACIÓN</th><th>ENTREGADO</th><th>TOTAL</th><th>RESPONSABLE</th><th>ACCIÓN</th></tr></thead>
        <tbody>
        <?php foreach($orders as $o): ?>
          <tr>
            <td><a class="history-order" href="/admin/produccion_orden.php?id=<?=((int)$o['id'])?>"><?=e($o['order_number'])?></a></td>
            <td><?=e($o['customer_name'] ?? 'Sin cliente')?></td>
            <td><?=e($o['quote_number'] ?? 'Sin cotización')?></td>
            <td><?=!empty($o['delivered_at'])?e(date('d/m/Y H:i',strtotime((string)$o['delivered_at']))):'—'?></td>
            <td><strong><?=quote_money((float)$o['total'])?></strong></td>
            <td><?=e($o['responsible_name'] ?? 'Sin asignar')?></td>
            <td><a class="btn btn-sm btn-secondary" href="/admin/produccion_orden.php?id=<?=((int)$o['id'])?>">Ver</a></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table>
    </div>

    <?php if($pages>1): ?>
      <nav class="history-pagination" aria-label="Paginación del historial">
        <?php if($page>1): ?><a class="btn btn-sm btn-secondary" href="?<?=http_build_query(['q'=>$q,'page'=>$page-1])?>">← Anterior</a><?php endif; ?>
        <span>Página <strong><?=number_format($page)?></strong> de <strong><?=number_format($pages)?></strong></span>
        <?php if($page<$pages): ?><a class="btn btn-sm btn-secondary" href="?<?=http_build_query(['q'=>$q,'page'=>$page+1])?>">Siguiente →</a><?php endif; ?>
      </nav>
    <?php endif; ?>
  <?php endif; ?>
</section>
<?php require __DIR__ . '/../includes/footer.php'; ?>
