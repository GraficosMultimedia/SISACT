<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_auth();

header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

$invoiceId = (int)($_GET['invoice_id'] ?? 0);
if ($invoiceId <= 0) {
    try {
        $invoiceId = (int)(db()->query('SELECT id FROM cp_invoices ORDER BY id DESC LIMIT 1')->fetchColumn() ?: 0);
    } catch (Throwable $e) {
        $invoiceId = 0;
    }
}

$invoice = null;
$directOrder = null;
$selectedCustomer = null;
$checks = [];
$fatal = null;

try {
    if (!finance_tables_ready()) {
        throw new RuntimeException('Las tablas de facturación no están disponibles.');
    }

    if ($invoiceId <= 0) {
        throw new RuntimeException('No se encontró una factura para probar. Usa ?invoice_id=ID.');
    }

    // Misma función utilizada por facturacion.php al entrar en edición.
    $invoice = finance_invoice_get($invoiceId);
    $checks[] = [
        'name' => 'finance_invoice_get()',
        'ok' => (bool)$invoice,
        'detail' => $invoice
            ? 'Factura encontrada. order_id='.(int)$invoice['order_id'].' · customer_id='.(int)$invoice['customer_id']
            : 'No se encontró la factura solicitada.'
    ];

    if (!$invoice) {
        throw new RuntimeException('La factura #'.$invoiceId.' no existe.');
    }

    $orderId = (int)($invoice['order_id'] ?? 0);
    $customerId = (int)($invoice['customer_id'] ?? 0);

    // Consulta directa de la orden, sin JavaScript y sin AJAX.
    $st = db()->prepare(
        "SELECT o.id,o.order_number,o.total,o.order_date,o.status,o.customer_id,c.name AS customer_name
         FROM cp_orders o
         LEFT JOIN cp_customers c ON c.id=o.customer_id
         WHERE o.id=? LIMIT 1"
    );
    $st->execute([$orderId]);
    $directOrder = $st->fetch() ?: null;

    $checks[] = [
        'name' => 'Consulta directa de cp_orders',
        'ok' => (bool)$directOrder,
        'detail' => $directOrder
            ? 'Orden encontrada: '.(string)$directOrder['order_number'].' · cliente #'.(int)$directOrder['customer_id']
            : 'No existe la orden con order_id='.$orderId
    ];

    // Cliente utilizado por el formulario de edición.
    if ($customerId > 0) {
        $st = db()->prepare('SELECT id,name FROM cp_customers WHERE id=? LIMIT 1');
        $st->execute([$customerId]);
        $selectedCustomer = $st->fetch() ?: null;
    }

    $checks[] = [
        'name' => 'Cliente seleccionado',
        'ok' => (bool)$selectedCustomer,
        'detail' => $selectedCustomer
            ? 'Cliente: '.(string)$selectedCustomer['name'].' (#'.(int)$selectedCustomer['id'].')'
            : 'No se encontró el customer_id='.$customerId
    ];

    // Coincidencia factura -> orden -> cliente.
    $relationOk = $directOrder && (int)$directOrder['customer_id'] === $customerId;
    $checks[] = [
        'name' => 'Relación factura → orden → cliente',
        'ok' => (bool)$relationOk,
        'detail' => $relationOk
            ? 'La orden pertenece al mismo cliente guardado en la factura.'
            : 'Hay una discrepancia entre customer_id de la factura y customer_id de la orden.'
    ];

    // Simula exactamente el option que PHP entrega al formulario de edición.
    $optionHtml = '';
    if ($directOrder) {
        $optionHtml = '<option value="'.(int)$directOrder['id'].'" selected>'
            .e((string)$directOrder['order_number'])
            .' · $'.number_format((float)$directOrder['total'], 2, '.', ',')
            .'</option>';
    }

    $checks[] = [
        'name' => 'Option inicial del select',
        'ok' => $optionHtml !== '',
        'detail' => $optionHtml !== ''
            ? 'PHP puede renderizar la orden seleccionada antes de JavaScript.'
            : 'No se pudo construir el option.'
    ];

    // Endpoint que usa facturacion.php para reconstruir las órdenes.
    $ajaxUrl = '/admin/facturacion.php?ajax=customer_orders&customer_id='.$customerId;
} catch (Throwable $e) {
    $fatal = $e->getMessage();
}

function test_badge(bool $ok): string {
    return $ok ? '<span class="badge ok">✓ OK</span>' : '<span class="badge bad">✕ FALLA</span>';
}

function test_h(string $value): string {
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Test de facturación</title>
<link rel="stylesheet" href="/assets/css/finanzas.css?v=20260928-2">
<link rel="stylesheet" href="/assets/css/cfdi-admin.css?v=20260928-2">
<style>
body{margin:0;padding:28px;background:#06111f;color:#eef6ff;font-family:system-ui,-apple-system,Segoe UI,sans-serif}
.test-shell{max-width:1100px;margin:0 auto}.test-card{background:#0c1d31;border:1px solid #244c70;border-radius:16px;padding:24px;margin:0 0 18px}
h1,h2{margin-top:0}.muted{color:#8eafd0}.grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px}
.kv{border:1px solid #234b6f;border-radius:12px;padding:14px;background:#09192b}.kv b{display:block;color:#78c9ff;margin-bottom:5px}
.badge{display:inline-block;padding:5px 10px;border-radius:999px;font-weight:700;font-size:12px}.badge.ok{background:#0b4b3e;color:#6ff0cf}.badge.bad{background:#5a1d2b;color:#ff9eb0}
.row{display:flex;align-items:center;justify-content:space-between;gap:15px;padding:13px 0;border-bottom:1px solid #183751}.row:last-child{border-bottom:0}
.code{background:#06111f;border:1px solid #234b6f;border-radius:10px;padding:14px;overflow:auto;white-space:pre-wrap;word-break:break-word}
.actions{display:flex;gap:10px;flex-wrap:wrap}.btn{display:inline-block;text-decoration:none;background:#168ff0;color:white;border-radius:9px;padding:10px 14px;font-weight:700;border:1px solid #38b7ff;cursor:pointer}.btn.secondary{background:#132c46;border-color:#315d83}
.ajax-result{margin-top:12px}.small{font-size:13px}.oktext{color:#6ff0cf}.badtext{color:#ff9eb0}
@media(max-width:700px){.grid{grid-template-columns:1fr}body{padding:14px}.test-card{padding:17px}}
</style>
</head>
<body>
<div class="test-shell">
  <div class="test-card">
    <div class="muted">DIAGNÓSTICO · SOLO LECTURA</div>
    <h1>Prueba de edición de facturación</h1>
    <p class="muted">Este archivo no guarda, edita ni elimina nada. Comprueba la cadena factura → cliente → orden y la respuesta AJAX antes de tocar <code>facturacion.php</code>.</p>
    <div class="actions">
      <a class="btn secondary" href="/admin/facturacion.php?edit=<?=((int)$invoiceId)?>">Abrir edición real</a>
      <a class="btn secondary" href="/admin/facturacion_test.php?invoice_id=<?=((int)$invoiceId)?>">Volver a probar</a>
    </div>
  </div>

  <?php if ($fatal): ?>
    <div class="test-card">
      <h2>Fallo inicial</h2>
      <p class="badtext"><?=test_h($fatal)?></p>
    </div>
  <?php else: ?>
    <div class="test-card">
      <h2>1. Datos que PHP recibe</h2>
      <div class="grid">
        <div class="kv"><b>Factura</b>#<?=((int)$invoiceId)?></div>
        <div class="kv"><b>order_id</b><?=((int)$invoice['order_id'])?></div>
        <div class="kv"><b>customer_id</b><?=((int)$invoice['customer_id'])?></div>
        <div class="kv"><b>invoice_number</b><?=test_h((string)$invoice['invoice_number'])?></div>
      </div>
    </div>

    <div class="test-card">
      <h2>2. Pruebas de integridad</h2>
      <?php foreach ($checks as $check): ?>
        <div class="row">
          <div><strong><?=test_h($check['name'])?></strong><div class="muted small"><?=test_h($check['detail'])?></div></div>
          <?=test_badge((bool)$check['ok'])?>
        </div>
      <?php endforeach; ?>
    </div>

    <div class="test-card">
      <h2>3. Orden que debería aparecer en el select</h2>
      <?php if ($directOrder): ?>
        <div class="grid">
          <div class="kv"><b>Orden</b><?=test_h((string)$directOrder['order_number'])?></div>
          <div class="kv"><b>Total</b>$<?=number_format((float)$directOrder['total'],2,'.',',')?></div>
          <div class="kv"><b>Cliente</b><?=test_h((string)$directOrder['customer_name'])?></div>
          <div class="kv"><b>Estado</b><?=test_h((string)$directOrder['status'])?></div>
        </div>
        <p class="muted">HTML que PHP debería dejar dentro de <code>#cfdi_order_id</code> antes de que intervenga JavaScript:</p>
        <div class="code"><?=test_h($optionHtml)?></div>
      <?php endif; ?>
    </div>

    <div class="test-card">
      <h2>4. Prueba AJAX real</h2>
      <p class="muted">Esta prueba llama desde el navegador al mismo endpoint que usa <code>facturacion.php</code>. No modifica datos.</p>
      <button type="button" class="btn" id="runAjaxTest">Probar customer_orders</button>
      <div class="ajax-result" id="ajaxResult">Sin ejecutar.</div>
    </div>
  <?php endif; ?>
</div>

<script>
(function(){
  const button=document.getElementById('runAjaxTest');
  const out=document.getElementById('ajaxResult');
  if(!button||!out)return;

  const customerId=<?=json_encode((int)($invoice['customer_id'] ?? 0))?>;
  const expectedOrderId=<?=json_encode((int)($invoice['order_id'] ?? 0))?>;

  button.addEventListener('click',async function(){
    out.innerHTML='Consultando…';

    try{
      const url='/admin/facturacion.php?ajax=customer_orders&customer_id='
        +encodeURIComponent(customerId)+'&_test='+Date.now();

      const response=await fetch(url,{
        credentials:'same-origin',
        cache:'no-store',
        headers:{'Accept':'application/json'}
      });

      const text=await response.text();
      let data=null;

      try{
        data=JSON.parse(text);
      }catch(e){
        throw new Error('La respuesta no es JSON. HTTP '+response.status+' · '+text.slice(0,300));
      }

      if(!response.ok || !data.ok){
        throw new Error((data&&data.error)||('HTTP '+response.status));
      }

      const items=Array.isArray(data.items)?data.items:[];
      const found=items.some(item=>Number(item.id)===expectedOrderId);

      out.innerHTML='<span class="badge ok">✓ AJAX OK</span> '
        +items.length+' orden(es) devueltas. '
        +(found
          ? '<span class="oktext">La orden de la factura aparece en la respuesta.</span>'
          : '<span class="badtext">La orden de la factura NO aparece en la respuesta.</span>');
    }catch(error){
      out.innerHTML='<span class="badge bad">✕ AJAX FALLA</span> '
        +'<span class="badtext">'+String(error.message||error)+'</span>';
    }
  });
})();
</script>
</body>
</html>
