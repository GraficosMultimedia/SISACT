<?php
declare(strict_types=1);
require_once __DIR__ . '/config/runtime.php';
require_once __DIR__ . '/includes/cotizaciones.php';
require_once __DIR__ . '/includes/company.php';
require_once __DIR__ . '/includes/cotizacion_pdf_renderer.php';

$token = trim((string)($_GET['t'] ?? ''));
if (!preg_match('/^[a-f0-9]{64}$/i', $token)) {
    http_response_code(404);
    exit('Enlace no válido.');
}

// Localizamos la cotización por el token público y después usamos quote_get()
// para cargar también todos los datos relacionados del cliente.
$st = db()->prepare(
    'SELECT quote_id
     FROM cp_quote_public_tokens
     WHERE token=? AND active=1
     LIMIT 1'
);
$st->execute([$token]);
$quoteId = (int)($st->fetchColumn() ?: 0);

if ($quoteId <= 0) {
    http_response_code(404);
    exit('La cotización ya no está disponible.');
}

$quote = quote_get($quoteId);
if (!$quote || in_array((string)($quote['status'] ?? ''), ['cancelled'], true)) {
    http_response_code(404);
    exit('La cotización ya no está disponible.');
}

db()->prepare('UPDATE cp_quote_public_tokens SET last_access_at=NOW() WHERE token=?')->execute([$token]);

$items = quote_items($quoteId);
$totals = quote_totals($quoteId);
$company = company_profile();
$data = generate_quote_pdf($quote, $items, $totals, $company);

header('Content-Type: application/pdf');
header('Content-Length: ' . strlen($data));
header('Content-Disposition: inline; filename="' . preg_replace('/[^A-Za-z0-9._-]+/', '_', (string)$quote['quote_number']) . '.pdf"');
header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
echo $data;
