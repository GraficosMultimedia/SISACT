<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/facebook.php';
require_auth();

$title = 'Facebook';
$error = null;
$success = null;
$test = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        if (!csrf_check($_POST['_csrf'] ?? null)) throw new RuntimeException('La sesión del formulario expiró. Recarga la página.');
        $action = (string)($_POST['form_action'] ?? 'save');
        if ($action === 'save') {
            setting_set('facebook.enabled', isset($_POST['enabled']) ? '1' : '0');
            setting_set('facebook.auto_publish', isset($_POST['auto_publish']) ? '1' : '0');
            setting_set('facebook.page_id', trim((string)($_POST['page_id'] ?? '')));
            setting_set('facebook.graph_version', trim((string)($_POST['graph_version'] ?? 'v26.0')));
            setting_set('facebook.public_base_url', trim((string)($_POST['public_base_url'] ?? '')));
            $clear = isset($_POST['clear_token']);
            $token = trim((string)($_POST['page_access_token'] ?? ''));
            if ($clear) setting_set('facebook.page_access_token', '');
            elseif ($token !== '') setting_set('facebook.page_access_token', $token);
            log_activity('update','facebook','Configuración de publicación automática de Facebook actualizada');
            $success = 'Configuración de Facebook guardada.';
        } elseif ($action === 'test') {
            $test = facebook_test_connection();
            if ($test['ok']) $success = 'Conexión correcta con la Página de Facebook: ' . (string)($test['data']['name'] ?? $test['data']['id'] ?? 'OK');
            else $error = (string)($test['data']['error']['message'] ?? $test['data']['error'] ?? 'No se pudo validar la conexión.');
        }
    } catch (Throwable $e) { $error = $e->getMessage(); }
}

$token = facebook_setting('page_access_token');
$tokenMasked = $token === '' ? '' : str_repeat('•', max(8, min(28, strlen($token))));
require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/promociones.css?v=20260919-facebook-1">
<div class="promo-toolbar"><div><span class="eyebrow">PUBLICACIÓN SOCIAL</span><h2>Facebook automático</h2><p class="muted">Conecta la Página de Facebook de Colibrí Print para publicar promociones desde el administrador.</p></div><div class="toolbar-actions"><a class="btn btn-secondary" href="/admin/promociones.php">← Promociones</a></div></div>
<?php if($error): ?><div class="notice danger" style="margin-bottom:14px"><?=e($error)?></div><?php endif; ?>
<?php if($success): ?><div class="notice" style="margin-bottom:14px"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>
<div class="promo-edit-grid">
<section class="card">
<div class="section-label">Configuración</div>
<form method="post">
<input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
<input type="hidden" name="form_action" value="save">
<div class="form-grid">
<div class="field full"><label><input type="checkbox" name="enabled" value="1" <?=facebook_is_enabled()?'checked':''?>> Integración Facebook habilitada</label><span class="help">Actívala después de validar la Página y el token.</span></div>
<div class="field full"><label><input type="checkbox" name="auto_publish" value="1" <?=facebook_auto_publish_enabled()?'checked':''?>> Publicación automática de promociones</label><span class="help">Una promoción marcada para Facebook se publica cuando está Activa y vigente.</span></div>
<div class="field"><label>ID de Página</label><input name="page_id" value="<?=e(facebook_setting('page_id'))?>" placeholder="Ej. 123456789012345"></div>
<div class="field"><label>Versión Graph API</label><input name="graph_version" value="<?=e(facebook_graph_version())?>" pattern="v\d+\.\d+" required></div>
<div class="field full"><label>Page Access Token</label><input type="password" name="page_access_token" value="" autocomplete="new-password" placeholder="<?=e($tokenMasked ?: 'Pega aquí el token de acceso de Página')?>"><span class="help"><?= $tokenMasked ? 'Token guardado. Déjalo vacío para conservarlo.' : 'Se requiere para publicar en la Página.' ?></span></div>
<div class="field full"><label><input type="checkbox" name="clear_token" value="1"> Borrar token guardado</label></div>
<div class="field full"><label>URL pública para Facebook</label><input type="url" name="public_base_url" value="<?=e(facebook_base_url())?>" placeholder="https://colibriprint.com.mx"><span class="help">Facebook necesita poder acceder públicamente a la imagen de la promoción.</span></div>
</div>
<div class="form-actions"><button class="btn" type="submit">Guardar configuración</button></div>
</form>
</section>
<section class="card">
<div class="section-label">Estado</div>
<p><strong>Integración:</strong> <?=facebook_is_enabled()?'Habilitada':'Deshabilitada'?></p>
<p><strong>Auto-publicación:</strong> <?=facebook_auto_publish_enabled()?'Activa':'Desactivada'?></p>
<p><strong>Página:</strong> <?=e(facebook_setting('page_id') ?: 'No configurada')?></p>
<p><strong>Token:</strong> <?=$tokenMasked!==''?'Guardado':'No configurado'?></p>
<form method="post" style="margin-top:18px"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="form_action" value="test"><button class="btn btn-secondary" type="submit">🔎 Probar conexión con Facebook</button></form>
</section>
</div>

<div class="card" style="margin-top:14px">
<div class="section-label">Cómo queda el flujo</div>
<p>1. Creas una promoción en <strong>Promociones</strong>.</p>
<p>2. La dejas en <strong>Activa</strong> y habilitada para Facebook.</p>
<p>3. Colibrí Print genera el texto, toma la imagen de campaña y publica en la Página.</p>
<p>4. El sistema guarda el ID de Facebook y evita publicar la misma promoción dos veces.</p>
<p>5. Las promociones futuras quedan pendientes hasta su fecha de inicio y pueden salir mediante el cron de cPanel.</p>
</div>
<?php require __DIR__.'/../includes/footer.php'; ?>
