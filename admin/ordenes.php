<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_auth();

$title = 'Órdenes de servicio';
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'cancel') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } else {
        $id = (int)($_POST['id'] ?? 0);
        if ($id > 0) {
            try {
                $pdo = db();
                $pdo->beginTransaction();
                $oldStmt = $pdo->prepare('SELECT status, order_number FROM cp_orders WHERE id=? LIMIT 1');
                $oldStmt->execute([$id]);
                $oldRow = $oldStmt->fetch();
                if (!$oldRow) {
                    throw new RuntimeException('Orden no encontrada.');
                }
                $oldStatus = (string)$oldRow['status'];
                if ($oldStatus === 'cancelled') {
                    $pdo->rollBack();
                    redirect('/admin/ordenes.php?updated=1');
                }
                $uid = (int)(current_user()['id'] ?? 0);
                $pdo->prepare('UPDATE cp_orders SET status=?,updated_by=?,updated_at=NOW() WHERE id=?')
                    ->execute(['cancelled', $uid ?: null, $id]);
                $pdo->prepare('INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at) VALUES(?,?,?,?,?,NOW())')
                    ->execute([$id, $oldStatus, 'cancelled', 'Orden cancelada desde gestión', $uid ?: null]);
                $pdo->commit();
                log_activity('update', 'orders', 'Orden cancelada ' . $oldRow['order_number']);
                redirect('/admin/ordenes.php?updated=1');
            } catch (Throwable $e) {
                if (isset($pdo) && $pdo->inTransaction()) {
                    $pdo->rollBack();
                }
                $error = 'No se pudo cancelar la orden. Verifica el registro seleccionado.';
            }
        }
    }
}

$q = trim((string)($_GET['q'] ?? ''));
$status = (string)($_GET['status'] ?? '');
$from = trim((string)($_GET['from'] ?? ''));
$to = trim((string)($_GET['to'] ?? ''));

$allowedStatuses = order_statuses();
if ($status !== '' && !array_key_exists($status, $allowedStatuses)) {
    $status = '';
}

$where = ['1=1'];
$params = [];
if ($q !== '') {
    $where[] = '(o.order_number LIKE ? OR q.quote_number LIKE ? OR c.name LIKE ? OR c.phone LIKE ?)';
    $like = '%' . $q . '%';
    array_push($params, $like, $like, $like, $like);
}
if ($status !== '') {
    $where[] = 'o.status=?';
    $params[] = $status;
}
if ($from !== '' && preg_match('/^\d{4}-\d{2}-\d{2}$/', $from)) {
    $where[] = 'o.order_date >= ?';
    $params[] = $from;
}
if ($to !== '' && preg_match('/^\d{4}-\d{2}-\d{2}$/', $to)) {
    $where[] = 'o.order_date <= ?';
    $params[] = $to;
}

$sql = 'SELECT o.id,o.order_number,o.order_date,o.due_date,o.status,o.total,o.quote_id,
               q.quote_number,c.name AS customer_name,c.phone AS customer_phone,
               u.name AS responsible_name
        FROM cp_orders o
        LEFT JOIN cp_quotes q ON q.id=o.quote_id
        LEFT JOIN cp_customers c ON c.id=o.customer_id
        LEFT JOIN cp_users u ON u.id=o.responsible_user_id
        WHERE ' . implode(' AND ', $where) . '
        ORDER BY o.id DESC LIMIT 200';

try {
    $st = db()->prepare($sql);
    $st->execute($params);
    $orders = $st->fetchAll();
} catch (Throwable $e) {
    $orders = [];
    $error = $error ?: 'No se pudieron cargar las órdenes. Verifica la estructura de la base de datos.';
}

$counts = ['total' => 0, 'pending' => 0, 'in_progress' => 0, 'completed' => 0, 'delivered' => 0, 'cancelled' => 0];
try {
    $rows = db()->query('SELECT status,COUNT(*) AS total FROM cp_orders GROUP BY status')->fetchAll();
    foreach ($rows as $row) {
        $key = (string)$row['status'];
        if (array_key_exists($key, $counts)) {
            $counts[$key] = (int)$row['total'];
        }
        $counts['total'] += (int)$row['total'];
    }
} catch (Throwable $e) {
    // El listado principal sigue siendo usable aunque el resumen no esté disponible.
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/ordenes.css?v=20260917-stab2">

<div class="order-toolbar">
  <div>
    <span class="eyebrow">GESTIÓN DE ÓRDENES</span>
    <h2>Órdenes de servicio</h2>
    <p class="muted">Controla trabajos, fechas compromiso, responsables y seguimiento del servicio.</p>
  </div>
  <div class="order-toolbar-actions">
    <a class="btn btn-primary" href="/admin/orden_nueva.php">Nueva orden</a>
    <a class="btn btn-secondary" href="/admin/produccion.php">Producción</a>
  </div>
</div>

<?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if (isset($_GET['updated'])): ?><div class="notice"><span class="ok">✓</span> Orden actualizada.</div><?php endif; ?>

<div class="order-summary-grid">
  <div class="order-summary-card"><span>Total</span><strong><?=number_format($counts['total'])?></strong></div>
  <div class="order-summary-card"><span>Pendientes</span><strong><?=number_format($counts['pending'])?></strong></div>
  <div class="order-summary-card"><span>En proceso</span><strong><?=number_format($counts['in_progress'])?></strong></div>
  <div class="order-summary-card"><span>Completadas</span><strong><?=number_format($counts['completed'])?></strong></div>
  <div class="order-summary-card"><span>Entregadas</span><strong><?=number_format($counts['delivered'])?></strong></div>
</div>

<div class="card order-filters">
<form method="get">
  <div class="filter-row">
    <div class="field"><label for="orderSearch">Buscar</label><input id="orderSearch" name="q" value="<?=e($q)?>" placeholder="Orden, cotización, cliente o teléfono"></div>
    <div class="field"><label for="orderStatus">Estado</label><select id="orderStatus" name="status"><option value="">Todos</option><?php foreach ($allowedStatuses as $k => $label): ?><option value="<?=e($k)?>" <?=$status === $k ? 'selected' : ''?>><?=e($label)?></option><?php endforeach; ?></select></div>
    <div class="field"><label for="from">Desde</label><input id="from" type="date" name="from" value="<?=e($from)?>"></div>
    <div class="field"><label for="to">Hasta</label><input id="to" type="date" name="to" value="<?=e($to)?>"></div>
    <div class="filter-actions"><button class="btn btn-secondary" type="submit">Buscar</button><a class="btn btn-secondary" href="/admin/ordenes.php">Limpiar</a></div>
  </div>
</form>
</div>

<div class="card order-table-card">
<div class="section-heading"><div><span class="eyebrow">REGISTROS</span><h3>Órdenes</h3></div><span class="count-pill"><?=count($orders)?></span></div>
<div class="table-wrap"><table class="table order-table"><thead><tr><th>Orden</th><th>Cliente</th><th>Cotización</th><th>Fecha</th><th>Entrega</th><th>Responsable</th><th>Estado</th><th>Total</th><th>Acciones</th></tr></thead><tbody>
<?php if (!$orders): ?><tr><td colspan="9" class="empty">No hay órdenes que coincidan con los filtros actuales.</td></tr>
<?php else: foreach ($orders as $row): ?>
<tr>
<td><a class="order-number" href="/admin/orden.php?id=<?=((int)$row['id'])?>"><?=e($row['order_number'])?></a></td>
<td><strong><?=e($row['customer_name'] ?: 'Sin cliente')?></strong><?php if (!empty($row['customer_phone'])): ?><small class="table-subtext"><?=e($row['customer_phone'])?></small><?php endif; ?></td>
<td><?php if (!empty($row['quote_id'])): ?><a href="/admin/cotizacion.php?id=<?=((int)$row['quote_id'])?>"><?=e($row['quote_number'])?></a><?php else: ?>—<?php endif; ?></td>
<td><?=e(date('d/m/Y', strtotime((string)$row['order_date'])))?></td>
<td><?=!empty($row['due_date']) ? e(date('d/m/Y', strtotime((string)$row['due_date']))) : '—'?></td>
<td><?=e($row['responsible_name'] ?: 'Sin asignar')?></td>
<td><span class="status-badge order-status-<?=e((string)$row['status'])?>"><?=e(order_status_label((string)$row['status']))?></span></td>
<td class="money-cell"><?=quote_money((float)$row['total'])?></td>
<td class="actions-cell"><a class="btn btn-sm btn-secondary" href="/admin/orden.php?id=<?=((int)$row['id'])?>">Ver</a><a class="btn btn-sm btn-secondary" href="/admin/orden.php?id=<?=((int)$row['id'])?>#seguimiento">Seguimiento</a><?php if ((string)$row['status'] !== 'delivered' && (string)$row['status'] !== 'cancelled'): ?><form method="post" class="inline-form" onsubmit="return confirm('¿Cancelar esta orden?');"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="cancel"><input type="hidden" name="id" value="<?=((int)$row['id'])?>"><button class="btn btn-sm btn-danger" type="submit">Cancelar</button></form><?php endif; ?></td>
</tr>
<?php endforeach; endif; ?></tbody></table></div></div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
