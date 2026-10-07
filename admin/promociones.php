<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/promociones.php';
require_once __DIR__ . '/../includes/facebook.php';
require_auth();

$title = 'Promociones';
$pdo = db();
$error = null;
$success = null;
$action = (string)($_GET['action'] ?? 'list');
$id = (int)($_GET['id'] ?? 0);
$q = trim((string)($_GET['q'] ?? ''));
$filterStatus = trim((string)($_GET['status'] ?? ''));

$empty = [
    'title' => '',
    'label' => 'OFERTA',
    'description' => '',
    'promo_type' => 'fixed',
    'normal_price' => '',
    'promo_price' => '',
    'discount_percent' => '',
    'quantity_available' => '',
    'start_date' => date('Y-m-d'),
    'end_date' => '',
    'image_path' => '',
    'whatsapp_text' => '',
    'status' => 'draft',
    'show_web' => 1,
    'show_catalog' => 1,
    'show_whatsapp' => 0,
];
$promotion = $empty;
$selectedProducts = [];
$facebookConfig = ['enabled'=>1,'custom_message'=>'','status'=>'pending','facebook_post_id'=>'','last_error'=>'','published_at'=>null];

function promotion_upload_image(array $file): ?string {
    if (($file['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) return null;
    if (($file['error'] ?? 0) !== UPLOAD_ERR_OK) throw new RuntimeException('No se pudo subir la imagen de la promoción.');
    if ((int)($file['size'] ?? 0) > 5 * 1024 * 1024) throw new RuntimeException('La imagen supera el máximo de 5 MB.');
    $finfo = new finfo(FILEINFO_MIME_TYPE);
    $mime = $finfo->file($file['tmp_name']);
    $allowed = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp'];
    if (!isset($allowed[$mime])) throw new RuntimeException('Formato de imagen no permitido. Usa JPG, PNG o WEBP.');
    $dir = __DIR__ . '/../uploads/promotions';
    if (!is_dir($dir) && !mkdir($dir, 0755, true)) throw new RuntimeException('No se pudo crear la carpeta de imágenes de promociones.');
    $name = bin2hex(random_bytes(16)) . '.' . $allowed[$mime];
    $dest = $dir . '/' . $name;
    if (!move_uploaded_file($file['tmp_name'], $dest)) throw new RuntimeException('No se pudo guardar la imagen de la promoción.');
    return '/uploads/promotions/' . $name;
}

function promotion_delete_image(?string $path): void {
    if (!$path) return;
    $base = realpath(__DIR__ . '/../uploads/promotions');
    $file = realpath(__DIR__ . '/..' . $path);
    if ($base && $file && str_starts_with($file, $base . DIRECTORY_SEPARATOR) && is_file($file)) @unlink($file);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $form = (string)($_POST['form_action'] ?? '');
    $id = (int)($_POST['id'] ?? 0);

    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
        $action = $form === 'save' && $id > 0 ? 'edit' : 'create';
    } elseif ($form === 'delete') {
        try {
            $current = promotion_get($id);
            if (!$current) throw new RuntimeException('La promoción no existe.');
            $pdo->prepare('DELETE FROM cp_promotions WHERE id=?')->execute([$id]);
            promotion_delete_image((string)($current['image_path'] ?? ''));
            log_activity('delete', 'promotions', 'Promoción #' . $id . ' eliminada');
            redirect('/admin/promociones.php?deleted=1');
        } catch (Throwable $e) {
            $error = 'No se pudo eliminar la promoción: ' . $e->getMessage();
            $action = 'list';
        }
    } elseif ($form === 'save') {
        $rawProductIds = $_POST['product_ids'] ?? [];
        $selectedProducts = [];
        if (is_array($rawProductIds)) {
            foreach ($rawProductIds as $productId) {
                $pid = (int)$productId;
                if ($pid > 0) $selectedProducts[$pid] = $pid;
            }
        }
        $selectedProducts = array_values($selectedProducts);
        $promotion = [
            'title' => trim((string)($_POST['title'] ?? '')),
            'label' => trim((string)($_POST['label'] ?? 'OFERTA')),
            'description' => trim((string)($_POST['description'] ?? '')),
            'promo_type' => trim((string)($_POST['promo_type'] ?? 'fixed')),
            'normal_price' => trim((string)($_POST['normal_price'] ?? '')),
            'promo_price' => trim((string)($_POST['promo_price'] ?? '')),
            'discount_percent' => trim((string)($_POST['discount_percent'] ?? '')),
            'quantity_available' => trim((string)($_POST['quantity_available'] ?? '')),
            'start_date' => trim((string)($_POST['start_date'] ?? '')),
            'end_date' => trim((string)($_POST['end_date'] ?? '')),
            'image_path' => '',
            'whatsapp_text' => trim((string)($_POST['whatsapp_text'] ?? '')),
            'status' => trim((string)($_POST['status'] ?? 'draft')),
            'show_web' => isset($_POST['show_web']) ? 1 : 0,
            'show_catalog' => isset($_POST['show_catalog']) ? 1 : 0,
            'show_whatsapp' => isset($_POST['show_whatsapp']) ? 1 : 0,
        ];
        $facebookConfig = [
            'enabled' => isset($_POST['facebook_enabled']) ? 1 : 0,
            'custom_message' => trim((string)($_POST['facebook_message'] ?? '')),
            'status' => 'pending', 'facebook_post_id' => '', 'last_error' => '', 'published_at' => null,
        ];
        $action = $id > 0 ? 'edit' : 'create';

        try {
            if ($promotion['title'] === '') throw new RuntimeException('El título de la promoción es obligatorio.');
            if (strlen($promotion['label']) > 60) throw new RuntimeException('La etiqueta es demasiado larga.');
            if (!array_key_exists($promotion['promo_type'], promotion_types())) throw new RuntimeException('Tipo de promoción no válido.');
            if (!array_key_exists($promotion['status'], promotion_statuses())) throw new RuntimeException('Estado de promoción no válido.');
            if (!$selectedProducts) throw new RuntimeException('Selecciona al menos un producto.');

            $dateStart = DateTime::createFromFormat('Y-m-d', $promotion['start_date']);
            if (!$dateStart || $dateStart->format('Y-m-d') !== $promotion['start_date']) throw new RuntimeException('La fecha de inicio no es válida.');
            if ($promotion['end_date'] !== '') {
                $dateEnd = DateTime::createFromFormat('Y-m-d', $promotion['end_date']);
                if (!$dateEnd || $dateEnd->format('Y-m-d') !== $promotion['end_date']) throw new RuntimeException('La fecha final no es válida.');
                if ($dateEnd < $dateStart) throw new RuntimeException('La fecha final no puede ser anterior a la fecha de inicio.');
            }

            $normalPrice = $promotion['normal_price'] === '' ? null : (float)$promotion['normal_price'];
            $promoPrice = $promotion['promo_price'] === '' ? null : (float)$promotion['promo_price'];
            $discount = $promotion['discount_percent'] === '' ? null : (float)$promotion['discount_percent'];
            if ($normalPrice !== null && $normalPrice < 0) throw new RuntimeException('El precio normal no puede ser negativo.');
            if ($promotion['promo_type'] === 'fixed') {
                if ($promoPrice === null) throw new RuntimeException('Captura el precio promocional.');
                if ($promoPrice < 0) throw new RuntimeException('El precio promocional no puede ser negativo.');
                if ($normalPrice !== null && $promoPrice > $normalPrice) throw new RuntimeException('El precio promocional no puede ser mayor al precio normal.');
                $discount = ($normalPrice !== null && $normalPrice > 0) ? round((($normalPrice - $promoPrice) / $normalPrice) * 100, 2) : null;
            } else {
                if ($discount === null || $discount <= 0 || $discount > 100) throw new RuntimeException('El descuento debe estar entre 0.01% y 100%.');
                if ($normalPrice !== null) $promoPrice = round($normalPrice * (1 - $discount / 100), 2);
            }

            $qty = null;
            if ($promotion['quantity_available'] !== '') {
                if (!ctype_digit($promotion['quantity_available'])) throw new RuntimeException('La cantidad disponible debe ser un número entero.');
                $qty = (int)$promotion['quantity_available'];
            }

            $newImage = promotion_upload_image($_FILES['image'] ?? []);
            $removeImage = isset($_POST['remove_image']);

            if ($id > 0) {
                $current = promotion_get($id);
                if (!$current) throw new RuntimeException('La promoción no existe.');
                $imagePath = (string)($current['image_path'] ?? '');
                if ($newImage) {
                    promotion_delete_image($imagePath);
                    $imagePath = $newImage;
                } elseif ($removeImage) {
                    promotion_delete_image($imagePath);
                    $imagePath = '';
                }
                $slug = promotion_unique_slug($pdo, $promotion['title'], $id);
                $stmt = $pdo->prepare('UPDATE cp_promotions SET title=?,slug=?,label=?,description=?,promo_type=?,normal_price=?,promo_price=?,discount_percent=?,quantity_available=?,start_date=?,end_date=?,image_path=?,whatsapp_text=?,status=?,show_web=?,show_catalog=?,show_whatsapp=?,updated_by=?,updated_at=NOW() WHERE id=?');
                $stmt->execute([$promotion['title'],$slug,$promotion['label'],$promotion['description'] ?: null,$promotion['promo_type'],$normalPrice,$promoPrice,$discount,$qty,$promotion['start_date'],$promotion['end_date'] !== '' ? $promotion['end_date'] : null,$imagePath ?: null,$promotion['whatsapp_text'] ?: null,$promotion['status'],$promotion['show_web'],$promotion['show_catalog'],$promotion['show_whatsapp'],current_user()['id'] ?? null,$id]);
                $pdo->prepare('DELETE FROM cp_promotion_products WHERE promotion_id=?')->execute([$id]);
            } else {
                $slug = promotion_unique_slug($pdo, $promotion['title']);
                $imagePath = $newImage ?: '';
                $stmt = $pdo->prepare('INSERT INTO cp_promotions(title,slug,label,description,promo_type,normal_price,promo_price,discount_percent,quantity_available,start_date,end_date,image_path,whatsapp_text,status,show_web,show_catalog,show_whatsapp,created_by,updated_by,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');
                $stmt->execute([$promotion['title'],$slug,$promotion['label'],$promotion['description'] ?: null,$promotion['promo_type'],$normalPrice,$promoPrice,$discount,$qty,$promotion['start_date'],$promotion['end_date'] !== '' ? $promotion['end_date'] : null,$imagePath ?: null,$promotion['whatsapp_text'] ?: null,$promotion['status'],$promotion['show_web'],$promotion['show_catalog'],$promotion['show_whatsapp'],current_user()['id'] ?? null,current_user()['id'] ?? null]);
                $id = (int)$pdo->lastInsertId();
            }

            $link = $pdo->prepare('INSERT INTO cp_promotion_products(promotion_id,product_id,sort_order,created_at) VALUES(?,?,?,NOW())');
            foreach ($selectedProducts as $index => $productId) $link->execute([$id,$productId,$index]);

            facebook_promotion_upsert($id, (bool)$facebookConfig['enabled'], (string)$facebookConfig['custom_message']);
            $fbResult = ['status'=>'pending'];
            if ((string)$promotion['status'] === 'active' && (int)$facebookConfig['enabled'] === 1) {
                $fbResult = facebook_publish_promotion($id);
            }
            log_activity($action === 'edit' ? 'update' : 'create', 'promotions', 'Promoción #' . $id . ' guardada');
            redirect('/admin/promociones.php?saved=' . ($action === 'edit' ? 'updated' : 'created') . '&fb=' . rawurlencode((string)$fbResult['status']));
        } catch (Throwable $e) {
            if (!empty($newImage ?? null)) promotion_delete_image($newImage);
            $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo guardar la promoción.';
        }
    }
}

if (isset($_GET['deleted'])) $success = 'Promoción eliminada correctamente.';
if (($_GET['saved'] ?? '') === 'created') $success = 'Promoción creada correctamente.';
if (($_GET['saved'] ?? '') === 'updated') $success = 'Promoción actualizada correctamente.';
if (($_GET['fb'] ?? '') === 'published') $success .= ' 📘 Facebook: publicada automáticamente.';
if (($_GET['fb'] ?? '') === 'pending') $success .= ' 📘 Facebook: quedó pendiente hasta su fecha de inicio.';
if (($_GET['fb'] ?? '') === 'error') $success .= ' 📘 Facebook: no se pudo publicar; revisa la configuración y el error en la promoción.';

if (($action === 'edit') && $id > 0 && $_SERVER['REQUEST_METHOD'] !== 'POST') {
    try {
        $found = promotion_get($id);
        if (!$found) { $error = 'La promoción solicitada no existe.'; $action = 'list'; }
        else {
            $promotion = array_merge($empty, $found);
            $selectedProducts = promotion_product_ids($id);
            $facebookConfig = facebook_promotion_config($id);
        }
    } catch (Throwable $e) { $error = 'No se pudo cargar la promoción.'; $action = 'list'; }
}

$products = [];
$rows = [];
$stats = ['active'=>0,'scheduled'=>0,'expired'=>0,'draft'=>0,'total'=>0];
if ($action === 'list') {
    try {
        $products = $pdo->query("SELECT p.id,p.name,p.sku,p.sale_price,
            (SELECT pi.path FROM cp_product_images pi WHERE pi.product_id=p.id AND pi.enabled=1 ORDER BY pi.sort_order,pi.id LIMIT 1) AS image_path
            FROM cp_products p WHERE p.enabled=1 ORDER BY p.name LIMIT 300")->fetchAll();
        $sql = "SELECT p.*, GROUP_CONCAT(DISTINCT pr.name ORDER BY pp.sort_order,pr.name SEPARATOR ', ') AS product_names,
                (SELECT pi.path FROM cp_product_images pi INNER JOIN cp_promotion_products pp2 ON pp2.product_id=pi.product_id WHERE pp2.promotion_id=p.id AND pi.enabled=1 ORDER BY pp2.sort_order,pi.sort_order,pi.id LIMIT 1) AS fallback_image
                FROM cp_promotions p
                LEFT JOIN cp_promotion_products pp ON pp.promotion_id=p.id
                LEFT JOIN cp_products pr ON pr.id=pp.product_id";
        $where = [];
        $params = [];
        if ($q !== '') { $where[] = '(p.title LIKE ? OR p.label LIKE ? OR p.description LIKE ? OR pr.name LIKE ?)'; $like = '%' . $q . '%'; array_push($params,$like,$like,$like,$like); }
        if ($filterStatus !== '' && array_key_exists($filterStatus, promotion_statuses())) { $where[] = 'p.status=?'; $params[] = $filterStatus; }
        if ($where) $sql .= ' WHERE ' . implode(' AND ', $where);
        $sql .= ' GROUP BY p.id ORDER BY p.id DESC LIMIT 150';
        $stmt = $pdo->prepare($sql); $stmt->execute($params); $rows = $stmt->fetchAll();
        foreach ($rows as &$row) $row['effective_state'] = promotion_effective_state($row);
        unset($row);
        foreach ($rows as $row) {
            $stats['total']++;
            $state = $row['effective_state'];
            if (isset($stats[$state])) $stats[$state]++;
        }
    } catch (Throwable $e) { $error = 'No se pudieron cargar las promociones: ' . $e->getMessage(); }
} elseif ($action === 'create' || $action === 'edit') {
    try { $products = $pdo->query("SELECT p.id,p.name,p.sku,p.sale_price,
        (SELECT pi.path FROM cp_product_images pi WHERE pi.product_id=p.id AND pi.enabled=1 ORDER BY pi.sort_order,pi.id LIMIT 1) AS image_path
        FROM cp_products p WHERE p.enabled=1 ORDER BY p.name LIMIT 300")->fetchAll(); } catch (Throwable $e) { $error = 'No se pudieron cargar los productos.'; }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/promociones.css?v=20260917-1">

<?php if ($action === 'create' || $action === 'edit'): ?>
<div class="promo-toolbar">
  <div><span class="eyebrow">FASE 11 · PROMOCIONES</span><h2><?= $action === 'edit' ? 'Editar promoción' : 'Nueva promoción' ?></h2><p class="muted">Las campañas comerciales se mantienen separadas de los avisos operativos del pedido.</p></div>
  <div class="toolbar-actions"><?=cancel_button('/admin/promociones.php')?> </div>
</div>
<?php if ($error): ?><div class="notice danger promo-notice"><?=e($error)?></div><?php endif; ?>
<div class="promo-edit-grid">
<section class="card">
  <div class="section-label">Datos de la promoción</div>
  <form method="post" enctype="multipart/form-data" id="promotionForm">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="form_action" value="save">
    <input type="hidden" name="id" value="<?=e((string)$id)?>">
    <div class="form-grid">
      <div class="field full"><label>Título <span class="required">*</span></label><input data-auto-focus name="title" maxlength="190" value="<?=e((string)$promotion['title'])?>" placeholder="Ej. Remate de vinil autoadherible" required></div>
      <div class="field"><label>Etiqueta</label><input name="label" maxlength="60" value="<?=e((string)$promotion['label'])?>" placeholder="OFERTA / REMATE / LIQUIDACIÓN"></div>
      <div class="field"><label>Tipo de promoción</label><select name="promo_type" id="promo_type"><?php foreach(promotion_types() as $key=>$label): ?><option value="<?=e($key)?>" <?=$promotion['promo_type']===$key?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select></div>
      <div class="field full"><label>Descripción comercial</label><textarea name="description" rows="4" maxlength="2000" placeholder="Qué incluye, condiciones, atractivo principal..."><?=e((string)$promotion['description'])?></textarea></div>
      <div class="field"><label>Precio normal</label><input type="number" min="0" step="0.01" name="normal_price" id="normal_price" value="<?=e((string)$promotion['normal_price'])?>" placeholder="0.00"></div>
      <div class="field fixed-only"><label>Precio promocional <span class="required">*</span></label><input type="number" min="0" step="0.01" name="promo_price" id="promo_price" value="<?=e((string)$promotion['promo_price'])?>" placeholder="0.00"></div>
      <div class="field percent-only"><label>Descuento % <span class="required">*</span></label><input type="number" min="0.01" max="100" step="0.01" name="discount_percent" id="discount_percent" value="<?=e((string)$promotion['discount_percent'])?>" placeholder="Ej. 20"></div>
      <div class="field"><label>Cantidad disponible</label><input type="number" min="0" step="1" name="quantity_available" value="<?=e((string)$promotion['quantity_available'])?>" placeholder="Vacío = ilimitada"><span class="help">Es la cantidad reservada para la promoción; no descuenta inventario automáticamente.</span></div>
      <div class="field"><label>Fecha de inicio <span class="required">*</span></label><input type="date" name="start_date" value="<?=e((string)$promotion['start_date'])?>" required></div>
      <div class="field"><label>Fecha final</label><input type="date" name="end_date" value="<?=e((string)$promotion['end_date'])?>"><span class="help">Vacío = sin fecha de término.</span></div>
      <div class="field"><label>Estado</label><select name="status"><?php foreach(promotion_statuses() as $key=>$label): ?><option value="<?=e($key)?>" <?=$promotion['status']===$key?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select></div>
      <div class="field full"><label>Imagen de campaña</label><input type="file" name="image" accept="image/jpeg,image/png,image/webp"><span class="help">JPG, PNG o WEBP. Máximo 5 MB. Si no subes una, se usará la imagen del producto en las vistas.</span><?php if(!empty($promotion['image_path'])): ?><div class="promo-current-image"><img src="<?=e((string)$promotion['image_path'])?>" alt=""><label><input type="checkbox" name="remove_image" value="1"> Quitar imagen personalizada</label></div><?php endif; ?></div>
    </div>

    <div class="section-label promo-section-gap">Productos incluidos</div>
    <div class="product-picker-head"><input type="search" id="productSearch" placeholder="Buscar producto..."><span class="help" id="productCount"></span></div>
    <div class="promo-product-grid" id="productGrid">
      <?php foreach($products as $p): $pid=(int)$p['id']; $checked=in_array($pid,$selectedProducts,true); ?>
      <label class="promo-product-item" data-product-search="<?=e(strtolower((string)$p['name'].' '.(string)($p['sku']??'')))?>">
        <input type="checkbox" name="product_ids[]" value="<?=$pid?>" data-price="<?=e((string)($p['sale_price'] ?? ''))?>" <?=$checked?'checked':''?>>
        <span class="promo-product-thumb"><?php if(!empty($p['image_path'])): ?><img src="<?=e((string)$p['image_path'])?>" alt=""><?php else: ?>📦<?php endif; ?></span>
        <span class="promo-product-text"><strong><?=e((string)$p['name'])?></strong><small><?=e((string)($p['sku'] ?: 'Sin SKU'))?> · <?=($p['sale_price']!==null?'$'.number_format((float)$p['sale_price'],2):'Sin precio')?></small></span>
      </label>
      <?php endforeach; ?>
      <?php if(!$products): ?><div class="empty">No hay productos activos para asociar a una promoción.</div><?php endif; ?>
    </div>

    <div class="section-label promo-section-gap">Publicación y WhatsApp</div>
    <div class="promo-channel-grid">
      <label><input type="checkbox" name="show_web" value="1" <?=$promotion['show_web']?'checked':''?>> Mostrar en web</label>
      <label><input type="checkbox" name="show_catalog" value="1" <?=$promotion['show_catalog']?'checked':''?>> Mostrar en catálogo</label>
      <label><input type="checkbox" name="show_whatsapp" value="1" <?=$promotion['show_whatsapp']?'checked':''?>> Habilitar para WhatsApp</label>
    </div>
    <div class="field promo-section-gap"><label>Mensaje comercial para WhatsApp</label><textarea name="whatsapp_text" id="whatsapp_text" rows="7" maxlength="3000" placeholder="Déjalo vacío para generarlo automáticamente a partir de los datos de la promoción."><?=e((string)$promotion['whatsapp_text'])?></textarea><span class="help">Este campo prepara una comunicación comercial. No se mezcla con los mensajes operativos de órdenes.</span></div>

    <div class="section-label promo-section-gap">Facebook automático</div>
    <div class="promo-channel-grid facebook-promo-box">
      <label><input type="checkbox" name="facebook_enabled" value="1" <?=((int)($facebookConfig['enabled'] ?? 1)===1?'checked':'')?>> Publicar automáticamente en Facebook</label>
      <span class="help">Cuando la promoción esté <strong>Activa</strong> y vigente, el sistema intentará publicarla con su imagen de campaña. Las promociones futuras quedan pendientes para el cron de cPanel.</span>
    </div>
    <div class="field"><label>Texto personalizado para Facebook</label><textarea name="facebook_message" rows="7" maxlength="5000" placeholder="Déjalo vacío para generar automáticamente el texto con precio, vigencia, WhatsApp y ubicación."><?=e((string)($facebookConfig['custom_message'] ?? ''))?></textarea><span class="help">No necesitas escribir nada para usar la plantilla automática.</span></div>
    <?php if(!empty($facebookConfig['facebook_post_id'])): ?><div class="notice">📘 Publicación Facebook: <strong><?=e((string)$facebookConfig['facebook_post_id'])?></strong><?=!empty($facebookConfig['published_at'])?' · '.e((string)$facebookConfig['published_at']):''?></div><?php elseif(!empty($facebookConfig['last_error'])): ?><div class="notice danger">Facebook: <?=e((string)$facebookConfig['last_error'])?></div><?php endif; ?>

    <div class="form-actions"><?=cancel_button('/admin/promociones.php')?><?=save_button($action === 'edit' ? 'Guardar cambios' : 'Crear promoción')?></div>
  </form>
</section>

<section class="card promo-preview-card">
  <div class="section-label">Vista previa</div>
  <div class="promo-preview" id="promoPreview">
    <div class="promo-preview-image" id="previewImage">🏷️</div>
    <span class="promo-preview-label" id="previewLabel"><?=e((string)$promotion['label'])?></span>
    <h3 id="previewTitle"><?=e((string)($promotion['title'] ?: 'Tu promoción'))?></h3>
    <p id="previewDescription"><?=e((string)($promotion['description'] ?: 'Describe aquí el atractivo principal de la campaña.'))?></p>
    <div class="promo-preview-price"><span id="previewNormal"><?= $promotion['normal_price']!=='' ? '$'.number_format((float)$promotion['normal_price'],2):'' ?></span><strong id="previewPromo"><?= $promotion['promo_price']!=='' ? '$'.number_format((float)$promotion['promo_price'],2):'' ?></strong></div>
    <div class="promo-preview-meta"><span id="previewDates"><?=e((string)$promotion['start_date'])?></span><span id="previewQty"></span></div>
  </div>
  <div class="promo-whatsapp-preview"><div class="section-label">Texto para WhatsApp</div><pre id="whatsappPreview"></pre><a class="btn btn-secondary" id="previewWa" href="#" target="_blank" rel="noopener">💬 Abrir WhatsApp</a></div>
</section>
</div>
<script>
(function(){
  const form=document.getElementById('promotionForm');
  if(!form) return;
  const type=document.getElementById('promo_type'), normal=document.getElementById('normal_price'), promo=document.getElementById('promo_price'), disc=document.getElementById('discount_percent');
  const fixed=document.querySelectorAll('.fixed-only'), percent=document.querySelectorAll('.percent-only');
  const title=document.querySelector('input[name="title"]'), label=document.querySelector('input[name="label"]'), desc=document.querySelector('textarea[name="description"]');
  const previewTitle=document.getElementById('previewTitle'), previewLabel=document.getElementById('previewLabel'), previewDescription=document.getElementById('previewDescription'), previewNormal=document.getElementById('previewNormal'), previewPromo=document.getElementById('previewPromo'), previewDates=document.getElementById('previewDates'), previewQty=document.getElementById('previewQty');
  const waPreview=document.getElementById('whatsappPreview'), waBtn=document.getElementById('previewWa');
  const productSearch=document.getElementById('productSearch'), productCount=document.getElementById('productCount');
  function updateType(){ const isFixed=type.value==='fixed'; fixed.forEach(x=>x.style.display=isFixed?'grid':'none'); percent.forEach(x=>x.style.display=isFixed?'none':'grid'); if(!isFixed && normal.value && disc.value){promo.value=(parseFloat(normal.value||0)*(1-parseFloat(disc.value||0)/100)).toFixed(2);} }
  function selectedProductPrice(){ const checked=form.querySelectorAll('input[name="product_ids[]"]:checked'); if(checked.length===1 && !normal.value) { const p=parseFloat(checked[0].dataset.price||''); if(isFinite(p)) normal.value=p.toFixed(2); } }
  function generatedText(){
    const t=(title.value||'Promoción').trim(), l=(label.value||'OFERTA').trim(), d=(desc.value||'').trim();
    const lines=['✨ '+l+': '+t]; if(d) lines.push(d);
    const np=parseFloat(normal.value||''); const pp=parseFloat(promo.value||''); const dp=parseFloat(disc.value||'');
    if(isFinite(pp)) lines.push('💥 Precio promocional: $'+pp.toFixed(2));
    if(isFinite(np) && isFinite(pp)) lines.push('Antes: $'+np.toFixed(2));
    if(isFinite(dp) && dp>0) lines.push('🏷️ Descuento: '+dp.toFixed(2).replace(/\.00$/,'')+'%');
    const s=form.querySelector('input[name="start_date"]').value, e=form.querySelector('input[name="end_date"]').value, q=form.querySelector('input[name="quantity_available"]').value;
    if(s && e) lines.push('📅 Vigencia: '+s.split('-').reverse().join('/')+' al '+e.split('-').reverse().join('/')); else if(s) lines.push('📅 Disponible desde: '+s.split('-').reverse().join('/'));
    if(q) lines.push('📦 Disponibilidad promocional: '+q);
    lines.push('Colibrí Print México');
    return lines.join('\n');
  }
  function updatePreview(){
    previewTitle.textContent=title.value.trim()||'Tu promoción'; previewLabel.textContent=label.value.trim()||'OFERTA'; previewDescription.textContent=desc.value.trim()||'Describe aquí el atractivo principal de la campaña.';
    const np=parseFloat(normal.value||''), pp=parseFloat(promo.value||''); previewNormal.textContent=isFinite(np)?'$'+np.toFixed(2):''; previewPromo.textContent=isFinite(pp)?'$'+pp.toFixed(2):'';
    const s=form.querySelector('input[name="start_date"]').value,e=form.querySelector('input[name="end_date"]').value; previewDates.textContent=s?(s.split('-').reverse().join('/')+(e?' → '+e.split('-').reverse().join('/'):'') ):'';
    const q=form.querySelector('input[name="quantity_available"]').value; previewQty.textContent=q?'📦 '+q+' disponibles':'';
    const custom=form.querySelector('textarea[name="whatsapp_text"]').value.trim(); const txt=custom||generatedText(); waPreview.textContent=txt; waBtn.href='https://wa.me/?text='+encodeURIComponent(txt);
  }
  [type,normal,promo,disc,title,label,desc].forEach(el=>el&&el.addEventListener('input',function(){updateType();updatePreview();}));
  form.querySelectorAll('input[name="product_ids[]"]').forEach(el=>el.addEventListener('change',function(){selectedProductPrice();updatePreview();}));
  form.querySelector('input[name="start_date"]').addEventListener('change',updatePreview); form.querySelector('input[name="end_date"]').addEventListener('change',updatePreview); form.querySelector('input[name="quantity_available"]').addEventListener('input',updatePreview);
  form.querySelector('textarea[name="whatsapp_text"]').addEventListener('input',updatePreview);
  if(productSearch){productSearch.addEventListener('input',function(){const term=this.value.toLowerCase().trim();let shown=0;document.querySelectorAll('.promo-product-item').forEach(item=>{const ok=!term||item.dataset.productSearch.includes(term);item.style.display=ok?'grid':'none';if(ok)shown++;});productCount.textContent=shown+' productos visibles';});productSearch.dispatchEvent(new Event('input'));}
  updateType(); updatePreview();
})();
</script>
<?php else: ?>
<div class="promo-toolbar">
  <div><span class="eyebrow">FASE 11 · PROMOCIONES</span><h2>Promociones</h2><p class="muted">Ofertas, remates y liquidaciones listas para reutilizar en web, catálogo y WhatsApp.</p></div>
  <div class="toolbar-actions"><?=action_button('Nueva promoción','/admin/promociones.php?action=create','btn')?> <a class="btn btn-secondary" href="/admin/facebook.php">📘 Facebook</a> <a class="btn btn-secondary" href="/api/promociones.php?channel=web" target="_blank" rel="noopener">Ver feed web</a></div>
</div>
<?php if($error): ?><div class="notice danger promo-notice"><?=e($error)?></div><?php endif; ?>
<?php if($success): ?><div class="notice promo-notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>
<div class="promo-stats"><div class="card"><span class="muted">Activas</span><strong><?=$stats['active']?></strong></div><div class="card"><span class="muted">Programadas</span><strong><?=$stats['scheduled']?></strong></div><div class="card"><span class="muted">Borradores</span><strong><?=$stats['draft']?></strong></div><div class="card"><span class="muted">Expiradas</span><strong><?=$stats['expired']?></strong></div></div>
<div class="card promo-filter-card"><form class="search-form" method="get"><input type="search" name="q" value="<?=e($q)?>" placeholder="Buscar promoción o producto"><select name="status"><option value="">Todos los estados</option><?php foreach(promotion_statuses() as $key=>$label): ?><option value="<?=e($key)?>" <?=$filterStatus===$key?'selected':''?>><?=e($label)?></option><?php endforeach; ?></select><button class="btn btn-secondary" type="submit">Buscar</button><?php if($q!==''||$filterStatus!==''): ?><?=cancel_button('/admin/promociones.php')?><?php endif; ?></form></div>
<div class="card table-wrap promo-table-wrap"><table class="table promo-table"><thead><tr><th>Promoción</th><th>Producto(s)</th><th>Precio</th><th>Vigencia</th><th>Publicación</th><th>Estado</th><th class="actions-cell">Acciones</th></tr></thead><tbody>
<?php foreach($rows as $r): $state=(string)$r['effective_state']; $waText=promotion_whatsapp_text($r); $waUrl='https://wa.me/?text='.rawurlencode($waText); ?>
<tr>
<td><div class="promo-row-title"><span class="promo-row-image"><?php $img=$r['image_path'] ?: ($r['fallback_image'] ?? ''); if($img): ?><img src="<?=e((string)$img)?>" alt=""><?php else: ?>🏷️<?php endif; ?></span><div><strong><?=e($r['title'])?></strong><small><?=e($r['label'])?></small></div></div></td>
<td><?=e($r['product_names'] ?: 'Sin producto')?></td>
<td><strong><?= $r['promo_price']!==null ? '$'.number_format((float)$r['promo_price'],2) : '—' ?></strong><?php if($r['normal_price']!==null): ?><div class="promo-old-price">$<?=number_format((float)$r['normal_price'],2)?></div><?php endif; ?><?php if($r['discount_percent']!==null): ?><small><?=e(rtrim(rtrim(number_format((float)$r['discount_percent'],2,'.',''), '0'), '.'))?>%</small><?php endif; ?></td>
<td><?=e(date('d/m/Y',strtotime((string)$r['start_date'])))?><?=!empty($r['end_date'])?' → '.e(date('d/m/Y',strtotime((string)$r['end_date']))):' → sin término'?></td>
<td><div class="promo-chips"><?php if((int)$r['show_web']===1): ?><span>Web</span><?php endif; ?><?php if((int)$r['show_catalog']===1): ?><span>Catálogo</span><?php endif; ?><?php if((int)$r['show_whatsapp']===1): ?><span>WhatsApp</span><?php endif; ?><?php $fbRow=facebook_promotion_config((int)$r['id']); if((int)$fbRow['enabled']===1): ?><span>Facebook</span><?php endif; ?></div><?php if((string)$fbRow['status']==='published'): ?><small class="muted">📘 Publicado</small><?php elseif((string)$fbRow['status']==='error'): ?><small class="status-inactive">📘 Error</small><?php endif; ?></td>
<td><span class="promo-status status-<?=e($state)?>"><?=e(promotion_effective_state_label($state))?></span></td>
<td class="actions-cell"><div class="actions"><?=edit_button('/admin/promociones.php?action=edit&id='.(int)$r['id'])?><a class="btn btn-sm btn-secondary" href="/admin/whatsapp.php?source=promotion&id=<?=((int)$r['id'])?>&template=promotion_offer">WhatsApp</a><form method="post" style="display:inline;margin:0"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="form_action" value="delete"><input type="hidden" name="id" value="<?=e((string)$r['id'])?>"><button type="submit" class="btn btn-sm btn-delete" data-confirm="¿Borrar la promoción <?=e($r['title'])?>? Esta acción no se puede deshacer.">Borrar</button></form></div></td>
</tr>
<?php endforeach; ?>
<?php if(!$rows): ?><tr><td colspan="7" class="empty">No hay promociones con los filtros actuales.<div class="empty-action"><?=action_button('Crear promoción','/admin/promociones.php?action=create','btn btn-sm')?></div></td></tr><?php endif; ?>
</tbody></table></div>
<?php endif; ?>
<?php require __DIR__.'/../includes/footer.php'; ?>
