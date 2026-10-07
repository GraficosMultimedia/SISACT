<?php
declare(strict_types=1);

require_once __DIR__ . '/includes/public_catalog.php';
require_once __DIR__ . '/includes/public_product.php';
require_once __DIR__ . '/includes/public_product_options.php';

$company = company_profile();
$pdo = db();

$productId = max(0, (int)($_GET['id'] ?? 0));
$product = cp_public_product_get($pdo, $productId);
$optionGroups = $product ? cp_product_options_get($pdo, $productId) : [];

if (!$product) {
    http_response_code(404);
    exit('Producto no encontrado.');
}

$images = $product['images'] ?? [];
$mainImage = !empty($images) ? cp_catalog_image_url((string)($images[0]['path'] ?? '')) : '';
$related = cp_public_product_related($pdo, (int)$product['category_id'], (int)$product['id'], 4);

$brand = trim((string)($company['trade_name'] ?? '')) ?: trim((string)($company['legal_name'] ?? 'Colibrí Print México'));
$phone = trim((string)($company['phone'] ?? ''));
$phoneDigits = preg_replace('/\D+/', '', $phone);
if ($phoneDigits !== '' && !str_starts_with($phoneDigits, '52')) $phoneDigits = '52' . $phoneDigits;

$description = trim((string)($product['description'] ?? ''));
if ($description === '') $description = 'Producto de Colibrí Print México para personalización y proyectos gráficos.';

$pricingType = (string)$product['pricing_type'];
$isFixed = $pricingType === 'fixed' && $product['sale_price'] !== null;
$priceText = $isFixed ? cp_catalog_money($product['sale_price']) : 'Cotización personalizada';

$waText = 'Hola Colibrí Print México, quiero información sobre el producto: ' . $product['name'] . '.';
$waBase = $phoneDigits !== '' ? 'https://wa.me/' . $phoneDigits : '';
$waUrl = $waBase ? $waBase . '?text=' . rawurlencode($waText) : '#';

$canonical = cp_public_absolute('/producto.php') . '?id=' . (int)$product['id'];
$absoluteImage = $mainImage ? cp_public_absolute($mainImage) : '';

function hp(string $value): string {
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

$schema = [
    '@context' => 'https://schema.org',
    '@type' => 'Product',
    'name' => (string)$product['name'],
    'description' => $description,
    'url' => $canonical,
    'brand' => [
        '@type' => 'Brand',
        'name' => $brand,
    ],
];
if ($absoluteImage) $schema['image'] = [$absoluteImage];
if (!empty($product['sku'])) $schema['sku'] = (string)$product['sku'];
if ($isFixed) {
    $schema['offers'] = [
        '@type' => 'Offer',
        'url' => $canonical,
        'priceCurrency' => 'MXN',
        'price' => number_format((float)$product['sale_price'], 2, '.', ''),
        'availability' => 'https://schema.org/InStock',
    ];
}
?>
<!doctype html>
<html lang="es-MX">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<meta name="description" content="<?= hp((string)$description) ?>">
<meta name="theme-color" content="#080a0d">
<link rel="canonical" href="<?= hp($canonical) ?>">
<meta property="og:title" content="<?= hp((string)$product['name']) ?> | <?= hp($brand) ?>">
<meta property="og:description" content="<?= hp((string)$description) ?>">
<meta property="og:type" content="product">
<meta property="og:url" content="<?= hp($canonical) ?>">
<?php if ($absoluteImage): ?><meta property="og:image" content="<?= hp($absoluteImage) ?>"><?php endif; ?>
<title><?= hp((string)$product['name']) ?> | <?= hp($brand) ?></title>
<link rel="stylesheet" href="<?= hp(cp_public_asset('assets/css/colibri-design-system.css')) ?>">
<link rel="stylesheet" href="<?= hp(cp_public_asset('assets/css/public-shell.css')) ?>">
<link rel="stylesheet" href="<?= hp(cp_public_asset('assets/css/producto-v3.css')) ?>">
<?php if ($optionGroups): ?><link rel="stylesheet" href="<?= hp(cp_public_asset('assets/css/producto-opciones.css')) ?>"><?php endif; ?>
<script type="application/ld+json"><?= json_encode($schema, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES) ?></script>

<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head>
<body>
<a class="skip-link" href="#producto-contenido">Saltar al producto</a>

<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('catalogo'); ?>

<main id="producto-contenido">
  <section class="prod-main">
    <div class="prod-container">
      <div class="prod-breadcrumb"><a href="<?= hp(cp_public_route('/catalogo.php')) ?>">Catálogo</a><span>›</span><?php if (!empty($product['category_id'])): ?><a href="<?= hp(cp_public_route('/categoria.php', ['id'=>(int)$product['category_id']])) ?>"><?= hp((string)$product['category_name']) ?></a><span>›</span><?php endif; ?><strong><?= hp((string)$product['name']) ?></strong></div>

      <div class="prod-grid">
        <div class="prod-gallery" data-cp-product-gallery>
          <div class="prod-main-media">
            <?php if ($mainImage): ?>
              <img id="prod-main-image" src="<?= hp($mainImage) ?>" alt="<?= hp((string)$product['name']) ?>" fetchpriority="high">
            <?php else: ?>
              <span class="prod-placeholder">CP</span>
            <?php endif; ?>
          </div>
          <?php if (count($images) > 1): ?>
          <div class="prod-thumbs" role="list" aria-label="Galería del producto">
            <?php foreach ($images as $index => $img):
              $src = cp_catalog_image_url((string)($img['path'] ?? ''));
              if (!$src) continue;
            ?>
              <button class="prod-thumb <?= $index===0?'active':'' ?>" type="button" data-cp-product-thumb data-src="<?= hp($src) ?>" aria-label="Ver imagen <?= $index+1 ?>">
                <img src="<?= hp($src) ?>" alt="" loading="lazy">
              </button>
            <?php endforeach; ?>
          </div>
          <?php endif; ?>
        </div>

        <article class="prod-info">
          <?php if (!empty($product['category_name'])): ?><a class="prod-category" href="<?= hp(cp_public_route('/categoria.php', ['id'=>(int)$product['category_id']])) ?>"><?= hp((string)$product['category_name']) ?></a><?php endif; ?>
          <p class="cp-kicker">COLIBRÍ PRINT · PRODUCTO</p>
          <h1><?= hp((string)$product['name']) ?></h1>
          <p class="prod-description"><?= nl2br(hp($description)) ?></p>

          <div class="prod-facts">
            <div><small>Tipo</small><strong><?= hp(cp_catalog_pricing_label($pricingType)) ?></strong></div>
            <?php if (!empty($product['sku'])): ?><div><small>SKU</small><strong><?= hp((string)$product['sku']) ?></strong></div><?php endif; ?>
          </div>

          <div class="prod-price">
            <small>Precio</small>
            <strong><?= hp($priceText) ?></strong>
            <?php if (!$isFixed): ?><span>El precio puede depender de cantidades, materiales o personalización.</span><?php endif; ?>
          </div>


          <?php if ($optionGroups): ?>
          <section
            class="prod-options"
            data-cp-product-options
            data-base-price="<?= $isFixed ? number_format((float)$product['sale_price'], 2, '.', '') : '0' ?>"
            data-fixed="<?= $isFixed ? '1' : '0' ?>"
            data-product-name="<?= hp((string)$product['name']) ?>"
            data-wa-base="<?= hp($waBase) ?>"
            aria-labelledby="prod-opciones-title"
          >
            <h2 id="prod-opciones-title">Personaliza tu producto</h2>

            <?php foreach ($optionGroups as $group): ?>
              <div class="prod-option-group">
                <div class="prod-option-label">
                  <strong><?= hp((string)$group['name']) ?></strong>
                  <small><?= $group['required'] ? 'Obligatorio' : 'Opcional' ?></small>
                </div>

                <?php $inputType = (string)$group['input_type']; ?>

                <?php if ($inputType === 'select'): ?>
                  <div class="prod-option-control">
                    <select data-price-source <?= $group['required'] ? 'required' : '' ?> name="option_<?= (int)$group['id'] ?>">
                      <?php if (!$group['required']): ?><option value="">Selecciona una opción</option><?php endif; ?>
                      <?php foreach ($group['values'] as $value): ?>
                        <option
                          value="<?= (int)$value['id'] ?>"
                          data-label="<?= hp((string)$value['label']) ?>"
                          data-price-delta="<?= number_format((float)$value['price_delta'], 2, '.', '') ?>"
                        ><?= hp((string)$value['label']) ?><?= (float)$value['price_delta'] != 0.0 ? ' · '.hp(cp_catalog_money((float)$value['price_delta'])) : '' ?></option>
                      <?php endforeach; ?>
                    </select>
                  </div>
                <?php elseif ($inputType === 'radio'): ?>
                  <div class="prod-option-choices" data-required="<?= $group['required'] ? '1' : '0' ?>">
                    <?php foreach ($group['values'] as $value): ?>
                      <div class="prod-option-choice">
                        <input
                          id="prod-opt-<?= (int)$group['id'] ?>-<?= (int)$value['id'] ?>"
                          type="radio"
                          name="option_<?= (int)$group['id'] ?>"
                          value="<?= (int)$value['id'] ?>"
                          data-price-delta="<?= number_format((float)$value['price_delta'], 2, '.', '') ?>"
                          data-label="<?= hp((string)$value['label']) ?>"
                        >
                        <label for="prod-opt-<?= (int)$group['id'] ?>-<?= (int)$value['id'] ?>">
                          <span><?= hp((string)$value['label']) ?></span>
                          <?php if ((float)$value['price_delta'] != 0.0): ?><em><?= ((float)$value['price_delta'] > 0 ? '+' : '').hp(cp_catalog_money((float)$value['price_delta'])) ?></em><?php endif; ?>
                        </label>
                      </div>
                    <?php endforeach; ?>
                  </div>
                <?php elseif ($inputType === 'textarea'): ?>
                  <div class="prod-option-control">
                    <textarea data-cp-free-field data-label="<?= hp((string)$group['name']) ?>" name="option_<?= (int)$group['id'] ?>" placeholder="<?= hp((string)($group['placeholder'] ?? '')) ?>" <?= $group['required'] ? 'required' : '' ?>></textarea>
                  </div>
                <?php elseif ($inputType === 'number'): ?>
                  <div class="prod-option-control">
                    <input data-cp-free-field data-label="<?= hp((string)$group['name']) ?>" type="number" name="option_<?= (int)$group['id'] ?>" placeholder="<?= hp((string)($group['placeholder'] ?? '')) ?>" <?= $group['required'] ? 'required' : '' ?>>
                  </div>
                <?php elseif ($inputType === 'checkbox'): ?>
                  <div class="prod-option-control">
                    <label class="prod-option-check">
                      <input data-cp-free-field data-label="<?= hp((string)$group['name']) ?>" type="checkbox" name="option_<?= (int)$group['id'] ?>" value="1">
                      <span>Aceptar / agregar esta opción</span>
                    </label>
                  </div>
                <?php elseif ($inputType === 'file'): ?>
                  <div class="prod-option-control">
                    <input data-cp-file-field data-label="<?= hp((string)$group['name']) ?>" type="file" name="option_file_<?= (int)$group['id'] ?>" <?= !empty($group['accept']) ? 'accept="'.hp((string)$group['accept']).'"' : '' ?>>
                    <small class="prod-option-help">Por ahora se captura el nombre del archivo para incluirlo en la solicitud. La carga segura se conectará al flujo correspondiente.</small>
                  </div>
                <?php else: ?>
                  <div class="prod-option-control">
                    <input data-cp-free-field data-label="<?= hp((string)$group['name']) ?>" type="text" name="option_<?= (int)$group['id'] ?>" placeholder="<?= hp((string)($group['placeholder'] ?? '')) ?>" <?= $group['required'] ? 'required' : '' ?>>
                  </div>
                <?php endif; ?>

                <?php if (!empty($group['help_text'])): ?><p class="prod-option-help"><?= hp((string)$group['help_text']) ?></p><?php endif; ?>
              </div>
            <?php endforeach; ?>

            <div class="prod-config-summary">
              <small><?= $isFixed ? 'Precio estimado según selección' : 'Configuración' ?></small>
              <strong data-cp-config-price><?= $isFixed ? hp(cp_catalog_money($product['sale_price'])) : 'Lista para cotizar' ?></strong>
              <span>El ajuste mostrado es referencial. El servidor deberá validar cualquier precio definitivo antes de una compra.</span>
            </div>

            <?php if ($waBase): ?>
              <a class="prod-config-wa" data-cp-config-wa href="<?= hp($waUrl) ?>" target="_blank" rel="noopener">Cotizar esta configuración por WhatsApp ↗</a>
            <?php endif; ?>
          </section>
          <?php endif; ?>

          <div class="prod-actions">
            <?php if ($waBase): ?><a class="prod-button prod-button-red" href="<?= hp($waUrl) ?>" target="_blank" rel="noopener">Cotizar por WhatsApp ↗</a><?php endif; ?>
            <a class="prod-button prod-button-dark" href="<?= hp(cp_public_route('/catalogo.php')) ?>">Seguir explorando</a>
          </div>

          <div class="prod-help-card">
            <span>✦</span>
            <div><strong>¿Necesitas una personalización?</strong><p>Podremos añadir opciones, cantidades y configuraciones desde la siguiente fase del producto.</p></div>
          </div>
        </article>
      </div>
    </div>
  </section>

  <?php if ($related): ?>
  <section class="prod-related">
    <div class="prod-container">
      <div class="prod-section-head">
        <div><p class="cp-kicker">SIGUE EXPLORANDO</p><h2>Productos relacionados.</h2></div>
        <a href="<?= hp(cp_public_route('/catalogo.php')) ?>">Todo el catálogo →</a>
      </div>
      <div class="prod-related-grid">
        <?php foreach ($related as $item): ?>
          <a class="prod-related-card" data-cp-tilt href="<?= hp((string)$item['url']) ?>">
            <div class="prod-related-media"><?php if (!empty($item['image_url'])): ?><img src="<?= hp((string)$item['image_url']) ?>" alt="<?= hp((string)$item['name']) ?>" loading="lazy"><?php else: ?><span>CP</span><?php endif; ?></div>
            <div><small><?= hp((string)$item['pricing_label']) ?></small><h3><?= hp((string)$item['name']) ?></h3><strong><?= hp($item['sale_price'] !== null ? cp_catalog_money($item['sale_price']) : 'Cotizar') ?></strong></div>
          </a>
        <?php endforeach; ?>
      </div>
    </div>
  </section>
  <?php endif; ?>
</main>

<footer class="prod-footer">
  <div class="prod-container"><strong>Colibrí <i>Print</i></strong><span>© <?= date('Y') ?> · <?= hp($brand) ?></span></div>
</footer>

<script src="<?= hp(cp_public_asset('assets/js/producto-v3.js')) ?>?v=20260919-10" defer></script>
<?php if ($optionGroups): ?><script src="<?= hp(cp_public_asset('assets/js/producto-opciones.js')) ?>?v=20260919-10" defer></script><?php endif; ?>
<script src="<?= hp(cp_public_asset('assets/js/public-shell.js')) ?>?v=20260919-9" defer></script>
</body>
</html>
