<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_auth();

$title = 'Facturación';
$error = null;
$success = null;
$editId = (int)($_GET['edit'] ?? 0);
$selectedOrderId = (int)($_GET['order_id'] ?? 0);
$editing = $editId > 0 ? finance_invoice_get($editId) : null;
if ($editing) {
    $selectedOrderId = (int)$editing['order_id'];
}

$invoice = [
    'id' => 0,
    'order_id' => $selectedOrderId,
    'invoice_number' => '',
    'invoice_date' => date('Y-m-d'),
    'subtotal' => '',
    'tax' => '0.00',
    'total' => '',
    'status' => 'draft',
    'cfdi_uuid' => '',
    'notes' => '',
];
if (!$editing) $invoice['invoice_number'] = finance_tables_ready() ? finance_invoice_number_next() : 'F-' . date('Y') . '-00001';
if ($editing) {
    foreach ($invoice as $key => $value) {
        if (array_key_exists($key, $editing)) $invoice[$key] = $editing[$key];
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['action'] ?? '') === 'invoice_save') {
        try {
            $id = (int)($_POST['id'] ?? 0);
            $orderId = (int)($_POST['order_id'] ?? 0);
            $invoiceNumber = trim((string)($_POST['invoice_number'] ?? ''));
            $invoiceDate = trim((string)($_POST['invoice_date'] ?? ''));
            $subtotal = round((float)str_replace(',', '', (string)($_POST['subtotal'] ?? 0)), 2);
            $tax = round((float)str_replace(',', '', (string)($_POST['tax'] ?? 0)), 2);
            $total = round((float)str_replace(',', '', (string)($_POST['total'] ?? 0)), 2);
            $status = (string)($_POST['status'] ?? 'draft');
            $cfdiUuid = trim((string)($_POST['cfdi_uuid'] ?? ''));
            $notes = trim((string)($_POST['notes'] ?? ''));
            $order = order_get($orderId);
            if (!$order) throw new RuntimeException('Selecciona una orden válida.');
            if ($invoiceNumber === '') throw new RuntimeException('El folio de factura es obligatorio.');
            if (!preg_match('/^[A-Za-z0-9._\/-]{2,60}$/', $invoiceNumber)) throw new RuntimeException('El folio de factura contiene caracteres no permitidos.');
            $dt = DateTime::createFromFormat('Y-m-d', $invoiceDate);
            if (!$dt || $dt->format('Y-m-d') !== $invoiceDate) throw new RuntimeException('La fecha de factura no es válida.');
            if ($subtotal < 0 || $tax < 0 || $total < 0) throw new RuntimeException('Los importes no pueden ser negativos.');
            if (!array_key_exists($status, finance_invoice_statuses())) throw new RuntimeException('Estado de factura no válido.');
            if ($cfdiUuid !== '' && strlen($cfdiUuid) > 80) throw new RuntimeException('El UUID fiscal es demasiado largo.');

            $uid = (int)(current_user()['id'] ?? 0);
            $customerId = (int)($order['customer_id'] ?? 0);
            if ($id > 0) {
                $current = finance_invoice_get($id);
                if (!$current) throw new RuntimeException('La factura indicada no existe.');
                db()->prepare('UPDATE cp_invoices SET order_id=?,customer_id=?,invoice_number=?,invoice_date=?,subtotal=?,tax=?,total=?,status=?,cfdi_uuid=?,notes=?,updated_by=?,updated_at=NOW() WHERE id=?')
                    ->execute([$orderId, $customerId ?: null, $invoiceNumber, $invoiceDate, $subtotal, $tax, $total, $status, $cfdiUuid ?: null, $notes ?: null, $uid ?: null, $id]);
                log_activity('update', 'invoices', 'Factura actualizada #' . $id);
            } else {
                db()->prepare('INSERT INTO cp_invoices(order_id,customer_id,invoice_number,invoice_date,subtotal,tax,total,status,cfdi_uuid,notes,created_by,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())')
                    ->execute([$orderId, $customerId ?: null, $invoiceNumber, $invoiceDate, $subtotal, $tax, $total, $status, $cfdiUuid ?: null, $notes ?: null, $uid ?: null, $uid ?: null]);
                $id = (int)db()->lastInsertId();
                log_activity('create', 'invoices', 'Factura registrada #' . $id);
            }
            redirect('/admin/facturacion.php?order_id=' . $orderId . '&saved=1');
        } catch (Throwable $e) {
            $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo guardar la factura.';
            foreach ($invoice as $key => $value) {
                if (array_key_exists($key, $_POST)) $invoice[$key] = (string)$_POST[$key];
            }
            $selectedOrderId = (int)($invoice['order_id'] ?? 0);
        }
    }
}

if (isset($_GET['saved'])) $success = 'Registro de facturación guardado correctamente.';
$tablesReady = finance_tables_ready();
$orders = $tablesReady ? finance_order_options() : [];
$invoices = $tablesReady ? finance_invoice_list() : [];
$orderSelected = $selectedOrderId > 0 ? order_get($selectedOrderId) : null;
$summary = $selectedOrderId > 0 && $tablesReady ? finance_order_summary($selectedOrderId) : null;

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/finanzas.css?v=20260917-1">
<div class="finance-toolbar">
  <div><span class="eyebrow">FASE 10 · FACTURACIÓN</span><h2>Facturación y documentos</h2><p class="muted">Control interno de facturas y datos fiscales relacionados con cada orden.</p></div>
  <div class="finance-actions"><a class="btn btn-secondary" href="/admin/pagos.php">💰 Pagos</a></div>
</div>

<?php if (!$tablesReady): ?>
<div class="notice danger">La estructura financiera todavía no está instalada. Ejecuta <strong>database/migrations/012_fase10_pagos_facturacion.sql</strong> en la base <strong>colibrip_abcsistema</strong>.</div>
<?php else: ?>
<div class="notice finance-disclaimer">🧾 Este módulo registra información administrativa de facturación. No genera, timbra ni sustituye un CFDI del SAT.</div>
<?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if ($success): ?><div class="notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<div class="finance-grid">
<section class="card">
  <div class="section-heading"><div><span class="eyebrow">REGISTRAR</span><h3><?=$editing?'Editar registro':'Nuevo registro'?></h3></div></div>
  <form method="post" class="finance-form">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="action" value="invoice_save">
    <input type="hidden" name="id" value="<?=((int)$invoice['id'])?>">
    <div class="form-grid">
      <div class="field full"><label>Orden de servicio <span class="required">*</span></label>
        <select name="order_id" id="invoice_order_id" required>
          <option value="">Selecciona una orden…</option>
          <?php foreach ($orders as $o): ?><option value="<?=((int)$o['id'])?>" data-total="<?=e((string)$o['total'])?>" <?=((int)$invoice['order_id']===(int)$o['id']?'selected':'')?>><?=e($o['order_number'])?> · <?=e($o['customer_name'] ?: 'Sin cliente')?> · Orden $<?=number_format((float)$o['total'],2,'.',',')?></option><?php endforeach; ?>
        </select>
      </div>
      <div class="field"><label>Folio <span class="required">*</span></label><input name="invoice_number" maxlength="60" value="<?=e((string)$invoice['invoice_number'])?>" required></div>
      <div class="field"><label>Fecha <span class="required">*</span></label><input type="date" name="invoice_date" value="<?=e((string)$invoice['invoice_date'])?>" required></div>
      <div class="field"><label>Subtotal</label><input type="number" name="subtotal" id="invoice_subtotal" min="0" step="0.01" value="<?=e((string)$invoice['subtotal'])?>"></div>
      <div class="field"><label>Impuesto</label><input type="number" name="tax" id="invoice_tax" min="0" step="0.01" value="<?=e((string)$invoice['tax'])?>"></div>
      <div class="field"><label>Total <span class="required">*</span></label><input type="number" name="total" id="invoice_total" min="0" step="0.01" value="<?=e((string)$invoice['total'])?>" required></div>
      <div class="field"><label>Estado</label><select name="status"><?php foreach(finance_invoice_statuses() as $k=>$label): ?><option value="<?=e($k)?>" <?=$invoice['status']===$k?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select></div>
      <div class="field full"><label>UUID / folio fiscal (opcional)</label><input name="cfdi_uuid" maxlength="80" value="<?=e((string)$invoice['cfdi_uuid'])?>" placeholder="Captúralo cuando exista un CFDI timbrado externamente."></div>
      <div class="field full"><label>Notas</label><textarea name="notes" rows="4" maxlength="1500" placeholder="Notas administrativas…"><?=e((string)$invoice['notes'])?></textarea></div>
    </div>
    <div class="form-actions"><a class="btn btn-cancel" href="/admin/facturacion.php<?= $selectedOrderId>0?'?order_id='.((int)$selectedOrderId):'' ?>">Limpiar</a><button class="btn btn-save" type="submit">Guardar facturación</button></div>
  </form>
</section>

<section class="card">
  <div class="section-heading"><div><span class="eyebrow">ORDEN SELECCIONADA</span><h3><?= $orderSelected ? e($orderSelected['order_number']) : 'Elige una orden' ?></h3></div></div>
  <?php if ($orderSelected && $summary): ?>
  <div class="balance-box"><div><span>Total orden</span><strong>$<?=number_format($summary['order_total'],2,'.',',')?></strong></div><div><span>Pagado</span><strong class="positive">$<?=number_format($summary['paid_total'],2,'.',',')?></strong></div><div><span>Saldo</span><strong class="pending">$<?=number_format($summary['balance'],2,'.',',')?></strong></div></div>
  <p class="help-text">Cliente: <?=e($orderSelected['customer_name'] ?? 'Sin cliente')?> · Facturas registradas: <?=((int)$summary['invoice_count'])?></p>
  <?php else: ?><p class="empty">Selecciona una orden para revisar su información financiera.</p><?php endif; ?>
</section>
</div>

<section class="card">
  <div class="section-heading"><div><span class="eyebrow">HISTORIAL</span><h3>Registros de facturación</h3></div></div>
  <div class="table-wrap"><table class="table finance-table"><thead><tr><th>Fecha</th><th>Folio</th><th>Orden</th><th>Cliente</th><th>Total</th><th>Estado</th><th>UUID</th><th></th></tr></thead><tbody>
  <?php if (!$invoices): ?><tr><td colspan="8" class="empty">No hay registros de facturación.</td></tr>
  <?php else: foreach($invoices as $i): ?><tr>
    <td><?=e(date('d/m/Y',strtotime((string)$i['invoice_date'])))?></td>
    <td><strong><?=e($i['invoice_number'])?></strong></td>
    <td><a href="/admin/orden.php?id=<?=((int)$i['order_id'])?>"><?=e($i['order_number'])?></a></td>
    <td><?=e($i['customer_name'] ?: 'Sin cliente')?></td>
    <td class="amount-cell">$<?=number_format((float)$i['total'],2,'.',',')?></td>
    <td><span class="finance-badge <?=($i['status']==='issued'?'is-ok':($i['status']==='cancelled'?'is-danger':'is-neutral'))?>"><?=e(finance_invoice_statuses()[$i['status']] ?? $i['status'])?></span></td>
    <td class="uuid-cell"><?=e($i['cfdi_uuid'] ?: '—')?></td>
    <td><a class="btn btn-sm btn-secondary" href="/admin/facturacion.php?edit=<?=((int)$i['id'])?>">Editar</a></td>
  </tr><?php endforeach; endif; ?>
  </tbody></table></div>
</section>

<script>
(function(){
  const order=document.getElementById('invoice_order_id');
  const subtotal=document.getElementById('invoice_subtotal');
  const tax=document.getElementById('invoice_tax');
  const total=document.getElementById('invoice_total');
  if(!order||!subtotal||!tax||!total) return;
  order.addEventListener('change', function(){
    const option=order.options[order.selectedIndex];
    const value=parseFloat(option && option.dataset.total ? option.dataset.total : '0');
    if(!<?= $editing ? 'true' : 'false' ?> && value>0){ subtotal.value=value.toFixed(2); tax.value='0.00'; total.value=value.toFixed(2); }
  });
  function calc(){
    const s=parseFloat(subtotal.value||'0')||0;
    const t=parseFloat(tax.value||'0')||0;
    total.value=(s+t).toFixed(2);
  }
  subtotal.addEventListener('input',calc);
  tax.addEventListener('input',calc);
})();
</script>
<?php endif; ?>
<?php require __DIR__ . '/../includes/footer.php'; ?>
