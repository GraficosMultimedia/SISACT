<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/web_cart.php';
if($_SERVER['REQUEST_METHOD']==='POST'){
 $a=(string)($_POST['action']??'');
 if($a==='add')cp_cart_add((int)($_POST['product_id']??0),(int)($_POST['quantity']??1));
 if($a==='set')cp_cart_set((int)($_POST['product_id']??0),(int)($_POST['quantity']??1));
 if($a==='remove')cp_cart_remove((int)($_POST['product_id']??0));
 if($a==='clear')cp_cart_clear();
}
$pdo=db();$company=cp_web_company();$items=cp_cart_items($pdo);$totals=cp_cart_totals($items);$brand=$company['trade_name']?:$company['legal_name'];
function h(string $v):string{return cp_web_h($v);}
?>
<!doctype html><html lang="es-MX"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Carrito | <?=h($brand)?></title><link rel="stylesheet" href="<?=h(cp_web_route('/assets/css/cart-v1.css'))?>">
<link rel="stylesheet" href="/assets/css/public-header-unified-v1.css?v=20260927-1">
<script src="/assets/js/public-header-unified-v1.js?v=20260927-1" defer></script>
</head><body>
<?php require_once __DIR__ . '/includes/public_header.php'; cp_public_header('catalogo'); ?>
<main class="wc-wrap wc-main"><div class="wc-crumb"><a href="<?=h(cp_web_route('/catalogo.php'))?>">Catálogo</a> › Carrito</div><div class="wc-head"><div><span>CARRITO</span><h1>Tu selección.</h1></div><span class="wc-count"><?=$totals['count']?> artículos</span></div>
<?php if(!$items):?><section class="wc-empty"><strong>Tu carrito está vacío.</strong><p>Explora el catálogo y agrega productos con precio fijo para preparar tu solicitud.</p><a href="<?=h(cp_web_route('/catalogo.php'))?>">Explorar catálogo →</a></section>
<?php else:?><section class="wc-grid"><div class="wc-lines"><?php foreach($items as $i):?><article class="wc-line"><a class="wc-line-image" href="<?=h(cp_web_route('/producto.php',['id'=>$i['id']]))?>"><?php if($i['image_url']):?><img src="<?=h($i['image_url'])?>" alt="<?=h($i['name'])?>" loading="lazy"><?php else:?><span>CP</span><?php endif;?></a><div class="wc-line-body"><small><?=h($i['category_name'])?></small><h2><?=h($i['name'])?></h2><div class="wc-line-price"><?= $i['sale_price']!==null&&$i['pricing_type']==='fixed'?h(cp_web_money($i['sale_price'])):'Cotización' ?></div><form method="post" class="wc-qty"><input type="hidden" name="action" value="set"><input type="hidden" name="product_id" value="<?=$i['id']?>"><button name="quantity" value="<?=max(0,$i['quantity']-1)?>">−</button><output><?=$i['quantity']?></output><button name="quantity" value="<?=min(999,$i['quantity']+1)?>">+</button></form><form method="post"><input type="hidden" name="action" value="remove"><input type="hidden" name="product_id" value="<?=$i['id']?>"><button class="wc-remove">Eliminar</button></form></div><strong class="wc-line-total"><?= $i['sale_price']!==null&&$i['pricing_type']==='fixed'?h(cp_web_money($i['sale_price']*$i['quantity'])):'Consultar' ?></strong></article><?php endforeach;?></div>
<aside class="wc-summary"><span>RESUMEN</span><h2>Preparar pedido</h2><div><span>Artículos</span><b><?=$totals['count']?></b></div><div><span>Subtotal fijo</span><b><?=h(cp_web_money($totals['subtotal']))?></b></div><?php if($totals['needs_quote']):?><p class="wc-warning">Hay productos que requieren cotización.</p><?php endif;?><a class="wc-primary" href="<?=h(cp_web_route('/checkout.php'))?>">Continuar →</a><form method="post"><input type="hidden" name="action" value="clear"><button>Vaciar carrito</button></form></aside></section><?php endif;?></main></body></html>
