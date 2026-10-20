<?php
declare(strict_types=1);
require_once __DIR__ . '/web_cart.php';
function cp_checkout_token():string{return bin2hex(random_bytes(32));}
function cp_checkout_get(PDO $pdo,string $token):?array{$s=$pdo->prepare('SELECT * FROM cp_web_checkout_sessions WHERE session_token=? LIMIT 1');$s->execute([$token]);$r=$s->fetch(PDO::FETCH_ASSOC);return$r?:null;}
function cp_checkout_save(PDO $pdo,array $d):string{$t=cp_checkout_token();$s=$pdo->prepare('INSERT INTO cp_web_checkout_sessions(session_token,status,customer_name,email,phone,address,city,state,zip_code,country,delivery_method,notes,cart_json,currency,subtotal,shipping,total,created_at,updated_at) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())');$s->execute([$t,'submitted',$d['customer_name'],$d['email']?:null,$d['phone']?:null,$d['address']?:null,$d['city']?:null,$d['state']?:null,$d['zip_code']?:null,$d['country']?:'MX',$d['delivery_method']?:null,$d['notes']?:null,json_encode($d['items'],JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES),'MXN',$d['subtotal'],$d['shipping'],$d['total']]);return$t;}
