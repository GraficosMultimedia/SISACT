<?php
declare(strict_types=1);
require_once __DIR__.'/includes/web_checkout.php';
if($_SERVER['REQUEST_METHOD']!=='POST'){http_response_code(405);exit('Método no permitido.');}
$pdo=db();$items=cp_cart_items($pdo);if(!$items){header('Location: '.cp_web_route('/carrito.php'));exit;}
$name=cp_web_sanitize_text((string)($_POST['customer_name']??''),190);$phone=cp_web_sanitize_text((string)($_POST['phone']??''),80);$email=trim((string)($_POST['email']??''));
if($name===''||$phone===''){http_response_code(422);exit('Nombre y teléfono son obligatorios.');}
if($email!==''&&!filter_var($email,FILTER_VALIDATE_EMAIL)){http_response_code(422);exit('Correo no válido.');}
$t=cp_cart_totals($items);
$d=['customer_name'=>$name,'email'=>$email,'phone'=>$phone,'address'=>cp_web_sanitize_text((string)($_POST['address']??''),500),'city'=>cp_web_sanitize_text((string)($_POST['city']??''),120),'state'=>cp_web_sanitize_text((string)($_POST['state']??''),120),'zip_code'=>cp_web_sanitize_text((string)($_POST['zip_code']??''),20),'delivery_method'=>cp_web_sanitize_text((string)($_POST['delivery_method']??''),40),'notes'=>cp_web_sanitize_text((string)($_POST['notes']??''),1000),'items'=>$items,'subtotal'=>$t['subtotal'],'shipping'=>0,'total'=>$t['subtotal']];
$token=cp_checkout_save($pdo,$d);cp_cart_clear();header('Location: '.cp_web_route('/pedido.php',['token'=>$token]));exit;
