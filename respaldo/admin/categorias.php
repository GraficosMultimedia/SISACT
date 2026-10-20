<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();
$title='Categorías'; $pdo=db(); $error=null; $success=null;
$action=(string)($_GET['action']??'list'); $id=(int)($_GET['id']??0); $q=trim((string)($_GET['q']??''));
$cat=['name'=>'','sort_order'=>0,'enabled'=>1];
if($_SERVER['REQUEST_METHOD']==='POST'){
  $form=(string)($_POST['form_action']??'');
  if(!csrf_check($_POST['_csrf']??null)){ $error='La sesión del formulario expiró. Recarga la página.'; $action=$form==='save'&&((int)($_POST['id']??0)>0)?'edit':'create'; $id=(int)($_POST['id']??0); }
  elseif($form==='delete'){
    $id=(int)($_POST['id']??0);
    try{
      $check=$pdo->prepare('SELECT COUNT(*) FROM cp_products WHERE category_id=?'); $check->execute([$id]);
      if((int)$check->fetchColumn()>0) throw new RuntimeException('No se puede borrar una categoría que tiene productos asociados.');
      $stmt=$pdo->prepare('DELETE FROM cp_categories WHERE id=?'); $stmt->execute([$id]);
      log_activity('delete','categories','Categoría #'.$id.' eliminada'); redirect('/admin/categorias.php?deleted=1');
    }catch(Throwable $e){$error=$e->getMessage();$action='list';}
  } elseif($form==='save'){
    $id=(int)($_POST['id']??0); $cat=['name'=>trim((string)($_POST['name']??'')),'sort_order'=>(int)($_POST['sort_order']??0),'enabled'=>isset($_POST['enabled'])?1:0]; $action=$id>0?'edit':'create';
    if($cat['name']==='') $error='El nombre es obligatorio.'; else try{
      if($id>0){$s=$pdo->prepare('UPDATE cp_categories SET name=?,sort_order=?,enabled=?,updated_at=NOW() WHERE id=?');$s->execute([$cat['name'],$cat['sort_order'],$cat['enabled'],$id]);log_activity('update','categories','Categoría #'.$id.' actualizada');redirect('/admin/categorias.php?saved=updated');}
      else {$s=$pdo->prepare("INSERT INTO cp_categories(name,type,enabled,sort_order,created_at,updated_at) VALUES (?, 'product', ?, ?, NOW(), NOW())");$s->execute([$cat['name'],$cat['enabled'],$cat['sort_order']]);$new=(int)$pdo->lastInsertId();log_activity('create','categories','Categoría #'.$new.' creada');redirect('/admin/categorias.php?saved=created');}
    }catch(Throwable $e){$error='No se pudo guardar la categoría: '.$e->getMessage();}
  }
}
if(isset($_GET['deleted']))$success='Categoría eliminada correctamente.';
if(($_GET['saved']??'')==='created')$success='Categoría creada correctamente.';
if(($_GET['saved']??'')==='updated')$success='Categoría actualizada correctamente.';
if($action==='edit'&&$id>0&&$_SERVER['REQUEST_METHOD']!=='POST'){ $s=$pdo->prepare('SELECT * FROM cp_categories WHERE id=?');$s->execute([$id]);$found=$s->fetch();if(!$found){$error='La categoría no existe.';$action='list';}else{$cat=array_merge($cat,$found);} }
$rows=[];if($action==='list'){if($q!==''){$s=$pdo->prepare('SELECT c.*,COUNT(p.id) product_count FROM cp_categories c LEFT JOIN cp_products p ON p.category_id=c.id WHERE c.name LIKE ? GROUP BY c.id ORDER BY c.sort_order,c.name');$s->execute(['%'.$q.'%']);$rows=$s->fetchAll();}else{$rows=$pdo->query('SELECT c.*,COUNT(p.id) product_count FROM cp_categories c LEFT JOIN cp_products p ON p.category_id=c.id GROUP BY c.id ORDER BY c.sort_order,c.name')->fetchAll();}}
require __DIR__.'/../includes/header.php';
?>
<?php if($action==='create'||$action==='edit'): ?>
<div class="toolbar"><div class="toolbar-title"><span class="eyebrow">FASE 3 · CATÁLOGO</span><h2><?= $action==='edit'?'Editar categoría':'Nueva categoría' ?></h2></div><div class="toolbar-actions"><?=cancel_button('/admin/categorias.php')?></div></div>
<?php if($error): ?><div class="notice danger" style="margin-bottom:14px"><?=e($error)?></div><?php endif; ?>
<div class="card form-card"><form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="form_action" value="save"><input type="hidden" name="id" value="<?=e((string)$id)?>"><div class="form-grid"><div class="field full"><label>Nombre <span class="required">*</span></label><input data-auto-focus name="name" maxlength="150" value="<?=e((string)$cat['name'])?>" required></div><div class="field"><label>Orden</label><input type="number" name="sort_order" value="<?=e((string)$cat['sort_order'])?>"></div><div class="field"><label>Estado</label><label style="display:flex;align-items:center;gap:8px"><input type="checkbox" name="enabled" value="1" <?=((int)$cat['enabled']===1?'checked':'')?> style="width:auto"> Activa</label></div></div><div class="form-actions"><?=cancel_button('/admin/categorias.php')?><?=save_button($action==='edit'?'Guardar cambios':'Crear categoría')?></div></form></div>
<?php else: ?>
<div class="toolbar"><div class="toolbar-title"><span class="eyebrow">FASE 3 · CATÁLOGO</span><h2>Categorías</h2><span class="muted">Organización del catálogo propio de Colibrí Print.</span></div><div class="toolbar-actions"><?=action_button('Nueva categoría','/admin/categorias.php?action=create','btn')?></div></div>
<?php if($error): ?><div class="notice danger" style="margin-bottom:14px"><?=e($error)?></div><?php endif; ?><?php if($success): ?><div class="notice" style="margin-bottom:14px"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>
<div class="card" style="margin-bottom:14px"><form class="search-form" method="get"><input type="search" name="q" value="<?=e($q)?>" placeholder="Buscar categoría"><button class="btn btn-secondary">Buscar</button><?php if($q!==''): ?><?=cancel_button('/admin/categorias.php')?><?php endif; ?></form></div>
<div class="card table-wrap"><table class="table"><thead><tr><th>ID</th><th>Categoría</th><th>Productos</th><th>Orden</th><th>Estado</th><th class="actions-cell">Acciones</th></tr></thead><tbody><?php foreach($rows as $r): ?><tr><td><?=e((string)$r['id'])?></td><td><strong><?=e($r['name'])?></strong></td><td><?=e((string)$r['product_count'])?></td><td><?=e((string)$r['sort_order'])?></td><td class="<?=((int)$r['enabled']===1?'status-active':'status-inactive')?>"><?=((int)$r['enabled']===1?'Activa':'Inactiva')?></td><td class="actions-cell"><div class="actions"><?=edit_button('/admin/categorias.php?action=edit&id='.(int)$r['id'])?><form method="post" style="display:inline;margin:0"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="form_action" value="delete"><input type="hidden" name="id" value="<?=e((string)$r['id'])?>"><button class="btn btn-sm btn-delete" type="submit" data-confirm="¿Borrar la categoría <?=e($r['name'])?>?">Borrar</button></form></div></td></tr><?php endforeach; ?><?php if(!$rows): ?><tr><td colspan="6" class="empty">No hay categorías.</td></tr><?php endif; ?></tbody></table></div>
<?php endif; ?><?php require __DIR__.'/../includes/footer.php'; ?>
