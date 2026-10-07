<?php
declare(strict_types=1);

require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/company.php';

$pdo = db();
$company = company_profile();

function h(string $v): string {
    return htmlspecialchars($v, ENT_QUOTES, 'UTF-8');
}
function cp_base_path(): string {
    static $base = null;
    if ($base !== null) return $base;
    $doc = isset($_SERVER['DOCUMENT_ROOT']) ? realpath((string)$_SERVER['DOCUMENT_ROOT']) : false;
    $root = realpath(__DIR__);
    if ($doc && $root) {
        $doc = rtrim(str_replace('\\','/',$doc), '/');
        $root = str_replace('\\','/',$root);
        if ($root === $doc) return $base = '';
        if (str_starts_with($root, $doc . '/')) {
            $rel = trim(substr($root, strlen($doc) + 1), '/');
            return $base = $rel === '' ? '' : '/' . $rel;
        }
    }
    return $base = '';
}
function cp_url(string $path = '', array $query = []): string {
    $url = cp_base_path() . '/' . ltrim($path, '/');
    $query = array_filter($query, static fn($v) => $v !== null && $v !== '');
    return $query ? $url . '?' . http_build_query($query, '', '&', PHP_QUERY_RFC3986) : $url;
}
function money_mx($v): string {
    return is_numeric($v) ? '$' . number_format((float)$v, 2, '.', ',') . ' MXN' : 'Consultar';
}
function asset(?string $path): string {
    $path = trim((string)$path);
    if ($path === '') return '';
    if (preg_match('#^(?:https?:)?//#i', $path)) return $path;
    return cp_url($path);
}
function wa_url(string $phone, string $message): string {
    $raw = preg_replace('/\D+/', '', $phone);
    if ($raw !== '' && !str_starts_with($raw, '52')) $raw = '52' . $raw;
    return $raw ? 'https://wa.me/' . $raw . '?text=' . rawurlencode($message) : '#';
}

$brand = trim((string)($company['trade_name'] ?? '')) ?: 'Colibrí Print';
$phone = (string)($company['phone'] ?? '');
$email = (string)($company['email'] ?? '');
$city = trim((string)($company['city'] ?? 'Hidalgo del Parral'));
$state = trim((string)($company['state'] ?? 'Chihuahua'));
$location = $city . ', ' . $state;
$address = trim((string)($company['address'] ?? ''));
$wa = wa_url($phone, 'Hola Colibrí Print, quiero información sobre sus productos y promociones.');

$mark = cp_url('assets/img/home/colibri-mark-v1.png');
$hero = cp_url('assets/img/home/hero-colibri-v1.png');
$collage = cp_url('assets/img/home/category-collage-v1.png');

$categories = [];
$products = [];
$promotions = [];

try {
    $categories = $pdo->query("
        SELECT c.id, c.name
        FROM cp_categories c
        WHERE c.type='product' AND c.enabled=1
        ORDER BY c.sort_order, c.name
        LIMIT 8
    ")->fetchAll(PDO::FETCH_ASSOC);

    $products = $pdo->query("
        SELECT p.id,p.name,p.description,p.sale_price,p.pricing_type,p.sku,c.name AS category_name,
               (SELECT i.path FROM cp_product_images i
                WHERE i.product_id=p.id AND i.enabled=1
                ORDER BY i.sort_order,i.id LIMIT 1) AS image_path
        FROM cp_products p
        LEFT JOIN cp_categories c ON c.id=p.category_id
        WHERE p.enabled=1 AND p.visible_web=1
        ORDER BY p.id DESC
        LIMIT 8
    ")->fetchAll(PDO::FETCH_ASSOC);

    $promotions = $pdo->query("
        SELECT pr.id,pr.title,pr.label,pr.description,pr.normal_price,pr.promo_price,
               pr.start_date,pr.end_date,pr.image_path,
               (SELECT pi.path
                FROM cp_promotion_products pp
                INNER JOIN cp_product_images pi
                  ON pi.product_id=pp.product_id AND pi.enabled=1
                WHERE pp.promotion_id=pr.id
                ORDER BY pp.sort_order,pi.sort_order,pi.id LIMIT 1) AS product_image
        FROM cp_promotions pr
        WHERE pr.show_web=1 AND pr.status <> 'draft'
        ORDER BY pr.id DESC
        LIMIT 12
    ")->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {
    // La portada permanece operativa aunque algún módulo opcional no esté disponible.
}

$today = new DateTimeImmutable('today');
foreach ($promotions as &$promo) {
    $start = !empty($promo['start_date']) ? new DateTimeImmutable((string)$promo['start_date']) : null;
    $end   = !empty($promo['end_date']) ? new DateTimeImmutable((string)$promo['end_date']) : null;
    $promo['is_active'] = (!$start || $start <= $today) && (!$end || $end >= $today);
    $promo['image'] = asset($promo['image_path'] ?: ($promo['product_image'] ?? ''));
    $promo['discount'] = null;
    if (is_numeric($promo['normal_price']) && is_numeric($promo['promo_price']) && (float)$promo['normal_price'] > 0) {
        $promo['discount'] = (int)round((1 - ((float)$promo['promo_price'] / (float)$promo['normal_price'])) * 100);
    }
}
unset($promo);

$activePromos = array_values(array_filter($promotions, fn($p) => !empty($p['is_active'])));
$expiredPromos = array_values(array_filter($promotions, fn($p) => empty($p['is_active'])));

$services = [
    ['Diseño y Branding','Logos, identidad visual, papelería y piezas publicitarias.','pink'],
    ['Impresión y Gran Formato','Producción para negocios, eventos, señalización y publicidad.','yellow'],
    ['Grabado Láser','Personalización de promocionales, placas, reconocimientos y regalos.','blue'],
    ['Corte CNC y Corpóreos','Letras, logotipos, piezas y soluciones tridimensionales.','green'],
    ['Textiles y Sublimación','Playeras, tazas, termos, vasos y productos personalizados.','orange'],
    ['Sellos y Artículos Útiles','Soluciones comerciales y administrativas listas para usar.','red'],
];

/* Módulo público de recepción de archivos para impresión */
$printSizes = [];
$printMaterials = [];
$printFinishes = [];
$printPrices = [];
try {
    $printSizes = $pdo->query("SELECT id,name,code,width_mm,height_mm,orientation,is_custom FROM cp_print_sizes WHERE enabled=1 ORDER BY sort_order,id")->fetchAll(PDO::FETCH_ASSOC);
    $printMaterials = $pdo->query("SELECT id,name,code,unit_label FROM cp_print_materials WHERE enabled=1 ORDER BY sort_order,id")->fetchAll(PDO::FETCH_ASSOC);
    $printFinishes = $pdo->query("SELECT id,name,code FROM cp_print_finishes WHERE enabled=1 ORDER BY sort_order,id")->fetchAll(PDO::FETCH_ASSOC);
    $printPrices = $pdo->query("SELECT id,size_id,material_id,finish_id,color_mode,pricing_mode,unit_price,min_qty FROM cp_print_prices WHERE enabled=1 ORDER BY id")->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {
    // El resto de la portada continúa funcionando aunque el módulo de impresión no esté disponible.
}
$printMaxFiles = 10;
$printMaxBytes = 20 * 1024 * 1024;
$printApi = cp_url('api/print-request.php');
$printFollowupBase = cp_url('seguimiento.php');
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description" content="Colibrí Print México. Diseño, impresión, grabado láser, corte CNC y productos personalizados.">
<meta name="theme-color" content="#090b10">
<title><?= h($brand) ?> México | Soluciones gráficas</title>
<link rel="stylesheet" href="/assets/css/home-professional.css?v=20260922-1">

<style id="colibri-print-receiver-css">
.print-receiver{background:linear-gradient(180deg,#eef6ff 0%,#f8fbff 100%);color:#0b1e50;padding:92px 0}
.print-receiver *{box-sizing:border-box}
.print-receiver .pr-shell{max-width:1420px;margin:0 auto;padding:0 22px}
.print-receiver .pr-head{display:flex;align-items:flex-end;justify-content:space-between;gap:20px;margin-bottom:22px}
.print-receiver .pr-eyebrow{font-size:12px;letter-spacing:.16em;font-weight:900;color:#1468f2;margin-bottom:8px}
.print-receiver h2.pr-title{font-size:clamp(32px,4vw,50px);line-height:1;margin:0 0 10px;color:#0b1e50}
.print-receiver .pr-subtitle{margin:0;color:#63749a;font-size:16px;max-width:760px}
.print-receiver .pr-pill{background:#e1f7f2;color:#143c61;border-radius:999px;padding:11px 16px;font-weight:900;white-space:nowrap}
.print-receiver .pr-steps{display:grid;grid-template-columns:repeat(4,1fr);background:#fff;border:1px solid #e4ecf7;border-radius:18px;padding:10px 18px;box-shadow:0 12px 38px rgba(30,72,135,.08);margin-bottom:18px}
.print-receiver .pr-step{display:flex;align-items:center;gap:12px;position:relative;min-height:54px}
.print-receiver .pr-step:not(:last-child):after{content:"";position:absolute;left:55%;right:8px;top:27px;height:3px;background:#dfe7f3}
.print-receiver .pr-step.pr-active:not(:last-child):after{background:linear-gradient(90deg,#1468f2,#dfe7f3)}
.print-receiver .pr-num{width:46px;height:46px;flex:0 0 46px;border-radius:50%;display:grid;place-items:center;background:#e7edf7;color:#6a7899;font-weight:900;font-size:18px;z-index:1}
.print-receiver .pr-active .pr-num{background:#1468f2;color:#fff}
.print-receiver .pr-step b{display:block;font-size:15px}
.print-receiver .pr-step span{display:block;color:#7180a4;font-size:11px;margin-top:2px}
.print-receiver .pr-layout{display:grid;grid-template-columns:minmax(0,1fr) 390px;gap:18px}
.print-receiver .pr-card{background:#fff;border:1px solid #e6edf7;border-radius:20px;box-shadow:0 12px 38px rgba(30,72,135,.08);padding:18px;margin-bottom:14px}
.print-receiver .pr-section-title{display:flex;align-items:center;gap:12px;margin-bottom:14px}
.print-receiver .pr-bubble{width:38px;height:38px;flex:0 0 38px;border-radius:50%;display:grid;place-items:center;background:#e7f1ff;color:#1468f2;font-weight:900}
.print-receiver .pr-section-title h3{margin:0;font-size:19px;color:#0b1e50}
.print-receiver .pr-section-title p{margin:3px 0 0;color:#7080a0;font-size:13px}
.print-receiver .pr-form-grid{display:grid;grid-template-columns:1.1fr 1fr .85fr;gap:14px}
.print-receiver .pr-field label{display:block;font-size:13px;font-weight:800;margin-bottom:6px;color:#0b1e50}
.print-receiver .pr-field input,.print-receiver .pr-field select,.print-receiver .pr-field textarea{width:100%;border:1px solid #ccd9ea;border-radius:10px;padding:11px 12px;background:#fff;color:#0b1e50;outline:none;font:inherit;font-size:14px}
.print-receiver .pr-field input:focus,.print-receiver .pr-field select:focus,.print-receiver .pr-field textarea:focus{border-color:#7ab0ff;box-shadow:0 0 0 3px #e8f2ff}
.print-receiver .pr-drop{border:2px dashed #7ab0ff;border-radius:17px;padding:27px;display:flex;align-items:center;justify-content:center;gap:24px;background:linear-gradient(135deg,#fbfdff,#f3f8ff);min-height:150px;text-align:center}
.print-receiver .pr-cloud{font-size:54px}
.print-receiver .pr-drop h4{margin:0 0 5px;font-size:18px;color:#0b1e50}
.print-receiver .pr-drop p{margin:0;color:#6e7d9c;font-size:13px}
.print-receiver .pr-btn{border:0;border-radius:10px;padding:11px 18px;background:#1468f2;color:#fff;font-weight:900;cursor:pointer;font-size:14px;box-shadow:0 6px 14px rgba(20,104,242,.18)}
.print-receiver .pr-btn:disabled{opacity:.55;cursor:not-allowed}
.print-receiver .pr-btn-alt{background:#eaf2ff;color:#1468f2;box-shadow:none}
.print-receiver .pr-file-list{margin-top:14px;display:grid;gap:10px}
.print-receiver .pr-file-card{border:1px solid #dce6f3;border-radius:15px;padding:12px;background:#fff}
.print-receiver .pr-file-head{display:flex;align-items:center;justify-content:space-between;gap:12px}
.print-receiver .pr-file-info{display:flex;align-items:center;gap:10px;min-width:0}
.print-receiver .pr-thumb{width:48px;height:56px;border-radius:8px;background:#f0f4fb;display:grid;place-items:center;overflow:hidden;color:#d82932;font-weight:900;font-size:11px;flex:0 0 48px}
.print-receiver .pr-thumb img{width:100%;height:100%;object-fit:cover}
.print-receiver .pr-filename{font-weight:900;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:390px}
.print-receiver .pr-meta{color:#6f7e9c;font-size:12px;margin-top:3px}
.print-receiver .pr-remove{border:1px solid #ffb7ba;background:#fff;color:#e5484d;border-radius:9px;padding:7px 10px;cursor:pointer;font-weight:900}
.print-receiver .pr-config{display:grid;grid-template-columns:repeat(5,1fr);gap:10px;margin-top:12px}
.print-receiver .pr-config .pr-field label{font-size:11px}
.print-receiver .pr-mini-total{display:flex;align-items:center;justify-content:space-between;background:#edf5ff;border-radius:10px;padding:10px 12px;margin-top:10px;font-weight:800;font-size:12px}
.print-receiver .pr-mini-total span:last-child{font-size:17px;color:#1468f2}
.print-receiver .pr-summary{position:sticky;top:18px;align-self:start}
.print-receiver .pr-summary-hero{border-radius:17px;background:linear-gradient(135deg,#1c73ef,#54a0ff);padding:20px;color:#fff;overflow:hidden;position:relative}
.print-receiver .pr-summary-hero:after{content:"▱ ▱ ▱";position:absolute;right:-10px;bottom:-14px;font-size:70px;opacity:.18;transform:rotate(-15deg)}
.print-receiver .pr-summary-hero small{font-weight:900;font-size:13px}
.print-receiver .pr-summary-hero h3{margin:8px 0 4px;font-size:16px;color:#fff}
.print-receiver .pr-summary-hero strong{font-size:38px}
.print-receiver .pr-stats{display:grid;grid-template-columns:repeat(3,1fr);gap:0;margin:14px 0;border-bottom:1px solid #e4ebf5;padding-bottom:14px}
.print-receiver .pr-stat{text-align:center;border-right:1px solid #e4ebf5}
.print-receiver .pr-stat:last-child{border:0}
.print-receiver .pr-stat b{display:block;font-size:22px;color:#0b1e50}
.print-receiver .pr-stat span{font-size:11px;color:#7180a0}
.print-receiver .pr-summary-list{display:grid;gap:10px}
.print-receiver .pr-sum-item{padding:10px 0;border-bottom:1px solid #e7edf6}
.print-receiver .pr-sum-item:last-child{border-bottom:0}
.print-receiver .pr-row{display:flex;justify-content:space-between;gap:10px}
.print-receiver .pr-sum-item b{font-size:13px;color:#0b1e50}
.print-receiver .pr-sum-item small{color:#7080a0}
.print-receiver .pr-total-row{display:flex;justify-content:space-between;font-size:18px;font-weight:900;padding-top:8px;color:#0b1e50}
.print-receiver .pr-notice{margin:14px 0;padding:12px 13px;background:#fff7dc;border-radius:12px;color:#624b00;font-size:12px}
.print-receiver .pr-full{width:100%}
.print-receiver .pr-trust{display:grid;grid-template-columns:repeat(3,1fr);gap:8px;margin-top:18px;text-align:center;color:#63749a;font-size:11px}
.print-receiver .pr-error{display:none;background:#fff0f0;color:#a32328;border:1px solid #ffc5c7;border-radius:11px;padding:11px 13px;margin-top:12px;font-size:13px}
.print-receiver .pr-loading{display:none;color:#6e7d9c;font-size:13px;margin-top:8px}
.print-receiver .pr-success{display:none;text-align:center;padding:42px 20px}
.print-receiver .pr-check{width:72px;height:72px;margin:auto;border-radius:50%;background:#e4f8ee;color:#12985f;display:grid;place-items:center;font-size:36px}
.print-receiver .pr-token{font-family:ui-monospace,SFMono-Regular,Consolas,monospace;background:#f2f6fb;border-radius:9px;padding:10px;word-break:break-all;font-size:12px}
.print-receiver .pr-success h3{font-size:28px;margin:15px 0 8px;color:#0b1e50}
.print-receiver .pr-success-actions{display:flex;justify-content:center;gap:10px;flex-wrap:wrap;margin-top:15px}
@media(max-width:1050px){
  .print-receiver .pr-layout{grid-template-columns:1fr}.print-receiver .pr-summary{position:static}.print-receiver .pr-form-grid{grid-template-columns:1fr 1fr}.print-receiver .pr-config{grid-template-columns:repeat(2,1fr)}
}
@media(max-width:680px){
  .print-receiver{padding:65px 0}.print-receiver .pr-shell{padding:0 10px}.print-receiver .pr-head{display:block}.print-receiver .pr-pill{display:inline-block;margin-top:12px}.print-receiver .pr-steps{grid-template-columns:1fr 1fr;gap:10px}.print-receiver .pr-step:after{display:none}.print-receiver .pr-step .pr-num{width:38px;height:38px;flex-basis:38px}.print-receiver .pr-card{padding:14px;border-radius:15px}.print-receiver .pr-form-grid,.print-receiver .pr-config{grid-template-columns:1fr}.print-receiver .pr-drop{padding:20px 10px;flex-direction:column;gap:8px}.print-receiver .pr-filename{max-width:190px}.print-receiver .pr-summary-hero strong{font-size:32px}
}
</style>


<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>

<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('inicio'); ?>

<main id="inicio">
<section class="hero">
  <div class="shell hero-grid">
    <div>
      <div class="eyebrow">SOLUCIONES GRÁFICAS PARA TU MARCA</div>
      <h1><span>IMPRIMIMOS</span><strong>TUS <em>IDEAS</em></strong><b>FABRICAMOS <i>TU MARCA</i></b></h1>
      <p>Diseño, impresión, grabado láser, corte CNC y productos personalizados para convertir lo que imaginas en algo que puedas tocar.</p>
      <div class="actions">
        <a class="btn btn-main" href="#solicita-impresiones">Solicita tus impresiones →</a>
        <a class="btn btn-alt" href="#catalogo">Ver catálogo</a>
        <?php if ($phone): ?><a class="btn btn-alt" href="<?= h($wa) ?>" target="_blank" rel="noopener">WhatsApp ↗</a><?php endif; ?>
      </div>
    </div>
    <div class="hero-art">
      <img src="<?= h($hero) ?>" alt="Soluciones gráficas de Colibrí Print">
      <span class="floating f1">GRABADO<br><b>LÁSER</b></span>
      <span class="floating f2">CORTE<br><b>CNC</b></span>
      <span class="floating f3">TU MARCA AQUÍ</span>
    </div>
  </div>
  <div class="shell trust">
    <div><b>+1,200</b><span>Proyectos atendidos</span></div>
    <div><b>100%</b><span>Atención personalizada</span></div>
    <div><b>MX</b><span>Envíos y atención nacional</span></div>
    <div><b>6+</b><span>Especialidades gráficas</span></div>
  </div>
</section>


<section class="print-receiver" id="solicita-impresiones">
  <div class="pr-shell">
    <div class="pr-head">
      <div>
        <div class="pr-eyebrow">RECEPCIÓN DE ARCHIVOS</div>
        <h2 class="pr-title">Solicita tus impresiones</h2>
        <p class="pr-subtitle">Sube tus archivos, configura cada uno y conoce el precio estimado antes de enviar tu solicitud.</p>
      </div>
      <div class="pr-pill">✓ Cálculo por páginas</div>
    </div>

    <div class="pr-steps">
      <div class="pr-step pr-active"><div class="pr-num">1</div><div><b>Tus datos</b><span>Completa tu información</span></div></div>
      <div class="pr-step pr-active"><div class="pr-num">2</div><div><b>Archivos</b><span>Sube tus archivos</span></div></div>
      <div class="pr-step pr-active"><div class="pr-num">3</div><div><b>Configuración</b><span>Personaliza cada archivo</span></div></div>
      <div class="pr-step pr-active"><div class="pr-num">4</div><div><b>Enviar</b><span>Revisa y confirma</span></div></div>
    </div>

    <div id="prMainLayout" class="pr-layout">
      <main>
        <section class="pr-card">
          <div class="pr-section-title"><div class="pr-bubble">1</div><div><h3>Tus datos</h3><p>¿A quién debemos entregar la solicitud?</p></div></div>
          <div class="pr-form-grid">
            <div class="pr-field"><label for="prName">Nombre completo</label><input id="prName" placeholder="Ej. Erika Bustillos" autocomplete="name"></div>
            <div class="pr-field"><label for="prEmail">Correo electrónico</label><input id="prEmail" type="email" placeholder="correo@ejemplo.com" autocomplete="email"></div>
            <div class="pr-field"><label for="prPhone">Teléfono</label><input id="prPhone" placeholder="627 000 0000" autocomplete="tel"></div>
          </div>
        </section>

        <section class="pr-card">
          <div class="pr-section-title"><div class="pr-bubble">2</div><div><h3>Archivos <span id="prFileCount" style="color:#1468f2">0</span></h3><p>Puedes enviar varios archivos en una sola solicitud.</p></div></div>
          <div id="prDrop" class="pr-drop">
            <div class="pr-cloud">☁️</div>
            <div>
              <h4>Arrastra tus archivos aquí</h4>
              <p>o selecciona desde tu equipo</p>
              <button id="prSelectBtn" class="pr-btn" type="button">📁 Seleccionar archivos</button>
              <input id="prFileInput" type="file" multiple accept=".pdf,.jpg,.jpeg,.png" hidden>
              <p style="margin-top:9px">PDF, JPG y PNG · máximo <?= (int)$printMaxFiles ?> archivos de <?= (int)($printMaxBytes/1024/1024) ?> MB</p>
            </div>
          </div>
          <div id="prFileList" class="pr-file-list"></div>
        </section>

        <section class="pr-card">
          <div class="pr-section-title"><div class="pr-bubble">3</div><div><h3>Configura cada archivo</h3><p>El precio se actualiza al cambiar cualquier opción.</p></div></div>
          <div id="prEmptyConfig" style="color:#7180a0;text-align:center;padding:25px">Sube tus archivos para configurar cada impresión.</div>
          <div id="prConfigList"></div>
        </section>

        <section class="pr-card">
          <div class="pr-section-title">
            <div class="pr-bubble">4</div>
            <div><h3>Enviar solicitud</h3><p>Revisaremos tus archivos y la configuración recibida.</p></div>
            <button id="prSubmitBtn" class="pr-btn" style="margin-left:auto" disabled>Enviar solicitud →</button>
          </div>
          <div id="prError" class="pr-error"></div>
          <div id="prLoading" class="pr-loading">Subiendo archivos y guardando tu solicitud…</div>
        </section>
      </main>

      <aside class="pr-summary">
        <section class="pr-card">
          <div class="pr-summary-hero"><small>RESUMEN</small><h3>Total estimado</h3><strong id="prTotal">$0.00</strong></div>
          <div class="pr-stats">
            <div class="pr-stat"><b id="prStatFiles">0</b><span>archivos</span></div>
            <div class="pr-stat"><b id="prStatPages">0</b><span>páginas</span></div>
            <div class="pr-stat"><b id="prStatSheets">0</b><span>hojas físicas</span></div>
          </div>
          <h3 style="margin:0 0 10px;color:#0b1e50">Detalle de archivos</h3>
          <div id="prSummaryList" class="pr-summary-list"><div style="color:#7180a0;font-size:13px">Aún no hay archivos.</div></div>
          <div class="pr-total-row"><span>Total estimado</span><span id="prTotal2">$0.00</span></div>
          <div class="pr-notice">⚠️ <b>Este es un precio estimado</b><br>La confirmación final se realiza al revisar tus archivos. El servidor vuelve a verificar las páginas del PDF al recibirlo.</div>
          <button id="prSubmitBtn2" class="pr-btn pr-full" disabled>Continuar con mi solicitud →</button>
          <div class="pr-trust"><div>🛡️<br>Archivos protegidos</div><div>☁️<br>PDF, JPG y PNG</div><div>🖨️<br>Listos para revisar</div></div>
        </section>
      </aside>
    </div>

    <section id="prSuccess" class="pr-card pr-success">
      <div class="pr-check">✓</div>
      <h3>¡Solicitud recibida!</h3>
      <p>Tu solicitud quedó registrada. Conserva este número para cualquier seguimiento.</p>
      <p><b>Solicitud:</b> <span id="prSuccessNumber"></span></p>
      <p><b>Total estimado:</b> <span id="prSuccessTotal"></span></p>
      <div class="pr-token" id="prSuccessToken"></div>
      <div class="pr-success-actions">
        <a id="prTrackingLink" class="btn btn-main" href="#" target="_blank" rel="noopener">Ver seguimiento →</a>
        <button id="prNewRequest" class="pr-btn pr-btn-alt" type="button">Nueva solicitud</button>
      </div>
      <p style="color:#7180a0;font-size:13px">Nuestro equipo revisará los archivos y confirmará el precio final.</p>
    </section>
  </div>
</section>

<section class="section dark" id="servicios">
  <div class="shell">
    <div class="head"><div><div class="eyebrow">NUESTRAS ESPECIALIDADES</div><h2>Mucho más que <span>impresión.</span></h2><p>Soluciones pensadas para negocios, eventos, marcas y proyectos personales.</p></div></div>
    <div class="services">
      <?php foreach ($services as $i=>$service): ?>
      <article class="service"><span class="num">0<?= $i+1 ?></span><h3><?= h($service[0]) ?></h3><p><?= h($service[1]) ?></p></article>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section class="section" id="categorias">
  <div class="shell">
    <div class="head"><div><div class="eyebrow">EXPLORA</div><h2>Encuentra lo que <span>necesitas.</span></h2></div><a href="<?= h(cp_url('catalogo.php')) ?>">Ver catálogo →</a></div>
    <div class="cat-grid">
      <?php
      $fallback = ['Impresión digital','Gran formato','Sublimación','Corte CNC','Grabado láser','Personalizados','Textiles','Promocionales'];
      foreach ($fallback as $i=>$name):
          $cat = $categories[$i] ?? null;
          $label = $cat['name'] ?? $name;
      ?>
      <a class="cat" href="<?= h($cat ? cp_url('catalogo.php',['categoria'=>(int)$cat['id']]) : cp_url('catalogo.php')) ?>">
        <?php if ($collage): ?><img src="<?= h($collage) ?>" alt="" loading="lazy"><?php endif; ?>
        <div><strong><?= h($label) ?></strong><span>Explorar →</span></div>
      </a>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section class="section dark" id="catalogo">
  <div class="shell">
    <div class="head"><div><div class="eyebrow">CATÁLOGO PROPIO</div><h2>Productos para <span>comprar o personalizar.</span></h2></div><a href="<?= h(cp_url('catalogo.php')) ?>">Abrir catálogo →</a></div>
    <div class="product-grid">
      <?php foreach ($products as $p): $img=asset($p['image_path'] ?? ''); $fixed=$p['pricing_type']==='fixed' && $p['sale_price']!==null; ?>
      <article class="product">
        <a class="product-media" href="<?= h(cp_url('producto.php',['id'=>(int)$p['id']])) ?>">
          <?php if($img): ?><img src="<?= h($img) ?>" alt="<?= h($p['name']) ?>" loading="lazy"><?php endif; ?>
        </a>
        <div class="product-body">
          <small><?= h($p['category_name'] ?: 'Colibrí Print') ?></small>
          <h3><?= h($p['name']) ?></h3>
          <p><?= h(trim((string)($p['description'] ?? '')) ?: 'Producto personalizable de Colibrí Print.') ?></p>
          <div class="price"><strong><?= $fixed ? h(money_mx($p['sale_price'])) : 'Cotización' ?></strong><a href="<?= h(cp_url('producto.php',['id'=>(int)$p['id']])) ?>">Ver detalle →</a></div>
        </div>
      </article>
      <?php endforeach; ?>
      <?php if (!$products): ?><p style="color:var(--muted)">El catálogo propio todavía no tiene productos publicados.</p><?php endif; ?>
    </div>
  </div>
</section>

<section class="section promo-section" id="promociones">
  <div class="shell">
    <div class="head"><div><div class="eyebrow">OFERTAS Y OPORTUNIDADES</div><h2>Promociones que <span>sí conviene mirar.</span></h2><p>Las promociones vencidas permanecen visibles como historial. Las activas se pueden consultar y solicitar.</p></div></div>

    <?php if ($activePromos): ?>
    <div class="promo-grid">
      <?php foreach($activePromos as $p): ?>
      <article class="promo" data-promo data-title="<?= h($p['title']) ?>" data-price="<?= h(money_mx($p['promo_price'])) ?>" data-end="<?= h($p['end_date'] ? date('d/m/Y',strtotime((string)$p['end_date'])) : 'por tiempo limitado') ?>" data-image="<?= h($p['image']) ?>" data-description="<?= h(strip_tags((string)($p['description'] ?? ''))) ?>">
        <div class="promo-image">
          <?php if($p['image']): ?><img src="<?= h($p['image']) ?>" alt="<?= h($p['title']) ?>" loading="lazy"><?php endif; ?>
          <?php if(!empty($p['discount']) && $p['discount'] > 0): ?><span class="promo-discount">-<?= (int)$p['discount'] ?>%</span><?php endif; ?>
          <span class="promo-status">ACTIVA</span>
        </div>
        <div class="promo-body">
          <small><?= $p['end_date'] ? 'Hasta '.h(date('d/m/Y',strtotime((string)$p['end_date']))) : 'Por tiempo limitado' ?></small>
          <h3><?= h($p['title']) ?></h3>
          <?php if($p['description']): ?><p><?= h(strip_tags((string)$p['description'])) ?></p><?php endif; ?>
          <strong class="promo-price"><?= h(money_mx($p['promo_price'])) ?></strong>
          <?php if($p['normal_price'] !== null): ?><span class="promo-old"><?= h(money_mx($p['normal_price'])) ?></span><?php endif; ?>
        </div>
      </article>
      <?php endforeach; ?>
    </div>
    <?php endif; ?>

    <?php if ($expiredPromos): ?>
    <div style="margin:55px 0 20px"><div class="eyebrow">HISTORIAL</div><h3 style="font-size:28px;margin:7px 0">Promociones que ya terminaron</h3><p style="color:var(--muted)">Siguen aquí para que puedas ver lo que estuvo disponible, pero ya no reciben pedidos.</p></div>
    <div class="promo-grid">
      <?php foreach($expiredPromos as $p): ?>
      <article class="promo expired" aria-disabled="true">
        <div class="promo-image">
          <?php if($p['image']): ?><img src="<?= h($p['image']) ?>" alt="<?= h($p['title']) ?>" loading="lazy"><?php endif; ?>
          <?php if(!empty($p['discount']) && $p['discount'] > 0): ?><span class="promo-discount">-<?= (int)$p['discount'] ?>%</span><?php endif; ?>
          <span class="promo-status">FINALIZADA</span>
        </div>
        <div class="promo-body">
          <small>Finalizó <?= $p['end_date'] ? h(date('d/m/Y',strtotime((string)$p['end_date']))) : '' ?></small>
          <h3><?= h($p['title']) ?></h3>
          <?php if($p['description']): ?><p><?= h(strip_tags((string)$p['description'])) ?></p><?php endif; ?>
          <strong style="color:#8795a8">Promoción no disponible</strong>
          <?php if($p['normal_price'] !== null): ?><span class="promo-old"><?= h(money_mx($p['normal_price'])) ?></span><?php endif; ?>
          <div class="expired-note">Solo historial · no seleccionable · no genera pedido</div>
        </div>
      </article>
      <?php endforeach; ?>
    </div>
    <?php endif; ?>

    <?php if (!$activePromos && !$expiredPromos): ?>
      <p style="color:var(--muted)">Próximamente publicaremos nuevas promociones.</p>
    <?php endif; ?>
  </div>
</section>

<section class="section" id="proceso">
  <div class="shell">
    <div class="head"><div><div class="eyebrow">ASÍ TRABAJAMOS</div><h2>De la idea a la <span>realidad.</span></h2></div></div>
    <div class="services">
      <article class="service"><span class="num">01</span><h3>Cuéntanos</h3><p>Explícanos qué necesitas, cantidades, medidas y fecha.</p></article>
      <article class="service"><span class="num">02</span><h3>Diseñamos y cotizamos</h3><p>Definimos materiales, acabados y la solución adecuada.</p></article>
      <article class="service"><span class="num">03</span><h3>Producimos</h3><p>Preparamos tu pedido con seguimiento y comunicación.</p></article>
      <article class="service"><span class="num">04</span><h3>Entregamos</h3><p>Coordinamos entrega local o atención para todo México.</p></article>
    </div>
  </div>
</section>

<section class="section dark" id="nosotros">
  <div class="shell">
    <div class="head"><div><div class="eyebrow">COLIBRÍ PRINT MÉXICO</div><h2>Tu proyecto merece <span>verse bien.</span></h2><p>Trabajamos desde <?= h($location) ?> para convertir diseño, impresión y personalización en soluciones reales para negocios, eventos y personas.</p></div></div>
  </div>
</section>
</main>

<footer class="footer" id="contacto">
  <div class="shell footer-grid">
    <div><strong style="font-size:20px">Colibrí <b style="color:var(--pink)">Print</b></strong><p><?= h($address) ?><?= $address ? ' · ' : '' ?><?= h($location) ?></p></div>
    <div><strong>Contacto</strong><?php if($phone): ?><a href="tel:<?= h($phone) ?>"><?= h($phone) ?></a><?php endif; ?><?php if($email): ?><a href="mailto:<?= h($email) ?>"><?= h($email) ?></a><?php endif; ?></div>
    <div><strong>Legal</strong><a href="<?= h(cp_url('terminos-y-condiciones/')) ?>">Términos y condiciones</a><a href="<?= h(cp_url('politica-de-privacidad/')) ?>">Política de privacidad</a></div>
    <div><strong>¿Listo?</strong><?php if($phone): ?><a class="cta" href="<?= h($wa) ?>" target="_blank" rel="noopener">Cotizar ahora →</a><?php endif; ?></div>
  </div>
  <div class="shell footer-bottom"><span>© <?= date('Y') ?> <?= h($brand) ?>. Todos los derechos reservados.</span><span>Imprimimos tus ideas.</span></div>
</footer>

<div class="modal" id="promoModal" aria-hidden="true">
  <div class="modal-card" role="dialog" aria-modal="true" aria-labelledby="promoTitle">
    <div class="modal-media"><img id="modalImage" alt=""></div>
    <div class="modal-content">
      <button class="close" type="button" id="closeModal">✕</button>
      <div class="eyebrow">COMPRA DIRECTA</div>
      <h2 id="promoTitle">Promoción</h2>
      <p id="modalDescription" style="color:var(--muted)"></p>
      <div class="sale" id="modalPrice"></div>
      <small style="color:#91a0b3">Vigencia: <span id="modalEnd"></span></small>

      <form id="promoForm">
        <label for="buyerName">Nombre *</label>
        <input id="buyerName" required autocomplete="name" placeholder="Tu nombre">
        <label for="buyerPhone">WhatsApp / teléfono *</label>
        <input id="buyerPhone" required autocomplete="tel" placeholder="10 dígitos">
        <label for="buyerQty">Cantidad *</label>
        <input id="buyerQty" type="number" min="1" value="1" required>
        <label>Método de pago *</label>
        <div class="pay">
          <label><input type="radio" name="payment" value="transferencia" checked> Transferencia</label>
          <label><input type="radio" name="payment" value="efectivo"> Efectivo</label>
        </div>
        <label for="buyerNote">Nota / indicaciones</label>
        <textarea id="buyerNote" placeholder="Color, medida, entrega, etc."></textarea>
        <div class="modal-actions">
          <button class="cancel" type="button" id="cancelModal">Cancelar</button>
          <button class="send" type="submit">Enviar pedido por WhatsApp ↗</button>
        </div>
      </form>
    </div>
  </div>
</div>


<script>
(() => {
  const PR = {
    sizes: <?= json_encode($printSizes, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) ?>,
    materials: <?= json_encode($printMaterials, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) ?>,
    finishes: <?= json_encode($printFinishes, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) ?>,
    prices: <?= json_encode($printPrices, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) ?>,
    api: <?= json_encode($printApi, JSON_UNESCAPED_SLASHES) ?>,
    followup: <?= json_encode($printFollowupBase, JSON_UNESCAPED_SLASHES) ?>,
    maxFiles: <?= (int)$printMaxFiles ?>,
    maxBytes: <?= (int)$printMaxBytes ?>
  };

  const qs = s => document.querySelector(s);
  const money = n => '$' + Number(n || 0).toLocaleString('es-MX',{minimumFractionDigits:2,maximumFractionDigits:2}) + ' MXN';
  const esc = s => String(s ?? '').replace(/[&<>'"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[c]));
  const sizeName = id => (PR.sizes.find(x=>Number(x.id)===Number(id)) || {}).name || '';
  const materialName = id => (PR.materials.find(x=>Number(x.id)===Number(id)) || {}).name || '';

  let prFiles = [];

  function defaultCfg(){
    return {
      size_id: Number((PR.sizes.find(x=>x.code==='a4') || PR.sizes[0] || {}).id || 1),
      material_id: Number((PR.materials.find(x=>x.code==='bond') || PR.materials[0] || {}).id || 1),
      finish_id: Number((PR.finishes.find(x=>x.code==='none') || PR.finishes[0] || {}).id || 1),
      color_mode: 'color',
      copies: 1,
      notes: ''
    };
  }

  function priceFor(item){
    const candidates = PR.prices.filter(x =>
      Number(x.size_id)===Number(item.size_id) &&
      Number(x.material_id)===Number(item.material_id) &&
      x.color_mode===item.color_mode &&
      Number(x.min_qty || 1) <= Number(item.copies || 1)
    );
    const exact = candidates.filter(x=>Number(x.finish_id)===Number(item.finish_id))
      .sort((a,b)=>Number(b.min_qty||1)-Number(a.min_qty||1)||Number(b.id)-Number(a.id))[0];
    if(exact) return Number(exact.unit_price);
    const fallback = candidates
      .sort((a,b)=>Number(b.min_qty||1)-Number(a.min_qty||1)||Number(b.id)-Number(a.id))[0];
    return fallback ? Number(fallback.unit_price) : 0;
  }

  function pagesFor(f){ return Math.max(1, Number(f.pageCount || 1)); }
  function itemTotal(f){ return priceFor(f) * pagesFor(f) * Number(f.copies || 1); }

  function selectHtml(arr,val){
    return arr.map(x=>`<option value="${x.id}" ${Number(x.id)===Number(val)?'selected':''}>${esc(x.name)}</option>`).join('');
  }

  function showError(message){
    const el=qs('#prError'); el.textContent=message; el.style.display='block';
  }
  function hideError(){ qs('#prError').style.display='none'; }

  function renderFiles(){
    qs('#prFileList').innerHTML = prFiles.map((f,i)=>`
      <div class="pr-file-card">
        <div class="pr-file-head">
          <div class="pr-file-info">
            <div class="pr-thumb">${f.type.startsWith('image/') ? `<img src="${f.preview}" alt="">` : 'PDF'}</div>
            <div style="min-width:0">
              <div class="pr-filename">${esc(f.name)}</div>
              <div class="pr-meta">${f.type==='application/pdf'?'PDF':'Imagen'} · ${(f.size/1024/1024).toFixed(2)} MB · ${pagesFor(f)} ${pagesFor(f)==1?'página':'páginas'}</div>
            </div>
          </div>
          <button class="pr-remove" type="button" data-remove="${i}">Quitar</button>
        </div>
        <div class="pr-config">
          <div class="pr-field"><label>Tamaño</label><select data-i="${i}" data-k="size_id">${selectHtml(PR.sizes,f.size_id)}</select></div>
          <div class="pr-field"><label>Material</label><select data-i="${i}" data-k="material_id">${selectHtml(PR.materials,f.material_id)}</select></div>
          <div class="pr-field"><label>Acabado</label><select data-i="${i}" data-k="finish_id">${selectHtml(PR.finishes,f.finish_id)}</select></div>
          <div class="pr-field"><label>Color</label><select data-i="${i}" data-k="color_mode"><option value="color" ${f.color_mode==='color'?'selected':''}>Color</option><option value="bw" ${f.color_mode==='bw'?'selected':''}>Blanco y negro</option></select></div>
          <div class="pr-field"><label>Cantidad</label><input type="number" min="1" max="9999" value="${f.copies}" data-i="${i}" data-k="copies"></div>
        </div>
        <div class="pr-mini-total"><span>${pagesFor(f)} ${pagesFor(f)==1?'página':'páginas'} × ${f.copies} copia(s) · ${money(priceFor(f))}/página</span><span>${money(itemTotal(f))}</span></div>
      </div>`).join('');

    qs('#prEmptyConfig').style.display=prFiles.length?'none':'block';

    qs('#prFileList').querySelectorAll('[data-remove]').forEach(btn=>{
      btn.addEventListener('click',()=>removeFile(Number(btn.dataset.remove)));
    });
    qs('#prFileList').querySelectorAll('[data-i][data-k]').forEach(el=>{
      el.addEventListener('change',()=>{
        const i=Number(el.dataset.i), k=el.dataset.k;
        prFiles[i][k]=k==='copies' ? Math.max(1,Math.min(9999,parseInt(el.value,10)||1)) : el.value;
        renderFiles(); recalc();
      });
    });
  }

  function renderSummary(){
    qs('#prSummaryList').innerHTML = prFiles.length
      ? prFiles.map(f=>`<div class="pr-sum-item"><div class="pr-row"><b>${esc(f.name)}</b><b>${money(itemTotal(f))}</b></div><small>${pagesFor(f)} ${pagesFor(f)==1?'página':'páginas'} · ${esc(sizeName(f.size_id))} · ${esc(materialName(f.material_id))} · ${f.color_mode==='bw'?'B/N':'Color'}</small></div>`).join('')
      : '<div style="color:#7180a0;font-size:13px">Aún no hay archivos.</div>';
  }

  function recalc(){
    let total=0,pages=0,sheets=0;
    prFiles.forEach(f=>{
      total += itemTotal(f);
      pages += pagesFor(f);
      sheets += pagesFor(f)*Number(f.copies||1);
    });
    qs('#prTotal').textContent=money(total);
    qs('#prTotal2').textContent=money(total);
    qs('#prStatFiles').textContent=prFiles.length;
    qs('#prStatPages').textContent=pages;
    qs('#prStatSheets').textContent=sheets;
    qs('#prFileCount').textContent=prFiles.length;

    const ready = prFiles.length>0 && qs('#prName').value.trim() && qs('#prPhone').value.trim();
    qs('#prSubmitBtn').disabled=!ready;
    qs('#prSubmitBtn2').disabled=!ready;
    renderSummary();
  }

  async function pdfPagesClient(file){
    try{
      const buf=await file.arrayBuffer();
      const text=new TextDecoder('latin1').decode(buf);
      const matches=text.match(/\/Type\s*\/Page\b/g);
      return Math.max(1,matches ? matches.length : 1);
    }catch(e){ return 1; }
  }

  async function addFiles(list){
    hideError();
    for(const file of [...list]){
      if(prFiles.length>=PR.maxFiles){showError(`Máximo ${PR.maxFiles} archivos por solicitud.`);break;}
      if(file.size>PR.maxBytes){showError(`${file.name} supera el límite de 20 MB.`);continue;}
      if(!['application/pdf','image/jpeg','image/png'].includes(file.type)){showError(`${file.name}: solo PDF, JPG y PNG.`);continue;}
      const cfg=defaultCfg();
      const f={...cfg,name:file.name,type:file.type,size:file.size,file,preview:file.type.startsWith('image/')?URL.createObjectURL(file):'',pageCount:1};
      if(file.type==='application/pdf') f.pageCount=await pdfPagesClient(file);
      prFiles.push(f);
    }
    renderFiles(); recalc();
  }

  function removeFile(i){
    if(prFiles[i]?.preview) URL.revokeObjectURL(prFiles[i].preview);
    prFiles.splice(i,1);
    renderFiles(); recalc();
  }

  async function submitPrintRequest(){
    hideError();
    if(!prFiles.length){showError('Agrega al menos un archivo.');return;}
    if(!qs('#prName').value.trim()){showError('Completa tu nombre.');return;}
    if(!qs('#prPhone').value.trim()){showError('Completa tu teléfono.');return;}

    qs('#prSubmitBtn').disabled=true;
    qs('#prSubmitBtn2').disabled=true;
    qs('#prLoading').style.display='block';

    const fd=new FormData();
    fd.append('name',qs('#prName').value.trim());
    fd.append('email',qs('#prEmail').value.trim());
    fd.append('phone',qs('#prPhone').value.trim());
    fd.append('items',JSON.stringify(prFiles.map(f=>({
      size_id:Number(f.size_id),material_id:Number(f.material_id),finish_id:Number(f.finish_id),
      color_mode:f.color_mode,copies:Number(f.copies),notes:f.notes||''
    }))));

    prFiles.forEach(f=>fd.append('files[]',f.file,f.name));

    try{
      const response=await fetch(PR.api,{method:'POST',body:fd});
      const raw=await response.text();
      let data;
      try{data=JSON.parse(raw);}catch(e){throw new Error('El servidor no devolvió una respuesta JSON válida. Revisa api/print-request.php y el registro de errores de PHP.');}
      if(!response.ok || !data.ok) throw new Error(data.error || 'No se pudo enviar la solicitud.');

      qs('#prMainLayout').style.display='none';
      qs('#prSuccess').style.display='block';
      qs('#prSuccessNumber').textContent='CPQ-'+String(data.request_id).padStart(6,'0');
      qs('#prSuccessTotal').textContent=money(data.total);
      qs('#prSuccessToken').textContent=data.request_token;
      qs('#prTrackingLink').href=PR.followup+'?t='+encodeURIComponent(data.request_token);
      document.getElementById('solicita-impresiones').scrollIntoView({behavior:'smooth',block:'start'});
    }catch(error){
      showError(error.message || 'No se pudo enviar la solicitud.');
      qs('#prSubmitBtn').disabled=false;
      qs('#prSubmitBtn2').disabled=false;
    }finally{
      qs('#prLoading').style.display='none';
    }
  }

  function resetPrintRequest(){
    prFiles.forEach(f=>{if(f.preview) URL.revokeObjectURL(f.preview);});
    prFiles=[];
    qs('#prFileInput').value='';
    qs('#prName').value='';
    qs('#prEmail').value='';
    qs('#prPhone').value='';
    qs('#prSuccess').style.display='none';
    qs('#prMainLayout').style.display='grid';
    renderFiles();recalc();
  }

  qs('#prSelectBtn').addEventListener('click',()=>qs('#prFileInput').click());
  qs('#prFileInput').addEventListener('change',e=>addFiles(e.target.files));

  const drop=qs('#prDrop');
  ['dragenter','dragover'].forEach(ev=>drop.addEventListener(ev,e=>{e.preventDefault();drop.style.background='#eaf3ff';}));
  ['dragleave','drop'].forEach(ev=>drop.addEventListener(ev,e=>{e.preventDefault();drop.style.background='linear-gradient(135deg,#fbfdff,#f3f8ff)';}));
  drop.addEventListener('drop',e=>addFiles(e.dataTransfer.files));

  ['prName','prEmail','prPhone'].forEach(id=>qs('#'+id).addEventListener('input',recalc));
  qs('#prSubmitBtn').addEventListener('click',submitPrintRequest);
  qs('#prSubmitBtn2').addEventListener('click',submitPrintRequest);
  qs('#prNewRequest').addEventListener('click',resetPrintRequest);

  renderFiles();recalc();
})();
</script>

<script src="/assets/js/home-professional.js?v=20260922-1" defer></script>
</body>
</html>
