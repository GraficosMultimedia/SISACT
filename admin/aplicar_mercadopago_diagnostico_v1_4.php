<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title='Mercado Pago · Diagnóstico V1.4';

$error=null;
$messages=[];

function mp14_column_type(): string
{
    try {
        $st = db()->query(
            "SHOW COLUMNS
             FROM cp_mercadopago_orders
             LIKE 'error_message'"
        );

        $row = $st->fetch();

        return strtolower(
            (string)($row['Type'] ?? '')
        );
    } catch (Throwable $e) {
        return '';
    }
}

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null)){
        $error='La sesión expiró.';
    }else{
        try{
            if(
                (string)($_POST['action']??'')
                === 'install'
            ){
                $type = mp14_column_type();

                if($type===''){
                    throw new RuntimeException(
                        'No se encontró '
                        .'cp_mercadopago_orders.error_message.'
                    );
                }

                if(
                    !str_contains(
                        $type,
                        'text'
                    )
                ){
                    db()->exec(
                        "ALTER TABLE cp_mercadopago_orders
                         MODIFY error_message TEXT NULL"
                    );

                    $messages[]=
                        'error_message ampliado a TEXT.';
                }else{
                    $messages[]=
                        'error_message ya permite diagnóstico largo.';
                }

                $messages[]=
                    'V1.4 lista para nueva prueba.';
            }
        }catch(Throwable $e){
            $error=$e->getMessage();
        }
    }
}

$type=mp14_column_type();

require __DIR__ . '/../includes/header.php';
?>

<div
class="card"
style="max-width:900px;margin:20px auto;padding:22px"
>

<span class="eyebrow">
MERCADO PAGO
</span>

<h2>
Diagnóstico persistente · V1.4
</h2>

<p class="muted">
Amplía el campo de error para conservar
la respuesta completa de Mercado Pago.
</p>

<?php if($error):?>
<div class="notice danger">
<?=e($error)?>
</div>
<?php endif;?>

<?php foreach($messages as $message):?>
<div class="notice">
<?=e($message)?>
</div>
<?php endforeach;?>

<div
style="margin:18px 0;padding:14px;border:1px solid rgba(255,255,255,.1);border-radius:11px"
>
Campo actual:
<strong>
<?=e($type!==''?$type:'No disponible')?>
</strong>
</div>

<form method="post">

<input
type="hidden"
name="_csrf"
value="<?=e(csrf_token())?>"
>

<button
class="btn btn-primary"
type="submit"
name="action"
value="install"
>
Aplicar V1.4
</button>

<a
class="btn btn-secondary"
href="/admin/mercadopago_configurar.php"
>
Abrir Mercado Pago
</a>

</form>

</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
