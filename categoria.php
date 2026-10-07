<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/public_catalog.php';

$company = company_profile();
$pdo = db();

$categoryId = max(0, (int)($_GET['id'] ?? $_GET['categoria'] ?? 0));
if ($categoryId <= 0) {
    http_response_code(404);
    exit('Categoría no encontrada.');
}

$categories = cp_catalog_get_categories($pdo);
$category = null;
foreach ($categories as $row) {
    if ((int)$row['id'] === $categoryId) {
        $category = $row;
        break;
    }
}

if (!$category) {
    http_response_code(404);
    exit('Categoría no encontrada.');
}

$filters = cp_catalog_normalize_request([
    'categoria' => $categoryId,
    'q' => $_GET['q'] ?? '',
    'page' => $_GET['page'] ?? 1,
    'per_page' => $_GET['per_page'] ?? 12,
    'orden' => $_GET['orden'] ?? 'featured',
]);

$catalog = cp_catalog_get_products($pdo, $filters);
$products = $catalog['items'];
$pagination = $catalog['pagination'];

$brand = trim((string)($company['trade_name'] ?? '')) ?: trim((string)($company['legal_name'] ?? 'Colibrí Print México'));
$phone = trim((string)($company['phone'] ?? ''));
$phoneDigits = preg_replace('/\D+/', '', $phone);
if ($phoneDigits !== '' && !str_starts_with($phoneDigits, '52')) $phoneDigits = '52' . $phoneDigits;
$waText = 'Hola Colibrí Print México, quiero información sobre la categoría: ' . $category['name'] . '.';
$wa = $phoneDigits !== '' ? 'https://wa.me/' . $phoneDigits . '?text=' . rawurlencode($waText) : '#';
$logo = cp_catalog_image_url($company['logo_path'] ?? '');
$categoryImage = cp_catalog_image_url((string)($category['image_path'] ?? ''));

function hcat(string $value): string {
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function category_query_url(array $changes = []): string {
    global $filters, $categoryId;
    $query = [
        'categoria' => $categoryId,
        'q' => $filters['q'],
        'page' => $filters['page'],
        'per_page' => $filters['per_page'],
        'orden' => $filters['orden'],
    ];
    foreach ($changes as $key => $value) {
        if ($value === null || $value === '') unset($query[$key]);
        else $query[$key] = $value;
    }
    if ((int)($query['page'] ?? 1) === 1) unset($query['page']);
    return cp_public_route('/categoria.php', $query);
}

$categoryTitle = trim((string)$category['name']);
$metaDescription = 'Explora ' . $categoryTitle . ' en el catálogo de Colibrí Print México. Productos personalizables para negocios, eventos y proyectos.';
$canonical = cp_public_absolute('/categoria.php') . '?id=' . $categoryId;
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description" content="<?= hcat($metaDescription) ?>">
<meta name="theme-color" content="#080a0d">
<link rel="canonical" href="<?= hcat($canonical) ?>">
<meta property="og:title" content="<?= hcat($categoryTitle) ?> | <?= hcat($brand) ?>">
<meta property="og:description" content="<?= hcat($metaDescription) ?>">
<meta property="og:type" content="website">
<meta property="og:url" content="<?= hcat($canonical) ?>">
<?php if ($categoryImage): ?><meta property="og:image" content="<?= hcat(cp_public_absolute($categoryImage)) ?>"><?php endif; ?>
<title><?= hcat($categoryTitle) ?> | <?= hcat($brand) ?></title>
<link rel="stylesheet" href="<?= hcat(cp_public_asset('assets/css/colibri-design-system.css')) ?>">
<link rel="stylesheet" href="<?= hcat(cp_public_asset('assets/css/public-shell.css')) ?>">
<link rel="stylesheet" href="<?= hcat(cp_public_asset('assets/css/categoria-v3.css')) ?>">

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<a class="skip-link" href="#categoria-contenido">Saltar al contenido</a>

<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('catalogo'); ?>

<main id="categoria-contenido">
  <section class="cat-page-hero">
    <div class="cat-page-container cat-page-hero-grid">
      <div>
        <div class="cat-page-breadcrumb"><a href="<?= hcat(cp_public_route('/catalogo.php')) ?>">Catálogo</a><span>›</span><strong><?= hcat($categoryTitle) ?></strong></div>
        <p class="cp-kicker">CATEGORÍA · COLIBRÍ PRINT</p>
        <h1><?= hcat($categoryTitle) ?><em> para llevar tu marca.</em></h1>
        <p class="cat-page-lead">Explora productos de esta categoría y encuentra una base para tu proyecto. Cuando necesites medidas, cantidades o personalización especial, podemos convertirlo en una cotización.</p>
        <div class="cat-page-stats">
          <span><b><?= (int)$category['product_count'] ?></b> publicados</span>
          <span><b>✦</b> personalizables</span>
          <span><b>↗</b> atención directa</span>
        </div>
      </div>
      <div class="cat-page-visual">
        <div class="cat-page-orbit cat-page-orbit-red">IDEAS</div>
        <div class="cat-page-orbit cat-page-orbit-mango">MARCA</div>
        <div class="cat-page-orbit cat-page-orbit-blue">PRINT</div>
        <div class="cat-page-category-core">
          <?php if ($categoryImage): ?><img src="<?= hcat($categoryImage) ?>" alt="" fetchpriority="high"><?php else: ?><span><?= hcat(mb_strtoupper(mb_substr($categoryTitle,0,1))) ?></span><?php endif; ?>
        </div>
      </div>
    </div>
  </section>

  <section class="cat-page-products">
    <div class="cat-page-container">
      <div class="cat-page-toolbar">
        <div>
          <p class="cp-kicker">PRODUCTOS DE <?= hcat($categoryTitle) ?></p>
          <h2><?= number_format((int)$pagination['total']) ?> opciones publicadas.</h2>
        </div>
        <a class="cat-page-back" href="<?= hcat(cp_public_route('/catalogo.php')) ?>">← Todo el catálogo</a>
      </div>

      <form class="cat-page-filter" method="get" action="<?= hcat(cp_public_route('/categoria.php')) ?>">
        <input type="hidden" name="id" value="<?= $categoryId ?>">
        <label>Buscar
          <input type="search" name="q" value="<?= hcat($filters['q']) ?>" placeholder="Buscar dentro de esta categoría">
        </label>
        <label>Ordenar
          <select name="orden">
            <option value="featured" <?= $filters['orden']==='featured'?'selected':'' ?>>Destacados</option>
            <option value="newest" <?= $filters['orden']==='newest'?'selected':'' ?>>Más recientes</option>
            <option value="name_asc" <?= $filters['orden']==='name_asc'?'selected':'' ?>>Nombre A–Z</option>
            <option value="price_asc" <?= $filters['orden']==='price_asc'?'selected':'' ?>>Precio menor</option>
            <option value="price_desc" <?= $filters['orden']==='price_desc'?'selected':'' ?>>Precio mayor</option>
          </select>
        </label>
        <button type="submit">Aplicar <span>→</span></button>
      </form>

      <?php if ($products): ?>
      <div class="cat-page-product-grid">
        <?php foreach ($products as $product): ?>
          <article class="cat-page-product" data-cp-tilt>
            <a class="cat-page-product-media" href="<?= hcat((string)$product['url']) ?>">
              <?php if (!empty($product['image_url'])): ?><img src="<?= hcat((string)$product['image_url']) ?>" alt="<?= hcat((string)$product['name']) ?>" loading="lazy"><?php else: ?><span>CP</span><?php endif; ?>
              <b><?= hcat((string)$product['pricing_label']) ?></b>
              <i>↗</i>
            </a>
            <div class="cat-page-product-body">
              <small><?= hcat((string)$product['category_name']) ?></small>
              <h3><a href="<?= hcat((string)$product['url']) ?>"><?= hcat((string)$product['name']) ?></a></h3>
              <?php if (!empty($product['description'])): ?><p><?= hcat((string)$product['description']) ?></p><?php endif; ?>
              <div>
                <strong><?= hcat($product['sale_price'] !== null ? cp_catalog_money($product['sale_price']) : 'Cotizar') ?></strong>
                <a href="<?= hcat((string)$product['url']) ?>">Ver detalle →</a>
              </div>
            </div>
          </article>
        <?php endforeach; ?>
      </div>
      <?php else: ?>
        <div class="cat-page-empty">
          <strong>Sin resultados aquí.</strong>
          <p>Prueba otra búsqueda dentro de <?= hcat($categoryTitle) ?>.</p>
          <a href="<?= hcat(cp_public_route('/categoria.php', ['id'=>$categoryId])) ?>">Ver todos</a>
        </div>
      <?php endif; ?>

      <?php if ($pagination['pages'] > 1): ?>
      <nav class="cat-page-pagination" aria-label="Paginación">
        <?php if ($pagination['has_previous']): ?><a href="<?= hcat(category_query_url(['page'=>$pagination['page']-1])) ?>">← Anterior</a><?php else: ?><span>← Anterior</span><?php endif; ?>
        <div>
          <?php
          $start = max(1, $pagination['page'] - 2);
          $end = min($pagination['pages'], $pagination['page'] + 2);
          for ($p=$start;$p<=$end;$p++):
          ?>
          <?= $p === $pagination['page'] ? '<b>'.$p.'</b>' : '<a href="'.hcat(category_query_url(['page'=>$p])).'">'.$p.'</a>' ?>
          <?php endfor; ?>
        </div>
        <?php if ($pagination['has_next']): ?><a href="<?= hcat(category_query_url(['page'=>$pagination['page']+1])) ?>">Siguiente →</a><?php else: ?><span>Siguiente →</span><?php endif; ?>
      </nav>
      <?php endif; ?>
    </div>
  </section>

  <section class="cat-page-cta-section">
    <div class="cat-page-container cat-page-cta-box">
      <div>
        <p class="cp-kicker">¿YA TIENES UNA IDEA?</p>
        <h2>La hacemos realidad.</h2>
        <p>Cuéntanos cantidad, uso y fecha. Nosotros te ayudamos a definir la solución.</p>
      </div>
      <?php if ($phone): ?><a href="<?= hcat($wa) ?>" target="_blank" rel="noopener">Cotizar por WhatsApp ↗</a><?php endif; ?>
    </div>
  </section>
</main>

<footer class="cat-page-footer">
  <div class="cat-page-container">
    <strong>Colibrí <i>Print</i></strong>
    <span>© <?= date('Y') ?> · Catálogo propio</span>
  </div>
</footer>

<script src="<?= hcat(cp_public_asset('assets/js/public-shell.js')) ?>?v=20260919-8" defer></script>
</body>
</html>
