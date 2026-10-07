<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_once __DIR__ . '/../includes/cfdi.php';
require_auth();

$title = 'Facturación';
$error = null;
$success = null;
$editId = (int)($_GET['edit'] ?? 0);
$editing = $editId > 0 ? finance_invoice_get($editId) : null;

$invoice = [
    'id' => 0,
    'order_id' => 0,
    'invoice_number' => '',
    'invoice_date' => date('Y-m-d'),
    'subtotal' => '',
    'tax' => '0.00',
    'total' => '',
    'status' => 'draft',
    'cfdi_uuid' => '',
    'notes' => '',
];
if ($editing) {
    foreach ($invoice as $key => $value) if (array_key_exists($key, $editing)) $invoice[$key] = $editing[$key];
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = (string)($_POST['action'] ?? '');
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif ($action === 'cfdi_create') {
        try {
            if (!isset($_FILES['xml_file']) || (int)$_FILES['xml_file']['error'] !== UPLOAD_ERR_OK) throw new RuntimeException('Carga el XML CFDI antes de crear el registro.');
            $parsed = cfdi_parse_upload($_FILES['xml_file']);
            $customerId = (int)($_POST['customer_id'] ?? 0);
            $orderId = (int)($_POST['order_id'] ?? 0);
            if ($customerId <= 0) throw new RuntimeException('Selecciona el cliente al que pertenece la factura.');
            if ($orderId <= 0) throw new RuntimeException('Selecciona la orden del cliente que recibirá la factura.');
            $st = db()->prepare('SELECT o.*,c.name AS customer_name FROM cp_orders o LEFT JOIN cp_customers c ON c.id=o.customer_id WHERE o.id=? AND o.customer_id=? LIMIT 1');
            $st->execute([$orderId,$customerId]);
            $order = $st->fetch();
            if (!$order) throw new RuntimeException('La orden seleccionada no pertenece al cliente indicado.');

            $invoiceNumber = trim((string)($parsed['uuid'] ?? ''));
            if ($invoiceNumber === '') $invoiceNumber = trim((string)($_POST['invoice_number'] ?? ''));
            if ($invoiceNumber === '') $invoiceNumber = trim((string)($parsed['internal_number'] ?? ''));
            if ($invoiceNumber === '') $invoiceNumber = finance_invoice_number_next();
            if (!preg_match('/^[A-Za-z0-9._\/-]{2,60}$/', $invoiceNumber)) throw new RuntimeException('El folio de factura no es válido.');

            $invoiceDate = (string)($parsed['invoice_date'] ?? '');
            if ($invoiceDate === '') $invoiceDate = trim((string)($_POST['invoice_date'] ?? ''));
            $dt = DateTime::createFromFormat('Y-m-d', $invoiceDate);
            if (!$dt || $dt->format('Y-m-d') !== $invoiceDate) throw new RuntimeException('Completa una fecha de factura válida.');

            $subtotalRaw = (string)($parsed['subtotal'] ?? '');
            $taxRaw = (string)($parsed['tax'] ?? '');
            $totalRaw = (string)($parsed['total'] ?? '');
            $subtotal = $subtotalRaw !== '' ? (float)$subtotalRaw : round((float)str_replace(',','',(string)($_POST['subtotal'] ?? 0)),2);
            $tax = $taxRaw !== '' ? (float)$taxRaw : round((float)str_replace(',','',(string)($_POST['tax'] ?? 0)),2);
            $total = $totalRaw !== '' ? (float)$totalRaw : round((float)str_replace(',','',(string)($_POST['total'] ?? 0)),2);
            if ($subtotal < 0 || $tax < 0 || $total < 0) throw new RuntimeException('Los importes no pueden ser negativos.');

            $status = $parsed['uuid'] !== '' ? 'issued' : ((string)($_POST['status'] ?? 'draft'));
            if (!array_key_exists($status, finance_invoice_statuses())) $status = 'draft';
            $notes = trim((string)($_POST['notes'] ?? ''));
            $uid = (int)(current_user()['id'] ?? 0);

            $db = db();
            $db->beginTransaction();
            try {
                $st = $db->prepare('INSERT INTO cp_invoices(order_id,customer_id,invoice_number,invoice_date,subtotal,tax,total,status,cfdi_uuid,notes,created_by,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');
                $st->execute([$orderId,$customerId,$invoiceNumber,$invoiceDate,$subtotal,$tax,$total,$status,($parsed['uuid'] ?? '') ?: null,$notes ?: null,$uid ?: null,$uid ?: null]);
                $invoiceId = (int)$db->lastInsertId();
                cfdi_store_parsed_document($invoiceId,$orderId,$parsed,(isset($_FILES['pdf_file']) && (int)$_FILES['pdf_file']['error']===UPLOAD_ERR_OK) ? $_FILES['pdf_file'] : null,$uid);
                log_activity('create','invoices','Factura + CFDI registrados #'.$invoiceId.($parsed['uuid']?' · UUID '.$parsed['uuid']:''));
                $db->commit();
            } catch (Throwable $e) {
                $db->rollBack();
                throw $e;
            }
            redirect('/admin/facturacion.php?order_id='.$orderId.'&created=1');
        } catch (Throwable $e) {
            $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo crear la factura con el CFDI.';
        }
    } elseif ($action === 'invoice_save') {
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
            if ($invoiceNumber === '' || !preg_match('/^[A-Za-z0-9._\/-]{2,60}$/', $invoiceNumber)) throw new RuntimeException('El folio de factura no es válido.');
            $dt = DateTime::createFromFormat('Y-m-d', $invoiceDate);
            if (!$dt || $dt->format('Y-m-d') !== $invoiceDate) throw new RuntimeException('La fecha de factura no es válida.');
            if ($subtotal < 0 || $tax < 0 || $total < 0) throw new RuntimeException('Los importes no pueden ser negativos.');
            if (!array_key_exists($status, finance_invoice_statuses())) throw new RuntimeException('Estado de factura no válido.');
            if ($cfdiUuid !== '' && strlen($cfdiUuid) > 80) throw new RuntimeException('El UUID fiscal es demasiado largo.');
            $uid = (int)(current_user()['id'] ?? 0);
            $customerId = (int)($order['customer_id'] ?? 0);
            $current = finance_invoice_get($id);
            if (!$current) throw new RuntimeException('La factura indicada no existe.');
            db()->prepare('UPDATE cp_invoices SET order_id=?,customer_id=?,invoice_number=?,invoice_date=?,subtotal=?,tax=?,total=?,status=?,cfdi_uuid=?,notes=?,updated_by=?,updated_at=NOW() WHERE id=?')->execute([$orderId,$customerId?:null,$invoiceNumber,$invoiceDate,$subtotal,$tax,$total,$status,$cfdiUuid?:null,$notes?:null,$uid?:null,$id]);
            log_activity('update','invoices','Factura actualizada #'.$id);
            redirect('/admin/facturacion.php?edit='.$id.'&saved=1');
        } catch (Throwable $e) {
            $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo guardar la factura.';
            foreach ($invoice as $key => $value) if (array_key_exists($key,$_POST)) $invoice[$key]=(string)$_POST[$key];
        }
    }
}

if (isset($_GET['created'])) $success = 'Factura creada y CFDI adjuntado a la orden correctamente.';
if (isset($_GET['saved'])) $success = 'Registro de facturación actualizado correctamente.';
$tablesReady = finance_tables_ready() && cfdi_tables_ready();
$invoices = $tablesReady ? finance_invoice_list() : [];
$invoiceDocuments = $tablesReady ? cfdi_invoice_document_list() : [];
$orderSelectedId = (int)($_GET['order_id'] ?? ($invoice['order_id'] ?? 0));
$orderSelected = $orderSelectedId > 0 ? order_get($orderSelectedId) : null;
$summary = $orderSelectedId > 0 && $tablesReady ? finance_order_summary($orderSelectedId) : null;
$orderOptions = [];
$selectedCustomerId = $editing ? (int)($editing['customer_id'] ?? 0) : (int)($_POST['customer_id'] ?? 0);
$selectedCustomer = null;
if ($tablesReady && $selectedCustomerId > 0) {
    try {
        $st = db()->prepare('SELECT id,name FROM cp_customers WHERE id=? LIMIT 1');
        $st->execute([$selectedCustomerId]);
        $selectedCustomer = $st->fetch() ?: null;
    } catch (Throwable $e) { $selectedCustomer = null; }
}
if ($editing && $invoice['order_id'] > 0) {
    try {
        $st = db()->prepare("SELECT o.id,o.order_number,o.total,o.order_date,o.customer_id,c.name AS customer_name FROM cp_orders o LEFT JOIN cp_customers c ON c.id=o.customer_id WHERE o.id=? LIMIT 1");
        $st->execute([(int)$invoice['order_id']]);
        $selectedOrder = $st->fetch() ?: null;
    } catch (Throwable $e) { $selectedOrder = null; }
} else {
    $selectedOrder = null;
}

// En edición, conserva la orden actualmente vinculada para que el select no quede vacío.
if ($selectedOrder) {
    $orderOptions = [$selectedOrder];
}

// Endpoints AJAX ligeros para no cargar +1200 clientes/órdenes en el HTML.
$ajax = (string)($_GET['ajax'] ?? '');
if ($ajax !== '') {
    header('Content-Type: application/json; charset=utf-8');
    try {
        if (!$tablesReady) throw new RuntimeException('La estructura de facturación no está disponible.');
        if ($ajax === 'customer_search') {
            $q = trim((string)($_GET['q'] ?? ''));
            $limit = min(20, max(5, (int)($_GET['limit'] ?? 12)));
            if (mb_strlen($q) < 2) { echo json_encode(['ok'=>true,'items'=>[]], JSON_UNESCAPED_UNICODE); exit; }
            $like = '%'.$q.'%';
            $st = db()->prepare("SELECT id,name FROM cp_customers WHERE name LIKE ? ORDER BY CASE WHEN name LIKE ? THEN 0 ELSE 1 END, name ASC LIMIT {$limit}");
            $st->execute([$like, $q.'%']);
            echo json_encode(['ok'=>true,'items'=>$st->fetchAll() ?: []], JSON_UNESCAPED_UNICODE); exit;
        }
        if ($ajax === 'customer_orders') {
            $customerId = (int)($_GET['customer_id'] ?? 0);
            if ($customerId <= 0) throw new RuntimeException('Cliente inválido.');
            $st = db()->prepare("SELECT o.id,o.order_number,o.total,o.order_date,o.customer_id,c.name AS customer_name FROM cp_orders o LEFT JOIN cp_customers c ON c.id=o.customer_id WHERE o.customer_id=? AND o.status<>'cancelled' ORDER BY o.id DESC LIMIT 100");
            $st->execute([$customerId]);
            echo json_encode(['ok'=>true,'items'=>$st->fetchAll() ?: []], JSON_UNESCAPED_UNICODE); exit;
        }
        throw new RuntimeException('Endpoint AJAX no válido.');
    } catch (Throwable $e) {
        http_response_code(400);
        echo json_encode(['ok'=>false,'error'=>$e->getMessage()], JSON_UNESCAPED_UNICODE); exit;
    }
}

require __DIR__.'/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/finanzas.css?v=20260928-2">
<link rel="stylesheet" href="/assets/css/cfdi-admin.css?v=20260928-2">
<div class="finance-toolbar">
  <div><span class="eyebrow">FASE 10 · FACTURACIÓN</span><h2>Facturación y documentos fiscales</h2><p class="muted">Carga el XML, revisa lo que el sistema detectó, completa lo que falte y vincúlalo con el cliente y su orden.</p></div>
  <div class="finance-actions"><a class="btn btn-secondary" href="/admin/pagos.php">💰 Pagos</a></div>
</div>
<?php if (!$tablesReady): ?>
<div class="notice danger">La estructura financiera/CFDI todavía no está instalada. Ejecuta las migraciones 012 y 013.</div>
<?php else: ?>
<?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if ($success): ?><div class="notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<?php if (!$editing): ?>
<section class="card cfdi-create-shell">
  <div class="cfdi-stepbar"><div class="cfdi-step is-active"><b>1</b><span>Cargar CFDI</span></div><div class="cfdi-step"><b>2</b><span>Vincular cliente y orden</span></div><div class="cfdi-step"><b>3</b><span>Crear expediente</span></div></div>
  <form method="post" enctype="multipart/form-data" id="cfdiCreateForm">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="cfdi_create">
    <div class="cfdi-create-grid">
      <div>
        <div class="cfdi-upload-panel">
          <span class="eyebrow">DOCUMENTOS</span><h3>Cargar XML y PDF</h3>
          <p class="muted">El XML es la fuente fiscal. Al seleccionarlo, los campos se llenan automáticamente antes de guardar.</p>
          <div class="field"><label>XML CFDI 4.0 <span class="required">*</span></label><input type="file" name="xml_file" id="xml_file" accept=".xml,text/xml,application/xml" required></div>
          <div class="field"><label>PDF del CFDI <span class="optional">opcional</span></label><input type="file" name="pdf_file" accept=".pdf,application/pdf"></div>
          <div id="cfdiFileStatus" class="cfdi-file-status">Esperando XML…</div>
        </div>
        <div class="cfdi-preview-card" id="cfdiPreviewCard">
          <div class="section-heading"><div><span class="eyebrow">LECTURA DEL XML</span><h3>Datos detectados</h3></div><span class="cfdi-pill" id="cfdiVersion">Sin cargar</span></div>
          <div class="cfdi-parties"><div><span>EMISOR</span><strong id="previewEmisor">—</strong><small id="previewEmisorRfc">—</small></div><div><span>RECEPTOR</span><strong id="previewReceptor">—</strong><small id="previewReceptorRfc">—</small></div></div>
          <div class="cfdi-meta"><div><span>UUID</span><strong id="previewUuid">—</strong></div><div><span>Forma de pago</span><strong id="previewForma">—</strong></div><div><span>Método de pago</span><strong id="previewMetodo">—</strong></div><div><span>Conceptos</span><strong id="previewConceptos">—</strong></div></div>
        </div>
      </div>

      <div>
        <div class="cfdi-form-panel">
          <span class="eyebrow">VINCULACIÓN</span><h3>Cliente y orden</h3>
          <div class="field cfdi-customer-field">
            <label for="cfdi_customer_search">Cliente <span class="required">*</span></label>
            <div class="cfdi-combobox" id="cfdiCustomerBox">
              <input type="hidden" name="customer_id" id="cfdi_customer_id" value="<?=((int)$selectedCustomerId)?>" required>
              <input type="search" id="cfdi_customer_search" class="cfdi-customer-search" autocomplete="off" spellcheck="false" placeholder="Escribe nombre del cliente…" value="<?=e((string)($selectedCustomer['name'] ?? ''))?>" aria-autocomplete="list" aria-controls="cfdi_customer_results" aria-expanded="false">
              <button type="button" class="cfdi-combobox-clear" id="cfdi_customer_clear" aria-label="Limpiar cliente" title="Limpiar cliente">×</button>
              <div class="cfdi-customer-results" id="cfdi_customer_results" role="listbox" hidden></div>
            </div>
            <small class="cfdi-search-hint">Escribe al menos 2 letras. La búsqueda consulta el servidor, no carga los 1200+ clientes.</small>
          </div>
          <div class="field"><label for="cfdi_order_id">Orden de servicio <span class="required">*</span></label><select name="order_id" id="cfdi_order_id" required <?= $selectedCustomerId ? '' : 'disabled' ?>><option value="">Primero selecciona un cliente…</option><?php if($selectedOrder): ?><option value="<?=((int)$selectedOrder['id'])?>" selected><?=e($selectedOrder['order_number'])?> · $<?=number_format((float)$selectedOrder['total'],2,'.',',')?></option><?php endif; ?></select><small class="cfdi-search-hint" id="cfdi_order_hint"><?= $selectedCustomerId ? 'Cargando órdenes…' : 'Las órdenes se cargarán al seleccionar un cliente.' ?></small></div>
          <div class="cfdi-link-note" id="cfdiLinkNote">La factura quedará vinculada al cliente y a esta orden al crear el registro.</div>
        </div>

        <div class="cfdi-form-panel">
          <span class="eyebrow">DATOS FISCALES</span><h3>Autollenado + faltantes manuales</h3>
          <div class="form-grid">
            <div class="field"><label>Folio / UUID <span class="required">*</span></label><input name="invoice_number" id="invoice_number" maxlength="60" placeholder="Se toma del UUID del XML o puedes capturarlo"></div>
            <div class="field"><label>Fecha <span class="required">*</span></label><input type="date" name="invoice_date" id="invoice_date" value="<?=e((string)$invoice['invoice_date'])?>" required></div>
            <div class="field"><label>Subtotal</label><input type="number" name="subtotal" id="invoice_subtotal" min="0" step="0.01"></div>
            <div class="field"><label>Impuesto trasladado</label><input type="number" name="tax" id="invoice_tax" min="0" step="0.01" value="0.00"></div>
            <div class="field"><label>Total <span class="required">*</span></label><input type="number" name="total" id="invoice_total" min="0" step="0.01" required></div>
            <div class="field"><label>Estado</label><select name="status" id="invoice_status"><option value="draft">Borrador</option><option value="issued" selected>Emitida</option><option value="cancelled">Cancelada</option></select></div>
            <div class="field full"><label>UUID / folio fiscal</label><input name="cfdi_uuid" id="cfdi_uuid" maxlength="80" placeholder="Se detecta del Timbre Fiscal Digital"></div>
            <div class="field full"><label>Notas administrativas</label><textarea name="notes" rows="3" maxlength="1500" placeholder="Notas, referencia interna o aclaraciones…"></textarea></div>
          </div>
          <div class="cfdi-source-note">Los valores que existan en el XML se toman como fuente fiscal al guardar. Los campos que el XML no traiga quedan disponibles para captura manual.</div>
          <div class="form-actions"><a class="btn btn-cancel" href="/admin/facturacion.php">Limpiar</a><button class="btn btn-save" type="submit">✓ Crear registro y adjuntar CFDI</button></div>
        </div>
      </div>
    </div>
  </form>
</section>
<?php else: ?>
<section class="card">
  <div class="section-heading"><div><span class="eyebrow">EDITAR REGISTRO</span><h3><?=e($editing['invoice_number'] ?? 'Factura')?></h3><p class="muted">La edición conserva el expediente CFDI ya asociado.</p></div><a class="btn btn-secondary" href="/admin/facturacion.php">+ Nueva factura</a></div>
  <form method="post" class="finance-form">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="invoice_save"><input type="hidden" name="id" value="<?=((int)$invoice['id'])?>">
    <div class="form-grid">
      <div class="field full"><label>Orden de servicio <span class="required">*</span></label><select name="order_id" required><?php foreach($orderOptions as $o): ?><option value="<?=((int)$o['id'])?>" <?=((int)$invoice['order_id']===(int)$o['id']?'selected':'')?>><?=e($o['order_number'])?> · <?=e($o['customer_name']?:'Sin cliente')?> · $<?=number_format((float)$o['total'],2,'.',',')?></option><?php endforeach; ?></select></div>
      <div class="field"><label>Folio / UUID <span class="required">*</span></label><input name="invoice_number" maxlength="60" value="<?=e((string)$invoice['invoice_number'])?>" required></div>
      <div class="field"><label>Fecha <span class="required">*</span></label><input type="date" name="invoice_date" value="<?=e((string)$invoice['invoice_date'])?>" required></div>
      <div class="field"><label>Subtotal</label><input type="number" name="subtotal" min="0" step="0.01" value="<?=e((string)$invoice['subtotal'])?>"></div>
      <div class="field"><label>Impuesto trasladado</label><input type="number" name="tax" min="0" step="0.01" value="<?=e((string)$invoice['tax'])?>"></div>
      <div class="field"><label>Total <span class="required">*</span></label><input type="number" name="total" min="0" step="0.01" value="<?=e((string)$invoice['total'])?>" required></div>
      <div class="field"><label>Estado</label><select name="status"><?php foreach(finance_invoice_statuses() as $k=>$label): ?><option value="<?=e($k)?>" <?=$invoice['status']===$k?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select></div>
      <div class="field full"><label>UUID / folio fiscal</label><input name="cfdi_uuid" maxlength="80" value="<?=e((string)$invoice['cfdi_uuid'])?>"></div>
      <div class="field full"><label>Notas</label><textarea name="notes" rows="4" maxlength="1500"><?=e((string)$invoice['notes'])?></textarea></div>
    </div>
    <div class="form-actions"><a class="btn btn-cancel" href="/admin/facturacion.php">Cancelar</a><button class="btn btn-save" type="submit">Guardar cambios</button></div>
  </form>
</section>
<?php endif; ?>

<section class="card">
  <div class="section-heading"><div><span class="eyebrow">ORDEN SELECCIONADA</span><h3><?= $orderSelected ? e($orderSelected['order_number']) : 'Vinculación de orden' ?></h3></div></div>
  <?php if($orderSelected&&$summary): ?><div class="balance-box"><div><span>Total orden</span><strong>$<?=number_format($summary['order_total'],2,'.',',')?></strong></div><div><span>Pagado</span><strong class="positive">$<?=number_format($summary['paid_total'],2,'.',',')?></strong></div><div><span>Saldo</span><strong class="pending">$<?=number_format($summary['balance'],2,'.',',')?></strong></div></div><p class="help-text">Cliente: <?=e($orderSelected['customer_name']??'Sin cliente')?> · Facturas registradas: <?=((int)$summary['invoice_count'])?></p><?php else: ?><p class="empty">Al crear una factura desde CFDI, aquí quedará asociada la orden correspondiente.</p><?php endif; ?>
</section>

<section class="card">
  <div class="section-heading"><div><span class="eyebrow">HISTORIAL</span><h3>Facturas y expedientes CFDI</h3></div></div>
  <div class="table-wrap"><table class="table finance-table"><thead><tr><th>Fecha</th><th>Folio</th><th>Orden</th><th>Cliente</th><th>Total</th><th>Estado</th><th>CFDI</th><th>Acciones</th></tr></thead><tbody>
  <?php if(!$invoices): ?><tr><td colspan="8" class="empty">No hay registros de facturación.</td></tr><?php else: foreach($invoices as $i): $doc=cfdi_invoice_document_latest((int)$i['id']); ?><tr><td><?=e(date('d/m/Y',strtotime((string)$i['invoice_date'])))?></td><td><strong><?=e($i['invoice_number'])?></strong></td><td><a href="/admin/orden.php?id=<?=((int)$i['order_id'])?>"><?=e($i['order_number'])?></a></td><td><?=e($i['customer_name']?:'Sin cliente')?></td><td class="amount-cell">$<?=number_format((float)$i['total'],2,'.',',')?></td><td><span class="finance-badge <?=($i['status']==='issued'?'is-ok':($i['status']==='cancelled'?'is-danger':'is-neutral'))?>"><?=e(finance_invoice_statuses()[$i['status']]??$i['status'])?></span></td><td><?php if($doc): ?><span class="cfdi-pill"><?=e($doc['uuid']?:'CFDI')?></span><?php else: ?><span class="muted">Pendiente</span><?php endif; ?></td><td class="cfdi-actions"><a class="btn btn-sm btn-secondary" href="/admin/facturacion.php?edit=<?=((int)$i['id'])?>">Editar</a><?php if($doc): ?><a class="btn btn-sm btn-secondary" href="/admin/cfdi_documento.php?id=<?=((int)$doc['id'])?>">CFDI</a><?php endif; ?></td></tr><?php endforeach; endif; ?>
  </tbody></table></div>
</section>

<script>
(function(){
  const xmlInput=document.getElementById('xml_file');
  const customer=document.getElementById('cfdi_customer_id');
  const customerSearch=document.getElementById('cfdi_customer_search');
  const customerBox=document.getElementById('cfdiCustomerBox');
  const customerResults=document.getElementById('cfdi_customer_results');
  const customerClear=document.getElementById('cfdi_customer_clear');
  const order=document.getElementById('cfdi_order_id');
  const orderHint=document.getElementById('cfdi_order_hint');
  const status=document.getElementById('invoice_status');
  const statusBox=document.getElementById('cfdiFileStatus');

  const escHtml=(v)=>String(v??'').replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[m]));
  let customerTimer=null, customerAbort=null, activeCustomerIndex=-1;
  function closeCustomerResults(){ if(customerResults){customerResults.hidden=true; customerResults.innerHTML='';} if(customerSearch)customerSearch.setAttribute('aria-expanded','false'); activeCustomerIndex=-1; }
  function showCustomerMessage(text, muted=true){ if(!customerResults)return; customerResults.innerHTML='<div class="cfdi-customer-empty '+(muted?'is-muted':'')+'">'+escHtml(text)+'</div>'; customerResults.hidden=false; if(customerSearch)customerSearch.setAttribute('aria-expanded','true'); }
  function renderCustomers(items){
    if(!customerResults)return;
    if(!items.length){showCustomerMessage('No encontramos clientes con esa búsqueda.');return;}
    customerResults.innerHTML=items.map((item,i)=>'<button type="button" class="cfdi-customer-option" role="option" data-id="'+Number(item.id)+'" data-name="'+escHtml(item.name)+'"><span>'+escHtml(item.name)+'</span><small>#'+Number(item.id)+'</small></button>').join('');
    customerResults.hidden=false; customerSearch.setAttribute('aria-expanded','true'); activeCustomerIndex=-1;
    customerResults.querySelectorAll('.cfdi-customer-option').forEach(btn=>btn.addEventListener('click',()=>selectCustomer(btn.dataset.id,btn.dataset.name)));
  }
  async function searchCustomers(){
    const q=(customerSearch?.value||'').trim();
    if(q.length<2){closeCustomerResults();return;}
    if(customerAbort)customerAbort.abort();
    customerAbort=new AbortController();
    showCustomerMessage('Buscando clientes…',true);
    try{
      const res=await fetch('/admin/facturacion.php?ajax=customer_search&q='+encodeURIComponent(q),{credentials:'same-origin',headers:{'Accept':'application/json'},signal:customerAbort.signal});
      const data=await res.json(); if(!res.ok||!data.ok)throw new Error(data.error||'No se pudo buscar.');
      renderCustomers(data.items||[]);
    }catch(err){if(err.name!=='AbortError')showCustomerMessage(err.message||'No se pudo buscar clientes.',false);}
  }
  function clearOrders(message){
    if(!order)return;
    order.innerHTML=''; const opt=document.createElement('option'); opt.value=''; opt.textContent=message||'Primero selecciona un cliente…'; order.appendChild(opt); order.disabled=true;
    if(orderHint)orderHint.textContent='Las órdenes se cargarán al seleccionar un cliente.';
  }
  async function loadOrders(customerId, selectedOrderId=''){
    if(!order)return;
    clearOrders('Cargando órdenes…');
    if(!customerId)return;
    try{
      const res=await fetch('/admin/facturacion.php?ajax=customer_orders&customer_id='+encodeURIComponent(customerId),{credentials:'same-origin',headers:{'Accept':'application/json'}});
      const data=await res.json(); if(!res.ok||!data.ok)throw new Error(data.error||'No se pudieron cargar las órdenes.');
      order.innerHTML='';
      const first=document.createElement('option'); first.value=''; first.textContent=data.items?.length?'Selecciona la orden…':'Este cliente no tiene órdenes disponibles'; order.appendChild(first);
      (data.items||[]).forEach(item=>{
        const opt=document.createElement('option'); opt.value=item.id; opt.textContent=(item.order_number||('Orden #'+item.id))+' · $'+Number(item.total||0).toLocaleString('es-MX',{minimumFractionDigits:2,maximumFractionDigits:2});
        if(String(item.id)===String(selectedOrderId))opt.selected=true; order.appendChild(opt);
      });
      order.disabled=!(data.items||[]).length;
      if(orderHint)orderHint.textContent=data.items?.length?(data.items.length+' orden'+(data.items.length===1?' disponible':'es disponibles')+' para este cliente.'):'No hay órdenes activas disponibles para este cliente.';
    }catch(err){clearOrders('No se pudieron cargar las órdenes'); if(orderHint)orderHint.textContent=err.message||'No se pudieron cargar las órdenes.';}
  }
  function selectCustomer(id,name){
    if(customer)customer.value=String(id);
    if(customerSearch)customerSearch.value=name||'';
    closeCustomerResults();
    loadOrders(id);
  }
  function clearCustomer(){
    if(customer)customer.value=''; if(customerSearch)customerSearch.value=''; closeCustomerResults(); clearOrders(); customerSearch?.focus();
  }
  if(customerSearch){
    customerSearch.addEventListener('input',()=>{clearTimeout(customerTimer); if(customer)customer.value=''; clearOrders(); customerTimer=setTimeout(searchCustomers,180);});
    customerSearch.addEventListener('focus',()=>{if(customerSearch.value.trim().length>=2)searchCustomers();});
    customerSearch.addEventListener('keydown',(e)=>{
      const opts=[...(customerResults?.querySelectorAll('.cfdi-customer-option')||[])];
      if(e.key==='ArrowDown'&&opts.length){e.preventDefault();activeCustomerIndex=(activeCustomerIndex+1)%opts.length;opts.forEach((x,i)=>x.classList.toggle('is-active',i===activeCustomerIndex));opts[activeCustomerIndex].scrollIntoView({block:'nearest'});}
      else if(e.key==='ArrowUp'&&opts.length){e.preventDefault();activeCustomerIndex=(activeCustomerIndex-1+opts.length)%opts.length;opts.forEach((x,i)=>x.classList.toggle('is-active',i===activeCustomerIndex));opts[activeCustomerIndex].scrollIntoView({block:'nearest'});}
      else if(e.key==='Enter'&&activeCustomerIndex>=0&&opts[activeCustomerIndex]){e.preventDefault();opts[activeCustomerIndex].click();}
      else if(e.key==='Escape')closeCustomerResults();
    });
  }
  customerClear?.addEventListener('click',clearCustomer);
  document.addEventListener('click',(e)=>{if(customerBox&&!customerBox.contains(e.target))closeCustomerResults();});
  if(customer?.value)loadOrders(customer.value,'<?=((int)($invoice['order_id'] ?? 0))?>'); else clearOrders();
  if(!xmlInput)return;
  const q=(sel,root=document)=>root.querySelector(sel);
  const attr=(el,name)=>el?el.getAttribute(name)||'':'';
  const local=(root,name)=>root?[...root.getElementsByTagNameNS('*',name)][0]||[...root.getElementsByTagName(name)][0]||null:null;
  const setField=(id,val)=>{const el=document.getElementById(id);if(!el)return;el.value=val||'';el.classList.toggle('cfdi-auto-filled',!!val);};
  const money=(v)=>v===''?'':(parseFloat(v)||0).toFixed(2);
  xmlInput.addEventListener('change',function(){
    const file=xmlInput.files&&xmlInput.files[0];
    if(!file){statusBox.textContent='Esperando XML…';return;}
    if(!/\.xml$/i.test(file.name)){statusBox.textContent='El archivo seleccionado no tiene extensión XML.';return;}
    const reader=new FileReader();
    reader.onload=function(){
      try{
        const doc=new DOMParser().parseFromString(String(reader.result),'application/xml');
        if(doc.querySelector('parsererror'))throw new Error('XML inválido');
        const root=doc.documentElement;
        if(!root||root.localName!=='Comprobante')throw new Error('No parece un CFDI de comprobante');
        const em=local(root,'Emisor'), rec=local(root,'Receptor'), tfd=local(root,'TimbreFiscalDigital'), imp=local(root,'Impuestos');
        const serie=attr(root,'Serie'), folio=attr(root,'Folio'), version=attr(root,'Version'), fecha=attr(root,'Fecha');
        const uuid=attr(tfd,'UUID'), subtotal=attr(root,'SubTotal'), total=attr(root,'Total'), tax=attr(imp,'TotalImpuestosTrasladados');
        const conceptos=[...root.getElementsByTagNameNS('*','Concepto')];
        setField('invoice_number',uuid||serie+(serie&&folio?'-':'')+folio);
        setField('invoice_date',fecha?fecha.slice(0,10):'');
        setField('invoice_subtotal',money(subtotal));
        setField('invoice_tax',money(tax));
        setField('invoice_total',money(total));
        setField('cfdi_uuid',uuid);
        if(status)status.value=uuid?'issued':'draft';
        q('#cfdiVersion').textContent='CFDI '+(version||'4.0');
        q('#previewEmisor').textContent=attr(em,'Nombre')||'—'; q('#previewEmisorRfc').textContent=attr(em,'Rfc')||'—';
        q('#previewReceptor').textContent=attr(rec,'Nombre')||'—'; q('#previewReceptorRfc').textContent=attr(rec,'Rfc')||'—';
        q('#previewUuid').textContent=uuid||'Sin UUID'; q('#previewForma').textContent=attr(root,'FormaPago')||'—'; q('#previewMetodo').textContent=attr(root,'MetodoPago')||'—'; q('#previewConceptos').textContent=String(conceptos.length);
        statusBox.innerHTML='<strong>✓ XML leído.</strong> Los datos fiscales detectados se reflejan en el formulario. PDF: '+(document.querySelector('input[name="pdf_file"]').files.length?'cargado':'opcional')+'.';
      }catch(err){statusBox.textContent='No se pudo leer el CFDI en el navegador: '+err.message;}
    };
    reader.readAsText(file);
  });
})();
</script>
<?php endif; ?>
<?php require __DIR__.'/../includes/footer.php'; ?>
