<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_once __DIR__ . '/../includes/produccion.php';
require_once __DIR__ . '/../includes/seguimiento.php';
require_once __DIR__ . '/../includes/whatsapp.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_once __DIR__ . '/../includes/quote_order_sync.php';
require_once __DIR__ . '/../includes/order_media.php';
require_once __DIR__ . '/../includes/payment_receipts.php';
require_auth();

$id=(int)($_GET['id'] ?? 0);
$order=order_get($id);
if(!$order) redirect('/admin/ordenes.php');
$title='Orden '.$order['order_number'];
$error=null;

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf'] ?? null)){
        $error='La sesión del formulario expiró. Recarga la página.';
    } else {
        $action=(string)($_POST['action'] ?? '');
        try{
            $pdo=db();$uid=(int)(current_user()['id'] ?? 0);
            if($action==='status'){
                $new=(string)($_POST['status'] ?? '');
                if(!array_key_exists($new,order_statuses())) throw new RuntimeException('Estado no válido.');
                $old=(string)$order['status'];
                $historyNote=trim((string)($_POST['history_note'] ?? ''));
                if($new==='delivered'){
                    // Si se marca como entregada desde la ficha de la orden,
                    // también se cierra la etapa de producción.
                    production_set_stage($id,'delivered',$historyNote);
                } elseif($old!==$new){
                    $pdo->beginTransaction();
                    $pdo->prepare('UPDATE cp_orders SET status=?,updated_by=?,updated_at=NOW() WHERE id=?')->execute([$new,$uid,$id]);
                    $pdo->prepare('INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at) VALUES(?,?,?,?,?,NOW())')->execute([$id,$old,$new,$historyNote,$uid]);
                    $pdo->commit();
                }
                redirect('/admin/orden.php?id='.$id.'&updated=1');
            }
            if($action==='sync_quote') {
                sync_order_from_quote((int)$order['quote_id'], $id, $uid, 'Sincronización manual desde cotización '.$order['quote_number']);
                redirect('/admin/orden.php?id='.$id.'&synced=1');
            }
            if($action==='advance_payment'){
                if(!finance_tables_ready()) throw new RuntimeException('El módulo financiero no está disponible.');
                $amount=round((float)str_replace(',', '', (string)($_POST['amount'] ?? 0)), 2);
                $paymentDate=trim((string)($_POST['payment_date'] ?? date('Y-m-d')));
                $method=(string)($_POST['method'] ?? 'transfer');
                $reference=trim((string)($_POST['reference'] ?? ''));
                $note=trim((string)($_POST['note'] ?? ''));
                if($amount<=0) throw new RuntimeException('El monto del anticipo debe ser mayor a $0.00.');
                $dt=DateTime::createFromFormat('Y-m-d',$paymentDate);
                if(!$dt || $dt->format('Y-m-d')!==$paymentDate) throw new RuntimeException('La fecha del anticipo no es válida.');
                if(!array_key_exists($method,finance_payment_methods())) throw new RuntimeException('Método de pago no válido.');
                $summary=finance_order_summary($id);
                if($amount > (float)$summary['balance'] + 0.009){
                    throw new RuntimeException('El anticipo supera el saldo pendiente. Saldo disponible: $'.number_format((float)$summary['balance'],2,'.',','));
                }
                $noteFinal='ANTICIPO'.($note!==''?' · '.$note:'');
                $pdo->prepare('INSERT INTO cp_payments(order_id,customer_id,amount,payment_date,method,reference,note,status,created_by,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,NOW(),NOW())')
                    ->execute([$id,(int)($order['customer_id'] ?? 0) ?: null,$amount,$paymentDate,$method,$reference ?: null,$noteFinal,'confirmed',$uid ?: null,$uid ?: null]);
                log_activity('create','payments','Anticipo registrado para orden #'.$id.' por $'.number_format($amount,2,'.',''));
                redirect('/admin/orden.php?id='.$id.'&advance_saved=1');
            }
            if($action==='photo_upload'){
                $type=(string)($_POST['photo_type'] ?? 'reference');
                $caption=trim((string)($_POST['caption'] ?? ''));
                order_photo_upload($_FILES['photo'] ?? [],$id,$uid,$type,$caption);
                log_activity('create','orders','Foto agregada a orden #'.$id);
                redirect('/admin/orden.php?id='.$id.'&photo_saved=1');
            }
            if($action==='file_upload'){
                $type=(string)($_POST['file_type'] ?? 'client_file');
                $caption=trim((string)($_POST['file_caption'] ?? ''));
                order_file_upload($_FILES['file'] ?? [],$id,$uid,$type,$caption);
                log_activity('create','orders','Archivo agregado a orden #'.$id);
                redirect('/admin/orden.php?id='.$id.'&file_saved=1#archivos-orden');
            }
            if($action==='photo_delete'){
                $photoId=(int)($_POST['photo_id'] ?? 0);
                order_photo_delete($photoId,$id);
                log_activity('delete','orders','Foto eliminada de orden #'.$id);
                redirect('/admin/orden.php?id='.$id.'&photo_deleted=1');
            }
            if($action==='payment_receipt_review'){
                payment_receipt_review(
                    (int)($_POST['receipt_id'] ?? 0),
                    $uid,
                    (string)($_POST['receipt_status'] ?? 'pending'),
                    !empty($_POST['payment_id']) ? (int)$_POST['payment_id'] : null,
                    (string)($_POST['receipt_note'] ?? '')
                );
                log_activity('update','orders','Comprobante de pago revisado para orden #'.$id);
                redirect('/admin/orden.php?id='.$id.'&receipt_reviewed=1#comprobantes-pago-admin');
            }
            if($action==='details'){
                $due=(string)($_POST['due_date'] ?? '');
                $responsible=(int)($_POST['responsible_user_id'] ?? 0);
                $notes=trim((string)($_POST['notes'] ?? ''));
                $internal=trim((string)($_POST['internal_notes'] ?? ''));
                $pdo->prepare('UPDATE cp_orders SET due_date=?,responsible_user_id=?,notes=?,internal_notes=?,updated_by=?,updated_at=NOW() WHERE id=?')->execute([$due?:null,$responsible?:null,$notes,$internal,$uid,$id]);
                redirect('/admin/orden.php?id='.$id.'&updated=1');
            }
        }catch(Throwable $e){
            if(isset($pdo)&&$pdo->inTransaction())$pdo->rollBack();
            $error=$e->getMessage()==='Estado no válido.'?$e->getMessage():'No se pudo actualizar la orden.';
        }
    }
}

$order=order_get($id);$items=order_items($id);$history=order_history($id);
$quoteSync=quote_order_diff((int)$order['quote_id'], $id);
$financeReady=finance_tables_ready();
$financeSummary=$financeReady?finance_order_summary($id):null;
$recentPayments=$financeReady?finance_payment_list($id,5):[];
$photos=order_photos($id);
$trackingUrl=tracking_url_for_order($id);
$paymentReceipts=payment_receipts_table_ready()?payment_receipts_for_order($id):[];
$users=db()->query('SELECT id,name FROM cp_users ORDER BY name')->fetchAll();

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/ordenes.css?v=20260917-6">
<link rel="stylesheet" href="/assets/css/finanzas.css?v=20260917-1">
<link rel="stylesheet" href="/assets/css/order-enhancements.css?v=20260919-1">
<link rel="stylesheet" href="/assets/css/order-file-library.css?v=20260919-1">
<link rel="stylesheet" href="/assets/css/payment-receipts.css?v=20260919-1">
<div class="order-toolbar no-print"><div><span class="eyebrow">FASE 6 · ORDEN DE SERVICIO</span><h2><?=e($order['order_number'])?></h2><p class="muted">Origen: <a href="/admin/cotizacion.php?id=<?=((int)$order['quote_id'])?>"><?=e($order['quote_number'])?></a></p></div><div class="order-toolbar-actions"><?php if (!empty($order['customer_phone'])): ?><a class="btn btn-secondary" href="/admin/whatsapp.php?source=order&id=<?=((int)$id)?>&template=order_confirmed">💬 WhatsApp</a><?php endif; ?><a class="btn btn-secondary" href="/admin/pagos.php?order_id=<?=((int)$id)?>">💰 Pagos</a><a class="btn btn-secondary" href="/admin/facturacion.php?order_id=<?=((int)$id)?>">🧾 Facturación</a><a class="btn btn-primary" href="<?=e($trackingUrl)?>" target="_blank" rel="noopener">🔗 Ver seguimiento</a>
<a class="btn btn-primary"
   href="/admin/orden_pdf_2paginas.php?id=<?=((int)$id)?>"
   target="_blank"
   rel="noopener">
    📄 PDF profesional
</a>
</div></div>
<?php if($error): ?><div class="notice danger no-print"><?=e($error)?></div><?php endif; ?><?php if(isset($_GET['advance_saved'])): ?><div class="notice no-print"><span class="ok">✓</span> Anticipo registrado correctamente.</div><?php endif; ?><?php if(isset($_GET['photo_saved'])): ?><div class="notice no-print"><span class="ok">✓</span> Foto agregada a la orden.</div><?php endif; ?><?php if(isset($_GET['photo_deleted'])): ?><div class="notice no-print"><span class="ok">✓</span> Foto eliminada.</div><?php endif; ?><?php if(isset($_GET['synced'])): ?><div class="notice no-print"><span class="ok">✓</span> Orden sincronizada con la cotización vinculada.</div><?php endif; ?><?php if(isset($_GET['created'])): ?><div class="notice no-print"><span class="ok">✓</span> Orden creada correctamente.</div><?php endif; ?><?php if(isset($_GET['updated'])): ?><div class="notice no-print"><span class="ok">✓</span> Orden actualizada.</div><?php endif; ?>
<div class="order-view-grid">
<main><article class="card order-document">
<div class="document-head"><div><span class="eyebrow">COLIBRÍ PRINT MÉXICO</span><h3><?=e($order['order_number'])?></h3><p>Fecha: <?=e(date('d/m/Y',strtotime((string)$order['order_date'])))?><?php if($order['due_date']): ?> · Compromiso: <?=e(date('d/m/Y',strtotime((string)$order['due_date'])))?><?php endif; ?></p></div><span class="status-badge order-status-<?=e((string)$order['status'])?>"><?=e(order_status_label((string)$order['status']))?></span></div>
<div class="customer-box"><span>CLIENTE</span><strong><?=e($order['customer_name'] ?? 'Sin cliente')?></strong><?php if($order['customer_tax_number']): ?><small>RFC: <?=e($order['customer_tax_number'])?></small><?php endif; ?><?php if($order['customer_email']): ?><small><?=e($order['customer_email'])?></small><?php endif; ?><?php if($order['customer_phone']): ?><small><?=e($order['customer_phone'])?></small><?php endif; ?><?php if($order['customer_address']): ?><small><?=e($order['customer_address'])?><?= $order['customer_city'] ? ', '.e($order['customer_city']) : '' ?><?= $order['customer_state'] ? ', '.e($order['customer_state']) : '' ?></small><?php endif; ?></div>
<?php if($quoteSync['exists'] && ($quoteSync['quote']['payment_terms'] || $quoteSync['quote']['delivery_time'] || $quoteSync['quote']['delivery_place'] || $quoteSync['quote']['terms'])): ?>
<div class="commercial-box">
  <span>DATOS COMERCIALES DE LA COTIZACIÓN</span>
  <div class="commercial-grid">
    <?php if($quoteSync['quote']['payment_terms']): ?><div><small>Pago</small><strong><?=e($quoteSync['quote']['payment_terms'])?></strong></div><?php endif; ?>
    <?php if($quoteSync['quote']['delivery_time']): ?><div><small>Entrega</small><strong><?=e($quoteSync['quote']['delivery_time'])?></strong></div><?php endif; ?>
    <?php if($quoteSync['quote']['delivery_place']): ?><div><small>Lugar</small><strong><?=e($quoteSync['quote']['delivery_place'])?></strong></div><?php endif; ?>
  </div>
  <?php if($quoteSync['quote']['terms']): ?><p><?=nl2br(e($quoteSync['quote']['terms']))?></p><?php endif; ?>
</div>
<?php endif; ?>
<?php if($quoteSync['exists'] && trim((string)($quoteSync['quote']['internal_notes'] ?? ''))!==''): ?>
<div class="quote-internal-box no-print">
  <div class="quote-internal-head"><span>NOTAS INTERNAS DE LA COTIZACIÓN</span><b>🔒 SOLO EQUIPO</b></div>
  <p><?=nl2br(e((string)$quoteSync['quote']['internal_notes']))?></p>
  <small>No se muestran en el seguimiento público ni al cliente.</small>
</div>
<?php endif; ?>
<table class="table"><thead><tr><th>Descripción</th><th>Cant.</th><th>Precio</th><th>Importe</th></tr></thead><tbody><?php foreach($items as $item): ?><tr><td><?=e($item['description'])?></td><td><?=e((string)$item['quantity'])?></td><td><?=quote_money((float)$item['unit_price'])?></td><td><?=quote_money((float)$item['subtotal'])?></td></tr><?php endforeach; ?></tbody></table>
<div class="document-total"><div class="grand"><span>Total</span><strong><?=quote_money((float)$order['total'])?></strong></div></div>
<?php if($order['notes']): ?><div class="document-section"><h4>Notas operativas</h4><p><?=nl2br(e($order['notes']))?></p></div><?php endif; ?>
<div class="document-footer">Orden generada desde <?=e($order['quote_number'])?> · <?=e($order['order_number'])?></div>
</article>

<section class="card payment-receipts-admin no-print" id="comprobantes-pago-admin">
  <div class="section-heading">
    <div>
      <span class="eyebrow">FINANZAS · DOCUMENTOS</span>
      <h3>Comprobantes enviados por el cliente</h3>
      <p class="muted">El comprobante se recibe para revisión y no confirma automáticamente el pago.</p>
    </div>
    <?php if(payment_receipts_table_ready()): ?><span class="count-pill"><?=count($paymentReceipts)?></span><?php endif; ?>
  </div>

  <?php if(!payment_receipts_table_ready()): ?>
    <div class="payment-receipt-install-warning">
      <strong>Función pendiente de activación</strong>
      <span>Ejecuta <code>database/sql/020_payment_receipts.sql</code> antes de recibir comprobantes.</span>
    </div>
  <?php elseif(!$paymentReceipts): ?>
    <div class="payment-receipt-empty">
      <strong>Aún no hay comprobantes.</strong>
      <span>El cliente podrá enviarlos desde su seguimiento público.</span>
    </div>
  <?php else: ?>
    <div class="payment-receipt-admin-list">
      <?php foreach($paymentReceipts as $receipt): ?>
        <article class="payment-receipt-admin-item">
          <div class="payment-receipt-admin-head">
            <div>
              <strong>🧾 <?=e((string)$receipt['original_name'])?></strong>
              <small>Recibido <?=e(date('d/m/Y H:i',strtotime((string)$receipt['created_at'])))?> · <?=e((string)$receipt['mime_type'])?></small>
            </div>
            <span class="receipt-status receipt-status-<?=e((string)$receipt['status'])?>"><?=e(strtoupper((string)$receipt['status']))?></span>
          </div>

          <?php if(trim((string)($receipt['note'] ?? ''))!==''): ?>
            <p class="payment-receipt-note"><?=nl2br(e((string)$receipt['note']))?></p>
          <?php endif; ?>

          <div class="payment-receipt-review-grid">
            <a class="btn btn-secondary" href="/comprobante_pago.php?t=<?=e($trackingUrl ? preg_replace('/^.*?t=/', '', $trackingUrl) : '')?>&rid=<?=((int)$receipt['id'])?>" target="_blank" rel="noopener">👁 Ver comprobante</a>
            <form method="post">
              <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
              <input type="hidden" name="action" value="payment_receipt_review">
              <input type="hidden" name="receipt_id" value="<?=((int)$receipt['id'])?>">
              <select name="receipt_status">
                <?php foreach(['pending'=>'Pendiente','reviewing'=>'En revisión','confirmed'=>'Confirmado','rejected'=>'Rechazado'] as $key=>$label): ?>
                  <option value="<?=e($key)?>" <?=$receipt['status']===$key?'selected':''?>><?=e($label)?></option>
                <?php endforeach; ?>
              </select>
              <select name="payment_id">
                <option value="">Sin vincular a pago</option>
                <?php foreach($recentPayments as $pay): ?>
                  <option value="<?=((int)$pay['id'])?>" <?=$receipt['payment_id']==$pay['id']?'selected':''?>>
                    <?=e(date('d/m/Y',strtotime((string)$pay['payment_date'])))?> · $<?=e(number_format((float)$pay['amount'],2,'.',','))?> · <?=e((string)$pay['method'])?>
                  </option>
                <?php endforeach; ?>
              </select>
              <input type="text" name="receipt_note" value="<?=e((string)($receipt['note'] ?? ''))?>" placeholder="Nota interna de revisión">
              <button class="btn btn-primary" type="submit">Guardar revisión</button>
            </form>
          </div>
        </article>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</section>

<section class="card order-photos-card no-print" id="archivos-orden">
  <div class="section-heading">
    <div>
      <span class="eyebrow">EXPEDIENTE · ARCHIVOS</span>
      <h3>Fotos, documentos y archivos de producción</h3>
      <p class="muted">Conserva en la orden todo lo necesario para fabricar el trabajo: referencias, diseños, PDFs, Word, Excel, archivos técnicos y evidencias.</p>
    </div>
    <span class="count-pill"><?=count($photos)?></span>
  </div>

  <?php if(order_photos_table_ready()): ?>
  <form method="post" enctype="multipart/form-data" class="photo-upload-form file-upload-form">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="action" value="file_upload">
    <div class="file-drop-zone" id="orderFileDropZone">
      <div class="file-drop-icon">📎</div>
      <div>
        <strong>Arrastra o selecciona un archivo</strong>
        <span>PDF · Word · Excel · PowerPoint · imágenes · CSV/TXT · ZIP/RAR · diseño/CAD</span>
      </div>
      <label class="file-choose">
        <input type="file" name="file" id="orderFileInput" required>
        <span>Elegir archivo</span>
      </label>
    </div>

    <div class="file-selected" id="orderFileSelected" hidden>
      <span id="orderFileIcon">📎</span>
      <div><strong id="orderFileName">Archivo</strong><small id="orderFileSize">0 KB</small></div>
    </div>

    <div class="photo-upload-grid">
      <div class="field">
        <label>Tipo</label>
        <select name="file_type">
          <?php foreach(order_file_types() as $key=>$label): ?>
            <option value="<?=e($key)?>" <?=$key==='client_file'?'selected':''?>><?=e($label)?></option>
          <?php endforeach; ?>
        </select>
      </div>
      <div class="field">
        <label>Descripción</label>
        <input name="file_caption" maxlength="255" placeholder="Ej. medidas, diseño aprobado, lista de cantidades, archivo de corte...">
      </div>
    </div>

    <div class="file-upload-actions">
      <button class="btn btn-primary" type="submit">📎 Guardar archivo en la orden</button>
      <small>Máximo 25 MB · almacenamiento interno del expediente.</small>
    </div>
  </form>
  <?php endif; ?>

  <?php if($photos): ?>
    <div class="order-file-grid">
      <?php foreach($photos as $file): ?>
        <article class="order-file-card <?=order_file_is_image($file)?'is-image':''?>">
          <div class="order-file-preview">
            <?php if(order_file_is_image($file) && $file['mime_type']!=='image/svg+xml'): ?>
              <img src="/admin/orden_archivo.php?id=<?=((int)$file['id'])?>" alt="<?=e((string)($file['caption']??'Archivo'))?>" loading="lazy">
            <?php else: ?>
              <span class="order-file-icon"><?=e(order_file_icon($file))?></span>
              <b><?=e(strtoupper(order_file_extension((string)$file['original_name'])))?></b>
            <?php endif; ?>
          </div>
          <div class="order-file-meta">
            <div class="order-file-main">
              <strong title="<?=e((string)$file['original_name'])?>"><?=e((string)$file['original_name'])?></strong>
              <span><?=e(order_file_type_label((string)$file['photo_type']))?></span>
            </div>
            <?php if(trim((string)($file['caption']??''))!==''): ?><p><?=e((string)$file['caption'])?></p><?php endif; ?>
            <small><?=e((string)($file['created_by_name']??'Sistema'))?> · <?=e(date('d/m/Y H:i',strtotime((string)$file['created_at'])))?> · <?=number_format(((int)$file['file_size'])/1024,0)?> KB</small>
            <div class="order-file-actions">
              <a class="btn btn-secondary btn-sm" href="/admin/orden_archivo.php?id=<?=((int)$file['id'])?>" target="_blank" rel="noopener">Abrir</a>
              <a class="btn btn-sm" href="/admin/orden_archivo.php?id=<?=((int)$file['id'])?>&download=1">Descargar</a>
              <form method="post" onsubmit="return confirm('¿Eliminar este archivo de la orden?');">
                <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                <input type="hidden" name="action" value="photo_delete">
                <input type="hidden" name="photo_id" value="<?=((int)$file['id'])?>">
                <button class="btn btn-sm btn-delete" type="submit">Eliminar</button>
              </form>
            </div>
          </div>
        </article>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</section>
<section class="card history-card no-print" id="seguimiento"><div class="section-heading"><div><span class="eyebrow">HISTORIAL</span><h3>Seguimiento de la orden</h3></div></div>
<?php if(!$history): ?><p class="empty">Sin movimientos.</p><?php else: ?><div class="history-list"><?php foreach($history as $h): ?><div class="history-item"><div><strong><?=e(order_status_label((string)$h['new_status']))?></strong><small><?=e(date('d/m/Y H:i',strtotime((string)$h['created_at'])))?> · <?=e($h['user_name'] ?? 'Sistema')?></small></div><p><?=e($h['note'] ?? '')?></p></div><?php endforeach; ?></div><?php endif; ?>
</section></main>
<aside class="no-print">
<?php if(!empty($quoteSync['changes'])): ?>
<div class="card sync-card">
  <span class="eyebrow">COTIZACIÓN VINCULADA</span>
  <h3>Hay datos diferentes</h3>
  <p class="help-text">La cotización <?=e($order['quote_number'])?> cambió después de crear esta orden.</p>
  <div class="sync-tags"><?php foreach($quoteSync['changes'] as $change): ?><span><?=e(ucfirst($change))?></span><?php endforeach; ?></div>
  <?php if(!empty($quoteSync['can_sync'])): ?>
    <form method="post" onsubmit="return confirm('Se actualizarán el cliente, los conceptos y el total de esta orden con los datos de la cotización. ¿Continuar?');">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <input type="hidden" name="action" value="sync_quote">
      <button class="btn btn-primary full" type="submit">↻ Sincronizar desde cotización</button>
    </form>
  <?php else: ?>
    <small class="help-text">La orden está cerrada. Se conserva este registro como histórico.</small>
  <?php endif; ?>
</div>
<?php endif; ?>
<div class="card status-card"><span class="eyebrow">ESTADO</span><h3>Actualizar estado</h3><form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="status"><select name="status"><?php foreach(order_statuses() as $k=>$label): ?><option value="<?=e($k)?>" <?=$order['status']===$k?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select><textarea name="history_note" rows="3" placeholder="Nota del cambio..."></textarea><button class="btn btn-primary full" type="submit">Guardar estado</button></form></div>
<div class="card finance-order-card"><span class="eyebrow">FINANZAS</span><h3>Anticipo y pagos</h3><?php if($financeSummary): ?><div class="finance-mini-grid"><div><span>Total</span><strong>$<?=number_format($financeSummary['order_total'],2,'.',',')?></strong></div><div><span>Pagado</span><strong class="positive">$<?=number_format($financeSummary['paid_total'],2,'.',',')?></strong></div><div><span>Saldo</span><strong class="pending">$<?=number_format($financeSummary['balance'],2,'.',',')?></strong></div></div>
<form method="post" class="quick-payment-form"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="advance_payment"><div class="field"><label>Monto del anticipo</label><input type="number" name="amount" min="0.01" max="<?=e(number_format((float)$financeSummary['balance'],2,'.',''))?>" step="0.01" placeholder="0.00" required></div><div class="field"><label>Método</label><select name="method"><?php foreach(finance_payment_methods() as $k=>$label): ?><option value="<?=e($k)?>"><?=e($label)?></option><?php endforeach; ?></select></div><div class="field"><label>Fecha</label><input type="date" name="payment_date" value="<?=e(date('Y-m-d'))?>" required></div><div class="field"><label>Referencia</label><input name="reference" maxlength="190" placeholder="Transferencia, recibo..."></div><div class="field full"><label>Nota</label><input name="note" maxlength="300" placeholder="Observación del anticipo"></div><button class="btn btn-primary full" type="submit">💰 Registrar anticipo</button></form>
<?php if($recentPayments): ?><div class="recent-payments"><strong>Últimos movimientos</strong><?php foreach($recentPayments as $p): ?><div><span><?=e(date('d/m',strtotime((string)$p['payment_date'])))?> · <?=e(finance_payment_methods()[$p['method']] ?? 'Otro')?></span><b>$<?=number_format((float)$p['amount'],2,'.',',')?></b></div><?php endforeach; ?></div><?php endif; ?><div class="actions actions-left"><a class="btn btn-sm btn-secondary" href="/admin/pagos.php?order_id=<?=((int)$id)?>">Ver todos los pagos</a><a class="btn btn-sm btn-secondary" href="/admin/facturacion.php?order_id=<?=((int)$id)?>">Ver facturación</a></div><?php else: ?><p class="help-text">Instala la migración de Fase 10 para habilitar los registros financieros.</p><?php endif; ?></div>
<div class="card internal-card"><span class="eyebrow">OPERACIÓN</span><h3>Datos internos</h3><form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="details"><div class="field"><label>Fecha compromiso</label><input type="date" name="due_date" value="<?=e((string)($order['due_date'] ?? ''))?>"></div><div class="field"><label>Responsable</label><select name="responsible_user_id"><option value="0">Sin asignar</option><?php foreach($users as $u): ?><option value="<?=((int)$u['id'])?>" <?=$u['id']==$order['responsible_user_id']?'selected':''?>><?=e($u['name'])?></option><?php endforeach; ?></select></div><div class="field"><label>Notas operativas</label><textarea name="notes" rows="4"><?=e((string)($order['notes'] ?? ''))?></textarea></div><div class="field"><label>Notas internas</label><textarea name="internal_notes" rows="4"><?=e((string)($order['internal_notes'] ?? ''))?></textarea></div><button class="btn btn-secondary full" type="submit">Guardar datos</button></form><small>La orden conserva su vínculo con la cotización original.</small></div>
</aside></div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
