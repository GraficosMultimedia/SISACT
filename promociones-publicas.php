<?php
declare(strict_types=1);

require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/company.php';

$company = company_profile();
$pdo = db();

function cp_h(string $value): string {
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function cp_public_image(?string $value): string {
    $value = trim((string)$value);
    if ($value === '') return '';
    if (preg_match('#^https?://#i', $value)) return $value;
    return '/' . ltrim($value, '/');
}

function cp_money($value): string {
    return is_numeric($value) ? '$' . number_format((float)$value, 2, '.', ',') . ' MXN' : '';
}

function cp_date(?string $value): string {
    if (!$value || $value === '0000-00-00') return '';
    $ts = strtotime($value);
    return $ts ? date('d/m/Y', $ts) : '';
}

function cp_iso_end(?string $value): ?string {
    if (!$value || $value === '0000-00-00') return null;
    return $value . 'T23:59:59-06:00';
}

function cp_wa(string $phone, string $text): string {
    $raw = preg_replace('/\D+/', '', $phone);
    if ($raw !== '' && !str_starts_with($raw, '52')) $raw = '52' . $raw;
    return $raw ? 'https://wa.me/' . $raw . '?text=' . rawurlencode($text) : '#';
}

$phone = (string)($company['phone'] ?? '');
$email = (string)($company['email'] ?? 'ventas@colibriprint.com.mx');
$city = (string)($company['city'] ?? 'Hidalgo del Parral');
$state = (string)($company['state'] ?? 'Chihuahua');
$address = trim((string)($company['address'] ?? '') . ($company['neighborhood'] ?? '' ? ', ' . $company['neighborhood'] : ''));

$q = trim((string)($_GET['q'] ?? ''));

$rows = [];
try {
    $sql = "
        SELECT
            p.id, p.title, p.slug, p.label, p.description, p.promo_type,
            p.normal_price, p.promo_price, p.discount_percent,
            p.quantity_available, p.start_date, p.end_date,
            p.image_path, p.whatsapp_text,
            GROUP_CONCAT(DISTINCT pp.product_id ORDER BY pp.sort_order SEPARATOR ',') AS product_ids,
            GROUP_CONCAT(DISTINCT cp.name ORDER BY pp.sort_order SEPARATOR ' · ') AS product_names,
            MIN(cp.id) AS first_product_id,
            MIN(cp.name) AS first_product_name,
            MIN(cp.sku) AS first_product_sku
        FROM cp_promotions p
        LEFT JOIN cp_promotion_products pp ON pp.promotion_id = p.id
        LEFT JOIN cp_products cp ON cp.id = pp.product_id
        WHERE p.status = 'active'
          AND p.show_web = 1
          AND p.start_date <= CURDATE()
          AND (p.end_date IS NULL OR p.end_date >= CURDATE())
    ";
    $params = [];
    if ($q !== '') {
        $sql .= " AND (p.title LIKE ? OR p.description LIKE ? OR cp.name LIKE ?)";
        $like = '%' . $q . '%';
        $params = [$like, $like, $like];
    }
    $sql .= "
        GROUP BY p.id, p.title, p.slug, p.label, p.description, p.promo_type,
                 p.normal_price, p.promo_price, p.discount_percent,
                 p.quantity_available, p.start_date, p.end_date,
                 p.image_path, p.whatsapp_text
        ORDER BY p.start_date DESC, p.id DESC
        LIMIT 24
    ";
    $st = $pdo->prepare($sql);
    $st->execute($params);
    $rows = $st->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {
    $rows = [];
}

$brand = (string)($company['trade_name'] ?: $company['legal_name'] ?: 'Colibrí Print México');
$canonical = 'https://colibriprint.com.mx/promociones-publicas.php';
$waGeneric = cp_wa($phone, 'Hola Colibrí Print México, quiero conocer las promociones y ofertas vigentes.');

$seoTitle = 'Promociones y ofertas | Colibrí Print México';
$seoDescription = 'Consulta promociones, ofertas y campañas vigentes de Colibrí Print México en Hidalgo del Parral, Chihuahua. Personalización, impresión, grabado, artículos promocionales y más.';
$ogImage = '';
foreach ($rows as $r) {
    $candidate = cp_public_image($r['image_path'] ?? '');
    if ($candidate !== '') {
        $ogImage = 'https://colibriprint.com.mx' . $candidate;
        break;
    }
}

$graph = [
    '@context' => 'https://schema.org',
    '@graph' => [
        [
            '@type' => 'CollectionPage',
            '@id' => $canonical . '#webpage',
            'url' => $canonical,
            'name' => $seoTitle,
            'description' => $seoDescription,
            'inLanguage' => 'es-MX',
            'isPartOf' => ['@id' => 'https://colibriprint.com.mx/#website']
        ],
        [
            '@type' => 'BreadcrumbList',
            '@id' => $canonical . '#breadcrumb',
            'itemListElement' => [
                ['@type'=>'ListItem','position'=>1,'name'=>'Inicio','item'=>'https://colibriprint.com.mx/'],
                ['@type'=>'ListItem','position'=>2,'name'=>'Promociones','item'=>$canonical]
            ]
        ]
    ]
];

foreach ($rows as $r) {
    if (($r['first_product_id'] ?? null) && $r['promo_price'] !== null) {
        $offer = [
            '@type' => 'Offer',
            'url' => $canonical . '#promocion-' . (int)$r['id'],
            'price' => (float)$r['promo_price'],
            'priceCurrency' => 'MXN',
            'availability' => 'https://schema.org/InStock'
        ];
        if (!empty($r['end_date'])) $offer['priceValidUntil'] = (string)$r['end_date'];
        $productNode = [
            '@type' => 'Product',
            '@id' => $canonical . '#product-' . (int)$r['id'],
            'name' => (string)($r['first_product_name'] ?: $r['title']),
            'brand' => ['@type'=>'Brand','name'=>$brand],
            'offers' => $offer
        ];
        if (!empty($r['first_product_sku'])) $productNode['sku'] = (string)$r['first_product_sku'];
        if (!empty($r['image_path'])) $productNode['image'] = [cp_public_image((string)$r['image_path'])];
        $graph['@graph'][] = $productNode;
    }
}

?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><?= cp_h($seoTitle) ?></title>
<meta name="description" content="<?= cp_h($seoDescription) ?>">
<meta name="theme-color" content="#080b0f">
<meta name="robots" content="index,follow,max-image-preview:large">
<link rel="canonical" href="<?= cp_h($canonical) ?>">
<meta property="og:type" content="website">
<meta property="og:locale" content="es_MX">
<meta property="og:title" content="<?= cp_h($seoTitle) ?>">
<meta property="og:description" content="<?= cp_h($seoDescription) ?>">
<meta property="og:url" content="<?= cp_h($canonical) ?>">
<?php if ($ogImage): ?><meta property="og:image" content="<?= cp_h($ogImage) ?>"><?php endif; ?>
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="<?= cp_h($seoTitle) ?>">
<meta name="twitter:description" content="<?= cp_h($seoDescription) ?>">
<?php if ($ogImage): ?><meta name="twitter:image" content="<?= cp_h($ogImage) ?>"><?php endif; ?>
<link rel="stylesheet" href="/assets/css/promociones-publicas-v2.css?v=20260919-2">
<script type="application/ld+json"><?= json_encode($graph, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE) ?></script>

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<a class="skip" href="#contenido">Saltar al contenido</a>

<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('promociones'); ?>

<main id="contenido">
<section class="promo-hero">
  <div class="promo-hero-grid"></div>
  <div class="promo-hero-glow red"></div>
  <div class="promo-hero-glow yellow"></div>
  <div class="cp-shell promo-hero-inner">
    <div class="promo-copy">
      <p class="eyebrow">PROMOCIONES · OFERTAS VIGENTES</p>
      <h1>Ofertas que sí puedes <em>aprovechar.</em></h1>
      <p>Encuentra campañas vigentes de Colibrí Print México en Hidalgo del Parral. Cada promoción se publica desde nuestro sistema con imagen, precio y fecha de vigencia reales.</p>
      <div class="promo-hero-actions">
        <a class="btn red" href="#ofertas">Ver ofertas <span>↓</span></a>
        <a class="btn outline" href="<?= cp_h($waGeneric) ?>" target="_blank" rel="noopener">Preguntar por WhatsApp ↗</a>
      </div>
      <div class="promo-trust">
        <span><b>✓</b> Precios publicados</span>
        <span><b>✓</b> Vigencia visible</span>
        <span><b>✓</b> Atención directa</span>
      </div>
    </div>
    <div class="promo-feature">
      <div class="feature-burst">OFERTA<br><strong>ACTIVA</strong></div>
      <div class="feature-label">COLIBRÍ PRINT MÉXICO</div>
      <strong class="feature-title"><?= count($rows) ? cp_h((string)$rows[0]['title']) : 'Promociones para tu proyecto' ?></strong>
      <p><?= count($rows) ? 'Consulta disponibilidad y condiciones de esta campaña.' : 'Cuando activemos una campaña, aparecerá aquí automáticamente.' ?></p>
      <?php if (count($rows)): ?>
        <div class="feature-price">
          <?php if ($rows[0]['normal_price'] !== null): ?><del><?= cp_h(cp_money($rows[0]['normal_price'])) ?></del><?php endif; ?>
          <?php if ($rows[0]['promo_price'] !== null): ?><strong><?= cp_h(cp_money($rows[0]['promo_price'])) ?></strong><?php endif; ?>
        </div>
      <?php endif; ?>
    </div>
  </div>
</section>

<section class="promo-toolbar-section" id="ofertas">
  <div class="cp-shell">
    <div class="section-heading">
      <div>
        <p class="eyebrow">CAMPAÑAS ACTUALES</p>
        <h2>Promociones y ofertas en <span>Colibrí Print México.</span></h2>
        <p>Revisa precios, vigencia y productos relacionados. Las ofertas se actualizan desde administración.</p>
      </div>
      <div class="search-box">
        <form method="get">
          <label for="promo-search">Buscar promoción</label>
          <div>
            <input id="promo-search" name="q" type="search" value="<?= cp_h($q) ?>" placeholder="Playeras, tazas, grabado...">
            <button type="submit">Buscar</button>
          </div>
        </form>
      </div>
    </div>

    <?php if ($rows): ?>
    <div class="promo-grid">
      <?php foreach ($rows as $r):
        $img = cp_public_image($r['image_path'] ?? '');
        $waText = trim((string)($r['whatsapp_text'] ?? ''));
        if ($waText === '') {
            $waText = 'Hola Colibrí Print México, quiero información sobre la promoción: ' . (string)$r['title'] . '. ¿Sigue disponible?';
        }
        $wa = cp_wa($phone, $waText);
        $productLink = !empty($r['first_product_id']) ? '/producto.php?id=' . (int)$r['first_product_id'] : '#ofertas';
      ?>
      <article class="promo-card" id="promocion-<?= (int)$r['id'] ?>">
        <div class="promo-card-media">
          <?php if ($img): ?><img src="<?= cp_h($img) ?>" alt="<?= cp_h((string)$r['title']) ?>" loading="lazy">
          <?php else: ?><div class="promo-no-image"><span>%</span><small>Promoción Colibrí Print</small></div><?php endif; ?>
          <span class="promo-pill"><?= cp_h((string)($r['label'] ?: 'OFERTA')) ?></span>
          <?php if ($r['discount_percent'] !== null): ?><span class="discount-pill">-<?= cp_h(rtrim(rtrim(number_format((float)$r['discount_percent'], 2, '.', ''), '0'), '.')) ?>%</span><?php endif; ?>
        </div>
        <div class="promo-card-body">
          <div class="promo-card-meta">
            <span>OFERTA VIGENTE</span>
            <?php if (!empty($r['end_date'])): ?><span>Hasta <?= cp_h(cp_date($r['end_date'])) ?></span><?php endif; ?>
          </div>
          <h3><?= cp_h((string)$r['title']) ?></h3>
          <?php if (!empty($r['product_names'])): ?><p class="promo-products"><strong>Incluye:</strong> <?= cp_h((string)$r['product_names']) ?></p><?php endif; ?>
          <?php if (!empty($r['description'])): ?><p><?= nl2br(cp_h((string)$r['description'])) ?></p><?php endif; ?>
          <div class="promo-price-row">
            <?php if ($r['normal_price'] !== null): ?><del><?= cp_h(cp_money($r['normal_price'])) ?></del><?php endif; ?>
            <?php if ($r['promo_price'] !== null): ?><strong><?= cp_h(cp_money($r['promo_price'])) ?></strong><?php else: ?><strong>Consultar</strong><?php endif; ?>
          </div>
          <?php if ($r['quantity_available'] !== null): ?>
            <div class="promo-availability"><?= (int)$r['quantity_available'] > 0 ? '✓ Disponibilidad limitada: ' . (int)$r['quantity_available'] . ' piezas' : 'Agotado' ?></div>
          <?php endif; ?>
          <div class="promo-actions">
            <?php if ($r['first_product_id']): ?><a class="btn-dark" href="<?= cp_h($productLink) ?>">Ver producto ↗</a><?php endif; ?>
            <a class="btn-red" href="<?= cp_h($wa) ?>" target="_blank" rel="noopener">Quiero esta oferta ↗</a>
          </div>
        </div>
      </article>
      <?php endforeach; ?>
    </div>
    <?php else: ?>
      <div class="empty-offers">
        <div class="empty-icon">%</div>
        <div>
          <p class="eyebrow">SIN OFERTAS ACTIVAS</p>
          <h3><?= $q !== '' ? 'No encontramos una promoción con esa búsqueda.' : 'Ahora mismo no hay una promoción publicada.' ?></h3>
          <p>La página permanece activa y lista para indexar nuevas campañas. Para un trabajo personalizado, podemos prepararte una cotización según materiales, medidas, cantidad y alcance.</p>
        </div>
        <a class="btn-red" href="<?= cp_h($waGeneric) ?>" target="_blank" rel="noopener">Cotizar por WhatsApp ↗</a>
      </div>
    <?php endif; ?>
  </div>
</section>

<section class="seo-copy">
  <div class="cp-shell seo-copy-grid">
    <div>
      <p class="eyebrow">PROMOCIONES EN PARRAL</p>
      <h2>Ofertas de impresión, personalización y soluciones gráficas.</h2>
      <p>Colibrí Print México publica aquí las campañas comerciales que están vigentes. Puedes encontrar promociones relacionadas con playeras personalizadas, tazas, productos promocionales, grabado láser, impresión y otras soluciones gráficas.</p>
      <p>Estamos en Hidalgo del Parral, Chihuahua, y atendemos proyectos para negocios, empresas, eventos y clientes que necesitan personalización o producción gráfica.</p>
    </div>
    <div class="seo-links">
      <a href="/catalogo.php"><span>01</span><strong>Explorar catálogo</strong><small>Productos publicados y personalizables.</small></a>
      <a href="/servicios.php"><span>02</span><strong>Ver servicios</strong><small>Diseño, impresión, grabado, CNC y más.</small></a>
      <a href="/corporativo.php"><span>03</span><strong>Conocer Colibrí Print</strong><small>Información corporativa y especialidades.</small></a>
    </div>
  </div>
</section>

<section class="promo-contact">
  <div class="cp-shell promo-contact-inner">
    <div>
      <p class="eyebrow">¿NO VES LO QUE NECESITAS?</p>
      <h2>Tu proyecto también puede tener una propuesta a medida.</h2>
      <p>Cuéntanos qué necesitas y te orientamos sobre materiales, cantidades, tiempos y proceso.</p>
    </div>
    <a class="btn-red large" href="<?= cp_h($waGeneric) ?>" target="_blank" rel="noopener">Hablar con Colibrí Print ↗</a>
  </div>
</section>
</main>

<footer class="cp-footer">
  <div class="cp-shell footer-grid">
    <div>
      <strong>Colibrí <em>Print</em></strong>
      <p><?= cp_h($address) ?> · <?= cp_h($city) ?>, <?= cp_h($state) ?></p>
    </div>
    <div class="footer-links">
      <a href="/">Inicio</a>
      <a href="/servicios.php">Servicios</a>
      <a href="/catalogo.php">Catálogo</a>
      <a href="/corporativo.php">Corporativo</a>
      <a href="/contacto.php">Contacto</a>
    </div>
    <div>
      <a href="https://www.facebook.com/ColibriPrintMexico" target="_blank" rel="noopener">Facebook</a>
      <a href="https://www.instagram.com/colibriprintmexico/" target="_blank" rel="noopener">Instagram</a>
      <a href="https://www.tiktok.com/@colibriprintmexico" target="_blank" rel="noopener">TikTok</a>
    </div>
  </div>
  <div class="cp-shell footer-bottom">© <?= date('Y') ?> Colibrí Print México · Promociones vigentes.</div>
</footer>

<script src="/assets/js/promociones-publicas-v2.js?v=20260919-2"></script>
</body>
</html>
