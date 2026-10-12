<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_once __DIR__ . '/../includes/finanzas.php';
require_once __DIR__ . '/../includes/company.php';
require_once __DIR__ . '/../includes/quote_order_sync.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/order_pdf_professional_2pages.php';

require_auth();

$id=(int)($_GET['id']??0);
$order=order_get($id);

if(!$order){
    http_response_code(404);
    exit('Orden no encontrada.');
}

$items=order_items($id);
$company=company_profile();

$financeReady=finance_tables_ready();
$finance=$financeReady?finance_order_summary($id):null;
$payments=$financeReady?finance_payment_list($id,8):[];

$quoteSync=quote_order_diff((int)($order['quote_id']??0),$id);

render_order_professional_2pages(
    $order,
    $items,
    $finance,
    $payments,
    $quoteSync,
    $company
);
