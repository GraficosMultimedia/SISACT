<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';

$db = cp_db();

$sizes = $db->query("SELECT * FROM cp_print_sizes ORDER BY sort_order,id")->fetchAll();
$materials = $db->query("SELECT * FROM cp_print_materials ORDER BY sort_order,id")->fetchAll();
$finishes = $db->query("SELECT * FROM cp_print_finishes ORDER BY sort_order,id")->fetchAll();

$prices = $db->query("
    SELECT
        p.*,
        s.name AS size_name,
        m.name AS material_name,
        f.name AS finish_name
    FROM cp_print_prices p
    JOIN cp_print_sizes s ON s.id = p.size_id
    JOIN cp_print_materials m ON m.id = p.material_id
    JOIN cp_print_finishes f ON f.id = p.finish_id
    ORDER BY s.sort_order,m.sort_order,f.sort_order,p.color_mode
")->fetchAll();

$msg = $_GET['ok'] ?? '';
?>
<?php
$title = 'Configuración de impresión';
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/admin-impresion-precios.css">

<div class="print-config-page">
  <div class="print-config-toolbar">
    <div class="print-config-context">
      <span class="print-config-kicker">OPERACIÓN DE IMPRESIONES</span>
      <strong>Catálogos y tarifas</strong>
      <span>Administra lo que alimenta el formulario de impresión.</span>
    </div>
    <div class="print-config-actions">
      <a class="cp-btn cp-btn-primary" href="/admin/recepcion_impresiones.php">▣ Recepción de impresiones</a>
      <a class="cp-btn cp-btn-soft" href="/admin/recepcion_historial.php">▤ Historial de impresiones</a>
    </div>
  </div>

<?php if ($msg): ?>
<div class="cp-success print-config-success">✓ <?= cp_e($msg) ?></div>
<?php endif; ?>

<div class="cp-admin-grid print-config-grid">

<section class="cp-card cp-section print-section">
<div class="cp-card-head print-section-head">
    <div class="cp-section-title">
        <div class="cp-section-num">1</div>
        <div><h2>Tamaños</h2><p>Nombre, código, medidas y disponibilidad.</p></div>
    </div>
    <span class="print-section-badge"><?= count($sizes) ?> registros</span>
</div>

<div class="cp-table-wrap">
<table class="cp-admin-table print-admin-table">
<tr><th>Nombre</th><th>Medidas</th><th>Activo</th><th>Acciones</th></tr>
<?php foreach ($sizes as $s): $fid = 'size-' . $s['id']; ?>
<tr>
<td data-label="Nombre"><input form="<?= $fid ?>" name="name" value="<?= cp_e($s['name']) ?>"></td>
<td data-label="Medidas">
    <div class="print-size-fields">
        <input class="print-measure" form="<?= $fid ?>" name="width_mm" type="number" step=".01" value="<?= $s['width_mm'] ?>" aria-label="Ancho en milímetros">
        <span aria-hidden="true">×</span>
        <input class="print-measure" form="<?= $fid ?>" name="height_mm" type="number" step=".01" value="<?= $s['height_mm'] ?>" aria-label="Alto en milímetros">
        <small>mm</small>
    </div>
</td>
<td data-label="Activo">
    <label class="print-toggle" title="Activar o desactivar tamaño">
        <input form="<?= $fid ?>" name="enabled" type="checkbox" value="1" <?= $s['enabled'] ? 'checked' : '' ?> aria-label="<?= cp_e($s['name']) ?> activo">
        <span aria-hidden="true"></span>
    </label>
</td>
<td data-label="Acciones">
<form id="<?= $fid ?>" method="post" action="catalog_save.php" class="print-action-form">
    <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
    <input type="hidden" name="type" value="size">
    <input type="hidden" name="id" value="<?= $s['id'] ?>">
    <button class="cp-btn cp-btn-soft" type="submit">Guardar</button>
</form>
</td>
</tr>
<?php endforeach; ?>
</table>
</div>
</section>

<section class="cp-card cp-section print-section">
<div class="cp-card-head print-section-head">
    <div class="cp-section-title">
        <div class="cp-section-num">2</div>
        <div><h2>Materiales</h2><p>Materiales disponibles para cotizar.</p></div>
    </div>
    <span class="print-section-badge"><?= count($materials) ?> registros</span>
</div>

<div class="cp-table-wrap">
<table class="cp-admin-table print-admin-table">
<tr><th>Nombre</th><th>Unidad</th><th>Activo</th><th>Acciones</th></tr>
<?php foreach ($materials as $m): $fid = 'material-' . $m['id']; ?>
<tr>
<td data-label="Nombre"><input form="<?= $fid ?>" name="name" value="<?= cp_e($m['name']) ?>"></td>
<td data-label="Unidad"><input form="<?= $fid ?>" name="unit_label" value="<?= cp_e($m['unit_label']) ?>"></td>
<td data-label="Activo">
    <label class="print-toggle" title="Activar o desactivar material">
        <input form="<?= $fid ?>" name="enabled" type="checkbox" value="1" <?= $m['enabled'] ? 'checked' : '' ?> aria-label="<?= cp_e($m['name']) ?> activo">
        <span aria-hidden="true"></span>
    </label>
</td>
<td data-label="Acciones" class="print-actions-cell">
<form id="<?= $fid ?>" method="post" action="catalog_save.php" class="print-action-form">
    <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
    <input type="hidden" name="type" value="material">
    <input type="hidden" name="id" value="<?= $m['id'] ?>">
    <button class="cp-btn cp-btn-soft" type="submit">Guardar</button>
</form>
<form method="post" action="catalog_save.php" class="print-inline-delete" onsubmit="return confirm('Si el material ya se ha usado o tiene tarifas, se desactivará en lugar de borrarse. ¿Continuar?')">
    <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
    <input type="hidden" name="type" value="material_delete">
    <input type="hidden" name="id" value="<?= $m['id'] ?>">
    <button class="cp-btn cp-btn-danger" type="submit">Eliminar</button>
</form>
</td>
</tr>
<?php endforeach; ?>
</table>
</div>
</section>

</div>

<section class="cp-card cp-section print-section print-section-full">
<div class="cp-card-head print-section-head">
    <div class="cp-section-title">
        <div class="cp-section-num">3</div>
        <div><h2>Acabados</h2><p>Modifica los nombres y disponibilidad sin tocar la lógica del cotizador.</p></div>
    </div>
    <span class="print-section-badge"><?= count($finishes) ?> registros</span>
</div>

<div class="cp-table-wrap">
<table class="cp-admin-table print-admin-table">
<tr><th>Nombre</th><th>Código</th><th>Activo</th><th>Acciones</th></tr>
<?php foreach ($finishes as $f): $fid = 'finish-' . $f['id']; ?>
<tr>
<td data-label="Nombre"><input form="<?= $fid ?>" name="name" value="<?= cp_e($f['name']) ?>"></td>
<td data-label="Código"><span class="print-code-pill"><?= cp_e($f['code']) ?></span></td>
<td data-label="Activo">
    <label class="print-toggle" title="Activar o desactivar acabado">
        <input form="<?= $fid ?>" name="enabled" type="checkbox" value="1" <?= $f['enabled'] ? 'checked' : '' ?> aria-label="<?= cp_e($f['name']) ?> activo">
        <span aria-hidden="true"></span>
    </label>
</td>
<td data-label="Acciones">
<form id="<?= $fid ?>" method="post" action="catalog_save.php" class="print-action-form">
    <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
    <input type="hidden" name="type" value="finish">
    <input type="hidden" name="id" value="<?= $f['id'] ?>">
    <button class="cp-btn cp-btn-soft" type="submit">Guardar</button>
</form>
</td>
</tr>
<?php endforeach; ?>
</table>
</div>
</section>

<section class="cp-card print-section print-price-section">
<div class="cp-card-head print-section-head">
    <div class="cp-section-title">
        <div class="cp-section-num">4</div>
        <div><h2>Matriz de tarifas</h2><p>La parte que realmente controla el precio del formulario.</p></div>
    </div>
    <span class="print-section-badge"><?= count($prices) ?> tarifas</span>
</div>

<form class="cp-admin-price print-price-form" method="post" action="price_save.php">
    <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
    <div class="print-field">
        <label for="price-size">Tamaño</label>
        <select id="price-size" name="size_id" required>
            <option value="">Seleccionar</option>
            <?php foreach ($sizes as $s): ?><option value="<?= $s['id'] ?>"><?= cp_e($s['name']) ?></option><?php endforeach; ?>
        </select>
    </div>
    <div class="print-field">
        <label for="price-material">Material</label>
        <select id="price-material" name="material_id" required>
            <option value="">Seleccionar</option>
            <?php foreach ($materials as $m): ?><option value="<?= $m['id'] ?>"><?= cp_e($m['name']) ?></option><?php endforeach; ?>
        </select>
    </div>
    <div class="print-field">
        <label for="price-finish">Acabado</label>
        <select id="price-finish" name="finish_id" required>
            <option value="">Seleccionar</option>
            <?php foreach ($finishes as $f): ?><option value="<?= $f['id'] ?>"><?= cp_e($f['name']) ?></option><?php endforeach; ?>
        </select>
    </div>
    <div class="print-field print-field-short">
        <label for="price-color">Modo</label>
        <select id="price-color" name="color_mode"><option value="color">Color</option><option value="bw">B/N</option></select>
    </div>
    <div class="print-field print-field-short">
        <label for="price-value">Precio</label>
        <input id="price-value" type="number" name="unit_price" step=".01" min="0" placeholder="0.00" required>
    </div>
    <div class="print-field">
        <label for="price-mode">Cobro</label>
        <select id="price-mode" name="pricing_mode"><option value="per_page">Por página</option><option value="per_sheet">Por hoja</option></select>
    </div>
    <button class="cp-btn cp-btn-primary print-price-save" type="submit">Guardar tarifa</button>
</form>

<div class="cp-table-wrap">
<table class="cp-admin-table print-admin-table print-price-table">
<tr>
    <th>Tamaño</th><th>Material</th><th>Acabado</th><th>Modo</th><th>Precio</th><th>Acciones</th>
</tr>
<?php foreach ($prices as $p): ?>
<tr>
    <td data-label="Tamaño"><?= cp_e($p['size_name']) ?></td>
    <td data-label="Material"><?= cp_e($p['material_name']) ?></td>
    <td data-label="Acabado"><?= cp_e($p['finish_name']) ?></td>
    <td data-label="Modo"><span class="print-mode-pill"><?= cp_e($p['color_mode']) ?> · <?= cp_e($p['pricing_mode']) ?></span></td>
    <td data-label="Precio"><strong>$<?= number_format((float)$p['unit_price'], 2, '.', ',') ?></strong></td>
    <td data-label="Acciones">
        <form method="post" action="price_delete.php" class="print-action-form" onsubmit="return confirm('¿Desactivar esta tarifa?')">
            <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
            <input type="hidden" name="id" value="<?= $p['id'] ?>">
            <button class="cp-btn cp-btn-danger" type="submit">Desactivar</button>
        </form>
    </td>
</tr>
<?php endforeach; ?>
</table>
</div>
</section>

</div>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
