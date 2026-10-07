<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();
if ($_SERVER['REQUEST_METHOD'] !== 'POST' || !csrf_check($_POST['_csrf'] ?? null)) { http_response_code(419); exit('Sesión expirada.'); }
$db=db(); $type=(string)($_POST['type']??''); $id=(int)($_POST['id']??0);
$tables=['size'=>'cp_print_sizes','material'=>'cp_print_materials','finish'=>'cp_print_finishes'];
$fields=['size'=>'size_id','material'=>'material_id','finish'=>'finish_id'];
try {
 if($id<1 || !isset($tables[$type])) throw new RuntimeException('Registro inválido.');
 $field=$fields[$type];
 $refs=0;
 foreach (['cp_print_prices','cp_print_price_rules','cp_print_request_items'] as $table) {
   try { $st=$db->prepare("SELECT COUNT(*) FROM `{$table}` WHERE `{$field}`=?"); $st->execute([$id]); $refs+=(int)$st->fetchColumn(); } catch(Throwable $ignored) {}
 }
 if($refs>0){
   $st=$db->prepare("UPDATE `{$tables[$type]}` SET enabled=0, updated_at=NOW() WHERE id=?"); $st->execute([$id]);
   log_activity('update','print_pricing','Catálogo de impresión desactivado por historial: '.$type.' #'.$id);
   redirect('/admin/impresion_precios.php?ok='.rawurlencode('Tiene historial asociado, por seguridad se desactivó en lugar de eliminarse.'));
 }
 $st=$db->prepare("DELETE FROM `{$tables[$type]}` WHERE id=?"); $st->execute([$id]);
 log_activity('delete','print_pricing','Catálogo de impresión eliminado: '.$type.' #'.$id);
 redirect('/admin/impresion_precios.php?ok='.rawurlencode('Registro eliminado correctamente.'));
} catch(Throwable $e){ redirect('/admin/impresion_precios.php?error='.rawurlencode($e->getMessage())); }
