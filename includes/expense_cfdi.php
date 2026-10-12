<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/cfdi.php';
require_once __DIR__ . '/company.php';

function expense_cfdi_tables_ready(): bool
{
    try {
        return (bool)db()->query("SHOW TABLES LIKE 'cp_expense_documents'")->fetchColumn();
    } catch (Throwable $e) {
        return false;
    }
}

function expense_cfdi_storage_dir(): string
{
    $dir = dirname(__DIR__) . '/storage/expenses';
    if (!is_dir($dir)) @mkdir($dir, 0750, true);
    return $dir;
}

function expense_cfdi_categories(): array
{
    return [
        'Materiales',
        'Nómina',
        'Servicios',
        'Renta',
        'Publicidad',
        'Mantenimiento',
        'Transporte',
        'Impuestos',
        'Equipo',
        'Otros',
    ];
}

function expense_cfdi_normalize_uploads(array $files): array
{
    if (!isset($files['name'])) return [];
    if (!is_array($files['name'])) return [$files];

    $normalized = [];
    $count = count($files['name']);
    for ($i = 0; $i < $count; $i++) {
        $normalized[] = [
            'name' => $files['name'][$i] ?? '',
            'full_path' => $files['full_path'][$i] ?? ($files['name'][$i] ?? ''),
            'type' => $files['type'][$i] ?? '',
            'tmp_name' => $files['tmp_name'][$i] ?? '',
            'error' => $files['error'][$i] ?? UPLOAD_ERR_NO_FILE,
            'size' => $files['size'][$i] ?? 0,
        ];
    }
    return $normalized;
}

function expense_cfdi_payment_method(string $formaPago): string
{
    $formaPago = trim($formaPago);
    if ($formaPago === '01') return 'cash';
    if ($formaPago === '03') return 'transfer';
    if (in_array($formaPago, ['04','28','29'], true)) return 'card';
    return 'other';
}

function expense_cfdi_payment_method_label(string $method): string
{
    return [
        'cash' => 'Efectivo',
        'transfer' => 'Transferencia',
        'card' => 'Tarjeta',
        'other' => 'Otro',
    ][$method] ?? 'Otro';
}

function expense_cfdi_status(string $metodoPago): string
{
    return strtoupper(trim($metodoPago)) === 'PPD' ? 'pending' : 'paid';
}

function expense_cfdi_suggest_category(array $parsed): string
{
    $parts = [];
    foreach (($parsed['items'] ?? []) as $item) {
        $parts[] = strtolower((string)($item['descripcion'] ?? ''));
        $parts[] = strtolower((string)($item['clave_prod_serv'] ?? ''));
    }
    $haystack = implode(' ', $parts);

    if (
        str_contains($haystack, '15101514') ||
        preg_match('/gasolin|gasolina|magna|premium|diesel|combustible|lubricante/', $haystack)
    ) return 'Transporte';

    if (preg_match('/vinil|lona|papel|tinta|acrilic|mdf|cart[oó]n|coroplast|pl[aá]stico|material|adhesiv|sustrato/', $haystack)) {
        return 'Materiales';
    }

    if (preg_match('/reparaci[oó]n|mantenimiento|refacci[oó]n|servicio t[eé]cnico|taller/', $haystack)) {
        return 'Mantenimiento';
    }

    if (preg_match('/impresora|plotter|l[aá]ser|router|computadora|equipo|maquinaria|herramienta/', $haystack)) {
        return 'Equipo';
    }

    if (preg_match('/publicidad|anuncio|meta ads|facebook ads|google ads|promoci[oó]n/', $haystack)) {
        return 'Publicidad';
    }

    if (preg_match('/renta|arrendamiento|alquiler/', $haystack)) {
        return 'Renta';
    }

    if (preg_match('/impuesto|derecho|sat|tesorer[ií]a/', $haystack)) {
        return 'Impuestos';
    }

    if (preg_match('/internet|telefon|hosting|dominio|software|licencia|suscripci[oó]n|electricidad|energ[ií]a|agua|servicio/', $haystack)) {
        return 'Servicios';
    }

    return 'Otros';
}

function expense_cfdi_description(array $parsed): string
{
    $descriptions = [];
    foreach (($parsed['items'] ?? []) as $item) {
        $value = trim((string)($item['descripcion'] ?? ''));
        if ($value !== '' && !in_array($value, $descriptions, true)) {
            $descriptions[] = $value;
        }
        if (count($descriptions) >= 3) break;
    }

    $description = implode(' · ', $descriptions);
    if ($description === '') {
        $description = 'CFDI ' . ((string)($parsed['internal_number'] ?? '') ?: (string)($parsed['uuid'] ?? ''));
    }

    return substr($description, 0, 500);
}

function expense_cfdi_xml_type(array $parsed): string
{
    $raw = (string)($parsed['raw'] ?? '');
    if ($raw === '') return '';

    libxml_use_internal_errors(true);
    $xml = simplexml_load_string($raw, 'SimpleXMLElement', LIBXML_NONET | LIBXML_NOBLANKS);
    if ($xml === false) {
        libxml_clear_errors();
        return '';
    }
    return trim((string)($xml['TipoDeComprobante'] ?? ''));
}

function expense_cfdi_find_duplicate(string $uuid, string $sha256): ?array
{
    if (!expense_cfdi_tables_ready()) return null;

    if ($uuid !== '') {
        $st = db()->prepare(
            'SELECT d.id,d.expense_id,d.uuid,e.description,e.amount
             FROM cp_expense_documents d
             INNER JOIN cp_expenses e ON e.id=d.expense_id
             WHERE d.uuid=? OR d.xml_sha256=?
             LIMIT 1'
        );
        $st->execute([$uuid, $sha256]);
    } else {
        $st = db()->prepare(
            'SELECT d.id,d.expense_id,d.uuid,e.description,e.amount
             FROM cp_expense_documents d
             INNER JOIN cp_expenses e ON e.id=d.expense_id
             WHERE d.xml_sha256=?
             LIMIT 1'
        );
        $st->execute([$sha256]);
    }

    $row = $st->fetch(PDO::FETCH_ASSOC);
    return $row ?: null;
}

function expense_cfdi_import_one(
    array $upload,
    int $userId,
    string $companyRfc = '',
    bool $allowRfcMismatch = false,
    string $categoryOverride = ''
): array {
    if (!expense_cfdi_tables_ready()) {
        throw new RuntimeException('El expediente XML de egresos no está instalado. Ejecuta la migración 022.');
    }

    $parsed = cfdi_parse_upload($upload);
    $uuid = strtoupper(trim((string)($parsed['uuid'] ?? '')));
    $sha256 = (string)($parsed['sha256'] ?? '');
    $total = (float)($parsed['total'] ?? 0);

    if ($total <= 0) {
        throw new RuntimeException('El CFDI no contiene un total mayor a cero.');
    }

    $tipo = expense_cfdi_xml_type($parsed);
    if ($tipo !== '' && $tipo !== 'I') {
        throw new RuntimeException(
            'El XML no es una factura de ingreso del proveedor (TipoDeComprobante=' . $tipo . '). No se registró como egreso.'
        );
    }

    if ($duplicate = expense_cfdi_find_duplicate($uuid, $sha256)) {
        return [
            'status' => 'duplicate',
            'expense_id' => (int)$duplicate['expense_id'],
            'uuid' => (string)($duplicate['uuid'] ?? $uuid),
            'description' => (string)$duplicate['description'],
            'amount' => (float)$duplicate['amount'],
            'message' => 'CFDI ya registrado como egreso #' . (int)$duplicate['expense_id'],
        ];
    }

    $receiverRfc = strtoupper(trim((string)($parsed['receptor_rfc'] ?? '')));
    $companyRfc = strtoupper(trim($companyRfc));

    if (
        $companyRfc !== '' &&
        $receiverRfc !== '' &&
        $receiverRfc !== $companyRfc &&
        !$allowRfcMismatch
    ) {
        throw new RuntimeException(
            'RFC receptor diferente. XML: ' . $receiverRfc .
            ' · Empresa SISACT: ' . $companyRfc .
            '. Activa "Permitir RFC diferente" solo si corresponde.'
        );
    }

    $categories = expense_cfdi_categories();
    $category = in_array($categoryOverride, $categories, true)
        ? $categoryOverride
        : expense_cfdi_suggest_category($parsed);

    $status = expense_cfdi_status((string)($parsed['metodo_pago'] ?? ''));
    $paymentMethod = expense_cfdi_payment_method((string)($parsed['forma_pago'] ?? ''));
    $expenseDate = (string)($parsed['invoice_date'] ?? '');
    if ($expenseDate === '') $expenseDate = date('Y-m-d');

    $supplier = trim((string)($parsed['emisor_nombre'] ?? ''));
    if ($supplier === '') $supplier = trim((string)($parsed['emisor_rfc'] ?? ''));
    $supplier = substr($supplier, 0, 190);

    $description = expense_cfdi_description($parsed);
    $reference = trim((string)($parsed['internal_number'] ?? ''));
    if ($reference === '') $reference = $uuid;

    $notesParts = [
        'Importado desde CFDI ' . ((string)($parsed['version'] ?? '4.0')),
    ];
    if ($uuid !== '') $notesParts[] = 'UUID ' . $uuid;
    if ($receiverRfc !== '') $notesParts[] = 'Receptor RFC ' . $receiverRfc;
    $notes = implode(' · ', $notesParts);

    $pdo = db();
    $xmlPath = null;

    try {
        $pdo->beginTransaction();

        // Revalidación dentro de la transacción.
        if ($duplicate = expense_cfdi_find_duplicate($uuid, $sha256)) {
            $pdo->rollBack();
            return [
                'status' => 'duplicate',
                'expense_id' => (int)$duplicate['expense_id'],
                'uuid' => (string)($duplicate['uuid'] ?? $uuid),
                'description' => (string)$duplicate['description'],
                'amount' => (float)$duplicate['amount'],
                'message' => 'CFDI ya registrado como egreso #' . (int)$duplicate['expense_id'],
            ];
        }

        $st = $pdo->prepare(
            'INSERT INTO cp_expenses
             (expense_date,due_date,category,supplier,description,amount,payment_method,reference,
              receipt_reference,order_id,status,notes,created_by,updated_by,created_at,updated_at)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())'
        );
        $st->execute([
            $expenseDate,
            null,
            $category,
            $supplier !== '' ? $supplier : null,
            $description,
            $total,
            $paymentMethod,
            $reference !== '' ? substr($reference, 0, 190) : null,
            $uuid !== '' ? 'CFDI XML · ' . $uuid : 'CFDI XML',
            null,
            $status,
            $notes,
            $userId ?: null,
            $userId ?: null,
        ]);
        $expenseId = (int)$pdo->lastInsertId();

        $year = substr($expenseDate, 0, 4);
        if (!preg_match('/^\d{4}$/', $year)) $year = date('Y');
        $dir = expense_cfdi_storage_dir() . '/' . $year;
        if (!is_dir($dir) && !@mkdir($dir, 0750, true) && !is_dir($dir)) {
            throw new RuntimeException('No se pudo crear el almacenamiento de XML de egresos.');
        }

        $base = $uuid !== '' ? $uuid : ('expense_' . $expenseId . '_' . substr($sha256, 0, 16));
        $base = preg_replace('/[^A-Za-z0-9._-]+/', '_', $base);
        $xmlPath = $dir . '/' . $base . '.xml';

        $raw = (string)($parsed['raw'] ?? '');
        if ($raw === '' || file_put_contents($xmlPath, $raw, LOCK_EX) === false) {
            throw new RuntimeException('No se pudo guardar el XML del egreso.');
        }

        $relativeXml = str_replace(dirname(__DIR__) . '/', '', $xmlPath);

        $doc = $pdo->prepare(
            'INSERT INTO cp_expense_documents
             (expense_id,uuid,xml_sha256,version,serie,folio,issued_at,currency,tipo_comprobante,
              issuer_rfc,issuer_name,receiver_rfc,receiver_name,subtotal,tax,total,
              payment_form,payment_method,xml_path,created_by,created_at)
             VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW())'
        );
        $doc->execute([
            $expenseId,
            $uuid !== '' ? $uuid : null,
            $sha256,
            (string)($parsed['version'] ?? '4.0'),
            (string)($parsed['serie'] ?? '') ?: null,
            (string)($parsed['folio'] ?? '') ?: null,
            (string)($parsed['issued_at'] ?? '') ?: null,
            (string)($parsed['moneda'] ?? 'MXN'),
            $tipo !== '' ? $tipo : null,
            (string)($parsed['emisor_rfc'] ?? '') ?: null,
            (string)($parsed['emisor_nombre'] ?? '') ?: null,
            $receiverRfc !== '' ? $receiverRfc : null,
            (string)($parsed['receptor_nombre'] ?? '') ?: null,
            (float)($parsed['subtotal'] ?? 0),
            (float)($parsed['tax'] ?? 0),
            $total,
            (string)($parsed['forma_pago'] ?? '') ?: null,
            (string)($parsed['metodo_pago'] ?? '') ?: null,
            $relativeXml,
            $userId ?: null,
        ]);

        $documentId = (int)$pdo->lastInsertId();
        $pdo->commit();

        log_activity(
            'create',
            'expenses',
            'Egreso CFDI importado #' . $expenseId . ' · ' . $description . ' · $' . number_format($total, 2, '.', ',')
        );

        return [
            'status' => 'imported',
            'expense_id' => $expenseId,
            'document_id' => $documentId,
            'uuid' => $uuid,
            'supplier' => $supplier,
            'description' => $description,
            'amount' => $total,
            'category' => $category,
            'payment_status' => $status,
            'payment_method' => $paymentMethod,
            'message' => 'Egreso #' . $expenseId . ' registrado',
        ];

    } catch (Throwable $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        if ($xmlPath && is_file($xmlPath)) @unlink($xmlPath);
        throw $e;
    }
}

function expense_cfdi_import_batch(
    array $files,
    int $userId,
    string $companyRfc = '',
    bool $allowRfcMismatch = false,
    string $categoryOverride = ''
): array {
    $uploads = expense_cfdi_normalize_uploads($files);
    if (!$uploads) {
        throw new RuntimeException('Selecciona al menos un XML CFDI.');
    }
    if (count($uploads) > 30) {
        throw new RuntimeException('Importa máximo 30 XML por operación.');
    }

    $result = [
        'imported' => 0,
        'duplicates' => 0,
        'errors' => 0,
        'total' => 0.0,
        'items' => [],
    ];

    foreach ($uploads as $upload) {
        $name = trim((string)($upload['name'] ?? 'archivo.xml'));
        if ((int)($upload['error'] ?? UPLOAD_ERR_NO_FILE) === UPLOAD_ERR_NO_FILE) continue;

        try {
            $item = expense_cfdi_import_one(
                $upload,
                $userId,
                $companyRfc,
                $allowRfcMismatch,
                $categoryOverride
            );
            $item['file'] = $name;

            if (($item['status'] ?? '') === 'imported') {
                $result['imported']++;
                $result['total'] += (float)($item['amount'] ?? 0);
            } elseif (($item['status'] ?? '') === 'duplicate') {
                $result['duplicates']++;
            }

            $result['items'][] = $item;
        } catch (Throwable $e) {
            $result['errors']++;
            $result['items'][] = [
                'status' => 'error',
                'file' => $name,
                'message' => $e->getMessage(),
            ];
        }
    }

    if (!$result['items']) {
        throw new RuntimeException('No se recibió ningún XML para procesar.');
    }

    return $result;
}

function expense_cfdi_document_for_expense(int $expenseId): ?array
{
    if ($expenseId <= 0 || !expense_cfdi_tables_ready()) return null;

    $st = db()->prepare(
        'SELECT * FROM cp_expense_documents
         WHERE expense_id=?
         ORDER BY id DESC
         LIMIT 1'
    );
    $st->execute([$expenseId]);
    $row = $st->fetch(PDO::FETCH_ASSOC);
    return $row ?: null;
}

function expense_cfdi_document_get(int $documentId): ?array
{
    if ($documentId <= 0 || !expense_cfdi_tables_ready()) return null;

    $st = db()->prepare(
        'SELECT d.*,e.description,e.supplier,e.amount,e.expense_date
         FROM cp_expense_documents d
         INNER JOIN cp_expenses e ON e.id=d.expense_id
         WHERE d.id=?
         LIMIT 1'
    );
    $st->execute([$documentId]);
    $row = $st->fetch(PDO::FETCH_ASSOC);
    return $row ?: null;
}
