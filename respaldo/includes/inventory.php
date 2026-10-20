<?php
declare(strict_types=1);
function cp_inventory_get(PDO $pdo,int $id):?array{$s=$pdo->prepare('SELECT * FROM cp_product_inventory WHERE product_id=? LIMIT 1');$s->execute([$id]);$r=$s->fetch(PDO::FETCH_ASSOC);return$r?:null;}
function cp_inventory_available(PDO $pdo,int $id):?float{$r=cp_inventory_get($pdo,$id);if(!$r||$r['stock_mode']==='unlimited')return null;return max(0,(float)$r['quantity']-(float)$r['reserved_quantity']);}
function cp_shipping_methods(PDO $pdo):array{return$pdo->query('SELECT * FROM cp_shipping_methods WHERE enabled=1 ORDER BY sort_order,id')->fetchAll(PDO::FETCH_ASSOC);}
function cp_shipping_price(PDO $pdo,int $methodId,float $subtotal):float{$s=$pdo->prepare('SELECT amount FROM cp_shipping_rules WHERE shipping_method_id=? AND enabled=1 AND (min_subtotal IS NULL OR min_subtotal<=?) AND (max_subtotal IS NULL OR max_subtotal>=?) ORDER BY id LIMIT 1');$s->execute([$methodId,$subtotal,$subtotal]);$v=$s->fetchColumn();if($v!==false)return(float)$v;$s=$pdo->prepare('SELECT price FROM cp_shipping_methods WHERE id=? AND enabled=1');$s->execute([$methodId]);return(float)($s->fetchColumn()?:0);}
