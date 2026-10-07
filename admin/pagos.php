<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_auth();

$title = 'Pagos';
$error = null;
$success = null;
$selectedOrderId = (int)($_GET['order_id'] ?? 0);
$editId = (int)($_GET['edit'] ?? 0);
$editing = $editId > 0 ? finance_payment_get($editId) : null;
if ($editing) $selectedOrderId = (int)$editing['order_id'];

$payment = [
    'id' => 0,
    'order_id' => $selectedOrderId,
    'amount' => '',
    'payment_date' => date('Y-m-d'),
    'method' => 'transfer',
    'reference' => '',
    'note' => '',
    'status' => 'confirmed',
];
if ($editing) {
    foreach ($payment as $key => $value) {
        if (array_key_exists($key, $editing)) $payment[$key] = $editing[$key];
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['action'] ?? '') === 'payment_save') {
        try {
            $id = (int)($_POST['id'] ?? 0);
            $orderId = (int)($_POST['order_id'] ?? 0);
            $amount = round((float)str_replace(',', '', (string)($_POST['amount'] ?? 0)), 2);
            $paymentDate = trim((string)($_POST['payment_date'] ?? ''));
            $method = (string)($_POST['method'] ?? 'other');
            $reference = trim((string)($_POST['reference'] ?? ''));
            $note = trim((string)($_POST['note'] ?? ''));
            $status = (string)($_POST['status'] ?? 'confirmed');
            if ($orderId <= 0 || !order_get($orderId)) throw new RuntimeException('Selecciona una orden válida.');
            if ($amount <= 0) throw new RuntimeException('El monto del pago debe ser mayor a $0.00.');
            $dt = DateTime::createFromFormat('Y-m-d', $paymentDate);
            if (!$dt || $dt->format('Y-m-d') !== $paymentDate) throw new RuntimeException('La fecha del pago no es válida.');
            if (!array_key_exists($method, finance_payment_methods())) throw new RuntimeException('Método de pago no válido.');
            if (!array_key_exists($status, finance_payment_statuses())) throw new RuntimeException('Estado del pago no válido.');

            $summary = finance_order_summary($orderId);
            $existing = 0.0;
            if ($id > 0) {
                $current = finance_payment_get($id);
                if (!$current || (int)$current['order_id'] !== $orderId) throw new RuntimeException('El pago indicado no existe.');
                if ((string)$current['status'] === 'confirmed') $existing = (float)$current['amount'];
            }
            if ($status === 'confirmed') {
                $available = max(0.0, $summary['balance'] + $existing);
                if ($amount > $available + 0.009) {
                    throw new RuntimeException('El pago supera el saldo pendiente de la orden. Saldo disponible: $' . number_format($available, 2, '.', ','));
                }
            }

            $uid = (int)(current_user()['id'] ?? 0);
            if ($id > 0) {
                db()->prepare('UPDATE cp_payments SET order_id=?,customer_id=(SELECT customer_id FROM cp_orders WHERE id=?),amount=?,payment_date=?,method=?,reference=?,note=?,status=?,updated_by=?,updated_at=NOW() WHERE id=?')
                    ->execute([$orderId, $orderId, $amount, $paymentDate, $method, $reference ?: null, $note ?: null, $status, $uid ?: null, $id]);
                log_activity('update', 'payments', 'Pago actualizado #' . $id);
            } else {
                $customerId = (int)(db()->query('SELECT customer_id FROM cp_orders WHERE id=' . $orderId)->fetchColumn() ?: 0);
                db()->prepare('INSERT INTO cp_payments(order_id,customer_id,amount,payment_date,method,reference,note,status,created_by,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,NOW(),NOW())')
                    ->execute([$orderId, $customerId ?: null, $amount, $paymentDate, $method, $reference ?: null, $note ?: null, $status, $uid ?: null, $uid ?: null]);
                $id = (int)db()->lastInsertId();
                log_activity('create', 'payments', 'Pago registrado #' . $id);
            }
            redirect('/admin/pagos.php?order_id=' . $orderId . '&saved=1');
        } catch (Throwable $e) {
            $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo guardar el pago.';
            $payment['order_id'] = (int)($_POST['order_id'] ?? 0);
            $payment['amount'] = (string)($_POST['amount'] ?? '');
            $payment['payment_date'] = (string)($_POST['payment_date'] ?? date('Y-m-d'));
            $payment['method'] = (string)($_POST['method'] ?? 'transfer');
            $payment['reference'] = (string)($_POST['reference'] ?? '');
            $payment['note'] = (string)($_POST['note'] ?? '');
            $payment['status'] = (string)($_POST['status'] ?? 'confirmed');
            $selectedOrderId = (int)$payment['order_id'];
        }
    }
}

if (isset($_GET['saved'])) $success = 'Pago guardado correctamente.';
$tablesReady = finance_tables_ready();
$orders = $tablesReady ? finance_order_options() : [];
$summary = $selectedOrderId > 0 && $tablesReady ? finance_order_summary($selectedOrderId) : null;
$payments = $tablesReady ? finance_payment_list($selectedOrderId > 0 ? $selectedOrderId : null) : [];
$global = $tablesReady ? finance_dashboard_totals() : null;
$orderSelected = $selectedOrderId > 0 ? order_get($selectedOrderId) : null;

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/finanzas.css?v=20260917-1">
<div class="finance-toolbar">
  <div><span class="eyebrow">FASE 10 · PAGOS</span><h2>Pagos y anticipos</h2><p class="muted">Registra cobros, anticipos y saldos por orden de servicio.</p></div>
  <div class="finance-actions"><a class="btn btn-secondary" href="/admin/facturacion.php">🧾 Facturación</a></div>
</div>

<?php if (!$tablesReady): ?>
<div class="notice danger">La estructura financiera todavía no está instalada. Ejecuta <strong>database/migrations/012_fase10_pagos_facturacion.sql</strong> en la base <strong>colibrip_abcsistema</strong>.</div>
<?php else: ?>
<?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if ($success): ?><div class="notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<div class="finance-metrics">
  <article class="finance-metric"><span>Total de órdenes</span><strong>$<?=number_format((float)$global['orders_total'],2,'.',',')?></strong></article>
  <article class="finance-metric"><span>Total cobrado</span><strong>$<?=number_format((float)$global['paid_total'],2,'.',',')?></strong></article>
  <article class="finance-metric"><span>Saldo pendiente</span><strong>$<?=number_format((float)$global['balance_total'],2,'.',',')?></strong></article>
  <article class="finance-metric"><span>Movimientos</span><strong><?=number_format((int)$global['payments_count'])?></strong></article>
</div>

<div class="finance-grid">
<section class="card">
  <div class="section-heading"><div><span class="eyebrow">REGISTRAR</span><h3><?=$editing?'Editar pago':'Nuevo pago'?></h3></div></div>
  <form method="post" class="finance-form">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="action" value="payment_save">
    <input type="hidden" name="id" value="<?=((int)$payment['id'])?>">
    <div class="form-grid">
      <div class="field full"><label>Orden de servicio <span class="required">*</span></label>
        <select name="order_id" required>
          <option value="">Selecciona una orden…</option>
          <?php foreach ($orders as $o): ?><option value="<?=((int)$o['id'])?>" <?=((int)$payment['order_id']===(int)$o['id']?'selected':'')?>><?=e($o['order_number'])?> · <?=e($o['customer_name'] ?: 'Sin cliente')?> · Saldo $<?=number_format(max(0,(float)$o['total']-(float)$o['paid_total']),2,'.',',')?></option><?php endforeach; ?>
        </select>
      </div>
      <div class="field"><label>Monto <span class="required">*</span></label><input type="number" name="amount" min="0.01" step="0.01" value="<?=e((string)$payment['amount'])?>" required></div>
      <div class="field"><label>Fecha <span class="required">*</span></label><input type="date" name="payment_date" value="<?=e((string)$payment['payment_date'])?>" required></div>
      <div class="field"><label>Método</label><select name="method"><?php foreach(finance_payment_methods() as $k=>$label): ?><option value="<?=e($k)?>" <?=$payment['method']===$k?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select></div>
      <div class="field"><label>Estado</label><select name="status"><?php foreach(finance_payment_statuses() as $k=>$label): ?><option value="<?=e($k)?>" <?=$payment['status']===$k?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select></div>
      <div class="field full"><label>Referencia</label><input name="reference" maxlength="190" value="<?=e((string)$payment['reference'])?>" placeholder="Folio, transferencia, ticket…"></div>
      <div class="field full"><label>Nota</label><textarea name="note" rows="4" maxlength="1200" placeholder="Observaciones del cobro…"><?=e((string)$payment['note'])?></textarea></div>
    </div>
    <div class="form-actions"><a class="btn btn-cancel" href="/admin/pagos.php<?= $selectedOrderId>0?'?order_id='.((int)$selectedOrderId):'' ?>">Limpiar</a><button class="btn btn-save" type="submit">Guardar pago</button></div>
  </form>
</section>

<section class="card">
  <div class="section-heading"><div><span class="eyebrow">ORDEN SELECCIONADA</span><h3><?= $orderSelected ? e($orderSelected['order_number']) : 'Elige una orden' ?></h3></div></div>
  <?php if ($summary && $orderSelected): ?>
  <div class="balance-box"><div><span>Total</span><strong>$<?=number_format($summary['order_total'],2,'.',',')?></strong></div><div><span>Pagado</span><strong class="positive">$<?=number_format($summary['paid_total'],2,'.',',')?></strong></div><div><span>Saldo</span><strong class="pending">$<?=number_format($summary['balance'],2,'.',',')?></strong></div></div>
  <p class="help-text">Cliente: <?=e($orderSelected['customer_name'] ?? 'Sin cliente')?></p>
  <?php else: ?><p class="empty">Selecciona una orden para registrar o consultar sus movimientos.</p><?php endif; ?>
</section>
</div>

<section class="card">
  <div class="section-heading"><div><span class="eyebrow">HISTORIAL</span><h3><?= $orderSelected ? 'Pagos de '.$orderSelected['order_number'] : 'Últimos pagos' ?></h3></div></div>
  <div class="table-wrap"><table class="table finance-table"><thead><tr><th>Fecha</th><th>Orden</th><th>Cliente</th><th>Método</th><th>Referencia</th><th>Estado</th><th class="amount-cell">Monto</th><th></th></tr></thead><tbody>
  <?php if (!$payments): ?><tr><td colspan="8" class="empty">No hay pagos registrados.</td></tr>
  <?php else: foreach($payments as $p): ?><tr>
    <td><?=e(date('d/m/Y',strtotime((string)$p['payment_date'])))?></td>
    <td><a href="/admin/pagos.php?order_id=<?=((int)$p['order_id'])?>"><?=e($p['order_number'])?></a></td>
    <td><?=e($p['customer_name'] ?: 'Sin cliente')?></td>
    <td><?=e(finance_payment_methods()[$p['method']] ?? 'Otro')?></td>
    <td><?=e($p['reference'] ?: '—')?></td>
    <td><span class="finance-badge <?=($p['status']==='confirmed'?'is-ok':'is-danger')?>"><?=e(finance_payment_statuses()[$p['status']] ?? $p['status'])?></span></td>
    <td class="amount-cell">$<?=number_format((float)$p['amount'],2,'.',',')?></td>
    <td><a class="btn btn-sm btn-secondary" href="/admin/pagos.php?edit=<?=((int)$p['id'])?>">Editar</a></td>
  </tr><?php endforeach; endif; ?>
  </tbody></table></div>
</section>
<?php endif; ?>
<?php require __DIR__ . '/../includes/footer.php'; ?>
