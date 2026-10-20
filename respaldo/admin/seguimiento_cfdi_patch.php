<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

$target = dirname(__DIR__) . '/seguimiento.php';
if (!is_file($target)) {
    http_response_code(404);
    exit('seguimiento.php no encontrado.');
}

$source = file_get_contents($target);
if ($source === false) {
    throw new RuntimeException('No se pudo leer seguimiento.php.');
}

$marker = '$paymentReceipts = $order ? tracking_payment_receipts((int)$order[\'id\']) : [];';
$insert = <<<'PHP'
$paymentReceipts = $order ? tracking_payment_receipts((int)$order['id']) : [];
$trackingCfdis = $order ? tracking_cfdi_for_order((int)$order['id']) : [];
PHP;

if (strpos($source, "tracking_cfdi_for_order((int)\$order['id'])") === false) {
    if (strpos($source, $marker) === false) {
        throw new RuntimeException('No se encontró el punto seguro de inserción en seguimiento.php.');
    }
    $source = str_replace($marker, $insert, $source, $count);
    if ($count !== 1) throw new RuntimeException('La inserción inicial no fue única.');
}

$cssMarker = '.payment-receipts-public{margin-top:16px;padding:21px}';
$cssInsert = <<<'CSS'
.payment-receipts-public{margin-top:16px;padding:21px}
.public-cfdi{margin-top:16px;padding:21px;background:#fff;border:1px solid var(--line);border-radius:var(--radius);box-shadow:var(--shadow)}
.public-cfdi-head{display:flex;justify-content:space-between;align-items:flex-start;gap:15px}
.public-cfdi-head h2{margin:3px 0 4px;color:var(--navy);font-size:20px}
.public-cfdi-head p{margin:0;color:var(--muted);font-size:11px}
.public-cfdi-count{font-size:10px;font-weight:800;color:#087443;background:#eaf9f1;border:1px solid #c9ecd9;padding:8px 11px;border-radius:999px;white-space:nowrap}
.public-cfdi-list{display:grid;gap:10px;margin-top:14px}
.public-cfdi-card{border:1px solid var(--line);border-radius:13px;padding:14px 15px;background:#fbfdff}
.public-cfdi-top{display:flex;justify-content:space-between;gap:15px;align-items:flex-start}
.public-cfdi-label{font-size:10px;color:var(--muted);font-weight:800;text-transform:uppercase;letter-spacing:.06em}
.public-cfdi-name{margin-top:4px;font-size:15px;font-weight:800;color:var(--navy);overflow-wrap:anywhere}
.public-cfdi-uuid{margin-top:4px;font-size:10px;color:#6d7d95;overflow-wrap:anywhere}
.public-cfdi-meta{display:grid;grid-template-columns:repeat(3,1fr);gap:9px;margin-top:11px}
.public-cfdi-meta div{background:#f7faff;border:1px solid #e5eef9;border-radius:10px;padding:9px}
.public-cfdi-meta span{display:block;color:var(--muted);font-size:9px}
.public-cfdi-meta strong{display:block;color:var(--navy);font-size:12px;margin-top:3px}
.public-cfdi-files{display:flex;flex-wrap:wrap;gap:8px;margin-top:12px}
.public-cfdi-files a{display:inline-flex;align-items:center;gap:6px;text-decoration:none;padding:9px 12px;border-radius:9px;font-size:11px;font-weight:800}
.public-cfdi-files .pdf{background:#fff1f1;color:#b52c3c;border:1px solid #f0c8ce}
.public-cfdi-files .xml{background:#edf7ff;color:var(--blue);border:1px solid #cde5f8}
.public-cfdi-more{margin-top:10px;color:var(--muted);font-size:10px}
@media(max-width:760px){
  .public-cfdi-head{display:block}
  .public-cfdi-count{display:inline-block;margin-top:9px}
  .public-cfdi-meta{grid-template-columns:1fr}
  .public-cfdi-top{display:block}
}
CSS;
if (strpos($source, '.public-cfdi{') === false) {
    if (strpos($source, $cssMarker) === false) {
        throw new RuntimeException('No se encontró el bloque CSS de comprobantes.');
    }
    $source = str_replace($cssMarker, $cssInsert, $source, $count);
    if ($count !== 1) throw new RuntimeException('La inserción CSS no fue única.');
}

$htmlMarker = '<section class="payment-receipts-public tracking-card" id="comprobantes-pago">';
$htmlBlock = <<<'PHP'
<section class="public-cfdi tracking-card" id="facturas-cfdi">
  <div class="public-cfdi-head">
    <div>
      <span class="eyebrow">FACTURAS Y CFDI</span>
      <h2>Facturas de esta orden</h2>
      <p>Documentos fiscales registrados para tu pedido.</p>
    </div>
    <?php if ($trackingCfdis): ?>
      <span class="public-cfdi-count"><?=count($trackingCfdis)?> <?=count($trackingCfdis)===1?'factura registrada':'facturas registradas'?></span>
    <?php endif; ?>
  </div>

  <?php if ($trackingCfdis): ?>
    <div class="public-cfdi-list">
      <?php foreach ($trackingCfdis as $cfdi): ?>
        <article class="public-cfdi-card">
          <div class="public-cfdi-top">
            <div>
              <div class="public-cfdi-label">Factura CFDI</div>
              <div class="public-cfdi-name"><?=track_e((string)($cfdi['invoice_number'] ?: $cfdi['uuid'] ?: 'Documento fiscal'))?></div>
              <div class="public-cfdi-uuid"><?=track_e((string)($cfdi['uuid'] ?: 'Sin UUID'))?></div>
            </div>
            <span class="receipt-badge"><?=track_e($cfdi['invoice_status']==='issued'?'Emitida':ucfirst((string)$cfdi['invoice_status']))?></span>
          </div>

          <div class="public-cfdi-meta">
            <div><span>Fecha</span><strong><?=track_date((string)($cfdi['issued_at'] ?: ''),'d/m/Y')?></strong></div>
            <div><span>Subtotal</span><strong><?=track_money((float)$cfdi['subtotal'])?></strong></div>
            <div><span>Total</span><strong><?=track_money((float)$cfdi['total'])?></strong></div>
          </div>

          <div class="public-cfdi-files">
            <?php if (!empty($cfdi['pdf_path'])): ?>
              <a class="pdf" target="_blank" rel="noopener noreferrer"
                 href="/seguimiento_cfdi.php?t=<?=rawurlencode($token)?>&id=<?=((int)$cfdi['document_id'])?>&file=pdf">
                📄 Descargar PDF
              </a>
            <?php endif; ?>
            <?php if (!empty($cfdi['xml_path'])): ?>
              <a class="xml" href="/seguimiento_cfdi.php?t=<?=rawurlencode($token)?>&id=<?=((int)$cfdi['document_id'])?>&file=xml">
                🧾 Descargar XML
              </a>
            <?php endif; ?>
          </div>

          <?php if (empty($cfdi['pdf_path']) && empty($cfdi['xml_path'])): ?>
            <div class="public-cfdi-more">El expediente está registrado, pero aún no hay archivos disponibles para descarga.</div>
          <?php endif; ?>
        </article>
      <?php endforeach; ?>
    </div>
  <?php else: ?>
    <p class="muted">Todavía no hay facturas registradas para esta orden.</p>
  <?php endif; ?>
</section>

<section class="payment-receipts-public tracking-card" id="comprobantes-pago">
PHP;
if (strpos($source, 'id="facturas-cfdi"') === false) {
    if (strpos($source, $htmlMarker) === false) {
        throw new RuntimeException('No se encontró el bloque de comprobantes de pago.');
    }
    $source = str_replace($htmlMarker, $htmlBlock, $source, $count);
    if ($count !== 1) throw new RuntimeException('La inserción HTML no fue única.');
}

$backup = $target . '.bak_cfdi_tracking_v1';
if (!is_file($backup)) {
    if (!copy($target, $backup)) throw new RuntimeException('No se pudo crear respaldo.');
}

if (file_put_contents($target, $source, LOCK_EX) === false) {
    throw new RuntimeException('No se pudo escribir seguimiento.php.');
}

echo '<h2>Integración CFDI aplicada</h2>';
echo '<p>Verificación completada. Respaldo: <code>'.htmlspecialchars(basename($backup),ENT_QUOTES,'UTF-8').'</code></p>';
?>
