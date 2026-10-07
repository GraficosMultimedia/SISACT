<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/company.php';
require_once __DIR__ . '/../includes/cotizacion_pdf_renderer.php';
require_auth();

$id=(int)($_GET['id'] ?? 0);
$quote=quote_get($id);
if(!$quote){ http_response_code(404); exit('Cotización no encontrada.'); }
$items=quote_items($id);
$totals=quote_totals($id);
$company=company_profile();
$data=generate_quote_pdf($quote,$items,$totals,$company);

header('Content-Type: application/pdf');
header('Content-Length: '.strlen($data));
header('Content-Disposition: inline; filename="'.preg_replace('/[^A-Za-z0-9._-]+/','_', (string)$quote['quote_number']).'.pdf"');
header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
echo $data;
