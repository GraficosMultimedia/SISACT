<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_auth();

$quoteId=(int)($_GET['quote_id'] ?? $_POST['quote_id'] ?? 0);
$error=null;
$quote=null;
try {
    $users=db()->query('SELECT id,name FROM cp_users ORDER BY name')->fetchAll();
} catch(Throwable $e) {
    error_log('orden_nueva usuarios: '.$e->getMessage().' | '.$e->getFile().' | linea='.$e->getLine());
    $users=[];
}
$orderDate=date('Y-m-d');
$dueDate='';
$responsible=(int)(current_user()['id'] ?? 0);
$notes='';
$internalNotes='';
$total=0.0;

/*
 * FASE 9 CORRECCIÓN:
 * La creación de una orden ya no obliga al usuario a conocer el ID de la
 * cotización. Mostramos directamente las cotizaciones aprobadas y que aún
 * no tienen una orden operativa activa.
 */
$approvedQuotes=[];
try {
    $approvedStmt=db()->query(
        "SELECT q.id,q.quote_number,q.issue_date,q.valid_until,
                c.name AS customer_name,
                COALESCE(t.total,0) AS total
         FROM cp_quotes q
         LEFT JOIN cp_customers c ON c.id=q.customer_id
         LEFT JOIN cp_quote_totals t ON t.quote_id=q.id
         WHERE q.status='approved'
           AND NOT EXISTS (
               SELECT 1 FROM cp_orders o
               WHERE o.quote_id=q.id
                 AND o.status<>'cancelled'
           )
         ORDER BY q.id DESC"
    );
    $approvedQuotes=$approvedStmt->fetchAll();
} catch(Throwable $e) {
    $error='No se pudieron cargar las cotizaciones aprobadas. Verifica la estructura de la base de datos.';
}

if($quoteId>0){
    try {
        $quote=quote_get($quoteId);
        if(!$quote){
            $error='La cotización seleccionada no existe.';
        } elseif((string)$quote['status']!=='approved') {
            $error='La cotización debe estar en estado Aprobada antes de crear la orden de servicio.';
            $quote=null;
        } else {
            $existing=order_for_quote($quoteId);
            if($existing && (string)$existing['status']!=='cancelled'){
                redirect('/admin/orden.php?id='.(int)$existing['id']);
            }
            $total=(float)order_total_from_quote($quoteId);
            $dueDate=trim((string)($quote['valid_until'] ?? ''));
        }
    } catch(Throwable $e) {
        error_log('orden_nueva cargar cotizacion: '.$e->getMessage().' | '.$e->getFile().' | linea='.$e->getLine());
        $quote=null;
        $error='No se pudo cargar la cotización seleccionada.';
    }
}

if($_SERVER['REQUEST_METHOD']==='POST' && $quote && !$error){
    if(!csrf_check($_POST['_csrf'] ?? null)){
        $error='La sesión del formulario expiró. Recarga la página.';
    } else {
        $orderDate=(string)($_POST['order_date'] ?? date('Y-m-d'));
        $dueDate=trim((string)($quote['valid_until'] ?? ''));
        $responsible=(int)($_POST['responsible_user_id'] ?? 0);
        $notes=trim((string)($_POST['notes'] ?? ''));
        $internalNotes=trim((string)($_POST['internal_notes'] ?? ''));
        try {
            $items=quote_items($quoteId);
            $total=(float)order_total_from_quote($quoteId);
            if(!$items){
                throw new RuntimeException('La cotización no contiene conceptos.');
            }
                $pdo=db();
                $pdo->beginTransaction();
                $uid=(int)(current_user()['id'] ?? 0);
                $number=order_number_next();
                $st=$pdo->prepare('INSERT INTO cp_orders(order_number,quote_id,customer_id,status,order_date,due_date,responsible_user_id,total,notes,internal_notes,created_by,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');
                $st->execute([$number,$quoteId,$quote['customer_id']??null,'pending',$orderDate,$dueDate?:null,$responsible?:null,$total,$notes,$internalNotes,$uid,$uid]);
                $orderId=(int)$pdo->lastInsertId();
                $ins=$pdo->prepare('INSERT INTO cp_order_items(order_id,quote_item_id,description,quantity,unit_price,subtotal,sort_order,created_at,updated_at) VALUES(?,?,?,?,?,?,?,NOW(),NOW())');
                foreach($items as $i=>$item){
                    $ins->execute([$orderId,$item['id'],$item['description'],$item['quantity'],$item['unit_price'],$item['subtotal'],$i]);
                }
                $pdo->prepare('INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at) VALUES(?,?,?,?,?,NOW())')
                    ->execute([$orderId,null,'pending','Orden creada desde '.$quote['quote_number'],$uid]);
                $pdo->commit();
                log_activity('create','orders','Orden creada '.$number.' desde cotización #'.$quoteId);
                redirect('/admin/orden.php?id='.$orderId.'&created=1');
        }catch(Throwable $e){
            if(isset($pdo)&&$pdo->inTransaction())$pdo->rollBack();
            error_log('orden_nueva crear orden: '.$e->getMessage().' | '.$e->getFile().' | linea='.$e->getLine());
            $error='No se pudo crear la orden. Revisa el registro de errores.';
        }
    }
}

$title='Nueva orden de servicio';
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/ordenes.css?v=20260917-9b">

<div class="order-toolbar">
  <div>
    <span class="eyebrow">FASE 6 · NUEVA ORDEN</span>
    <h2>Nueva orden de servicio</h2>
    <p class="muted">Selecciona una cotización aprobada para iniciar el servicio.</p>
  </div>
  <div class="order-toolbar-actions"><a class="btn btn-secondary" href="/admin/ordenes.php">Cancelar</a></div>
</div>

<?php if($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>

<?php if(!$quote): ?>
<section class="card approved-quotes-card">
  <div class="section-heading">
    <div>
      <span class="eyebrow">COTIZACIONES APROBADAS</span>
      <h3>Selecciona el trabajo que vas a convertir en orden</h3>
      <p class="muted">Solo aparecen cotizaciones aprobadas que todavía no tienen una orden de servicio activa.</p>
    </div>
    <span class="count-pill"><?=count($approvedQuotes)?></span>
  </div>

  <?php if(!$approvedQuotes): ?>
    <div class="approved-empty">
      <div class="approved-empty-icon">📋</div>
      <strong>No hay cotizaciones aprobadas disponibles</strong>
      <p>Cuando una cotización pase a <b>Aprobada</b>, aparecerá automáticamente aquí para crear su orden de servicio.</p>
      <a class="btn btn-secondary" href="/admin/cotizaciones.php">Ver cotizaciones</a>
    </div>
  <?php else: ?>
    <div class="approved-quote-list">
      <?php foreach($approvedQuotes as $q): ?>
        <a class="approved-quote-row" href="/admin/orden_nueva.php?quote_id=<?=((int)$q['id'])?>">
          <div class="approved-quote-main">
            <strong><?=e($q['quote_number'])?></strong>
            <span><?=e($q['customer_name'] ?? 'Sin cliente')?></span>
          </div>
          <div class="approved-quote-meta">
            <span>Fecha: <?=e(date('d/m/Y',strtotime((string)$q['issue_date'])))?></span>
            <?php if(!empty($q['valid_until'])): ?><span>Vigencia: <?=e(date('d/m/Y',strtotime((string)$q['valid_until'])))?></span><?php endif; ?>
          </div>
          <div class="approved-quote-total"><?=quote_money((float)$q['total'])?></div>
          <span class="btn btn-sm btn-primary">Crear orden →</span>
        </a>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</section>
<?php else: ?>
<div class="order-create-grid">
<section class="card">
  <div class="section-heading">
    <div><span class="eyebrow">ORIGEN</span><h3><?=e($quote['quote_number'])?></h3></div>
    <span class="status-badge order-status-<?=e((string)$quote['status'])?>"><?=e(quote_status_label((string)$quote['status']))?></span>
  </div>
  <div class="customer-box"><span>CLIENTE</span><strong><?=e($quote['customer_name'] ?? 'Sin cliente')?></strong><?php if($quote['customer_phone']): ?><small><?=e($quote['customer_phone'])?></small><?php endif; ?></div>
  <table class="table"><thead><tr><th>Descripción</th><th>Cant.</th><th>Importe</th></tr></thead><tbody>
  <?php foreach(quote_items($quoteId) as $item): ?><tr><td><?=e($item['description'])?></td><td><?=e((string)$item['quantity'])?></td><td><?=quote_money((float)$item['subtotal'])?></td></tr><?php endforeach; ?>
  </tbody></table>
  <div class="document-total"><div class="grand"><span>Total</span><strong><?=quote_money($total)?></strong></div></div>
</section>
<aside class="card">
  <span class="eyebrow">OPERACIÓN</span><h3>Datos de la orden</h3>
  <form method="post">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="quote_id" value="<?=((int)$quoteId)?>">
    <div class="field"><label>Fecha de orden</label><input type="date" name="order_date" value="<?=e($orderDate)?>" required></div>
    <div class="field"><label>Fecha compromiso (desde cotización)</label><input type="date" name="due_date" value="<?=e($dueDate)?>" readonly><small>Esta fecha se toma directamente de la vigencia/vencimiento de la cotización.</small></div>
    <div class="field"><label>Responsable</label><select name="responsible_user_id"><option value="0">Sin asignar</option><?php foreach($users as $u): ?><option value="<?=((int)$u['id'])?>" <?=$responsible===(int)$u['id']?'selected':''?>><?=e($u['name'])?></option><?php endforeach; ?></select></div>
    <div class="field"><label>Notas para operación</label><textarea name="notes" rows="5" placeholder="Indicaciones que acompañarán la orden..."><?=e($notes)?></textarea></div>
    <div class="field"><label>Notas internas</label><textarea name="internal_notes" rows="4" placeholder="Información interna..."><?=e($internalNotes)?></textarea></div>
    <div class="form-actions"><a class="btn btn-secondary" href="/admin/orden_nueva.php">← Cambiar cotización</a><button class="btn btn-primary" type="submit">Crear orden</button></div>
  </form>
</aside>
</div>
<?php endif; ?>
<?php require __DIR__ . '/../includes/footer.php'; ?>
