<?php
declare(strict_types=1);

/**
 * Renderer único del documento profesional de Orden de Servicio.
 *
 * Lo usan:
 * - /admin/orden_pdf_2paginas.php
 * - /seguimiento_comprobante.php
 *
 * De esta forma Administración y Seguimiento muestran exactamente
 * el mismo documento profesional.
 */
function render_order_professional_2pages(
    array $order,
    array $items,
    ?array $finance,
    array $payments,
    array $quoteSync,
    array $company
): void {
    $brand=(string)($company['trade_name']?:$company['legal_name']?:'Colibrí Print');
    $logo=(string)($company['logo_path']??'');

    $money=static fn(float $n):string=>'$'.number_format($n,2,'.',',');
    $esc=static fn(string $v):string=>htmlspecialchars($v,ENT_QUOTES,'UTF-8');
    $pct=static function(float $n):string{
        $s=number_format($n,2,'.','');
        return rtrim(rtrim($s,'0'),'.').'%';
    };

    $total=(float)($order['total']??0);
    $paid=$finance?(float)($finance['paid_total']??0):0.0;
    $balance=$finance?(float)($finance['balance']??max(0,$total-$paid)):max(0,$total-$paid);

    $quoteId=(int)($order['quote_id']??0);
    $quoteTotals=$quoteId>0
        ? quote_totals($quoteId)
        : ['subtotal'=>0,'discount'=>0,'tax'=>0,'total'=>0];

    $commercialSubtotal=(float)($quoteTotals['subtotal']??0);
    $commercialDiscount=(float)($quoteTotals['discount']??0);
    $commercialTax=(float)($quoteTotals['tax']??0);

    $discountPct=($commercialSubtotal>0 && $commercialDiscount>0)
        ? ($commercialDiscount/$commercialSubtotal)*100
        : 0.0;

    $taxBase=max(0.0,$commercialSubtotal-$commercialDiscount);
    $taxPct=($taxBase>0 && $commercialTax>0)
        ? ($commercialTax/$taxBase)*100
        : 0.0;

    $hasBreakdown=$commercialSubtotal>0 || $commercialDiscount>0 || $commercialTax>0;

    $status=(string)($order['status']??'');
    $statusLabel=static function(string $s):string{
        $map=[
            'draft'=>'Borrador',
            'confirmed'=>'Confirmada',
            'pending'=>'Pendiente',
            'in_progress'=>'En producción',
            'completed'=>'Completada',
            'ready'=>'Lista para entrega',
            'delivered'=>'Entregada',
            'cancelled'=>'Cancelada',
        ];
        return $map[$s]??$s;
    };

    header('Content-Type: text/html; charset=UTF-8');
    header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
    header('X-Robots-Tag: noindex, nofollow', true);
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>Orden <?=$esc((string)$order['order_number'])?></title>
<style>
@page{size:Letter;margin:12mm 14mm}
*{box-sizing:border-box}
body{margin:0;background:#e9eef3;color:#17212b;font-family:Arial,Helvetica,sans-serif;font-size:10pt}
.print-actions{
    position:sticky;top:0;z-index:20;display:flex;justify-content:center;gap:8px;
    padding:10px;background:rgba(11,34,57,.96);box-shadow:0 5px 18px rgba(0,0,0,.14)
}
.print-actions button{
    border:0;border-radius:8px;padding:9px 14px;background:#16b7a4;color:#fff;
    font:inherit;font-size:9pt;font-weight:800;cursor:pointer
}
.sheet{
    width:215.9mm;min-height:279.4mm;margin:10mm auto;padding:12mm 14mm;
    background:#fff;position:relative;page-break-after:always;
    box-shadow:0 8px 30px rgba(23,33,43,.11)
}
.sheet:last-child{page-break-after:auto}
.accent{height:3px;background:#16b7a4;margin:-12mm -14mm 7mm}
.accent.pink{background:#ec0b63}
.header{display:flex;justify-content:space-between;align-items:flex-start}
.brand{display:flex;gap:10px;align-items:center}
.brand img{width:42mm;max-height:20mm;object-fit:contain}
.brand strong{display:block;font-size:16pt;color:#0b2239}
.brand small{color:#667085}
.title{text-align:right}
.eyebrow{font-size:7.5pt;letter-spacing:.1em;text-transform:uppercase;color:#667085;font-weight:800}
.title h1{margin:3px 0;font-size:23pt;color:#0b2239}
.title p{margin:0;color:#667085;font-size:8pt}
.status{display:inline-block;margin-top:4px;padding:4px 8px;background:#e8fbf8;color:#087c70;font-size:7.5pt;font-weight:800}
.grid3{display:grid;grid-template-columns:1fr 1fr 1fr;margin-top:5mm;background:#f4f7fa;border:1px solid #d9e1e8}
.grid3>div{padding:3.5mm;border-right:1px solid #d9e1e8}
.grid3>div:last-child{border-right:0}
.value{margin-top:2px;font-size:8.7pt}
.box{border:1px solid #d9e1e8;padding:4mm;margin-top:4mm}
.client{font-size:13pt;font-weight:800;color:#0b2239;margin-top:2px}
.meta{display:grid;grid-template-columns:1fr 1fr;gap:4px 15px;margin-top:5px;color:#4f5b67;font-size:8.5pt}
table{width:100%;border-collapse:collapse;margin-top:5mm}
th{background:#0b2239;color:#fff;text-align:left;padding:7px;font-size:7.8pt}
td{border-bottom:1px solid #d9e1e8;padding:7px;font-size:8.5pt}
th:not(:first-child),td:not(:first-child){text-align:right}
.totals{width:50%;margin-left:auto;margin-top:4mm}
.totals .trow{display:flex;justify-content:space-between;gap:15px;padding:5px 7px;border-bottom:1px solid #d9e1e8;color:#4f5b67}
.totals .trow b{color:#17212b}
.totals .discount b{color:#d20b42}
.totals .tax b{color:#087c70}
.totals .grand{
    display:flex;justify-content:space-between;gap:15px;border-top:2px solid #16b7a4;
    border-bottom:0;padding:8px 7px 5px;font-size:14pt;font-weight:800;color:#0b2239
}
.section{border-top:1px solid #d9e1e8;margin-top:5mm;padding-top:3mm}
.section h3{margin:0 0 4px;color:#0b2239;font-size:9.5pt}
.section p{margin:0;color:#596675;font-size:8.5pt}
.footer{
    position:absolute;left:14mm;right:14mm;bottom:6mm;border-top:1px solid #16b7a4;
    padding-top:3px;color:#667085;font-size:7pt;display:flex;justify-content:space-between
}
.summary{margin-top:8mm;border:1px solid #d9e1e8}
.row{display:flex;justify-content:space-between;padding:10px 13px;border-bottom:1px solid #d9e1e8}
.head{background:#0b2239;color:#fff;font-weight:800;font-size:7.8pt}
.row.discount strong{color:#d20b42}
.row.tax strong{color:#087c70}
.row.total{background:#f4f7fa;font-weight:800}
.paid{background:#e8fbf8}
.balance{background:#fff4f6}
.balance strong{color:#d20b42;font-size:17pt}
.paylist{margin-top:5mm;border:1px solid #d9e1e8}
.payrow{display:grid;grid-template-columns:24mm 30mm 1fr 30mm;gap:8px;padding:7px;border-bottom:1px solid #d9e1e8;font-size:8pt}
.payrow.head{background:#f4f7fa;color:#667085;font-weight:800}
.note{margin-top:7mm;background:#f4f7fa;border:1px solid #d9e1e8;padding:5mm;font-size:8.5pt;color:#44515e}
.closing{margin-top:8mm;background:#0b2239;color:#fff;padding:5mm;display:grid;grid-template-columns:1fr 1fr 1fr}
.closing span{display:block;font-size:7pt;opacity:.75;text-transform:uppercase}
.closing strong{display:block;margin-top:2px;font-size:11pt}

@media(max-width:900px){
    body{background:#fff}
    .sheet{width:100%;min-height:auto;margin:0;padding:18px;box-shadow:none}
    .footer{position:static;margin-top:25px}
}
@media print{
    .print-actions{display:none!important}
    body{background:#fff}
    .sheet{width:auto;min-height:0;margin:0;padding:0;box-shadow:none}
    .accent{margin:0 0 7mm}
    .footer{position:fixed}
}
</style>
</head>
<body>

<div class="print-actions">
    <button type="button" onclick="window.print()">🖨️ Imprimir / Guardar PDF</button>
</div>

<section class="sheet">
<div class="accent"></div>

<div class="header">
    <div class="brand">
        <?php if($logo):?><img src="<?=$esc($logo)?>" alt="logo"><?php endif;?>
        <div>
            <strong><?=$esc($brand)?></strong>
            <?php if(!empty($company['legal_name'])):?><small><?=$esc((string)$company['legal_name'])?></small><?php endif;?>
        </div>
    </div>

    <div class="title">
        <div class="eyebrow">ORDEN DE SERVICIO</div>
        <h1><?=$esc((string)$order['order_number'])?></h1>
        <p>
            Fecha: <?=$esc(date('d/m/Y',strtotime((string)$order['order_date'])))?>
            <?php if(!empty($order['due_date'])):?>
                · Compromiso: <?=$esc(date('d/m/Y',strtotime((string)$order['due_date'])))?>
            <?php endif;?>
        </p>
        <span class="status"><?=$esc($statusLabel($status))?></span>
    </div>
</div>

<div class="grid3">
    <div>
        <div class="eyebrow">ORDEN</div>
        <div class="value"><?=$esc((string)$order['order_number'])?></div>
    </div>
    <div>
        <div class="eyebrow">COTIZACIÓN</div>
        <div class="value"><?=$esc((string)($order['quote_number']??'—'))?></div>
    </div>
    <div>
        <div class="eyebrow">FECHA DE ENTREGA</div>
        <div class="value"><?=!empty($order['due_date'])?$esc(date('d/m/Y',strtotime((string)$order['due_date']))):'Por definir'?></div>
    </div>
</div>

<div class="box">
    <div class="eyebrow">DATOS DEL CLIENTE</div>
    <div class="client"><?=$esc((string)($order['customer_name']??'Sin cliente'))?></div>

    <div class="meta">
        <?php if(!empty($order['customer_tax_number'])):?><div><b>RFC:</b> <?=$esc((string)$order['customer_tax_number'])?></div><?php endif;?>
        <?php if(!empty($order['customer_phone'])):?><div><b>Teléfono:</b> <?=$esc((string)$order['customer_phone'])?></div><?php endif;?>
        <?php if(!empty($order['customer_email'])):?><div><b>Correo:</b> <?=$esc((string)$order['customer_email'])?></div><?php endif;?>
        <?php if(!empty($order['customer_address'])):?><div><b>Domicilio:</b> <?=$esc((string)$order['customer_address'])?></div><?php endif;?>
    </div>
</div>

<?php if(!empty($quoteSync['exists'])):?>
<div class="box">
    <div class="eyebrow">CONDICIONES COMERCIALES</div>
    <div class="meta">
        <?php if(!empty($quoteSync['quote']['payment_terms'])):?><div><b>Pago:</b> <?=$esc((string)$quoteSync['quote']['payment_terms'])?></div><?php endif;?>
        <?php if(!empty($quoteSync['quote']['delivery_time'])):?><div><b>Entrega:</b> <?=$esc((string)$quoteSync['quote']['delivery_time'])?></div><?php endif;?>
        <?php if(!empty($quoteSync['quote']['delivery_place'])):?><div><b>Lugar:</b> <?=$esc((string)$quoteSync['quote']['delivery_place'])?></div><?php endif;?>
    </div>
</div>
<?php endif;?>

<table>
<thead>
<tr>
    <th>Descripción</th>
    <th>Cant.</th>
    <th>Precio</th>
    <th>Importe</th>
</tr>
</thead>
<tbody>
<?php foreach($items as $item):?>
<tr>
    <td><?=$esc((string)$item['description'])?></td>
    <td><?=$esc((string)$item['quantity'])?></td>
    <td><?=$money((float)$item['unit_price'])?></td>
    <td><?=$money((float)$item['subtotal'])?></td>
</tr>
<?php endforeach;?>
</tbody>
</table>

<div class="totals">
    <?php if($hasBreakdown):?>
        <div class="trow">
            <span>Subtotal</span>
            <b><?=$money($commercialSubtotal)?></b>
        </div>

        <?php if($commercialDiscount>0.009):?>
        <div class="trow discount">
            <span>Descuento (<?=$esc($pct($discountPct))?>)</span>
            <b>-<?=$money($commercialDiscount)?></b>
        </div>
        <?php endif;?>

        <?php if($commercialTax>0.009):?>
        <div class="trow tax">
            <span>IVA (<?=$esc($pct($taxPct))?>)</span>
            <b><?=$money($commercialTax)?></b>
        </div>
        <?php endif;?>
    <?php endif;?>

    <div class="grand">
        <span>Total</span>
        <b><?=$money($total)?></b>
    </div>
</div>

<?php if(!empty($order['notes'])):?>
<div class="section">
    <h3>Notas operativas</h3>
    <p><?=nl2br($esc((string)$order['notes']))?></p>
</div>
<?php endif;?>

<div class="footer">
    <span><?=$esc($brand)?> · <?=$esc((string)$order['order_number'])?></span>
    <span>Página 1 de 2</span>
</div>
</section>

<section class="sheet">
<div class="accent pink"></div>

<div class="eyebrow">RESUMEN FINANCIERO</div>
<div class="title" style="text-align:left">
    <h1>Pagos de la orden</h1>
    <p>Resumen financiero de <?=$esc((string)$order['order_number'])?></p>
</div>

<div class="summary">
    <div class="row head">
        <span>CONCEPTO</span>
        <span>IMPORTE</span>
    </div>

    <?php if($hasBreakdown):?>
        <div class="row">
            <span>Subtotal</span>
            <b><?=$money($commercialSubtotal)?></b>
        </div>

        <?php if($commercialDiscount>0.009):?>
        <div class="row discount">
            <span>Descuento (<?=$esc($pct($discountPct))?>)</span>
            <strong>-<?=$money($commercialDiscount)?></strong>
        </div>
        <?php endif;?>

        <?php if($commercialTax>0.009):?>
        <div class="row tax">
            <span>IVA (<?=$esc($pct($taxPct))?>)</span>
            <strong><?=$money($commercialTax)?></strong>
        </div>
        <?php endif;?>
    <?php endif;?>

    <div class="row total">
        <span>Total de la orden</span>
        <b><?=$money($total)?></b>
    </div>

    <div class="row paid">
        <span>Total pagado</span>
        <b><?=$money($paid)?></b>
    </div>

    <div class="row balance">
        <span>Saldo pendiente</span>
        <strong><?=$money($balance)?></strong>
    </div>
</div>

<?php if($payments):?>
<div class="section">
    <h3>Pagos registrados</h3>

    <div class="paylist">
        <div class="payrow head">
            <span>Fecha</span>
            <span>Método</span>
            <span>Referencia</span>
            <span>Importe</span>
        </div>

        <?php foreach($payments as $p):?>
        <div class="payrow">
            <span><?=!empty($p['payment_date'])?$esc(date('d/m/Y',strtotime((string)$p['payment_date']))):'—'?></span>
            <span><?=$esc((string)($p['method_label']??$p['method']??'Pago'))?></span>
            <span><?=$esc((string)($p['reference']??''))?></span>
            <span><?=$money((float)$p['amount'])?></span>
        </div>
        <?php endforeach;?>
    </div>
</div>
<?php endif;?>

<div class="note">
    <b>Estado actual:</b> <?=$esc($statusLabel($status))?><br>
    <?php if(!empty($order['due_date'])):?>
        Fecha compromiso: <?=$esc(date('d/m/Y',strtotime((string)$order['due_date'])))?>
    <?php endif;?>
</div>

<?php if(!empty($quoteSync['exists']) && !empty($quoteSync['quote']['terms'])):?>
<div class="section">
    <h3>Condiciones comerciales</h3>
    <p><?=nl2br($esc((string)$quoteSync['quote']['terms']))?></p>
</div>
<?php endif;?>

<div class="closing">
    <div>
        <span>Orden</span>
        <strong><?=$esc((string)$order['order_number'])?></strong>
    </div>
    <div>
        <span>Total</span>
        <strong><?=$money($total)?></strong>
    </div>
    <div>
        <span>Saldo</span>
        <strong><?=$money($balance)?></strong>
    </div>
</div>

<div class="footer">
    <span><?=$esc($brand)?> · <?=$esc((string)$order['order_number'])?></span>
    <span>Página 2 de 2</span>
</div>
</section>

</body>
</html>
<?php
}
