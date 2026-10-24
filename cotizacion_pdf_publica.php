<?php
declare(strict_types=1);

require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/cotizaciones.php';
require_once __DIR__ . '/includes/company.php';
require_once __DIR__ . '/includes/cotizacion_pdf_renderer.php';
require_once __DIR__ . '/includes/cancelled_public_landing_v1.php';
// SISACT_CANCELLED_LANDING_ORDER_TOKEN_V1

function qpv2_e(?string $v): string {
    return htmlspecialchars((string)$v, ENT_QUOTES, 'UTF-8');
}

function qpv2_color(string $v, string $fallback): string {
    $v = trim($v);
    return preg_match('/^#[0-9a-f]{6}$/i', $v) ? $v : $fallback;
}

function qpv2_catalog_url(string $website): string {
    $website = rtrim($website, '/');
    return $website . '/#servicios';
}

function qpv2_products(string $website, string $whatsUrl): array {
    $catalog = qpv2_catalog_url($website);

    return [
        [
            'tag' => 'Más solicitado',
            'title' => 'Impresión gran formato',
            'text' => 'Lonas, viniles, stickers, etiquetas y material publicitario listo para producción.',
            'accent' => 'pink',
            'href' => $catalog,
            'cta' => 'Ver opciones',
        ],
        [
            'tag' => 'Alta demanda',
            'title' => 'Grabado láser',
            'text' => 'Personalización en termos, placas, maderas, acrílicos y regalos empresariales.',
            'accent' => 'cyan',
            'href' => $catalog,
            'cta' => 'Solicitar precio',
        ],
        [
            'tag' => 'Fabricación',
            'title' => 'Corte CNC y láser',
            'text' => 'Piezas personalizadas, letras, señalética, exhibidores y proyectos especiales.',
            'accent' => 'yellow',
            'href' => $catalog,
            'cta' => 'Explorar',
        ],
        [
            'tag' => 'Aprovecha hoy',
            'title' => 'Cotización nueva por WhatsApp',
            'text' => 'Recibe una nueva propuesta con disponibilidad, tiempos y precio actualizado.',
            'accent' => 'green',
            'href' => $whatsUrl !== '' ? $whatsUrl : $catalog,
            'cta' => 'Pedir nueva cotización',
        ],
    ];
}

function qpv2_unavailable(array $company, string $title, string $message, int $httpStatus=404): never {
    http_response_code($httpStatus);
    header('Content-Type: text/html; charset=utf-8');
    header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
    header('X-Robots-Tag: noindex, nofollow', true);

    $name = trim((string)($company['trade_name'] ?? ''))
        ?: trim((string)($company['name'] ?? ''))
        ?: 'Colibrí Print';
    $slogan = trim((string)($company['slogan'] ?? '')) ?: 'Soluciones gráficas para tu marca';
    $website = trim((string)($company['website'] ?? '')) ?: 'https://colibriprint.com.mx';

    $phone = trim((string)($company['phone'] ?? ''));
    $email = trim((string)($company['email'] ?? ''));
    $address = trim((string)($company['address'] ?? 'Hidalgo del Parral, Chihuahua'));

    $wa = trim((string)($company['whatsapp'] ?? ''));
    if ($wa === '') $wa = $phone;
    $wa = preg_replace('/[^0-9]/', '', $wa);
    if ($wa !== '' && strlen($wa) == 10) $wa = '52' . $wa;

    $waText = rawurlencode(
        'Hola ' . $name .
        ', mi cotización ya no está vigente y necesito una nueva propuesta actualizada.'
    );
    $waUrl = $wa !== '' ? 'https://wa.me/' . $wa . '?text=' . $waText : '';

    $logo = trim((string)($company['logo_path'] ?? ''));
    if ($logo !== '' && !preg_match('#^(https?://|/)#i', $logo)) {
        $logo = '/' . ltrim($logo, '/');
    }

    $primary = qpv2_color((string)($company['color_primary'] ?? ''), '#ff255d');
    $secondary = qpv2_color((string)($company['color_secondary'] ?? ''), '#061733');
    $accent = qpv2_color((string)($company['color_accent'] ?? ''), '#0fd0ff');
    $gold = '#ffd24d';
    $products = qpv2_products($website, $waUrl);
    $catalogUrl = qpv2_catalog_url($website);

?>
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="robots" content="noindex,nofollow">
<title><?=qpv2_e($title)?> | <?=qpv2_e($name)?></title>
<style>
:root{
  --bg:#041126;
  --bg2:#071b38;
  --panel:#0a1f3f;
  --panel2:#0d274f;
  --stroke:rgba(255,255,255,.10);
  --white:#f7fbff;
  --text:#d8e5f6;
  --muted:#9db3cf;
  --primary:<?=qpv2_e($primary)?>;
  --secondary:<?=qpv2_e($secondary)?>;
  --accent:<?=qpv2_e($accent)?>;
  --gold:<?=$gold?>;
  --success:#21d49a;
  --shadow:0 22px 70px rgba(0,0,0,.28);
}
*{box-sizing:border-box}
html,body{min-height:100%}
body{
  margin:0;
  color:var(--white);
  font-family:Inter,ui-sans-serif,system-ui,-apple-system,"Segoe UI",sans-serif;
  background:
    radial-gradient(circle at 15% 18%, rgba(15,208,255,.14), transparent 26%),
    radial-gradient(circle at 82% 16%, rgba(255,37,93,.16), transparent 24%),
    linear-gradient(180deg, #031022 0%, #071a36 100%);
}
.page{
  min-height:100vh;
  padding:28px 18px 34px;
}
.shell{
  width:min(1180px,100%);
  margin:0 auto;
}
.hero{
  position:relative;
  overflow:hidden;
  border:1px solid var(--stroke);
  border-radius:32px;
  background:
    linear-gradient(130deg, rgba(255,37,93,.15), transparent 30%),
    linear-gradient(160deg, rgba(15,208,255,.10), transparent 45%),
    linear-gradient(180deg, rgba(255,255,255,.03), rgba(255,255,255,.02)),
    linear-gradient(180deg, #06162f 0%, #081c3b 100%);
  box-shadow:var(--shadow);
}
.hero:before{
  content:"";
  position:absolute;
  inset:auto -120px -120px auto;
  width:360px;
  height:360px;
  border-radius:50%;
  background:radial-gradient(circle, rgba(255,37,93,.25), transparent 70%);
  pointer-events:none;
}
.topbar{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:14px;
  padding:18px 22px;
  border-bottom:1px solid var(--stroke);
}
.brand{
  display:flex;
  align-items:center;
  gap:13px;
  min-width:0;
}
.logo{
  width:62px;
  height:48px;
  display:flex;
  align-items:center;
  justify-content:center;
  overflow:hidden;
  flex:0 0 auto;
}
.logo img{max-width:100%;max-height:100%;object-fit:contain}
.logo-fallback{
  width:46px;
  height:46px;
  border-radius:14px;
  display:flex;
  align-items:center;
  justify-content:center;
  background:linear-gradient(135deg, var(--primary), #ff5b84);
  color:#fff;
  font-weight:900;
}
.brand-copy{min-width:0}
.brand-copy strong{
  display:block;
  color:#fff;
  font-size:18px;
  letter-spacing:-.2px;
}
.brand-copy span{
  display:block;
  margin-top:2px;
  color:var(--muted);
  font-size:11px;
  white-space:nowrap;
  overflow:hidden;
  text-overflow:ellipsis;
}
.badge{
  flex:0 0 auto;
  padding:8px 12px;
  border-radius:999px;
  border:1px solid rgba(255,255,255,.12);
  background:rgba(255,255,255,.04);
  color:#d7e5fb;
  font-size:10px;
  font-weight:900;
  letter-spacing:.08em;
  text-transform:uppercase;
}
.hero-grid{
  display:grid;
  grid-template-columns:1.12fr .88fr;
  gap:24px;
  padding:30px 30px 28px;
}
.copy{
  padding:10px 4px 10px 4px;
}
.copy .eyebrow{
  display:inline-block;
  margin-bottom:14px;
  color:var(--accent);
  font-size:12px;
  font-weight:900;
  letter-spacing:.18em;
  text-transform:uppercase;
}
.copy h1{
  margin:0;
  font-size:clamp(34px,5vw,58px);
  line-height:.98;
  letter-spacing:-1.6px;
}
.copy h1 .accent{color:var(--primary)}
.copy .lead{
  max-width:660px;
  margin:18px 0 0;
  color:var(--text);
  font-size:16px;
  line-height:1.75;
}
.notice{
  margin-top:18px;
  padding:16px 18px;
  display:flex;
  gap:12px;
  align-items:flex-start;
  border-radius:18px;
  border:1px solid rgba(15,208,255,.16);
  background:rgba(8,29,62,.78);
}
.notice .dot{
  width:10px;
  height:10px;
  margin-top:7px;
  border-radius:50%;
  background:var(--success);
  flex:0 0 auto;
}
.notice strong{display:block;color:#fff;font-size:13px;margin-bottom:4px}
.notice span{color:var(--muted);font-size:13px;line-height:1.6}
.quick{
  margin-top:24px;
  display:flex;
  flex-wrap:wrap;
  gap:12px;
}
.btn{
  min-height:50px;
  padding:0 18px;
  display:inline-flex;
  align-items:center;
  justify-content:center;
  border-radius:14px;
  text-decoration:none;
  font-weight:900;
  font-size:13px;
  letter-spacing:.01em;
  transition:.18s ease;
}
.btn:hover{transform:translateY(-1px)}
.btn-primary{
  background:linear-gradient(135deg, var(--primary), #ff4776);
  color:#fff;
  box-shadow:0 14px 26px rgba(255,37,93,.24);
}
.btn-secondary{
  border:1px solid rgba(255,255,255,.12);
  background:rgba(255,255,255,.04);
  color:#fff;
}
.btn-tertiary{
  border:1px solid rgba(15,208,255,.20);
  background:rgba(9,28,58,.86);
  color:#cfe8ff;
}
.stats{
  margin-top:24px;
  display:grid;
  grid-template-columns:repeat(3,minmax(0,1fr));
  gap:12px;
}
.stat{
  padding:16px 16px 14px;
  border-radius:16px;
  border:1px solid var(--stroke);
  background:rgba(255,255,255,.035);
}
.stat strong{
  display:block;
  font-size:24px;
  color:#fff;
}
.stat span{
  display:block;
  margin-top:5px;
  color:var(--muted);
  font-size:12px;
}
.side{
  display:flex;
  flex-direction:column;
  gap:14px;
}
.panel{
  padding:18px;
  border-radius:22px;
  border:1px solid var(--stroke);
  background:linear-gradient(180deg, rgba(255,255,255,.05), rgba(255,255,255,.025));
}
.panel h3{
  margin:0 0 6px;
  color:#fff;
  font-size:22px;
}
.panel p{
  margin:0;
  color:var(--muted);
  line-height:1.65;
  font-size:13px;
}
.ribbon{
  display:inline-flex;
  align-items:center;
  gap:8px;
  margin-bottom:12px;
  color:var(--gold);
  font-size:11px;
  font-weight:900;
  letter-spacing:.1em;
  text-transform:uppercase;
}
.offer-stack{
  display:grid;
  gap:12px;
  margin-top:12px;
}
.offer{
  padding:14px;
  border-radius:16px;
  border:1px solid rgba(255,255,255,.08);
  background:rgba(255,255,255,.03);
}
.offer .tag{
  display:inline-flex;
  padding:5px 9px;
  border-radius:999px;
  font-size:10px;
  font-weight:900;
  letter-spacing:.06em;
  text-transform:uppercase;
}
.offer .pink{background:rgba(255,37,93,.13); color:#ff8aac}
.offer .cyan{background:rgba(15,208,255,.12); color:#7fe8ff}
.offer .yellow{background:rgba(255,210,77,.12); color:#ffe48d}
.offer .green{background:rgba(33,212,154,.12); color:#8bf3cf}
.offer h4{
  margin:11px 0 7px;
  color:#fff;
  font-size:16px;
}
.offer p{
  margin:0;
  color:var(--muted);
  font-size:13px;
  line-height:1.6;
}
.offer a{
  margin-top:11px;
  display:inline-flex;
  align-items:center;
  gap:6px;
  color:#fff;
  font-size:12px;
  font-weight:800;
  text-decoration:none;
}
.bottom{
  display:grid;
  grid-template-columns:1fr 1fr;
  gap:16px;
  padding:0 30px 28px;
}
.contact-card{
  padding:18px;
  border-radius:20px;
  border:1px solid var(--stroke);
  background:rgba(255,255,255,.03);
}
.contact-card h4{
  margin:0 0 10px;
  font-size:18px;
}
.contact-list{
  display:grid;
  gap:8px;
  color:var(--muted);
  font-size:13px;
  line-height:1.6;
}
.mini-actions{
  margin-top:14px;
  display:flex;
  flex-wrap:wrap;
  gap:10px;
}
.flow{
  padding:18px;
  border-radius:20px;
  border:1px solid var(--stroke);
  background:linear-gradient(180deg, rgba(15,208,255,.05), rgba(255,255,255,.03));
}
.flow h4{
  margin:0 0 12px;
  font-size:18px;
}
.steps{
  display:grid;
  gap:10px;
}
.step{
  display:flex;
  gap:11px;
  align-items:flex-start;
}
.step .n{
  width:26px;
  height:26px;
  flex:0 0 auto;
  border-radius:50%;
  display:flex;
  align-items:center;
  justify-content:center;
  color:#fff;
  background:linear-gradient(135deg, var(--primary), #ff4776);
  font-size:12px;
  font-weight:900;
}
.step div strong{
  display:block;
  color:#fff;
  font-size:13px;
  margin-bottom:2px;
}
.step div span{
  color:var(--muted);
  font-size:12px;
  line-height:1.55;
}
.footer{
  padding:0 30px 26px;
  color:#8fa7c6;
  font-size:11px;
  text-align:center;
}
.footer strong{color:#fff}
@media (max-width:980px){
  .hero-grid,.bottom{grid-template-columns:1fr}
}
@media (max-width:680px){
  .page{padding:14px}
  .topbar{padding:15px 16px}
  .badge{display:none}
  .hero-grid{padding:24px 18px 18px; gap:18px}
  .bottom{padding:0 18px 18px}
  .copy h1{font-size:38px}
  .stats{grid-template-columns:1fr}
  .quick,.mini-actions{display:grid}
  .btn{width:100%}
  .footer{padding:0 18px 20px}
}
</style>
</head>
<body>
<main class="page">
  <div class="shell">
    <section class="hero">
      <div class="topbar">
        <div class="brand">
          <div class="logo">
            <?php if ($logo !== ''): ?>
              <img src="<?=qpv2_e($logo)?>" alt="<?=qpv2_e($name)?>">
            <?php else: ?>
              <div class="logo-fallback">CP</div>
            <?php endif; ?>
          </div>
          <div class="brand-copy">
            <strong><?=qpv2_e($name)?></strong>
            <span><?=qpv2_e($slogan)?></span>
          </div>
        </div>
        <span class="badge">Cotización vencida</span>
      </div>

      <div class="hero-grid">
        <div class="copy">
          <span class="eyebrow">Tu enlace ya no está activo</span>
          <h1>Tu cotización <span class="accent">ya no está vigente</span></h1>

          <p class="lead">
            <?=qpv2_e($message)?>
            Para ayudarte mejor, podemos prepararte una nueva propuesta con precios actualizados, tiempos de entrega y disponibilidad real al momento.
          </p>

          <div class="notice">
            <span class="dot"></span>
            <div>
              <strong>Extra plus para recuperar tu venta</strong>
              <span>
                Mientras solicitas tu nueva cotización, aquí mismo te mostramos productos y servicios que hoy puedes aprovechar para avanzar más rápido con tu proyecto.
              </span>
            </div>
          </div>

          <div class="quick">
            <?php if ($waUrl !== ''): ?>
              <a class="btn btn-primary" href="<?=qpv2_e($waUrl)?>" target="_blank" rel="noopener">Solicitar nueva cotización →</a>
            <?php endif; ?>
            <a class="btn btn-secondary" href="<?=qpv2_e($catalogUrl)?>">Ver productos y servicios</a>
            <a class="btn btn-tertiary" href="<?=qpv2_e($website)?>">Ir al sitio principal</a>
          </div>

          <div class="stats">
            <div class="stat">
              <strong>1,200+</strong>
              <span>Proyectos atendidos</span>
            </div>
            <div class="stat">
              <strong>100%</strong>
              <span>Atención personalizada</span>
            </div>
            <div class="stat">
              <strong>MX</strong>
              <span>Atención nacional</span>
            </div>
          </div>
        </div>

        <aside class="side">
          <div class="panel">
            <span class="ribbon">Aprovecha hoy</span>
            <h3>Productos y ofertas actuales</h3>
            <p>
              Si tu cotización perdió vigencia, puedes retomar tu compra con una propuesta nueva y también descubrir alternativas que quizá te convengan más hoy.
            </p>

            <div class="offer-stack">
              <?php foreach ($products as $item): ?>
                <article class="offer">
                  <span class="tag <?=qpv2_e($item['accent'])?>"><?=qpv2_e($item['tag'])?></span>
                  <h4><?=qpv2_e($item['title'])?></h4>
                  <p><?=qpv2_e($item['text'])?></p>
                  <a href="<?=qpv2_e($item['href'])?>"<?=str_starts_with((string)$item['href'], 'http') ? ' target="_blank" rel="noopener"' : ''?>>
                    <?=qpv2_e($item['cta'])?> <span aria-hidden="true">→</span>
                  </a>
                </article>
              <?php endforeach; ?>
            </div>
          </div>
        </aside>
      </div>

      <div class="bottom">
        <section class="contact-card">
          <h4>Contáctanos y reactivamos tu proyecto</h4>
          <div class="contact-list">
            <?php if ($phone !== ''): ?><div><strong>Teléfono:</strong> <?=qpv2_e($phone)?></div><?php endif; ?>
            <?php if ($email !== ''): ?><div><strong>Correo:</strong> <?=qpv2_e($email)?></div><?php endif; ?>
            <?php if ($address !== ''): ?><div><strong>Ubicación:</strong> <?=qpv2_e($address)?></div><?php endif; ?>
          </div>
          <div class="mini-actions">
            <?php if ($waUrl !== ''): ?>
              <a class="btn btn-primary" href="<?=qpv2_e($waUrl)?>" target="_blank" rel="noopener">WhatsApp</a>
            <?php endif; ?>
            <?php if ($phone !== ''): ?>
              <a class="btn btn-secondary" href="tel:<?=qpv2_e(preg_replace('/[^0-9+]/', '', $phone))?>">Llamar ahora</a>
            <?php endif; ?>
          </div>
        </section>

        <section class="flow">
          <h4>¿Qué sigue?</h4>
          <div class="steps">
            <div class="step">
              <span class="n">1</span>
              <div>
                <strong>Solicita una nueva cotización</strong>
                <span>Te respondemos con precio actualizado, tiempos y materiales disponibles.</span>
              </div>
            </div>
            <div class="step">
              <span class="n">2</span>
              <div>
                <strong>Confirma tu mejor opción</strong>
                <span>Podemos ajustar cantidades, acabados o alternativas que se adapten mejor a tu presupuesto.</span>
              </div>
            </div>
            <div class="step">
              <span class="n">3</span>
              <div>
                <strong>Continúa con tu pedido</strong>
                <span>Una vez aprobada la nueva propuesta, retomamos el proceso para producción o entrega.</span>
              </div>
            </div>
          </div>
        </section>
      </div>

      <div class="footer">
        <strong><?=qpv2_e($name)?></strong> · Imprimimos tus ideas y fabricamos tu marca.
      </div>
    </section>
  </div>
</main>
</body>
</html>
<?php
    exit;
}

$company = company_profile();
/*
 * Entrada desde seguimiento.php cuando una orden fue cancelada.
 * Se vuelve a validar el token y el estado en servidor.
 */
$orderTrackingToken = trim(
    (string)(
        $_GET['ot']
        ?? ''
    )
);

if (
    $orderTrackingToken !== ''
    && preg_match(
        '/^[a-f0-9]{64}$/i',
        $orderTrackingToken
    )
) {
    $cancelContext =
        cancelled_landing_v1_context_by_tracking_token(
            $orderTrackingToken
        );

    if (
        $cancelContext
        && !empty(
            $cancelContext['is_cancelled']
        )
    ) {
        qpv2_unavailable(
            $company,
            cancelled_landing_v1_title(
                $cancelContext
            ),
            cancelled_landing_v1_message(
                $cancelContext
            ),
            200
        );
    }
}
$token = trim((string)($_GET['t'] ?? ''));

if (!preg_match('/^[a-f0-9]{64}$/i', $token)) {
    qpv2_unavailable(
        $company,
        'No pudimos abrir esta cotización',
        'El enlace es inválido o ya fue reemplazado.'
    );
}

$st = db()->prepare(
    'SELECT quote_id
     FROM cp_quote_public_tokens
     WHERE token=? AND active=1
     LIMIT 1'
);
$st->execute([$token]);
$quoteId = (int)($st->fetchColumn() ?: 0);

if ($quoteId <= 0) {
    qpv2_unavailable(
        $company,
        'Esta cotización ya no está disponible',
        'La cotización que recibiste dejó de estar vigente o ya fue reemplazada por una versión más reciente.'
    );
}

$quote = quote_get($quoteId);

if (!$quote) {
    qpv2_unavailable(
        $company,
        'Esta cotización ya no está disponible',
        'La cotización fue cerrada o dejó de estar activa.'
    );
}

if (
    strtolower(
        trim(
            (string)(
                $quote['status']
                ?? ''
            )
        )
    ) === 'cancelled'
) {
    qpv2_unavailable(
        $company,
        'Esta cotización fue cancelada',
        'La propuesta anterior ya no se encuentra vigente. '
        . 'Puedes solicitar una nueva cotización con precio, disponibilidad '
        . 'y tiempos actualizados, o revisar nuestros productos y ofertas actuales.',
        200
    );
}

db()->prepare(
    'UPDATE cp_quote_public_tokens
     SET last_access_at=NOW()
     WHERE token=?'
)->execute([$token]);

$items = quote_items($quoteId);
$totals = quote_totals($quoteId);

$data = generate_quote_pdf(
    $quote,
    $items,
    $totals,
    $company
);

header('Content-Type: application/pdf');
header('Content-Length: ' . strlen($data));
header(
    'Content-Disposition: inline; filename="'
    . preg_replace('/[^A-Za-z0-9._-]+/', '_', (string)$quote['quote_number'])
    . '.pdf"'
);
header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');

echo $data;
