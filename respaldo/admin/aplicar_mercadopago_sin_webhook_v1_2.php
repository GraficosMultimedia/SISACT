<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title='Mercado Pago · Sin Webhook V1.2';
$root=dirname(__DIR__);
$trackingPath=$root.'/seguimiento.php';

$error=null;
$messages=[];

function mp12_write(string $path,string $content):void
{
    $tmp=$path.'.mp12.tmp';

    if(file_put_contents($tmp,$content,LOCK_EX)===false){
        throw new RuntimeException('No se pudo escribir seguimiento.php.');
    }

    $perms=@fileperms($path);
    if($perms!==false)@chmod($tmp,$perms&0777);

    if(!rename($tmp,$path)){
        @unlink($tmp);
        throw new RuntimeException('No se pudo reemplazar seguimiento.php.');
    }
}

function mp12_patch(string $src):string
{
    if(str_contains($src,'SISACT_MERCADOPAGO_POLLING_V1_2')){
        return $src;
    }

    if(!str_contains($src,"includes/mercadopago.php")){
        $anchor="require_once __DIR__ . '/includes/company.php';";
        if(!str_contains($src,$anchor)){
            throw new RuntimeException('seguimiento.php: no se encontró company.php.');
        }
        $src=str_replace(
            $anchor,
            $anchor."\nrequire_once __DIR__ . '/includes/mercadopago.php';",
            $src
        );
    }

    $patterns=[
        '$finance = tracking_payment_summary((int)$order[\'id\']);',
        '$finance=tracking_payment_summary((int)$order[\'id\']);',
    ];

    $anchor=null;
    foreach($patterns as $p){
        if(str_contains($src,$p)){
            $anchor=$p;
            break;
        }
    }

    if($anchor===null){
        throw new RuntimeException(
            'seguimiento.php: no se encontró tracking_payment_summary() para insertar la sincronización.'
        );
    }

    $insert=<<<'PHP'
/* SISACT_MERCADOPAGO_POLLING_V1_2 */
if ($order && function_exists('mp_sync_pending_for_order')) {
    mp_sync_pending_for_order((int)$order['id'], 20);
}

PHP;

    return str_replace($anchor,$insert.$anchor,$src);
}

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null)){
        $error='La sesión expiró. Recarga la página.';
    }else{
        try{
            $action=(string)($_POST['action']??'');

            if($action==='install'){
                if(!is_file($trackingPath)){
                    throw new RuntimeException('No se encontró seguimiento.php.');
                }

                $src=(string)file_get_contents($trackingPath);
                $patched=mp12_patch($src);

                $backup=$trackingPath.'.bak_mercadopago_polling_v1_2';

                if(!is_file($backup)&&!copy($trackingPath,$backup)){
                    throw new RuntimeException('No se pudo respaldar seguimiento.php.');
                }

                mp12_write($trackingPath,$patched);

                $messages[]='Sincronización por API instalada en Seguimiento.';
                $messages[]='La integración ya no depende de Webhooks.';
            }

            if($action==='revert'){
                $backup=$trackingPath.'.bak_mercadopago_polling_v1_2';

                if(!is_file($backup)){
                    throw new RuntimeException('No existe el respaldo V1.2.');
                }

                if(!copy($backup,$trackingPath)){
                    throw new RuntimeException('No se pudo restaurar seguimiento.php.');
                }

                $messages[]='seguimiento.php restaurado.';
            }
        }catch(Throwable $e){
            $error=$e->getMessage();
        }
    }
}

require __DIR__ . '/../includes/header.php';
?>
<div class="card" style="max-width:940px;margin:20px auto;padding:22px">
<span class="eyebrow">MERCADO PAGO · SIN WEBHOOK</span>
<h2>Corrección V1.2</h2>

<p class="muted">
Corrige el payload de Checkout Pro Orders y sincroniza pagos mediante
<code>GET /v1/orders/{id}</code>.
</p>

<?php if($error):?><div class="notice danger"><?=e($error)?></div><?php endif;?>
<?php foreach($messages as $m):?><div class="notice"><?=e($m)?></div><?php endforeach;?>

<form method="post" style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px">
<input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
<button class="btn btn-primary" type="submit" name="action" value="install">Aplicar V1.2 sin Webhook</button>
<a class="btn btn-secondary" href="/admin/mercadopago_configurar.php">Configurar Mercado Pago</a>
<button class="btn btn-secondary" type="submit" name="action" value="revert">Revertir</button>
</form>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
