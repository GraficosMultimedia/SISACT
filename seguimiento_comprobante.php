<?php
declare(strict_types=1);

require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/seguimiento.php';
require_once __DIR__ . '/includes/ordenes.php';
require_once __DIR__ . '/includes/finanzas.php';
require_once __DIR__ . '/includes/company.php';
require_once __DIR__ . '/includes/quote_order_sync.php';
require_once __DIR__ . '/includes/cotizaciones.php';
require_once __DIR__ . '/includes/order_pdf_professional_2pages.php';

$token=trim((string)($_GET['t']??''));

if(!preg_match('/^[a-f0-9]{64}$/i',$token)){
    http_response_code(404);
    exit('Enlace no válido.');
}

/*
 * Seguridad pública:
 * El token resuelve la orden. NO se permite pasar id directamente.
 * Por eso Seguimiento puede mostrar el mismo PDF que Administración
 * sin exponer /admin/ ni requerir login al cliente.
 */
$publicOrder=tracking_order_by_token($token);

if(!$publicOrder){
    http_response_code(404);
    exit('El seguimiento ya no está disponible.');
}

$id=(int)$publicOrder['id'];
$order=order_get($id);

if(!$order){
    http_response_code(404);
    exit('Orden no encontrada.');
}

$items=order_items($id);
$company=company_profile();

$financeReady=finance_tables_ready();
$finance=$financeReady?finance_order_summary($id):tracking_payment_summary($id);
$payments=$financeReady?finance_payment_list($id,8):tracking_confirmed_payments($id);

$quoteSync=quote_order_diff((int)($order['quote_id']??0),$id);

render_order_professional_2pages(
    $order,
    $items,
    $finance,
    $payments,
    $quoteSync,
    $company
);
