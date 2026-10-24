<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/mercadopago.php';

require_auth();

$title='Mercado Pago';

$error=null;
$success=null;
$tokenTest=null;
$syncResult=null;

$path=mp_config_path();

$current=[
    'enabled'=>false,
    'mode'=>'test',
    'access_token'=>'',
    'base_url'=>'https://colibriprint.com.mx',
    'currency'=>'MXN',
    'test_buyer_email'=>'',
];

if(is_file($path)){
    try{
        $loaded=require $path;

        if(is_array($loaded)){
            $current=array_merge(
                $current,
                $loaded
            );
        }
    }catch(Throwable $e){}
}

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null)){
        $error='La sesión expiró. Recarga la página.';
    }else{
        try{
            $action=(string)(
                $_POST['action']
                ?? 'save'
            );

            if($action==='test_token'){
                $tokenTest=
                    mp_test_access_token();
            }elseif($action==='sync_now'){
                $syncResult=
                    mp_sync_pending_transactions(
                        50
                    );
            }else{
                $enabled=
                    isset($_POST['enabled']);

                $mode=(string)(
                    $_POST['mode']
                    ?? 'test'
                );

                if(
                    !in_array(
                        $mode,
                        ['test','production'],
                        true
                    )
                ){
                    $mode='test';
                }

                $accessToken=trim(
                    (string)(
                        $_POST['access_token']
                        ?? ''
                    )
                );

                $baseUrl=rtrim(
                    trim(
                        (string)(
                            $_POST['base_url']
                            ?? ''
                        )
                    ),
                    '/'
                );

                $testBuyerEmail=
                    strtolower(
                        trim(
                            (string)(
                                $_POST['test_buyer_email']
                                ?? ''
                            )
                        )
                    );

                if($accessToken===''){
                    $accessToken=
                        trim(
                            (string)(
                                $current['access_token']
                                ?? ''
                            )
                        );
                }

                if($enabled){
                    if($accessToken===''){
                        throw new RuntimeException(
                            'Captura el Access Token.'
                        );
                    }

                    if(
                        !preg_match(
                            '#^https://[a-z0-9.-]+(?::\d+)?(?:/.*)?$#i',
                            $baseUrl
                        )
                    ){
                        throw new RuntimeException(
                            'La Base URL debe usar HTTPS.'
                        );
                    }

                    if($mode==='test'){
                        if($testBuyerEmail===''){
                            throw new RuntimeException(
                                'En modo Pruebas captura '
                                .'el correo Comprador de prueba.'
                            );
                        }

                        if(
                            !filter_var(
                                $testBuyerEmail,
                                FILTER_VALIDATE_EMAIL
                            )
                            || !str_ends_with(
                                $testBuyerEmail,
                                '@testuser.com'
                            )
                        ){
                            throw new RuntimeException(
                                'El correo Comprador '
                                .'de prueba debe terminar '
                                .'en @testuser.com.'
                            );
                        }
                    }
                }

                $data=[
                    'enabled'=>$enabled,
                    'mode'=>$mode,
                    'access_token'=>$accessToken,
                    'base_url'=>$baseUrl,
                    'currency'=>'MXN',
                    'test_buyer_email'=>$testBuyerEmail,
                ];

                $php=
                    "<?php\n"
                    ."declare(strict_types=1);\n\n"
                    ."/* ARCHIVO LOCAL PRIVADO. "
                    ."NO SUBIR A GITHUB. */\n"
                    ."return "
                    .var_export(
                        $data,
                        true
                    )
                    .";\n";

                if(
                    file_put_contents(
                        $path,
                        $php,
                        LOCK_EX
                    )===false
                ){
                    throw new RuntimeException(
                        'No se pudo guardar '
                        .'mercadopago.local.php.'
                    );
                }

                @chmod(
                    $path,
                    0600
                );

                $current=$data;
                $success='Configuración guardada.';
            }
        }catch(Throwable $e){
            $error=$e->getMessage();
        }
    }
}

$mask=static function(string $v):string{
    $v=trim($v);

    return $v===''
        ? 'No configurado'
        : str_repeat('•',10)
            .substr($v,-4);
};

$transactions=
    mp_table_ready()
    ? mp_recent_transactions(25)
    : [];

$lastError=
    mp_last_error();

$lastAttempt=
    mp_last_attempt();

require __DIR__ . '/../includes/header.php';
?>
<style>
.mp-admin{max-width:1080px;margin:0 auto}
.mp-grid{display:grid;grid-template-columns:1fr 1fr;gap:14px}
.mp-field{display:grid;gap:6px}
.mp-field label{font-size:11px;font-weight:800}
.mp-field input,.mp-field select{
    width:100%;
    min-height:44px;
    padding:10px;
    border:1px solid var(--line);
    border-radius:10px;
    background:var(--card);
    color:inherit
}
.mp-note{
    padding:13px;
    border:1px solid rgba(50,180,240,.25);
    background:rgba(50,180,240,.06);
    border-radius:11px
}
.mp-error{
    padding:13px;
    border:1px solid #f0647755;
    background:#f0647710;
    border-radius:11px;
    color:#ff9aa8;
    font-family:ui-monospace,monospace;
    font-size:11px;
    line-height:1.55;
    word-break:break-word;
    white-space:pre-wrap
}
.mp-attempt{
    display:grid;
    grid-template-columns:repeat(4,minmax(0,1fr));
    gap:10px;
    margin-top:12px
}
.mp-attempt>div{
    padding:12px;
    border:1px solid var(--line);
    border-radius:10px
}
.mp-attempt small{
    display:block;
    color:var(--muted)
}
.mp-attempt strong{
    display:block;
    margin-top:4px
}
.mp-table{
    width:100%;
    border-collapse:collapse
}
.mp-table th,.mp-table td{
    padding:9px;
    border-bottom:1px solid var(--line);
    font-size:11px;
    text-align:left;
    vertical-align:top
}
@media(max-width:760px){
    .mp-grid{grid-template-columns:1fr}
    .mp-attempt{grid-template-columns:1fr 1fr}
    .mp-table{display:block;overflow:auto}
}
</style>

<div class="mp-admin">

<div class="card" style="padding:22px">

<span class="eyebrow">
CHECKOUT PRO · ORDERS API
</span>

<h2>
Mercado Pago · Minimal V1.4
</h2>

<div class="mp-note">
<strong>
Payload mínimo + diagnóstico persistente.
</strong>

<p class="muted" style="margin-bottom:0">
El nuevo intento enviará solamente los campos
necesarios para crear Checkout Pro.
Además, el diagnóstico puede almacenar la respuesta
completa de Mercado Pago.
</p>
</div>

<?php if($error):?>
<div class="notice danger" style="margin-top:14px">
<?=e($error)?>
</div>
<?php endif;?>

<?php if($success):?>
<div class="notice" style="margin-top:14px">
<?=e($success)?>
</div>
<?php endif;?>

<?php if($tokenTest):?>
<div
class="notice <?=$tokenTest['ok']?'':'danger'?>"
style="margin-top:14px"
>
<?=e((string)$tokenTest['message'])?>
</div>
<?php endif;?>

<?php if($syncResult):?>
<div class="notice" style="margin-top:14px">
Sincronización:
<?=e((string)$syncResult['checked'])?>
revisadas ·
<?=e((string)$syncResult['paid'])?>
acreditadas ·
<?=e((string)$syncResult['errors'])?>
errores.
</div>
<?php endif;?>

<form method="post" style="margin-top:18px">

<input
type="hidden"
name="_csrf"
value="<?=e(csrf_token())?>"
>

<div class="mp-grid">

<div class="mp-field">
<label>Base URL HTTPS</label>
<input
name="base_url"
value="<?=e((string)$current['base_url'])?>"
required
>
</div>

<div class="mp-field">
<label>Modo</label>
<select name="mode">
<option
value="test"
<?=$current['mode']==='test'?'selected':''?>
>
Pruebas
</option>

<option
value="production"
<?=$current['mode']==='production'?'selected':''?>
>
Producción
</option>
</select>
</div>

<div class="mp-field">
<label>Access Token</label>
<input
type="password"
name="access_token"
autocomplete="new-password"
placeholder="<?=$mask((string)$current['access_token'])?>"
>
</div>

<div class="mp-field">
<label>Correo Comprador de prueba</label>
<input
type="email"
name="test_buyer_email"
value="<?=e((string)$current['test_buyer_email'])?>"
placeholder="usuario@testuser.com"
>
<small class="muted">
Solo se usa cuando Modo = Pruebas.
</small>
</div>

</div>

<label style="display:flex;gap:8px;align-items:center;margin:16px 0">

<input
type="checkbox"
name="enabled"
value="1"
<?=!empty($current['enabled'])?'checked':''?>
>

<strong>
Habilitar pagos Mercado Pago
</strong>

</label>

<div style="display:flex;gap:10px;flex-wrap:wrap">

<button
class="btn btn-primary"
type="submit"
name="action"
value="save"
>
Guardar configuración
</button>

<button
class="btn btn-secondary"
type="submit"
name="action"
value="test_token"
>
Probar Access Token
</button>

<button
class="btn btn-secondary"
type="submit"
name="action"
value="sync_now"
>
Sincronizar pagos ahora
</button>

</div>

</form>

</div>

<?php if($lastAttempt):?>

<div
class="card"
style="padding:22px;margin-top:14px"
>

<span class="eyebrow">
ÚLTIMO INTENTO LOCAL
</span>

<h3>
Estado del intento más reciente
</h3>

<div class="mp-attempt">

<div>
<small>ID local</small>
<strong>
#<?=e((string)$lastAttempt['id'])?>
</strong>
</div>

<div>
<small>Orden</small>
<strong>
<?=e((string)($lastAttempt['order_number']??$lastAttempt['order_id']))?>
</strong>
</div>

<div>
<small>Estado</small>
<strong>
<?=e((string)$lastAttempt['status'])?>
</strong>
</div>

<div>
<small>Actualizado</small>
<strong>
<?=e((string)$lastAttempt['updated_at'])?>
</strong>
</div>

</div>

<?php if(!empty($lastAttempt['error_message'])):?>

<div class="mp-error" style="margin-top:12px">
<?=e((string)$lastAttempt['error_message'])?>
</div>

<?php endif;?>

</div>

<?php endif;?>

<?php if($lastError):?>

<div
class="card"
style="padding:22px;margin-top:14px"
>

<span class="eyebrow">
DIAGNÓSTICO COMPLETO
</span>

<h3>
Último error de Mercado Pago
</h3>

<div class="mp-error">
<?=e((string)$lastError['error_message'])?>
</div>

<p class="muted">
Orden:
<?=e((string)($lastError['order_number']??$lastError['order_id']))?>
· Creado:
<?=e((string)$lastError['created_at'])?>
· Actualizado:
<?=e((string)$lastError['updated_at'])?>
</p>

</div>

<?php endif;?>

<div
class="card"
style="padding:22px;margin-top:14px"
>

<h3>
Últimas operaciones
</h3>

<?php if(!$transactions):?>

<p class="muted">
Todavía no hay operaciones.
</p>

<?php else:?>

<table class="mp-table">

<thead>
<tr>
<th>ID</th>
<th>Orden</th>
<th>Monto</th>
<th>Estado</th>
<th>MP Order</th>
<th>Error / detalle</th>
<th>Fecha</th>
</tr>
</thead>

<tbody>

<?php foreach($transactions as $tx):?>

<tr>

<td>
#<?=e((string)$tx['id'])?>
</td>

<td>
<?=e((string)$tx['order_number'])?>
</td>

<td>
$<?=number_format((float)$tx['amount'],2,'.',',')?>
</td>

<td>
<?=e((string)$tx['status'])?>
<?=!empty($tx['status_detail'])?' · '.e((string)$tx['status_detail']):''?>
</td>

<td>
<?=e((string)($tx['mp_order_id']??'—'))?>
</td>

<td>
<?=e((string)($tx['error_message']??''))?>
</td>

<td>
<?=e((string)$tx['created_at'])?>
</td>

</tr>

<?php endforeach;?>

</tbody>

</table>

<?php endif;?>

</div>

</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
