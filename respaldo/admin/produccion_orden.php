<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/produccion.php';
require_once __DIR__ . '/../includes/whatsapp.php';
require_auth();
$id=(int)($_GET['id'] ?? 0);
$order=order_get($id);
if(!$order) redirect('/admin/produccion.php');
$title='Producción · '.$order['order_number']; $error=null;
if($_SERVER['REQUEST_METHOD']==='POST'){
  if(!csrf_check($_POST['_csrf'] ?? null)) $error='La sesión del formulario expiró. Recarga la página.';
  else {
    try { $stage=(string)($_POST['stage'] ?? ''); production_set_stage($id,$stage,trim((string)($_POST['note'] ?? ''))); log_activity('update','production','Etapa actualizada para orden #'.$id); redirect('/admin/produccion_orden.php?id='.$id.'&updated=1'); }
    catch(Throwable $e){ $error=$e->getMessage()==='Etapa de producción no válida.'?$e->getMessage():'No se pudo actualizar la etapa.'; }
  }
}
$order=order_get($id); $items=order_items($id); $history=production_history($id); $current=production_get_stage($id); $stages=production_stages(); unset($stages['cancelled']);
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/produccion.css?v=20260917-7">
<div class="production-toolbar no-print"><div><span class="eyebrow">FASE 7 · ORDEN EN PRODUCCIÓN</span><h2><?=e($order['order_number'])?></h2><p class="muted">Cotización de origen: <a href="/admin/cotizacion.php?id=<?=((int)$order['quote_id'])?>"><?=e($order['quote_number'])?></a></p></div><div class="production-actions"><?php if (!empty($order['customer_phone'])): ?><a class="btn btn-secondary" href="/admin/whatsapp.php?source=order&id=<?=((int)$id)?>&template=<?=e(whatsapp_stage_template_key($current))?>">💬 WhatsApp etapa</a><?php endif; ?><a class="btn btn-secondary" href="/admin/produccion.php">← Kanban</a><a class="btn btn-secondary" href="/admin/orden.php?id=<?=((int)$id)?>">Ver orden</a></div></div>
<?php if($error): ?><div class="notice danger no-print"><?=e($error)?></div><?php endif; ?><?php if(isset($_GET['updated'])): ?><div class="notice no-print"><span class="ok">✓</span> Producción actualizada.</div><?php endif; ?>
<div class="production-detail-grid">
<main>
<section class="card production-document"><div class="document-head"><div><span class="eyebrow">COLIBRÍ PRINT MÉXICO</span><h3><?=e($order['order_number'])?></h3><p><?=e($order['customer_name'] ?? 'Sin cliente')?> · Fecha compromiso: <?=!empty($order['due_date'])?e(date('d/m/Y',strtotime((string)$order['due_date']))):'Sin fecha'?></p></div><span class="production-status stage-<?=e($current)?>"><?=e(production_stage_icon($current).' '.production_stage_label($current))?></span></div>
<div class="production-progress"><?php foreach($stages as $k=>$meta): ?><div class="progress-step <?=$k===$current?'active':''?> <?=array_search($current,array_keys($stages),true)!==false && array_search($k,array_keys($stages),true)<array_search($current,array_keys($stages),true)?'done':''?>"><span><?=e($meta['icon'])?></span><small><?=e($meta['label'])?></small></div><?php endforeach; ?></div>
<h4>Conceptos</h4><div class="table-wrap"><table class="table"><thead><tr><th>Descripción</th><th>Cantidad</th><th>Precio</th><th>Importe</th></tr></thead><tbody><?php foreach($items as $item): ?><tr><td><?=e($item['description'])?></td><td><?=e((string)$item['quantity'])?></td><td><?=quote_money((float)$item['unit_price'])?></td><td><?=quote_money((float)$item['subtotal'])?></td></tr><?php endforeach; ?></tbody></table></div>
<div class="production-meta"><div><span>RESPONSABLE</span><strong><?=e($order['responsible_name'] ?? 'Sin asignar')?></strong></div><div><span>TOTAL</span><strong><?=quote_money((float)$order['total'])?></strong></div></div>
<?php if($order['notes']): ?><div class="document-section"><h4>Notas operativas</h4><p><?=nl2br(e($order['notes']))?></p></div><?php endif; ?></section>
<section class="card history-card" id="historial"><div class="section-heading"><div><span class="eyebrow">HISTORIAL</span><h3>Movimientos de producción</h3></div></div><?php if(!$history): ?><p class="empty">Sin movimientos registrados.</p><?php else: ?><div class="history-list"><?php foreach($history as $h): ?><div class="history-item"><div><strong><?=e(production_stage_label((string)$h['new_status']))?></strong><small><?=e(date('d/m/Y H:i',strtotime((string)$h['created_at'])))?> · <?=e($h['user_name'] ?? 'Sistema')?></small></div><?php if(trim((string)$h['note'])!==''): ?><p><?=nl2br(e($h['note']))?></p><?php endif; ?></div><?php endforeach; ?></div><?php endif; ?></section>
</main>
<aside class="no-print"><section class="card stage-editor"><span class="eyebrow">CONTROL DE PRODUCCIÓN</span><h3>Mover de etapa</h3><form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><div class="field"><label>Nueva etapa</label><select name="stage"><?php foreach($stages as $k=>$meta): ?><option value="<?=e($k)?>" <?=$current===$k?'selected':''?>><?=e($meta['icon'].' '.$meta['label'])?></option><?php endforeach; ?></select></div><div class="field"><label for="stageNote">Mensaje de la etapa</label><textarea id="stageNote" name="note" rows="6" placeholder="El mensaje se cargará automáticamente al seleccionar una etapa..."></textarea><small class="field-help">El mensaje sugerido cambia automáticamente según la etapa. Puedes editarlo antes de guardar.</small></div><button class="btn btn-primary full" type="submit">Guardar etapa</button></form></section><section class="card stage-help"><span class="eyebrow">FLUJO</span><p>Pendiente → Diseño → Aprobación → Impresión → Producción → Calidad → Listo → Entregado</p><small>El cambio queda registrado en el historial de la orden.</small></section></aside>
</div>
<script>
(function(){
  const stage=document.querySelector('select[name="stage"]');
  const note=document.getElementById('stageNote');
  if(!stage||!note) return;
  const messages={
    pending:'Hemos recibido tu pedido y se encuentra en espera de iniciar el proceso. Te informaremos cuando avance a la siguiente etapa.',
    design:'Tu pedido se encuentra en etapa de diseño. Estamos preparando y revisando los detalles necesarios antes de continuar.',
    approval:'El diseño de tu pedido está listo para revisión y aprobación. Una vez aprobado, podremos continuar con el proceso.',
    printing:'Tu pedido se encuentra en proceso de impresión. Estamos trabajando en la producción de tus piezas.',
    production:'Tu pedido se encuentra en producción. Nuestro equipo está realizando el proceso de fabricación y acabado.',
    quality:'Tu pedido se encuentra en revisión de calidad. Estamos verificando que el trabajo cumpla con los requisitos antes de entregarlo.',
    ready:'Tu pedido está terminado y listo para entrega. Te informaremos las indicaciones correspondientes para recibirlo.',
    delivered:'Tu pedido ha sido entregado. Gracias por confiar en Colibrí Print México.'
  };
  let lastSuggested='';
  function syncMessage(force){
    const text=messages[stage.value]||'';
    if(force || note.value.trim()==='' || note.value===lastSuggested){
      note.value=text;
      lastSuggested=text;
    }
  }
  stage.addEventListener('change',function(){ syncMessage(true); });
  syncMessage(false);
})();
</script>
<style>
.stage-editor .field-help{display:block;margin-top:7px;line-height:1.45;opacity:.72;}
.stage-editor textarea{min-height:125px;resize:vertical;}
</style>
<?php require __DIR__ . '/../includes/footer.php'; ?>
