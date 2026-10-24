<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Mercado Pago · Instalación V1';
$root = dirname(__DIR__);
$trackingPath = $root . '/seguimiento.php';
$migrationPath = $root . '/database/sql/023_mercadopago_checkout.sql';

$error = null;
$messages = [];

function mpv1_table_exists(string $table): bool
{
    try {
        $st=db()->prepare('SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?');
        $st->execute([$table]);
        return (int)$st->fetchColumn()>0;
    } catch(Throwable $e) { return false; }
}

function mpv1_install_schema(): void
{
    if (mpv1_table_exists('cp_mercadopago_orders')) return;

    db()->exec(
        "CREATE TABLE IF NOT EXISTS cp_mercadopago_orders (
            id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
            order_id INT NOT NULL,
            customer_id INT NULL,
            external_reference VARCHAR(64) NOT NULL,
            return_token CHAR(64) NOT NULL,
            tracking_token_hash CHAR(64) NULL,
            idempotency_key CHAR(36) NOT NULL,
            mp_order_id VARCHAR(96) NULL,
            amount DECIMAL(12,2) NOT NULL,
            currency CHAR(3) NOT NULL DEFAULT 'MXN',
            status VARCHAR(40) NOT NULL DEFAULT 'creating',
            status_detail VARCHAR(100) NULL,
            checkout_url TEXT NULL,
            mp_payment_id VARCHAR(96) NULL,
            payment_method_id VARCHAR(60) NULL,
            payment_method_type VARCHAR(60) NULL,
            cp_payment_id INT NULL,
            live_mode TINYINT(1) NULL,
            error_message VARCHAR(500) NULL,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            paid_at DATETIME NULL,
            last_webhook_at DATETIME NULL,
            PRIMARY KEY (id),
            UNIQUE KEY uq_mp_external_reference (external_reference),
            UNIQUE KEY uq_mp_return_token (return_token),
            UNIQUE KEY uq_mp_idempotency_key (idempotency_key),
            UNIQUE KEY uq_mp_order_id (mp_order_id),
            UNIQUE KEY uq_mp_payment_id (mp_payment_id),
            UNIQUE KEY uq_mp_cp_payment_id (cp_payment_id),
            KEY idx_mp_order_created (order_id,created_at),
            KEY idx_mp_status_updated (status,updated_at)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
    );
}

function mpv1_atomic_write(string $path,string $content):void
{
    $tmp=$path.'.mpv1.tmp';
    if(file_put_contents($tmp,$content,LOCK_EX)===false)throw new RuntimeException('No se pudo escribir seguimiento.php.');
    $perms=@fileperms($path);if($perms!==false)@chmod($tmp,$perms&0777);
    if(!rename($tmp,$path)){@unlink($tmp);throw new RuntimeException('No se pudo reemplazar seguimiento.php.');}
}

function mpv1_patch_tracking(string $src): string
{
    if (!str_contains($src, "includes/mercadopago.php")) {
        $anchor = "require_once __DIR__ . '/includes/company.php';";
        if (!str_contains($src,$anchor)) throw new RuntimeException('seguimiento.php: no se encontró include company.php.');
        $src = str_replace($anchor,$anchor."\nrequire_once __DIR__ . '/includes/mercadopago.php';",$src);
    }

    if (!str_contains($src, 'mercadopago-tracking-v1.css')) {
        $anchor = '<style>';
        $pos = strpos($src,$anchor);
        if ($pos===false) throw new RuntimeException('seguimiento.php: no se encontró <style>.');
        $link = '<link rel="stylesheet" href="/assets/css/mercadopago-tracking-v1.css?v=1.0.0">'."\n";
        $src = substr($src,0,$pos).$link.substr($src,$pos);
    }

    if (!str_contains($src, 'SISACT_MERCADOPAGO_TRACKING_V1')) {
        $anchor = '<section class="tracking-receipt">';
        $pos = strpos($src,$anchor);
        if ($pos===false) throw new RuntimeException('seguimiento.php: no se encontró tracking-receipt.');

        $block = <<<'HTML'
<?php
/* SISACT_MERCADOPAGO_TRACKING_V1 */
$mpPublic = $order
    ? mp_public_context((int)$order['id'], $finance)
    : ['configured'=>false,'ready'=>false,'balance'=>0.0,'show'=>false];
?>
<?php if ($mpPublic['show']): ?>
<section class="mp-pay-card" id="pagar-mercadopago">
  <div class="mp-pay-head">
    <div>
      <span class="eyebrow">PAGO EN LÍNEA</span>
      <h2>Paga tu orden con Mercado Pago</h2>
      <p>Realiza el pago del saldo pendiente en el entorno seguro de Mercado Pago. Al acreditarse, SISACT registrará el pago automáticamente.</p>
    </div>
    <span class="mp-pay-badge">MERCADO PAGO</span>
  </div>
  <div class="mp-pay-body">
    <div class="mp-pay-amount">
      <span>Saldo a pagar</span>
      <strong><?=track_money((float)$mpPublic['balance'])?></strong>
    </div>
    <form class="mp-pay-form" action="/mercadopago_iniciar.php" method="post">
      <input type="hidden" name="tracking_token" value="<?=track_e($token)?>">
      <button class="mp-pay-button" type="submit">Pagar con Mercado Pago →</button>
    </form>
  </div>
  <?php if (!empty($_GET['mp_error'])): ?>
    <div class="mp-pay-error"><?=track_e((string)$_GET['mp_error'])?></div>
  <?php endif; ?>
  <p class="mp-pay-security">El monto se recalcula en el servidor antes de iniciar el checkout. El pago solo se registra cuando Mercado Pago confirma la acreditación.</p>
</section>
<?php endif; ?>

HTML;
        $src = substr($src,0,$pos).$block.substr($src,$pos);
    }

    return $src;
}

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null))$error='La sesión expiró. Recarga la página.';
    else{
        try{
            $action=(string)($_POST['action']??'');
            if($action==='install'){
                if(!is_file($trackingPath))throw new RuntimeException('No se encontró seguimiento.php.');
                $src=(string)file_get_contents($trackingPath);
                $patched=mpv1_patch_tracking($src);

                $backup=$trackingPath.'.bak_mercadopago_v1';
                if(!is_file($backup)&&!copy($trackingPath,$backup))throw new RuntimeException('No se pudo respaldar seguimiento.php.');

                mpv1_install_schema();
                mpv1_atomic_write($trackingPath,$patched);

                $messages[]='Tabla cp_mercadopago_orders lista.';
                $messages[]='Botón Mercado Pago agregado a Seguimiento.';
                $messages[]='Ahora configura tus credenciales privadas.';
            }elseif($action==='revert'){
                $backup=$trackingPath.'.bak_mercadopago_v1';
                if(!is_file($backup))throw new RuntimeException('No existe el respaldo V1.');
                if(!copy($backup,$trackingPath))throw new RuntimeException('No se pudo restaurar seguimiento.php.');
                $messages[]='seguimiento.php restaurado. La tabla y transacciones no se eliminaron.';
            }
        }catch(Throwable $e){$error=$e->getMessage();}
    }
}

require __DIR__ . '/../includes/header.php';
?>
<div class="card" style="max-width:940px;margin:20px auto;padding:22px">
<span class="eyebrow">MERCADO PAGO · CHECKOUT PRO</span>
<h2>Pago desde Seguimiento · V1</h2>
<p class="muted">Usa la Orders API moderna de Mercado Pago. No almacena datos de tarjeta en SISACT.</p>
<?php if($error):?><div class="notice danger"><?=e($error)?></div><?php endif;?>
<?php foreach($messages as $m):?><div class="notice"><?=e($m)?></div><?php endforeach;?>
<div style="display:flex;gap:10px;flex-wrap:wrap;margin:18px 0">
<form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><button class="btn btn-primary" type="submit" name="action" value="install">Instalar Mercado Pago V1</button></form>
<a class="btn btn-secondary" href="/admin/mercadopago_configurar.php">Configurar credenciales</a>
<form method="post"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><button class="btn btn-secondary" type="submit" name="action" value="revert" onclick="return confirm('¿Restaurar seguimiento.php?');">Revertir interfaz</button></form>
</div>
<p class="muted">Tabla 023: <strong><?=mpv1_table_exists('cp_mercadopago_orders')?'✓ instalada':'pendiente'?></strong> · cURL: <strong><?=function_exists('curl_init')?'✓ disponible':'NO disponible'?></strong></p>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
