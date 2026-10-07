<?php
declare(strict_types=1);
require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/company.php';

$company = company_profile();
$pdo = db();

function h(string $value): string { return htmlspecialchars($value, ENT_QUOTES, 'UTF-8'); }

function cp_base_path(): string {
    static $base = null;
    if ($base !== null) return $base;
    $documentRoot = isset($_SERVER['DOCUMENT_ROOT']) ? realpath((string)$_SERVER['DOCUMENT_ROOT']) : false;
    $projectRoot = realpath(__DIR__);
    if ($documentRoot && $projectRoot) {
        $doc = rtrim(str_replace('\\','/',$documentRoot), '/');
        $root = str_replace('\\','/',$projectRoot);
        if ($root === $doc) return $base = '';
        $prefix = $doc . '/';
        if (str_starts_with($root, $prefix)) {
            $relative = trim(substr($root, strlen($prefix)), '/');
            return $base = $relative !== '' ? '/' . $relative : '';
        }
    }
    $script = str_replace('\\','/',(string)($_SERVER['SCRIPT_NAME'] ?? '/catalogo.php'));
    $candidate = trim(dirname($script), '/.');
    return $base = $candidate !== '' ? '/' . $candidate : '';
}

function cp_url(string $path = '', array $query = []): string {
    $path = trim($path);
    if ($path !== '' && preg_match('#^(?:https?:)?//#i', $path)) $url = $path;
    else $url = rtrim(cp_base_path(), '/') . '/' . ltrim($path, '/');
    if ($url === '') $url = '/';
    $query = array_filter($query, static fn($v) => $v !== null && $v !== '');
    return $query ? $url . '?' . http_build_query($query, '', '&', PHP_QUERY_RFC3986) : $url;
}

function cp_origin(): string {
    $https = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') || ((int)($_SERVER['SERVER_PORT'] ?? 0) === 443) || strtolower((string)($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '')) === 'https';
    return ($https ? 'https' : 'http') . '://' . ($_SERVER['HTTP_HOST'] ?? 'localhost');
}

function cp_absolute(string $path = ''): string { return cp_origin() . cp_url($path); }

function public_asset(?string $value): string {
    $value = trim((string)$value);
    if ($value === '') return '';
    if (preg_match('#^(?:https?:)?//#i', $value)) return $value;
    return cp_url($value);
}

function money_public($value): string {
    return is_numeric($value) ? '$' . number_format((float)$value, 2, '.', ',') . ' MXN' : '';
}

function pricing_label(string $type): string {
    return [
        'fixed' => 'Precio publicado',
        'variable' => 'Cotización',
        'calculated' => 'Precio calculado',
        'project' => 'Proyecto cotizable'
    ][$type] ?? 'Cotización';
}

function quote_url(string $base, string $name): string {
    if ($base === '') return '#';
    return $base . '?text=' . rawurlencode(
        'Hola Colibrí Print México, quiero cotizar el producto: ' . $name . '. Me gustaría conocer opciones, medidas, materiales, cantidades, tiempos y precio.'
    );
}

$categoryId = (int)($_GET['categoria'] ?? 0);
$q = trim((string)($_GET['q'] ?? ''));

$categories = $pdo->query("SELECT id,name FROM cp_categories WHERE type='product' AND enabled=1 ORDER BY sort_order,name")->fetchAll(PDO::FETCH_ASSOC);

$sql = "
    SELECT p.id,p.name,p.sku,p.description,p.sale_price,p.pricing_type,
           c.name AS category_name,
           (SELECT i.path FROM cp_product_images i WHERE i.product_id=p.id AND i.enabled=1 ORDER BY i.sort_order,i.id LIMIT 1) AS image_path
    FROM cp_products p
    LEFT JOIN cp_categories c ON c.id=p.category_id
    WHERE p.enabled=1 AND p.visible_web=1
";
$params = [];
if ($categoryId > 0) {
    $sql .= " AND p.category_id=?";
    $params[] = $categoryId;
}
if ($q !== '') {
    $sql .= " AND (p.name LIKE ? OR p.sku LIKE ? OR p.description LIKE ?)";
    $like = '%' . $q . '%';
    array_push($params, $like, $like, $like);
}
$sql .= " ORDER BY c.sort_order,c.name,p.id DESC LIMIT 100";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);
$products = $stmt->fetchAll(PDO::FETCH_ASSOC);

$phone = (string)($company['phone'] ?? '');
$phoneRaw = preg_replace('/\D+/', '', $phone);
if ($phoneRaw !== '' && !str_starts_with($phoneRaw, '52')) $phoneRaw = '52' . $phoneRaw;
$waBase = $phoneRaw !== '' ? 'https://wa.me/' . $phoneRaw : '';
$wa = quote_url($waBase, 'un proyecto personalizado');
$brand = trim((string)($company['trade_name'] ?? '')) ?: 'Colibrí Print';
$location = trim((string)($company['city'] ?? 'Hidalgo del Parral')) . ', ' . trim((string)($company['state'] ?? 'Chihuahua'));
$noindex = cp_base_path() !== '';
$robots = $noindex ? 'noindex,nofollow,noarchive' : 'index,follow';

$activePromotions = [];
try {
    $activePromotions = $pdo->query("SELECT id,title,label,description,normal_price,promo_price,end_date,image_path FROM cp_promotions WHERE show_web=1 AND status <> 'draft' AND start_date <= CURDATE() AND (end_date IS NULL OR end_date >= CURDATE()) ORDER BY id DESC LIMIT 3")->fetchAll(PDO::FETCH_ASSOC);
} catch (Throwable $e) {
    $activePromotions = [];
}

$metaDescription = 'Catálogo de Colibrí Print México: productos personalizados, impresión, textiles, promocionales y soluciones gráficas.';
$canonical = cp_absolute('catalogo.php');
$markImage = cp_url('assets/img/home/colibri-mark-v1.png');
$catalogArt = cp_url('assets/img/home/category-collage-v1.png');
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description" content="<?= h($metaDescription) ?>">
<meta name="robots" content="<?= h($robots) ?>">
<meta name="theme-color" content="#08090d">
<link rel="canonical" href="<?= h($canonical) ?>">
<meta property="og:title" content="Catálogo | Colibrí Print México">
<meta property="og:description" content="<?= h($metaDescription) ?>">
<meta property="og:type" content="website">
<meta property="og:url" content="<?= h($canonical) ?>">
<meta property="og:image" content="<?= h(cp_absolute('assets/img/home/category-collage-v1.png')) ?>">
<title>Catálogo | <?= h($brand) ?></title>
<link rel="stylesheet" href="<?= h(cp_url('assets/css/catalogo-v5.css')) ?>?v=20260919-2">
<script defer src="<?= h(cp_url('assets/js/catalogo-v5.js')) ?>?v=20260919-1"></script>

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<a class="skip-link" href="#contenido">Saltar al catálogo</a>

<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('catalogo'); ?>

<main id="contenido">
<section class="catalog-hero">
  <div class="hero-overlay"></div>
  <div class="shell catalog-hero-grid">
    <div class="catalog-copy">
      <span class="eyebrow">CATÁLOGO · COLIBRÍ PRINT MÉXICO</span>
      <h1>PRODUCTOS QUE <span>HACEN</span><br>REAL TU IDEA.</h1>
      <p>Explora productos personalizables, compara categorías y entra al producto para solicitar una cotización. Cuando el precio depende del proyecto, aquí no inventamos números: lo cotizamos contigo.</p>
      <div class="hero-actions">
        <a class="btn btn-primary" href="#productos">Ver productos <span>↓</span></a>
        <?php if($waBase): ?><a class="btn btn-outline" href="<?= h($wa) ?>" target="_blank" rel="noopener">WhatsApp <span>↗</span></a><?php endif; ?>
      </div>
      <div class="hero-points"><span>✦ Calidad</span><span>✦ Personalización</span><span>✦ Producción</span><span>✦ Entrega</span></div>
    </div>
    <div class="catalog-art">
      <div class="art-frame"><img src="<?= h($catalogArt) ?>" alt="Ejemplos de soluciones de impresión y personalización de Colibrí Print"></div>
      <div class="art-badge">DESDE LA IDEA<br><strong>HASTA EL RESULTADO</strong></div>
    </div>
  </div>
</section>

<section class="catalog-tools" id="productos">
  <div class="shell">
    <div class="section-head">
      <div><span class="eyebrow">EXPLORA</span><h2>Catálogo <span>propio.</span></h2><p><?= count($products) ?> <?= count($products)===1?'producto disponible':'productos disponibles' ?> en la web.</p></div>
      <?php if($q!=='' || $categoryId>0): ?><a class="clear-link" href="<?= h(cp_url('catalogo.php')) ?>">Limpiar filtros ×</a><?php endif; ?>
    </div>

    <form class="search-box" method="get" role="search">
      <?php if ($categoryId > 0): ?><input type="hidden" name="categoria" value="<?= (int)$categoryId ?>"><?php endif; ?>
      <span>⌕</span>
      <input type="search" name="q" value="<?= h($q) ?>" placeholder="Busca tazas, playeras, llaveros, textiles..." aria-label="Buscar productos">
      <button type="submit">Buscar</button>
    </form>

    <div class="category-chips" aria-label="Categorías del catálogo">
      <a class="chip <?= $categoryId===0?'selected':'' ?>" href="<?= h(cp_url('catalogo.php', $q!==''?['q'=>$q]:[])) ?>">Todas <b><?= count($products) ?></b></a>
      <?php foreach($categories as $category): ?>
        <?php
          $href = cp_url('catalogo.php', array_filter(['categoria'=>(int)$category['id'],'q'=>$q], static fn($v)=>$v!==''));
        ?>
        <a class="chip <?= $categoryId===(int)$category['id']?'selected':'' ?>" href="<?= h($href) ?>"><?= h($category['name']) ?></a>
      <?php endforeach; ?>
    </div>
  </div>
</section>

<section class="products-section">
  <div class="shell">
    <?php if(!$products): ?>
      <div class="empty-state"><strong>No encontramos productos con esos filtros.</strong><p>Prueba otra categoría o escribe directamente para pedir una cotización.</p><?php if($waBase): ?><a class="btn btn-primary" href="<?= h($wa) ?>" target="_blank" rel="noopener">Hablar por WhatsApp ↗</a><?php endif; ?></div>
    <?php else: ?>
      <div class="product-grid">
      <?php foreach($products as $product):
        $image = public_asset($product['image_path'] ?? '');
        $isFixed = $product['pricing_type'] === 'fixed' && $product['sale_price'] !== null;
        $productUrl = cp_url('producto.php',['id'=>(int)$product['id']]);
      ?>
        <article class="product-card">
          <a class="product-media" href="<?= h($productUrl) ?>" aria-label="Ver <?= h($product['name']) ?>">
            <?php if($image): ?><img src="<?= h($image) ?>" alt="<?= h($product['name']) ?>" loading="lazy"><?php else: ?><div class="product-placeholder"><span>CP</span><small>Imagen próximamente</small></div><?php endif; ?>
            <span class="product-tag"><?= h($product['category_name'] ?: 'Colibrí Print') ?></span>
          </a>
          <div class="product-body">
            <div class="product-type"><?= h(pricing_label((string)$product['pricing_type'])) ?></div>
            <h3><?= h($product['name']) ?></h3>
            <?php if(!empty($product['description'])): ?><p><?= h((string)$product['description']) ?></p><?php else: ?><p>Personalización y opciones según el proyecto.</p><?php endif; ?>
            <div class="product-foot">
              <strong><?= $isFixed ? h(money_public($product['sale_price'])) : 'Cotización' ?></strong>
              <a href="<?= h($productUrl) ?>">Ver producto <span>→</span></a>
            </div>
          </div>
        </article>
      <?php endforeach; ?>
      </div>
    <?php endif; ?>
  </div>
</section>

<?php if($activePromotions): ?>
<section class="promo-strip">
  <div class="shell">
    <div class="section-head inverse"><div><span class="eyebrow">PROMOCIONES ACTIVAS</span><h2>También hay <span>ofertas.</span></h2></div><a href="<?= h(cp_url('promociones-publicas.php')) ?>">Ver promociones →</a></div>
    <div class="promo-grid">
      <?php foreach($activePromotions as $promo): ?>
        <article class="promo-card"><div class="promo-image"><?php if(!empty($promo['image_path'])): ?><img src="<?= h(public_asset($promo['image_path'])) ?>" alt="<?= h($promo['title']) ?>" loading="lazy"><?php endif; ?><span><?= h($promo['label'] ?: 'OFERTA') ?></span></div><div class="promo-body"><h3><?= h($promo['title']) ?></h3><?php if(!empty($promo['description'])): ?><p><?= h($promo['description']) ?></p><?php endif; ?><div><?php if($promo['promo_price']!==null): ?><strong><?= h(money_public($promo['promo_price'])) ?></strong><?php endif; ?><?php if($promo['normal_price']!==null): ?><del><?= h(money_public($promo['normal_price'])) ?></del><?php endif; ?></div></div></article>
      <?php endforeach; ?>
    </div>
  </div>
</section>
<?php endif; ?>

<section class="catalog-cta">
  <div class="shell cta-inner">
    <div><span class="eyebrow">¿NO ENCUENTRAS LO QUE BUSCAS?</span><h2>Lo fabricamos <span>para ti.</span></h2><p>Hay proyectos que no caben en una ficha de producto. Cuéntanos qué necesitas y armamos la cotización.</p></div>
    <?php if($waBase): ?><a class="btn btn-dark" href="<?= h($wa) ?>" target="_blank" rel="noopener">Quiero cotizar <span>→</span></a><?php endif; ?>
  </div>
</section>
</main>

<footer class="footer">
  <div class="shell footer-grid">
    <div><div class="footer-brand"><img src="<?= h($markImage) ?>" alt=""><span><strong>Colibrí <b>Print</b></strong><small>MÉXICO · SOLUCIONES GRÁFICAS</small></span></div><p><?= h((string)($company['address'] ?? 'C. Alemania 87')) ?>, <?= h($location) ?>.</p></div>
    <div><strong>Explora</strong><a href="<?= h(cp_url('')) ?>#inicio">Inicio</a><a href="<?= h(cp_url('')) ?>#servicios">Servicios</a><a href="<?= h(cp_url('catalogo.php')) ?>">Catálogo</a></div>
    <div><strong>Atención</strong><?php if($phone): ?><a href="tel:<?= h($phone) ?>"><?= h($phone) ?></a><?php endif; ?><?php if(!empty($company['email'])): ?><a href="mailto:<?= h((string)$company['email']) ?>"><?= h((string)$company['email']) ?></a><?php endif; ?><span>Atención en todo México</span></div>
    <div><strong>¿Listo para imprimir?</strong><?php if($waBase): ?><a class="footer-cta" href="<?= h($wa) ?>" target="_blank" rel="noopener">Cotizar por WhatsApp ↗</a><?php endif; ?></div>
  </div>
  <div class="shell footer-bottom"><span>© <?= date('Y') ?> Colibrí Print México</span><span>Catálogo propio · Productos y servicios personalizados</span></div>
</footer>

<?php if($waBase): ?><a class="float-wa" href="<?= h($wa) ?>" target="_blank" rel="noopener" aria-label="Cotizar por WhatsApp">◔</a><?php endif; ?>
</body>
</html>
