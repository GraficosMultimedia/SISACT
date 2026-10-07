<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/tiktok.php';
require_auth();

$title = 'TikTok';
$error = null;
$success = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        if (!csrf_check($_POST['_csrf'] ?? null)) {
            throw new RuntimeException('La sesión del formulario expiró. Recarga la página.');
        }

        $action = (string)($_POST['form_action'] ?? '');

        if ($action === 'save') {
            tiktok_set('enabled', isset($_POST['enabled']) ? '1' : '0');
            tiktok_set('client_key', trim((string)($_POST['client_key'] ?? '')));
            tiktok_set('client_secret', trim((string)($_POST['client_secret'] ?? '')));
            tiktok_set('redirect_uri', trim((string)($_POST['redirect_uri'] ?? '')));
            tiktok_set('scopes', trim((string)($_POST['scopes'] ?? 'user.info.basic,video.publish')));
            log_activity('update', 'tiktok', 'Configuración de TikTok actualizada');
            $success = 'Configuración de TikTok guardada.';
        } elseif ($action === 'disconnect') {
            tiktok_clear_connection();
            log_activity('update', 'tiktok', 'Cuenta de TikTok desconectada');
            $success = 'Cuenta de TikTok desconectada.';
        } elseif ($action === 'refresh') {
            if (!tiktok_connected()) throw new RuntimeException('No hay una cuenta de TikTok conectada.');
            if (!tiktok_refresh_access_token()) throw new RuntimeException('No se pudo renovar el token de TikTok.');
            tiktok_creator_info();
            $success = 'Conexión de TikTok renovada y validada.';
        }
    } catch (Throwable $e) {
        $error = $e->getMessage();
    }
}

$authorizeState = bin2hex(random_bytes(24));
$_SESSION['tiktok_oauth_state'] = $authorizeState;

$connected = tiktok_connected();
$configured = tiktok_configured();

if ($connected) {
    try {
        tiktok_creator_info();
    } catch (Throwable $e) {
        $error = $error ?: $e->getMessage();
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/tiktok.css?v=20260920-1">

<div class="ttk-toolbar">
  <div>
    <span class="eyebrow">COMUNICACIÓN · TIKTOK</span>
    <h2>Publicación de contenido</h2>
    <p class="muted">Conecta la cuenta de TikTok y publica videos desde el administrador.</p>
  </div>
  <div class="ttk-actions">
    <?php if ($connected): ?>
      <form method="post">
        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
        <input type="hidden" name="form_action" value="refresh">
        <button class="btn btn-secondary" type="submit">↻ Renovar conexión</button>
      </form>
      <form method="post">
        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
        <input type="hidden" name="form_action" value="disconnect">
        <button class="btn btn-delete" type="submit" data-confirm="¿Desconectar la cuenta de TikTok?">Desconectar</button>
      </form>
    <?php elseif ($configured): ?>
      <a class="btn" href="<?=e(tiktok_authorize_url($authorizeState))?>">Conectar con TikTok</a>
    <?php endif; ?>
  </div>
</div>

<?php if ($error): ?><div class="notice danger ttk-notice"><?=e($error)?></div><?php endif; ?>
<?php if ($success): ?><div class="notice ttk-notice"><span class="ok">✓</span> <?=e($success)?></div><?php endif; ?>

<div class="ttk-grid">
<section class="card">
  <div class="section-label">Cuenta</div>

  <?php if ($connected): ?>
    <div class="ttk-account">
      <?php $avatar = tiktok_setting('avatar_url'); ?>
      <?php if ($avatar): ?><img class="ttk-avatar" src="<?=e($avatar)?>" alt=""><?php else: ?><div class="ttk-avatar ttk-avatar-fallback">TT</div><?php endif; ?>
      <div>
        <strong>@<?=e(tiktok_setting('username', 'tiktok'))?></strong>
        <small><?=e(tiktok_setting('display_name', 'Cuenta conectada'))?></small>
      </div>
      <span class="ttk-status ttk-status-ok">Conectada</span>
    </div>

    <div class="ttk-info">
      <div><span>Open ID</span><strong><?=e(tiktok_setting('open_id'))?></strong></div>
      <div><span>Token</span><strong>Guardado en servidor</strong></div>
    </div>
  <?php else: ?>
    <div class="ttk-empty">
      <div class="ttk-icon">♪</div>
      <h3>Cuenta no conectada</h3>
      <p>Primero completa la configuración de la app y después autoriza la cuenta de TikTok.</p>
      <?php if (!$configured): ?><span class="ttk-chip">Faltan credenciales de la app</span><?php endif; ?>
    </div>
  <?php endif; ?>
</section>

<section class="card">
  <div class="section-label">Aplicación TikTok</div>
  <form method="post">
    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
    <input type="hidden" name="form_action" value="save">

    <div class="form-grid">
      <div class="field full">
        <label><input type="checkbox" name="enabled" value="1" <?=tiktok_enabled()?'checked':''?>> Integración TikTok habilitada</label>
        <span class="help">El acceso se mantiene deshabilitado hasta que termines la configuración.</span>
      </div>
      <div class="field">
        <label>Client Key</label>
        <input name="client_key" value="<?=e(tiktok_setting('client_key'))?>" autocomplete="off">
      </div>
      <div class="field">
        <label>Client Secret</label>
        <input type="password" name="client_secret" value="" autocomplete="new-password" placeholder="<?=tiktok_setting('client_secret') !== '' ? 'Guardado. Deja vacío para conservarlo.' : 'Pega el Client Secret'?>">
      </div>
      <div class="field full">
        <label>Redirect URI</label>
        <input type="url" name="redirect_uri" value="<?=e(tiktok_redirect_uri())?>" placeholder="https://colibriprint.com.mx/api/tiktok/callback.php">
      </div>
      <div class="field full">
        <label>Scopes</label>
        <input name="scopes" value="<?=e(tiktok_scopes())?>">
        <span class="help">Para publicación directa: user.info.basic,video.publish. TikTok debe aprobar los scopes usados por la aplicación.</span>
      </div>
    </div>

    <div class="form-actions">
      <button class="btn btn-save" type="submit">Guardar configuración</button>
    </div>
  </form>
</section>
</div>

<div class="card ttk-guide-card">
  <div class="section-label">Preparación en TikTok for Developers</div>
  <ol class="ttk-steps">
    <li>Crear o abrir la aplicación en TikTok for Developers.</li>
    <li>Agregar <strong>Login Kit</strong> y <strong>Content Posting API</strong>.</li>
    <li>Registrar exactamente la Redirect URI HTTPS que aparece aquí.</li>
    <li>Solicitar/usar el scope <strong>video.publish</strong> para publicación directa.</li>
    <li>Verificar el dominio de los videos si se utilizará <strong>PULL_FROM_URL</strong>.</li>
    <li>Probar primero con la cuenta conectada antes de activar un flujo automático.</li>
  </ol>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
