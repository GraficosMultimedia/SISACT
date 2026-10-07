<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cfdi.php';
require_auth();
$id=(int)($_GET['id']??0); $doc=cfdi_document_get($id); if(!$doc){http_response_code(404);exit('Documento CFDI no encontrado.');}
$items=[]; if(cfdi_tables_ready()){ $st=db()->prepare('SELECT * FROM cp_invoice_items WHERE document_id=? ORDER BY id');$st->execute([$id]);$items=$st->fetchAll()?:[]; }
if(isset($_GET['download'])) { $kind=$_GET['download']==='pdf'?'pdf':'xml'; cfdi_stream_file($doc,$kind); }
require __DIR__.'/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/finanzas.css?v=20260928-1"><link rel="stylesheet" href="/assets/css/cfdi-admin.css?v=20260928-1">
<div class="finance-toolbar"><div><span class="eyebrow">EXPEDIENTE CFDI</span><h2><?=e($doc['invoice_number'])?></h2><p class="muted">Documento fiscal asociado a <?=e($doc['order_number'])?>.</p></div><div class="finance-actions"><a class="btn btn-secondary" href="/admin/facturacion.php?edit=<?=((int)$doc['invoice_id'])?>">← Factura</a><?php if($doc['xml_path']): ?><a class="btn btn-secondary" href="/admin/cfdi_documento.php?id=<?=$id?>&download=xml">XML</a><?php endif; ?><?php if($doc['pdf_path']): ?><a class="btn btn-save" href="/admin/cfdi_documento.php?id=<?=$id?>&download=pdf">PDF</a><?php endif; ?></div></div>
<div class="card cfdi-sheet">
  <div class="cfdi-hero"><div><span>UUID</span><strong><?=e($doc['uuid']?:'Sin UUID')?></strong></div><div><span>Versión</span><strong><?=e($doc['version'])?></strong></div><div><span>Moneda</span><strong><?=e($doc['moneda']?:'MXN')?></strong></div></div>
  <div class="cfdi-parties"><div><span>EMISOR</span><strong><?=e($doc['emisor_nombre']?:'—')?></strong><small><?=e($doc['emisor_rfc']?:'—')?></small></div><div><span>RECEPTOR</span><strong><?=e($doc['receptor_nombre']?:'—')?></strong><small><?=e($doc['receptor_rfc']?:'—')?></small></div></div>
  <div class="table-wrap"><table class="table finance-table"><thead><tr><th>Clave</th><th>Descripción</th><th>Cantidad</th><th>Unidad</th><th>Valor unitario</th><th>Importe</th></tr></thead><tbody><?php foreach($items as $it): ?><tr><td><?=e($it['clave_prod_serv']?:'—')?></td><td><?=e($it['descripcion']?:'—')?></td><td><?=e((string)$it['cantidad'])?></td><td><?=e($it['unidad']?:$it['clave_unidad']?:'—')?></td><td>$<?=number_format((float)$it['valor_unitario'],2,'.',',')?></td><td>$<?=number_format((float)$it['importe'],2,'.',',')?></td></tr><?php endforeach; ?></tbody></table></div>
  <div class="cfdi-totals"><div><span>Subtotal</span><strong>$<?=number_format((float)$doc['subtotal'],2,'.',',')?></strong></div><div><span>IVA / impuestos trasladados</span><strong>$<?=number_format((float)$doc['tax'],2,'.',',')?></strong></div><div class="grand"><span>Total</span><strong>$<?=number_format((float)$doc['total'],2,'.',',')?></strong></div></div>
  <div class="cfdi-meta"><div><span>Forma de pago</span><strong><?=e($doc['forma_pago']?:'—')?></strong></div><div><span>Método de pago</span><strong><?=e($doc['metodo_pago']?:'—')?></strong></div><div><span>Certificado SAT</span><strong><?=e($doc['certificado_sat']?:'—')?></strong></div><div><span>No. certificado</span><strong><?=e($doc['no_certificado_sat']?:'—')?></strong></div></div>
</div>
<?php require __DIR__.'/../includes/footer.php'; ?>
