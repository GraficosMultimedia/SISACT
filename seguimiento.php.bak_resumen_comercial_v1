<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/seguimiento.php';
require_once __DIR__ . '/includes/seguimiento_cfdi.php';
require_once __DIR__ . '/includes/company.php';

$company = company_profile();
$token = trim((string)($_GET['t'] ?? ''));
$order = $token !== '' ? tracking_order_by_token($token) : null;
$currentInternal = $order ? tracking_current_stage((int)$order['id']) : '';
$history = $order ? tracking_history((int)$order['id']) : [];
$clientStages = tracking_client_stages();
$currentClient = $order ? tracking_internal_to_client_stage($currentInternal) : 'received';
$clientKeys = array_keys($clientStages);
$currentIndex = array_search($currentClient, $clientKeys, true);
if ($currentIndex === false) $currentIndex = 0;
$showApproval = $order ? tracking_has_design_approval($history, $currentInternal) : false;
$clientHistory = $order ? tracking_client_history($history, $showApproval) : [];
$latestMessage = $order ? tracking_latest_client_message($history, $currentInternal) : '';
$items = $order ? tracking_order_items((int)$order['id']) : [];
$finance = $order ? tracking_payment_summary((int)$order['id']) : ['order_total'=>0,'paid_total'=>0,'balance'=>0,'payment_count'=>0,'first_payment'=>null,'last_payment'=>null];
$payments = $order ? tracking_confirmed_payments((int)$order['id']) : [];
$paymentReceipts = $order ? tracking_payment_receipts((int)$order['id']) : [];
$trackingCfdis = $order ? tracking_cfdi_for_order((int)$order['id']) : [];

function track_e(?string $value): string { return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8'); }
function track_money(float $value): string { return '$' . number_format($value, 2, '.', ','); }
function track_date(?string $value, string $format='d/m/Y'): string {
    if (!$value) return 'Por confirmar';
    $ts = strtotime($value);
    return $ts ? date($format, $ts) : 'Por confirmar';
}
function track_company_address(array $company): string {
    $parts = [];
    foreach (['address','neighborhood','city','state','postal_code','country'] as $key) {
        $value = trim((string)($company[$key] ?? ''));
        if ($value !== '') $parts[] = $value;
    }
    return implode(' · ', $parts);
}
$companyDisplayName = trim((string)($company['trade_name'] ?? '')) !== ''
    ? (string)$company['trade_name']
    : ((string)($company['legal_name'] ?? '') !== '' ? (string)$company['legal_name'] : 'Colibrí Print');
$companyLegalName = trim((string)($company['legal_name'] ?? ''));
$companyAddress = track_company_address($company);
$companyPhone = trim((string)($company['phone'] ?? ''));
$companyEmail = trim((string)($company['email'] ?? ''));
$companyWebsite = trim((string)($company['website'] ?? ''));
$companyRfc = trim((string)($company['rfc'] ?? ''));
$companyWebsiteLabel = preg_replace('#^https?://#i', '', $companyWebsite);
$companyPhoneHref = preg_replace('/[^0-9+]/', '', $companyPhone);
$companyWhatsAppHref = preg_replace('/[^0-9]/', '', $companyPhone);
if ($companyWhatsAppHref !== '' && strlen($companyWhatsAppHref) === 10) $companyWhatsAppHref = '52' . $companyWhatsAppHref;
$pdfUrl = $order ? '/seguimiento_comprobante.php?t=' . rawurlencode($token) : '#';
$waUrl = ($order && $companyWhatsAppHref !== '') ? 'https://wa.me/' . $companyWhatsAppHref . '?text=' . rawurlencode('Hola Colibrí Print México, quiero consultar mi pedido ' . ($order['order_number'] ?? '') . '.') : '#';
?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title>Seguimiento de pedido | <?=track_e($companyDisplayName)?></title>
<style>
:root{
  --navy:#102a56; --blue:#087bd9; --blue2:#18a8f0; --green:#19a85b;
  --ink:#172b4d; --muted:#6d7d95; --line:#e5edf6; --bg:#f4f7fb;
  --card:#fff; --soft:#eef6ff; --shadow:0 12px 35px rgba(16,42,86,.08);
  --radius:18px;
}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--ink);font-family:Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}
a{color:inherit}
.tracking-page{max-width:1180px;margin:0 auto;padding:24px 20px 42px}
.tracking-company-header{background:#fff;border:1px solid var(--line);border-radius:22px;padding:18px 22px;margin-bottom:16px;box-shadow:var(--shadow)}
.tracking-company-top{display:flex;justify-content:space-between;align-items:center;gap:20px}
.tracking-company-brand{display:flex;align-items:center;gap:15px}
.company-logo{width:82px;height:58px;display:flex;align-items:center;justify-content:center;overflow:hidden}
.company-logo img{max-width:100%;max-height:100%;object-fit:contain}
.company-logo-fallback{font-size:35px}
.company-identity strong{display:block;font-size:22px;letter-spacing:-.4px;color:var(--navy)}
.company-identity span{display:block;color:#718096;font-size:12px;margin-top:2px}
.company-identity small{display:block;color:var(--blue);font-weight:700;font-size:12px;margin-top:4px}
.company-header-badge{background:#effaf4;color:#087443;border:1px solid #ccefdc;border-radius:999px;padding:9px 13px;font-size:12px;font-weight:700;white-space:nowrap}
.badge-dot{display:inline-block;width:7px;height:7px;background:var(--green);border-radius:50%;margin-right:7px}
.tracking-company-details{border-top:1px solid var(--line);margin-top:14px;padding-top:12px;color:var(--muted);font-size:11px}
.contact-line{display:flex;flex-wrap:wrap;gap:10px 18px;margin-top:7px}
.contact-line a{text-decoration:none}
.hero-card{background:linear-gradient(135deg,#075dbb,#087bd9 55%,#18a8f0);color:#fff;border-radius:22px;padding:27px 30px;display:flex;justify-content:space-between;align-items:center;gap:25px;box-shadow:0 16px 40px rgba(8,123,217,.22);position:relative;overflow:hidden}
.hero-card:after{content:"";position:absolute;width:300px;height:300px;border-radius:50%;right:-120px;top:-170px;background:rgba(255,255,255,.08)}
.eyebrow{display:block;font-size:10px;font-weight:800;letter-spacing:.08em;text-transform:uppercase;color:#5b7699}
.hero-card .eyebrow{color:#d7efff}
.hero-card h1{margin:5px 0 4px;font-size:38px;letter-spacing:-1px;line-height:1.05}
.hero-card p{margin:0;color:#e3f3ff;font-size:14px}
.tracking-tagline{margin-top:12px;font-size:12px;color:#d9f2ff}
.current-pill{position:relative;z-index:1;background:#20a85b;border:1px solid rgba(255,255,255,.3);border-radius:13px;padding:13px 17px;min-width:185px;text-align:center;box-shadow:0 8px 20px rgba(0,0,0,.12)}
.current-pill span{display:block;font-size:10px;text-transform:uppercase;letter-spacing:.07em;opacity:.85}
.current-pill strong{display:block;font-size:17px;margin-top:3px}
.tracking-receipt,.tracking-card,.two-col article{background:var(--card);border:1px solid var(--line);border-radius:var(--radius);box-shadow:var(--shadow)}
.tracking-receipt{margin-top:16px;padding:23px}
.receipt-head,.section-title{display:flex;justify-content:space-between;align-items:flex-start;gap:15px}
.receipt-head h2,.section-title h2{margin:3px 0 4px;color:var(--navy);font-size:20px}
.receipt-head p{margin:0;color:var(--muted);font-size:11px}
.receipt-badge{font-size:10px;font-weight:800;color:#087443;background:#eaf9f1;border:1px solid #c9ecd9;padding:8px 11px;border-radius:999px}
.receipt-kpis{display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin:20px 0}
.receipt-kpis>div{background:#f7faff;border:1px solid #e5eef9;border-radius:13px;padding:15px}
.receipt-kpis span{display:block;color:var(--muted);font-size:11px}
.receipt-kpis strong{display:block;color:var(--navy);font-size:23px;margin-top:5px}
.receipt-kpis .paid strong{color:var(--green)}
.receipt-kpis .balance strong{color:#e26b38}
.receipt-service{border-top:1px solid var(--line);padding-top:16px}
.receipt-service h3{margin:3px 0 12px;font-size:14px;color:var(--navy)}
.receipt-items{border:1px solid var(--line);border-radius:12px;overflow:hidden}
.receipt-item{display:flex;justify-content:space-between;gap:15px;padding:13px 15px;border-bottom:1px solid var(--line);font-size:13px}
.receipt-item:last-child{border-bottom:0}
.receipt-item small{display:block;color:var(--muted);margin-top:3px}
.receipt-actions{display:flex;flex-wrap:wrap;gap:10px;margin-top:15px}
.receipt-actions a{display:inline-flex;align-items:center;justify-content:center;text-decoration:none;padding:10px 14px;border-radius:10px;font-size:12px;font-weight:800}
.receipt-actions .pdf{border:1px solid var(--blue);color:var(--blue);background:#fff}
.receipt-actions .wa{background:#eaf9f1;color:#087443;border:1px solid #c9ecd9}
.receipt-disclaimer{font-size:10px;color:#8a98aa;margin:13px 0 0}

/* Datos bancarios configurados en Administración */
.payment-info-card{margin-top:16px;padding:21px;background:linear-gradient(135deg,#102a56,#173d76);border:1px solid #1d4b86;border-radius:18px;box-shadow:0 12px 35px rgba(16,42,86,.12);color:#fff}
.payment-info-card .eyebrow{color:#79c8ff}
.payment-info-card h2{margin:4px 0 5px;color:#fff;font-size:20px}
.payment-info-card .payment-intro{margin:0;color:#d9eaff;font-size:11px}
.payment-info-layout{display:grid;grid-template-columns:1fr 220px;gap:14px;margin-top:16px}
.payment-info-box{background:#fff;color:var(--ink);border-radius:13px;padding:15px 16px;border:1px solid rgba(255,255,255,.35)}
.payment-info-box .payment-label{display:block;color:#6d7d95;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.05em;margin-bottom:8px}
.payment-info-text{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono",monospace;font-size:12px;line-height:1.55;white-space:normal;word-break:break-word;color:#172b4d}
.payment-reference{background:rgba(255,255,255,.09);border:1px solid rgba(255,255,255,.18);border-radius:13px;padding:15px}
.payment-reference span{display:block;color:#a9c9e9;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.07em}
.payment-reference strong{display:block;color:#fff;font-size:19px;line-height:1.2;margin-top:8px;word-break:break-all}
.payment-reference small{display:block;color:#c9def3;font-size:10px;line-height:1.45;margin-top:9px}
@media(max-width:760px){
  .payment-info-layout{grid-template-columns:1fr}
}
.advance-confirmed,.advance-pending{margin-top:12px;padding:11px 13px;border-radius:11px;display:flex;gap:10px;align-items:center;font-size:12px}
.advance-confirmed{background:#effaf4;border:1px solid #ccefdc}
.advance-pending{background:#fff8ec;border:1px solid #f2dfb6}
.advance-confirmed strong,.advance-pending strong{display:block}
.advance-confirmed small,.advance-pending small{display:block;color:var(--muted);margin-top:2px}
.payment-history-mini{margin-top:12px}
.payment-history-mini>div{display:flex;flex-wrap:wrap;gap:7px;margin-top:6px}
.payment-history-mini span{background:#f4f7fb;border:1px solid var(--line);border-radius:999px;padding:5px 8px;font-size:10px;color:var(--muted)}
.progress-card{margin-top:16px;padding:22px;background:#fff;border:1px solid var(--line);border-radius:var(--radius);box-shadow:var(--shadow)}
.progress-line{display:grid;grid-template-columns:repeat(5,1fr);gap:0;margin-top:17px}
.stage{position:relative;text-align:center;color:#8997aa;font-size:11px;font-weight:700}
.stage:not(:last-child):after{content:"";position:absolute;height:2px;background:#dfe7f1;left:55%;right:-45%;top:18px;z-index:0}
.stage.done{color:var(--navy)}
.stage.done:after{background:#2f78c4}
.stage.active{color:var(--blue)}
.stage-dot{position:relative;z-index:1;margin:0 auto 8px;width:38px;height:38px;border-radius:50%;background:#eef2f6;border:2px solid #ccd5df;display:flex;align-items:center;justify-content:center;font-size:15px}
.stage.done .stage-dot{background:var(--navy);border-color:var(--navy);color:#fff}
.stage.active .stage-dot{background:#e7f4ff;border:4px solid #91cdf7;color:var(--blue);box-shadow:0 0 0 5px #eef8ff}
.stage span{display:block}
.approval-note{display:flex;gap:10px;align-items:center;margin-top:16px;padding:12px 14px;border-radius:11px;background:#f4f8ff;border:1px solid #dceafb;font-size:12px}
.approval-note strong,.approval-note span{display:block}
.approval-note span{color:var(--muted);margin-top:2px}
.two-col{display:grid;grid-template-columns:1.35fr .65fr;gap:16px;margin-top:16px}
.two-col article{padding:21px}
.current-message h2{margin:6px 0 8px;font-size:22px;color:var(--navy)}
.current-message p{margin:0;color:#4f6078;font-size:13px;line-height:1.6}
.current-message small{display:block;margin-top:13px;color:#8b98aa;font-size:10px}
.order-summary .info-row{display:flex;justify-content:space-between;gap:20px;padding:10px 0;border-bottom:1px solid var(--line);font-size:12px}
.order-summary .info-row span{color:var(--muted)}
.order-summary .info-row strong{color:var(--navy)}
.order-summary .info-row.total{border-bottom:0;margin-top:2px;padding-top:14px}
.order-summary .info-row.total strong{font-size:22px;color:var(--blue)}
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
.public-receipt-links{display:grid;gap:8px;margin-top:12px}
.public-receipt-link{display:flex;align-items:center;gap:10px;text-decoration:none;border:1px solid var(--line);border-radius:11px;padding:10px 12px}
.public-receipt-icon{font-size:20px}
.public-receipt-link span:nth-child(2){flex:1}
.public-receipt-link strong,.public-receipt-link small{display:block}
.public-receipt-link small{color:var(--muted);font-size:10px;margin-top:2px}
.public-receipt-link b{color:var(--blue)}
.public-receipt-upload{margin-top:15px;background:#f8fbff;border:1px dashed #c9dced;border-radius:12px;padding:14px}
.public-receipt-upload label{display:block;font-size:11px;color:var(--muted);font-weight:700;margin-bottom:9px}
.public-receipt-upload input[type=file],.public-receipt-upload textarea{width:100%;margin-top:5px;border:1px solid #d8e3ef;border-radius:9px;padding:9px;background:#fff;font:inherit;font-size:11px}
.public-receipt-upload button{border:0;border-radius:9px;background:var(--blue);color:#fff;font-weight:800;padding:10px 14px;cursor:pointer}
.public-receipt-upload small{display:block;color:#8b98aa;font-size:9px;margin-top:8px}
.history{margin-top:16px;padding:21px}
.timeline{margin-top:15px;border-left:2px solid #dbe7f3;margin-left:12px;padding-left:19px}
.timeline-item{position:relative;padding:0 0 18px}
.timeline-item:last-child{padding-bottom:0}
.timeline-dot{position:absolute;left:-32px;top:-2px;width:24px;height:24px;border-radius:50%;background:#e9f4ff;border:2px solid #acd6f7;display:flex;align-items:center;justify-content:center;font-size:11px}
.timeline-item strong{display:block;color:var(--navy);font-size:12px}
.timeline-item time{display:block;color:#8b98aa;font-size:10px;margin-top:2px}
.timeline-item p{margin:6px 0 0;color:#5f6f85;font-size:11px;line-height:1.5}
.not-found{padding:50px;text-align:center;margin-top:16px}
.not-found h1{color:var(--navy)}
.muted{color:#8a98aa;font-size:12px}
footer{text-align:center;color:#8a98aa;font-size:10px;padding:22px 5px 0}
footer strong{color:var(--navy)}
@media(max-width:760px){
  .tracking-page{padding:12px 10px 28px}
  .tracking-company-header{padding:14px}
  .tracking-company-top{align-items:flex-start}
  .company-header-badge{display:none}
  .company-logo{width:65px;height:48px}
  .company-identity strong{font-size:17px}
  .hero-card{padding:20px;border-radius:17px;display:block}
  .hero-card h1{font-size:29px}
  .current-pill{margin-top:17px;min-width:0}
  .receipt-kpis{grid-template-columns:1fr}
  .two-col{grid-template-columns:1fr}
  .progress-card{overflow-x:auto}
  .progress-line{min-width:620px}
  .receipt-head{display:block}
  .receipt-badge{display:inline-block;margin-top:10px}
  .contact-line{gap:7px 12px}
}
</style>

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<div class="tracking-page">

<?php if(isset($_GET['receipt_sent'])): ?>
<div class="tracking-card" style="border-color:#b9ecd5;background:#effbf6;margin-bottom:10px;padding:13px">
<strong style="color:#0b6a4b">✓ Comprobante enviado correctamente.</strong>
<p style="margin:5px 0 0;color:#577467;font-size:11px">Quedó pendiente de revisión por Administración.</p>
</div>
<?php endif; ?>

<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header(''); ?>

<header class="tracking-company-header">
  <div class="tracking-company-top">
    <div class="tracking-company-brand">
      <?php if (!empty($company['logo_path'])): ?>
        <div class="company-logo"><img src="<?=track_e($company['logo_path'])?>" alt="<?=track_e($companyDisplayName)?>"></div>
      <?php else: ?>
        <div class="company-logo company-logo-fallback">🐦</div>
      <?php endif; ?>
      <div class="company-identity">
        <strong><?=track_e($companyDisplayName)?></strong>
        <?php if ($companyLegalName !== '' && $companyLegalName !== $companyDisplayName): ?><span><?=track_e($companyLegalName)?></span><?php endif; ?>
        <small>Seguimiento de pedidos</small>
      </div>
    </div>
    <div class="company-header-badge"><span class="badge-dot"></span> Consulta segura</div>
  </div>
  <?php if ($companyAddress !== '' || $companyPhone !== '' || $companyEmail !== '' || $companyWebsite !== '' || $companyRfc !== ''): ?>
  <div class="tracking-company-details">
    <?php if ($companyAddress !== ''): ?><div>📍 <?=track_e($companyAddress)?></div><?php endif; ?>
    <div class="contact-line">
      <?php if ($companyPhone !== ''): ?><a href="tel:<?=track_e($companyPhoneHref)?>">📞 <?=track_e($companyPhone)?></a><?php endif; ?>
      <?php if ($companyPhone !== '' && $companyWhatsAppHref !== ''): ?><a href="https://wa.me/<?=track_e($companyWhatsAppHref)?>" target="_blank" rel="noopener noreferrer">💬 WhatsApp</a><?php endif; ?>
      <?php if ($companyEmail !== ''): ?><a href="mailto:<?=track_e($companyEmail)?>">✉️ <?=track_e($companyEmail)?></a><?php endif; ?>
      <?php if ($companyWebsite !== ''): ?><a href="<?=track_e($companyWebsite)?>" target="_blank" rel="noopener noreferrer">🌐 <?=track_e($companyWebsiteLabel)?></a><?php endif; ?>
      <?php if ($companyRfc !== ''): ?><span>RFC: <?=track_e($companyRfc)?></span><?php endif; ?>
    </div>
  </div>
  <?php endif; ?>
</header>

<?php if (!$order): ?>
<section class="tracking-card not-found">
  <div style="font-size:35px">🔎</div>
  <h1>No encontramos este pedido</h1>
  <p>El enlace de seguimiento no es válido o ya no está disponible.</p>
</section>
<?php else: ?>

<section class="hero-card">
  <div>
    <span class="eyebrow">ORDEN DE SERVICIO</span>
    <h1><?=track_e($order['order_number'])?></h1>
    <p><?=track_e($order['customer_name'] ?: 'Cliente')?> · <?=track_e($order['quote_number'] ?: 'Orden de servicio')?></p>
    <div class="tracking-tagline">Seguimiento actualizado de tu pedido.</div>
  </div>
  <div class="current-pill">
    <span>Estado actual</span>
    <strong><?=$clientStages[$currentClient]['icon']?> <?=track_e($clientStages[$currentClient]['label'])?></strong>
  </div>
</section>

<section class="tracking-receipt">
  <div class="receipt-head">
    <div>
      <span class="eyebrow">RESUMEN COMERCIAL</span>
      <h2>Servicio y pagos</h2>
      <p>Pedido <?=track_e($order['order_number'])?> · <?=track_date($order['order_date'])?></p>
    </div>
    <span class="receipt-badge"><?= $finance['paid_total'] > 0 ? 'PAGO REGISTRADO' : 'PAGO PENDIENTE' ?></span>
  </div>

  <div class="receipt-kpis">
    <div><span>Total del servicio</span><strong><?=track_money((float)$finance['order_total'])?></strong></div>
    <div class="paid"><span>Total pagado</span><strong><?=track_money((float)$finance['paid_total'])?></strong></div>
    <div class="balance"><span>Saldo pendiente</span><strong><?=track_money((float)$finance['balance'])?></strong></div>
  </div>

  <div class="receipt-service">
    <span class="eyebrow">SERVICIOS CONTRATADOS</span>
    <h3>Conceptos de la orden</h3>
    <?php if (!$items): ?>
      <p class="muted">No hay conceptos registrados.</p>
    <?php else: ?>
      <div class="receipt-items">
      <?php foreach($items as $item): ?>
        <div class="receipt-item">
          <div>
            <strong><?=nl2br(track_e((string)$item['description']))?></strong>
            <small>Cantidad: <?=track_e((string)$item['quantity'])?></small>
          </div>
          <strong><?=track_money((float)$item['subtotal'])?></strong>
        </div>
      <?php endforeach; ?>
      </div>
    <?php endif; ?>
  </div>

  <?php if ($finance['first_payment']): $fp=$finance['first_payment']; ?>
  <div class="advance-confirmed">
    <span>💳</span>
    <div><strong>Primer pago registrado: <?=track_money((float)$fp['amount'])?></strong>
    <small><?=track_e((string)$fp['method_label'])?> · <?=track_date((string)$fp['payment_date'])?><?php if(trim((string)$fp['reference'])!==''): ?> · Ref. <?=track_e((string)$fp['reference'])?><?php endif; ?></small></div>
  </div>
  <?php else: ?>
  <div class="advance-pending">
    <span>🧾</span>
    <div><strong>Pago pendiente de registro</strong>
    <small>Cuando Administración confirme el pago, aparecerá aquí.</small></div>
  </div>
  <?php endif; ?>

  <?php if (count($payments)>1): ?>
  <div class="payment-history-mini">
    <span class="eyebrow">PAGOS REGISTRADOS</span>
    <div><?php foreach($payments as $pay): ?><span><?=track_date((string)$pay['payment_date'])?> · <?=track_money((float)$pay['amount'])?></span><?php endforeach; ?></div>
  </div>
  <?php endif; ?>

  <div class="receipt-actions">
    <a class="pdf" href="<?=track_e($pdfUrl)?>">📄 Descargar comprobante PDF</a>
    <?php if($waUrl!=='#'): ?><a class="wa" href="<?=track_e($waUrl)?>" target="_blank" rel="noopener noreferrer">💬 Consultar por WhatsApp</a><?php endif; ?>
  </div>
  <p class="receipt-disclaimer">Esta información refleja los datos comerciales y pagos confirmados en el sistema. No sustituye un CFDI.</p>
</section>

<?php if (trim((string)($company['payment_info'] ?? '')) !== ''): ?>
<section class="payment-info-card" id="datos-para-pago">
  <span class="eyebrow">PAGO</span>
  <h2>Información comercial de pago</h2>
  <p class="payment-intro">Datos bancarios proporcionados por <?=track_e($companyDisplayName)?> para realizar el pago de tu orden.</p>

  <div class="payment-info-layout">
    <div class="payment-info-box">
      <span class="payment-label">Datos para pago</span>
      <div class="payment-info-text"><?=nl2br(track_e((string)$company['payment_info']))?></div>
    </div>

    <div class="payment-reference">
      <span>Referencia de pago</span>
      <strong><?=track_e($order['order_number'])?></strong>
      <small>Si la empresa solicita una referencia o concepto, utiliza el número de esta orden.</small>
    </div>
  </div>
</section>
<?php endif; ?>

<section class="progress-card">
  <div class="section-title">
    <div><span class="eyebrow">PROGRESO</span><h2>Así va tu pedido</h2></div>
  </div>
  <div class="progress-line client-progress">
  <?php foreach ($clientStages as $key=>$stage): $idx=array_search($key,$clientKeys,true); $done=$idx < $currentIndex; $active=$key===$currentClient; ?>
    <div class="stage <?=($done?'done ':'').($active?'active':'')?>">
      <div class="stage-dot"><?=($done?'✓':$stage['icon'])?></div>
      <span><?=track_e($stage['label'])?></span>
    </div>
  <?php endforeach; ?>
  </div>
  <?php if ($showApproval): ?>
  <div class="approval-note <?=($currentInternal==='approval'?'is-current':'')?>">
    <div class="approval-note-icon">✅</div>
    <div><strong>Aprobación de diseño</strong><span><?=$currentInternal==='approval'?'Estamos esperando tu aprobación para continuar.':'El diseño ya pasó por esta etapa.'?></span></div>
  </div>
  <?php endif; ?>
</section>

<section class="two-col">
  <article class="current-message">
    <span class="eyebrow">ACTUALIZACIÓN</span>
    <h2><?=$clientStages[$currentClient]['icon']?> <?=track_e($clientStages[$currentClient]['label'])?></h2>
    <p><?=nl2br(track_e($latestMessage))?></p>
    <small>Última actualización: <?=track_date($history ? $history[count($history)-1]['created_at'] : null,'d/m/Y H:i')?></small>
  </article>

  <article class="order-summary">
    <span class="eyebrow">INFORMACIÓN DE LA ORDEN</span>
    <div class="info-row"><span>Pedido</span><strong><?=track_e($order['order_number'])?></strong></div>
    <div class="info-row"><span>Fecha de pedido</span><strong><?=track_date($order['order_date'])?></strong></div>
    <div class="info-row"><span>Entrega estimada</span><strong><?=track_date($order['due_date'])?></strong></div>
    <div class="info-row total"><span>Total</span><strong><?=track_money((float)$order['total'])?></strong></div>
  </article>
</section>

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
  <div class="section-title"><div><span class="eyebrow">PAGOS Y COMPROBANTES</span><h2>Comprobantes de pago</h2></div></div>
  <?php if($paymentReceipts): ?>
    <div class="public-receipt-links">
    <?php foreach($paymentReceipts as $receipt): ?>
      <a class="public-receipt-link" href="/comprobante_pago.php?t=<?=rawurlencode($token)?>&rid=<?=((int)$receipt['id'])?>">
        <span class="public-receipt-icon">🧾</span>
        <span><strong><?=track_e($receipt['original_name'])?></strong><small><?=track_e(ucfirst((string)$receipt['status']))?> · <?=track_date((string)$receipt['created_at'])?></small></span>
        <b>↗</b>
      </a>
    <?php endforeach; ?>
    </div>
  <?php else: ?>
    <p class="muted">Los comprobantes enviados para esta orden aparecerán aquí.</p>
  <?php endif; ?>

  <form class="public-receipt-upload" action="/api/comprobante_pago_cliente.php" method="post" enctype="multipart/form-data">
    <input type="hidden" name="tracking_token" value="<?=track_e($token)?>">
    <label><span>Enviar comprobante de pago</span><input type="file" name="receipt" accept="image/jpeg,image/png,image/webp,application/pdf" required></label>
    <label><span>Nota (opcional)</span><textarea name="note" rows="2" placeholder="Ej. Anticipo de la orden"></textarea></label>
    <button type="submit">🧾 Enviar comprobante</button>
    <small>JPG, PNG, WEBP o PDF · máximo 10 MB. El envío no confirma automáticamente el pago.</small>
  </form>
</section>

<section class="history tracking-card">
  <div class="section-title"><div><span class="eyebrow">ACTUALIZACIONES</span><h2>Lo que ha pasado</h2></div></div>
  <?php if (!$clientHistory): ?>
    <p class="muted">Aún no hay actualizaciones registradas.</p>
  <?php else: ?>
  <div class="timeline">
    <?php foreach ($clientHistory as $entry): ?>
    <div class="timeline-item <?=($entry['key']==='approval'?'timeline-approval':'')?>">
      <div class="timeline-dot"><?=$entry['icon']?></div>
      <div><strong><?=track_e($entry['label'])?></strong><time><?=track_date($entry['created_at'],'d/m/Y H:i')?></time>
      <?php if(trim((string)$entry['note'])!==''): ?><p><?=nl2br(track_e($entry['note']))?></p><?php endif; ?></div>
    </div>
    <?php endforeach; ?>
  </div>
  <?php endif; ?>
</section>

<?php endif; ?>

<footer>
  <strong><?=track_e($companyDisplayName)?></strong>
  <?php if ($companyAddress !== ''): ?> · <?=track_e($companyAddress)?><?php endif; ?>
  <br><span>Seguimiento de pedido · Información informativa y operativa.</span>
</footer>
</div>
</body>
</html>
