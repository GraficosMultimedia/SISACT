<?php
declare(strict_types=1);
require_once __DIR__ . '/web_common.php';
if(session_status()!==PHP_SESSION_ACTIVE)session_start();
function cp_cart_add(int $productId,int $qty=1):void{if($productId<=0)return;if(!isset($_SESSION['cp_cart']))$_SESSION['cp_cart']=[];$cur=(int)($_SESSION['cp_cart'][$productId]['qty']??0);$_SESSION['cp_cart'][$productId]=['qty'=>max(1,min(999,$cur+max(1,$qty)))];}
function cp_cart_set(int $productId,int $qty):void{if($productId<=0)return;if($qty<=0){unset($_SESSION['cp_cart'][$productId]);return;}if(!isset($_SESSION['cp_cart']))$_SESSION['cp_cart']=[];$_SESSION['cp_cart'][$productId]=['qty'=>max(1,min(999,$qty))];}
function cp_cart_remove(int $productId):void{unset($_SESSION['cp_cart'][$productId]);}
function cp_cart_clear():void{unset($_SESSION['cp_cart']);}
function cp_cart_items(PDO $pdo):array{
 $cart=$_SESSION['cp_cart']??[];if(!is_array($cart)||!$cart)return[];$ids=array_map('intval',array_keys($cart));$ids=array_values(array_filter($ids,fn($x)=>$x>0));if(!$ids)return[];
 $ph=implode(',',array_fill(0,count($ids),'?'));
 $s=$pdo->prepare("SELECT p.id,p.name,p.sku,p.description,p.sale_price,p.pricing_type,c.name category_name,(SELECT i.path FROM cp_product_images i WHERE i.product_id=p.id AND i.enabled=1 ORDER BY i.sort_order,i.id LIMIT 1) image_path FROM cp_products p LEFT JOIN cp_categories c ON c.id=p.category_id WHERE p.enabled=1 AND p.visible_web=1 AND p.id IN ($ph)");
 $s->execute($ids);$found=[];
 foreach($s->fetchAll(PDO::FETCH_ASSOC) as $r){$id=(int)$r['id'];$found[$id]=['id'=>$id,'name'=>(string)$r['name'],'sku'=>(string)($r['sku']??''),'description'=>(string)($r['description']??''),'sale_price'=>$r['sale_price']!==null?(float)$r['sale_price']:null,'pricing_type'=>(string)$r['pricing_type'],'category_name'=>(string)($r['category_name']??''),'image_url'=>cp_web_image($r['image_path']??''),'quantity'=>max(1,min(999,(int)($cart[$id]['qty']??1)))];}
 $out=[];foreach($cart as $id=>$v){$id=(int)$id;if(isset($found[$id]))$out[]=$found[$id];}return$out;
}
function cp_cart_totals(array $items):array{$sub=0;$quote=false;$count=0;foreach($items as $i){$count+=(int)$i['quantity'];if($i['sale_price']===null||$i['pricing_type']!=='fixed'){$quote=true;continue;}$sub+=(float)$i['sale_price']*(int)$i['quantity'];}return['subtotal'=>$sub,'needs_quote'=>$quote,'count'=>$count];}
