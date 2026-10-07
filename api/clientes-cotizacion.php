<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

header('Content-Type: application/json; charset=UTF-8');
header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');

function cpq_client_json(array $data, int $status=200): never {
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    exit;
}

$q = trim((string)($_GET['q'] ?? ''));
if ($q === '' || strlen($q) < 2) {
    cpq_client_json([]);
}
if (strlen($q) > 120) $q = substr($q, 0, 120);

try {
    $pdo = db();
    $like = '%' . $q . '%';
    $phoneDigits = preg_replace('/\D+/', '', $q) ?: '';
    $phoneLike = '%' . $phoneDigits . '%';

    $sql = "
        SELECT id, name, email, phone, tax_number, city, state
        FROM cp_customers
        WHERE enabled = 1
          AND (
                name LIKE ?
                OR COALESCE(email,'') LIKE ?
                OR COALESCE(phone,'') LIKE ?
                OR COALESCE(tax_number,'') LIKE ?
                OR REPLACE(REPLACE(REPLACE(REPLACE(COALESCE(phone,''),' ',''),'-',''),'(',''),')','') LIKE ?
              )
        ORDER BY
            name ASC
        LIMIT 20
    ";

    $st = $pdo->prepare($sql);
    $st->execute([$like,$like,$like,$like,$phoneLike]);
    cpq_client_json($st->fetchAll(PDO::FETCH_ASSOC));
} catch (Throwable $e) {
    cpq_client_json(['error'=>true,'message'=>'No se pudo consultar la base de clientes.'],500);
}
?>
