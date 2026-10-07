<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Opciones de producto';
$pdo = db();
$error = null;
$success = null;

$productId = max(0, (int)($_GET['product_id'] ?? $_POST['product_id'] ?? 0));
if ($productId <= 0) {
    http_response_code(400);
    exit('Producto inválido.');
}

$productStmt = $pdo->prepare('SELECT id,name,pricing_type,sale_price FROM cp_products WHERE id=? LIMIT 1');
$productStmt->execute([$productId]);
$product = $productStmt->fetch();
if (!$product) {
    http_response_code(404);
    exit('Producto no encontrado.');
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        if (!csrf_check($_POST['_csrf'] ?? null)) {
            throw new RuntimeException('La sesión del formulario expiró. Recarga la página.');
        }

        $action = (string)($_POST['form_action'] ?? '');

        if ($action === 'delete_group') {
            $groupId = (int)($_POST['group_id'] ?? 0);
            $stmt = $pdo->prepare('DELETE FROM cp_product_option_groups WHERE id=? AND product_id=?');
            $stmt->execute([$groupId, $productId]);
            $success = 'Grupo eliminado.';
        } elseif ($action === 'save_group') {
            $groupId = (int)($_POST['group_id'] ?? 0);
            $name = trim((string)($_POST['name'] ?? ''));
            $inputType = trim((string)($_POST['input_type'] ?? 'select'));
            $required = isset($_POST['required']) ? 1 : 0;
            $helpText = trim((string)($_POST['help_text'] ?? ''));
            $placeholder = trim((string)($_POST['placeholder'] ?? ''));
            $sortOrder = (int)($_POST['sort_order'] ?? 0);
            $allowed = ['select','radio','text','textarea','number','file','checkbox'];

            if ($name === '') throw new RuntimeException('El nombre del grupo es obligatorio.');
            if (!in_array($inputType, $allowed, true)) throw new RuntimeException('Tipo de campo inválido.');

            if ($groupId > 0) {
                $stmt = $pdo->prepare('UPDATE cp_product_option_groups SET name=?,input_type=?,required=?,help_text=?,placeholder=?,sort_order=?,updated_at=NOW() WHERE id=? AND product_id=?');
                $stmt->execute([$name,$inputType,$required,$helpText ?: null,$placeholder ?: null,$sortOrder,$groupId,$productId]);
            } else {
                $stmt = $pdo->prepare('INSERT INTO cp_product_option_groups(product_id,name,input_type,required,help_text,placeholder,sort_order,enabled,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,NOW(),NOW())');
                $stmt->execute([$productId,$name,$inputType,$required,$helpText ?: null,$placeholder ?: null,$sortOrder,1]);
            }

            $success = 'Grupo guardado.';
        } elseif ($action === 'save_value') {
            $groupId = (int)($_POST['group_id'] ?? 0);
            $valueId = (int)($_POST['value_id'] ?? 0);
            $label = trim((string)($_POST['label'] ?? ''));
            $value = trim((string)($_POST['value'] ?? ''));
            $priceDelta = (float)($_POST['price_delta'] ?? 0);
            $sortOrder = (int)($_POST['sort_order'] ?? 0);

            $check = $pdo->prepare('SELECT id FROM cp_product_option_groups WHERE id=? AND product_id=?');
            $check->execute([$groupId,$productId]);

            if (!$check->fetch()) throw new RuntimeException('Grupo inválido.');
            if ($label === '' || $value === '') throw new RuntimeException('Etiqueta y valor son obligatorios.');

            if ($valueId > 0) {
                $stmt = $pdo->prepare('UPDATE cp_product_option_values SET label=?,value=?,price_delta=?,sort_order=?,updated_at=NOW() WHERE id=? AND group_id=?');
                $stmt->execute([$label,$value,$priceDelta,$sortOrder,$valueId,$groupId]);
            } else {
                $stmt = $pdo->prepare('INSERT INTO cp_product_option_values(group_id,label,value,price_delta,sort_order,enabled,created_at,updated_at) VALUES(?,?,?,?,?,1,NOW(),NOW())');
                $stmt->execute([$groupId,$label,$value,$priceDelta,$sortOrder]);
            }

            $success = 'Opción guardada.';
        } elseif ($action === 'delete_value') {
            $valueId = (int)($_POST['value_id'] ?? 0);
            $stmt = $pdo->prepare('DELETE v FROM cp_product_option_values v INNER JOIN cp_product_option_groups g ON g.id=v.group_id WHERE v.id=? AND g.product_id=?');
            $stmt->execute([$valueId,$productId]);
            $success = 'Opción eliminada.';
        } else {
            throw new RuntimeException('Acción no reconocida.');
        }
    } catch (Throwable $e) {
        $error = $e instanceof RuntimeException ? $e->getMessage() : 'No se pudo guardar la configuración.';
    }
}

$groupStmt = $pdo->prepare('SELECT * FROM cp_product_option_groups WHERE product_id=? ORDER BY sort_order,id');
$groupStmt->execute([$productId]);
$groups = $groupStmt->fetchAll();

$valueStmt = $pdo->prepare('SELECT * FROM cp_product_option_values WHERE group_id=? ORDER BY sort_order,id');
foreach ($groups as &$group) {
    $valueStmt->execute([(int)$group['id']]);
    $group['values'] = $valueStmt->fetchAll();
}
unset($group);

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/producto-opciones-admin.css?v=20260919-10">

<div class="option-admin-toolbar">
  <div>
    <span class="eyebrow">FASE 10 · VARIANTES Y PERSONALIZACIÓN</span>
    <h2>Opciones de producto</h2>
    <p class="muted">Producto #<?= (int)$product['id'] ?> · <?= e((string)$product['name']) ?></p>
  </div>
  <div><a class="btn btn-secondary" href="/admin/productos.php?action=edit&id=<?= (int)$product['id'] ?>">Volver al producto</a></div>
</div>

<?php if($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
<?php if($success): ?><div class="notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<div class="option-admin-grid">
  <section class="card">
    <div class="option-admin-section-head">
      <div><span class="eyebrow">NUEVO GRUPO</span><h3>Crear opción</h3></div>
    </div>

    <form method="post" class="option-form">
      <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
      <input type="hidden" name="form_action" value="save_group">
      <input type="hidden" name="product_id" value="<?= (int)$productId ?>">
      <input type="text" name="name" placeholder="Ej. Color, Talla, Texto, Archivo" required>
      <select name="input_type">
        <option value="select">Lista</option>
        <option value="radio">Opciones</option>
        <option value="text">Texto</option>
        <option value="textarea">Texto largo</option>
        <option value="number">Número</option>
        <option value="file">Archivo</option>
        <option value="checkbox">Casilla</option>
      </select>
      <label><input type="checkbox" name="required" value="1"> Obligatorio</label>
      <input type="text" name="placeholder" placeholder="Placeholder">
      <textarea name="help_text" placeholder="Ayuda para el cliente"></textarea>
      <input type="number" name="sort_order" value="0" placeholder="Orden">
      <button class="btn btn-primary" type="submit">Guardar grupo</button>
    </form>
  </section>

  <section class="card">
    <div class="option-admin-section-head">
      <div><span class="eyebrow">GRUPOS EXISTENTES</span><h3>Configuración</h3></div>
    </div>

    <?php if(!$groups): ?>
      <div class="option-admin-empty">Este producto todavía no tiene opciones configuradas.</div>
    <?php endif; ?>

    <?php foreach($groups as $group): ?>
      <div class="option-admin-group">
        <div class="option-admin-group-head">
          <div><strong><?=e((string)$group['name'])?></strong><small><?=e((string)$group['input_type'])?> <?=((int)$group['required']===1?'· obligatorio':'')?></small></div>
          <form method="post" onsubmit="return confirm('¿Eliminar este grupo y sus opciones?');">
            <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
            <input type="hidden" name="form_action" value="delete_group">
            <input type="hidden" name="product_id" value="<?= (int)$productId ?>">
            <input type="hidden" name="group_id" value="<?= (int)$group['id'] ?>">
            <button class="btn btn-danger" type="submit">Eliminar</button>
          </form>
        </div>

        <?php if(in_array((string)$group['input_type'], ['select','radio'], true)): ?>
        <div class="option-admin-values">
          <?php foreach($group['values'] as $value): ?>
            <div>
              <span><b><?=e((string)$value['label'])?></b><small><?=e((string)$value['value'])?></small></span>
              <strong><?=number_format((float)$value['price_delta'],2,'.',',')?> MXN</strong>
              <form method="post">
                <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                <input type="hidden" name="form_action" value="delete_value">
                <input type="hidden" name="product_id" value="<?= (int)$productId ?>">
                <input type="hidden" name="value_id" value="<?= (int)$value['id'] ?>">
                <button class="link-danger" type="submit">Eliminar</button>
              </form>
            </div>
          <?php endforeach; ?>
        </div>

        <form method="post" class="option-value-form">
          <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
          <input type="hidden" name="form_action" value="save_value">
          <input type="hidden" name="product_id" value="<?= (int)$productId ?>">
          <input type="hidden" name="group_id" value="<?= (int)$group['id'] ?>">
          <input type="text" name="label" placeholder="Etiqueta: Negro" required>
          <input type="text" name="value" placeholder="Valor interno: negro" required>
          <input type="number" name="price_delta" step="0.01" value="0" placeholder="Ajuste de precio">
          <input type="number" name="sort_order" value="0" placeholder="Orden">
          <button class="btn btn-secondary" type="submit">+ Opción</button>
        </form>
        <?php else: ?>
          <div class="option-admin-note">Este tipo de campo no requiere una lista de valores.</div>
        <?php endif; ?>
      </div>
    <?php endforeach; ?>
  </section>
</div>
<?php
