<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Clientes';
$pdo = db();
$error = null;
$success = null;
$action = (string)($_GET['action'] ?? 'list');
$id = (int)($_GET['id'] ?? 0);
$q = trim((string)($_GET['q'] ?? ''));
$returnTo = trim((string)($_GET['return_to'] ?? $_POST['return_to'] ?? ''));
if ($returnTo !== '' && !str_starts_with($returnTo, '/admin/')) $returnTo = '';

/**
 * Replica clientes de Akaunting en cp_customers.
 * Akaunting se consulta en modo lectura. Nunca se escriben sus tablas.
 */
$akauntingSync = ['new'=>0,'updated'=>0,'unchanged'=>0,'errors'=>0];

$emptyCustomer = [
    'name'=>'', 'email'=>'', 'tax_number'=>'', 'phone'=>'', 'address'=>'',
    'city'=>'', 'zip_code'=>'', 'state'=>'', 'country'=>'MX', 'notes'=>'', 'enabled'=>1
];
$customer = $emptyCustomer;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $postAction = (string)($_POST['form_action'] ?? '');
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página e inténtalo nuevamente.';
        $action = $postAction === 'edit' ? 'edit' : 'create';
        $id = (int)($_POST['id'] ?? 0);
    } elseif ($postAction === 'delete') {
        $id = (int)($_POST['id'] ?? 0);
        if ($id <= 0) $error = 'Cliente inválido.';
        else {
            try {
                $sourceStmt = $pdo->prepare('SELECT source_type FROM cp_customers WHERE id=? LIMIT 1');
                $sourceStmt->execute([$id]);
                if ((string)$sourceStmt->fetchColumn() === 'akaunting') {
                    throw new RuntimeException('Este cliente pertenece a un registro histórico migrado y no puede editarse desde aquí.');
                }
                $stmt = $pdo->prepare('DELETE FROM cp_customers WHERE id=?');
                $stmt->execute([$id]);
                log_activity('delete','customers','Cliente #' . $id . ' eliminado');
                redirect('/admin/clientes.php?deleted=1');
            } catch (Throwable $e) {
                $error = 'No se pudo borrar el cliente: ' . $e->getMessage();
                $action = 'list';
            }
        }
    } elseif ($postAction === 'save') {
        $id = (int)($_POST['id'] ?? 0);
        $customer = [
            'name'=>trim((string)($_POST['name'] ?? '')),
            'email'=>trim((string)($_POST['email'] ?? '')),
            'tax_number'=>trim((string)($_POST['tax_number'] ?? '')),
            'phone'=>trim((string)($_POST['phone'] ?? '')),
            'address'=>trim((string)($_POST['address'] ?? '')),
            'city'=>trim((string)($_POST['city'] ?? '')),
            'zip_code'=>trim((string)($_POST['zip_code'] ?? '')),
            'state'=>trim((string)($_POST['state'] ?? '')),
            'country'=>strtoupper(trim((string)($_POST['country'] ?? 'MX'))),
            'notes'=>trim((string)($_POST['notes'] ?? '')),
            'enabled'=>isset($_POST['enabled']) ? 1 : 0,
        ];
        $action = $id > 0 ? 'edit' : 'create';

        if ($id > 0) {
            $sourceStmt = $pdo->prepare('SELECT source_type FROM cp_customers WHERE id=? LIMIT 1');
            $sourceStmt->execute([$id]);
            if ((string)$sourceStmt->fetchColumn() === 'akaunting') {
                $error = 'Este cliente pertenece a un registro histórico migrado y no puede editarse desde aquí.';
            }
        }

        if ($customer['name'] === '' && !$error) {
            $error = 'El nombre del cliente es obligatorio.';
        } elseif ($customer['email'] !== '' && !filter_var($customer['email'], FILTER_VALIDATE_EMAIL)) {
            $error = 'El correo electrónico no es válido.';
        } else {
            try {
                if ($id > 0) {
                    $stmt = $pdo->prepare('UPDATE cp_customers SET name=?, email=?, tax_number=?, phone=?, address=?, city=?, zip_code=?, state=?, country=?, notes=?, enabled=?, updated_at=NOW() WHERE id=?');
                    $stmt->execute([
                        $customer['name'],$customer['email'] ?: null,$customer['tax_number'] ?: null,
                        $customer['phone'] ?: null,$customer['address'] ?: null,$customer['city'] ?: null,
                        $customer['zip_code'] ?: null,$customer['state'] ?: null,$customer['country'] ?: 'MX',
                        $customer['notes'] ?: null,$customer['enabled'],$id
                    ]);
                    log_activity('update','customers','Cliente #' . $id . ' actualizado');
                    redirect('/admin/clientes.php?saved=updated');
                } else {
                    $stmt = $pdo->prepare('INSERT INTO cp_customers (source_type,name,email,tax_number,phone,address,city,zip_code,state,country,notes,enabled,created_at,updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');
                    $stmt->execute([
                        'local',$customer['name'],$customer['email'] ?: null,$customer['tax_number'] ?: null,
                        $customer['phone'] ?: null,$customer['address'] ?: null,$customer['city'] ?: null,
                        $customer['zip_code'] ?: null,$customer['state'] ?: null,$customer['country'] ?: 'MX',
                        $customer['notes'] ?: null,$customer['enabled']
                    ]);
                    $newId = (int)$pdo->lastInsertId();
                    log_activity('create','customers','Cliente #' . $newId . ' creado');
                    if ($returnTo !== '') {
                        redirect($returnTo . (str_contains($returnTo, '?') ? '&' : '?') . 'customer_id=' . $newId);
                    }
                    redirect('/admin/clientes.php?saved=created');
                }
            } catch (Throwable $e) {
                $error = 'No se pudo guardar el cliente: ' . $e->getMessage();
            }
        }
    }
}

if (isset($_GET['deleted'])) $success = 'Cliente eliminado correctamente.';
if (($_GET['saved'] ?? '') === 'created') $success = 'Cliente creado correctamente.';
if (($_GET['saved'] ?? '') === 'updated') $success = 'Cliente actualizado correctamente.';

if (($action === 'edit') && $id > 0 && $_SERVER['REQUEST_METHOD'] !== 'POST') {
    try {
        $stmt = $pdo->prepare('SELECT * FROM cp_customers WHERE id=? LIMIT 1');
        $stmt->execute([$id]);
        $found = $stmt->fetch();
        if (!$found) {
            $error = 'El cliente solicitado no existe.';
            $action = 'list';
        } else {
            $customer = array_merge($emptyCustomer, $found);
        }
    } catch (Throwable $e) {
        $error = 'No se pudo cargar el cliente.';
        $action = 'list';
    }
}

$rows = [];
$totalCustomers = 0;
$totalAkaunting = 0;
$totalLocal = 0;
$page = max(1, (int)($_GET['page'] ?? 1));
$perPage = (int)($_GET['per_page'] ?? 50);
if (!in_array($perPage, [25, 50, 100], true)) $perPage = 50;
$totalPages = 1;

if ($action === 'list') {
    try {
        $where = [];
        $params = [];
        if ($q !== '') {
            $where[] = '(name LIKE ? OR phone LIKE ? OR email LIKE ? OR tax_number LIKE ?)';
            $like = '%' . $q . '%';
            array_push($params, $like, $like, $like, $like);
        }

        $whereSql = $where ? ' WHERE ' . implode(' AND ', $where) : '';

        $countStmt = $pdo->prepare('SELECT COUNT(*) FROM cp_customers' . $whereSql);
        $countStmt->execute($params);
        $totalCustomers = (int)$countStmt->fetchColumn();

        // Desde la migración, cp_customers es la única fuente de clientes.
        $totalAkaunting = 0;
        $totalLocal = (int)$pdo->query("SELECT COUNT(*) FROM cp_customers WHERE source_type='local'")->fetchColumn();

        $totalPages = max(1, (int)ceil($totalCustomers / $perPage));
        if ($page > $totalPages) $page = $totalPages;

        $offset = ($page - 1) * $perPage;
        $stmt = $pdo->prepare(
            'SELECT id,source_type,name,email,phone,city,state,enabled,created_at
             FROM cp_customers' . $whereSql . '
             ORDER BY id DESC
             LIMIT ' . (int)$perPage . ' OFFSET ' . (int)$offset
        );
        $stmt->execute($params);
        $rows = $stmt->fetchAll();
    } catch (Throwable $e) {
        $error = 'No se pudieron cargar los clientes: ' . $e->getMessage();
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/sisact-design-system-v1.css?v=1.0.1">
<link rel="stylesheet" href="/assets/css/clientes-workspace-professional-v1.css?v=1.0.0">

<div class="cw-page <?=$action === 'list' ? 'cw-list-mode' : 'cw-form-mode'?>">

<?php if ($action === 'create' || $action === 'edit'): ?>
<div class="toolbar cw-hero">
  <div class="toolbar-title">
    <span class="eyebrow">GESTIÓN DE CLIENTES</span>
    <h2><?= $action === 'edit' ? 'Editar cliente' : 'Nuevo cliente' ?></h2>
    <span class="muted">Todos los clientes se gestionan exclusivamente en la base local de Colibrí Print.</span>
  </div>
  <div class="toolbar-actions"><?=cancel_button('/admin/clientes.php' . ($q !== '' ? '?q=' . urlencode($q) : ''))?></div>
</div>

<?php if($error): ?><div class="notice danger cw-notice"><?=e($error)?></div><?php endif; ?>

<div class="card form-card cw-form-card">
  <div class="cw-form-heading">
    <div>
      <span class="section-label">DATOS PRINCIPALES</span>
      <h3><?= $action === 'edit' ? 'Información del cliente' : 'Registrar cliente' ?></h3>
      <p>Información comercial, fiscal y de contacto.</p>
    </div>
  </div>

  <form method="post" autocomplete="off">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="form_action" value="save">
    <input type="hidden" name="id" value="<?=e((string)$id)?>">
    <input type="hidden" name="return_to" value="<?=e($returnTo)?>">

    <div class="form-grid cw-form-grid">
      <div class="field full cw-field-primary">
        <label>Nombre / razón social <span class="required">*</span></label>
        <input data-auto-focus type="text" name="name" maxlength="190" value="<?=e((string)$customer['name'])?>" required>
      </div>

      <div class="field">
        <label>Correo electrónico</label>
        <input type="email" name="email" maxlength="190" value="<?=e((string)$customer['email'])?>">
      </div>

      <div class="field">
        <label>Teléfono / WhatsApp</label>
        <input type="text" name="phone" maxlength="80" value="<?=e((string)$customer['phone'])?>">
      </div>

      <div class="field">
        <label>RFC</label>
        <input type="text" name="tax_number" maxlength="80" value="<?=e((string)$customer['tax_number'])?>">
      </div>

      <div class="field">
        <label>País</label>
        <input type="text" name="country" maxlength="10" value="<?=e((string)$customer['country'])?>">
      </div>

      <div class="field full">
        <label>Dirección</label>
        <input type="text" name="address" maxlength="500" value="<?=e((string)$customer['address'])?>">
      </div>

      <div class="field">
        <label>Ciudad</label>
        <input type="text" name="city" maxlength="120" value="<?=e((string)$customer['city'])?>">
      </div>

      <div class="field">
        <label>Estado</label>
        <input type="text" name="state" maxlength="120" value="<?=e((string)$customer['state'])?>">
      </div>

      <div class="field">
        <label>Código postal</label>
        <input type="text" name="zip_code" maxlength="20" value="<?=e((string)$customer['zip_code'])?>">
      </div>

      <div class="field cw-active-field">
        <label>Estado del cliente</label>
        <label class="cw-check">
          <input type="checkbox" name="enabled" value="1" <?=((int)$customer['enabled']===1?'checked':'')?>>
          <span>Cliente activo</span>
        </label>
      </div>

      <div class="field full">
        <label>Notas internas</label>
        <textarea name="notes" rows="4"><?=e((string)$customer['notes'])?></textarea>
      </div>
    </div>

    <div class="form-actions cw-form-actions">
      <?=cancel_button('/admin/clientes.php' . ($q !== '' ? '?q=' . urlencode($q) : ''))?>
      <?=save_button($action === 'edit' ? 'Guardar cambios' : 'Crear cliente')?>
    </div>
  </form>
</div>

<?php else: ?>

<div class="toolbar cw-hero">
  <div class="toolbar-title">
    <span class="eyebrow">CLIENTES · DIRECTORIO</span>
    <h2>Clientes</h2>
    <span class="muted">Directorio maestro de clientes locales de Colibrí Print.</span>
  </div>
  <div class="toolbar-actions"><?=action_button('＋ Nuevo cliente','/admin/clientes.php?action=create','btn')?> </div>
</div>

<?php if($error): ?><div class="notice danger cw-notice"><?=e($error)?></div><?php endif; ?>
<?php if($success): ?><div class="notice cw-notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<div class="card cw-search-card">
  <form class="search-form cw-search" method="get">
    <input type="search" name="q" value="<?=e($q)?>" placeholder="Buscar nombre, teléfono, correo o RFC">
    <input type="hidden" name="page" value="1">
    <button class="btn btn-secondary" type="submit">Buscar</button>
    <?php if($q!==''): ?><?=cancel_button('/admin/clientes.php')?><?php endif; ?>
  </form>
</div>

<?php if (($akauntingSync['errors'] ?? 0) > 0): ?>
<div class="notice danger cw-notice">La sincronización de clientes con Akaunting está desactivada. El catálogo local es la única fuente.</div>
<?php endif; ?>

<div class="customer-stats cw-stats">
  <div class="card customer-stat">
    <span>Total <?= $q!=='' ? 'en búsqueda' : '' ?></span>
    <strong><?=number_format($totalCustomers)?></strong>
    <small>clientes visibles según el filtro</small>
  </div>
  <div class="card customer-stat">
    <span>Fuente de clientes</span>
    <strong>Local</strong>
    <small>catálogo maestro</small>
  </div>
  <div class="card customer-stat">
    <span>Locales</span>
    <strong><?=number_format($totalLocal)?></strong>
    <small>clientes creados en Colibrí Print</small>
  </div>
</div>

<div class="card table-wrap cw-directory">
  <div class="customers-table-head">
    <div>
      <strong>Directorio de clientes</strong>
      <span>Mostrando <?= $totalCustomers ? (($page-1)*$perPage+1) : 0 ?>–<?=min($page*$perPage,$totalCustomers)?> de <?=number_format($totalCustomers)?></span>
    </div>
    <form method="get" class="per-page-form">
      <?php if($q!==''): ?><input type="hidden" name="q" value="<?=e($q)?>"><?php endif; ?>
      <input type="hidden" name="page" value="1">
      <label>Mostrar
        <select name="per_page" onchange="this.form.submit()">
          <?php foreach([25,50,100] as $size): ?>
            <option value="<?=$size?>" <?=$perPage===$size?'selected':''?>><?=$size?></option>
          <?php endforeach; ?>
        </select>
        por página
      </label>
    </form>
  </div>

  <table class="table cw-table">
    <thead>
      <tr>
        <th>ID</th><th>Cliente</th><th>Origen</th><th>Teléfono</th><th>Correo</th>
        <th>Ubicación</th><th>Estado</th><th class="actions-cell">Acciones</th>
      </tr>
    </thead>
    <tbody>
    <?php foreach($rows as $r): ?>
      <tr>
        <td data-label="ID"><?=e((string)$r['id'])?></td>
        <td data-label="Cliente">
          <strong><?=e($r['name'])?></strong>
          <div class="muted cw-created">Alta: <?=e((string)$r['created_at'])?></div>
        </td>
        <td data-label="Origen">
          <span class="source-badge source-local">Local</span>
        </td>
        <td data-label="Teléfono"><?=e($r['phone'] ?: '—')?></td>
        <td data-label="Correo"><?=e($r['email'] ?: '—')?></td>
        <td data-label="Ubicación"><?=e(trim(($r['city']??'').' '.($r['state']??'')) ?: '—')?></td>
        <td data-label="Estado" class="<?=((int)$r['enabled']===1?'status-active':'status-inactive')?>">
          <span class="cw-status <?=((int)$r['enabled']===1?'is-active':'is-inactive')?>"><?=((int)$r['enabled']===1?'Activo':'Inactivo')?></span>
        </td>
        <td data-label="Acciones" class="actions-cell">
          <div class="actions">
            <?=edit_button('/admin/clientes.php?action=edit&id='.(int)$r['id'].($q!==''?'&q='.urlencode($q):'').'&page='.$page.'&per_page='.$perPage)?>
            <form method="post" class="cw-delete-form">
              <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
              <input type="hidden" name="form_action" value="delete">
              <input type="hidden" name="id" value="<?=e((string)$r['id'])?>">
              <button type="submit" class="btn btn-sm btn-delete" data-confirm="¿Borrar a <?=e($r['name'])?>? Esta acción no se puede deshacer.">Borrar</button>
            </form>
          </div>
        </td>
      </tr>
    <?php endforeach; ?>

    <?php if(!$rows): ?>
      <tr class="cw-empty-row">
        <td colspan="8" class="empty">
          No se encontraron clientes.<?= $q!=='' ? ' Prueba otra búsqueda o crea un nuevo cliente.' : '' ?>
          <div class="empty-action"><?=action_button('Crear cliente','/admin/clientes.php?action=create','btn btn-sm')?></div>
        </td>
      </tr>
    <?php endif; ?>
    </tbody>
  </table>

  <?php if($totalPages>1): ?>
  <nav class="customer-pagination" aria-label="Paginación de clientes">
    <?php
      $startPage=max(1,$page-2);
      $endPage=min($totalPages,$page+2);
      $paginationUrl=function(int $p) use ($q,$perPage): string {
          $params=['page'=>$p,'per_page'=>$perPage];
          if($q!=='') $params['q']=$q;
          return '/admin/clientes.php?'.http_build_query($params);
      };
    ?>
    <a class="page-btn <?=$page===1?'disabled':''?>" href="<?=$page===1?'#':e($paginationUrl(1))?>">«</a>
    <a class="page-btn <?=$page===1?'disabled':''?>" href="<?=$page===1?'#':e($paginationUrl($page-1))?>">‹</a>
    <?php if($startPage>1): ?><span class="page-gap">…</span><?php endif; ?>
    <?php for($p=$startPage;$p<=$endPage;$p++): ?>
      <a class="page-btn <?=$p===$page?'active':''?>" href="<?=e($paginationUrl($p))?>"><?=$p?></a>
    <?php endfor; ?>
    <?php if($endPage<$totalPages): ?><span class="page-gap">…</span><?php endif; ?>
    <a class="page-btn <?=$page===$totalPages?'disabled':''?>" href="<?=$page===$totalPages?'#':e($paginationUrl($page+1))?>">›</a>
    <a class="page-btn <?=$page===$totalPages?'disabled':''?>" href="<?=$page===$totalPages?'#':e($paginationUrl($totalPages))?>">»</a>
  </nav>
  <?php endif; ?>
</div>
<?php endif; ?>

</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
