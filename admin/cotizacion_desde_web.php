<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/quote_conditions.php';
require_once __DIR__ . '/../includes/public_quote_links.php';
require_once __DIR__ . '/../includes/web_print_flow.php';

require_auth();

function cpqflow_h($value): string
{
    return htmlspecialchars(
        (string)$value,
        ENT_QUOTES,
        'UTF-8'
    );
}

function cpqflow_fail(string $message): never
{
    http_response_code(500);
    ?>
    <!doctype html>
    <html lang="es-MX">
    <head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <title>Conversión · Colibrí Print</title>
      <style>
        body{
          margin:0;
          padding:30px;
          background:#071321;
          color:#fff;
          font-family:Arial,sans-serif
        }
        .box{
          max-width:820px;
          margin:50px auto;
          padding:25px;
          border:1px solid #284d66;
          border-radius:16px;
          background:#0c1d2b
        }
        h1{margin:0 0 10px;color:#ff657e}
        .msg{
          padding:14px;
          border:1px solid #31485a;
          border-radius:10px;
          background:#07111a;
          white-space:pre-wrap;
          font:13px/1.5 Consolas,monospace
        }
        a{
          display:inline-block;
          margin-top:16px;
          padding:11px 15px;
          border-radius:9px;
          background:#1dbfe8;
          color:#04131c;
          text-decoration:none;
          font-weight:800
        }
      </style>
    </head>
    <body>
      <div class="box">
        <h1>No se pudo convertir</h1>
        <div class="msg"><?=cpqflow_h($message)?></div>
        <a href="/admin/cotizaciones_web.php">
          ← Volver a solicitudes web
        </a>
      </div>
    </body>
    </html>
    <?php
    exit;
}

function cpqflow_customer(
    PDO $pdo,
    array $request
): ?array {
    $customerId = (int)(
        $request['customer_id']
        ?? 0
    );

    if ($customerId > 0) {
        $st = $pdo->prepare(
            'SELECT
                id,
                name,
                email,
                phone,
                address,
                city,
                state,
                zip_code,
                tax_number,
                country
             FROM cp_customers
             WHERE id=?
               AND enabled=1
             LIMIT 1'
        );

        $st->execute([
            $customerId,
        ]);

        $row =
            $st->fetch(
                PDO::FETCH_ASSOC
            );

        if ($row) {
            return $row;
        }
    }

    $email = trim(
        (string)($request['email'] ?? '')
    );

    if ($email !== '') {
        $st = $pdo->prepare(
            'SELECT
                id,
                name,
                email,
                phone,
                address,
                city,
                state,
                zip_code,
                tax_number,
                country
             FROM cp_customers
             WHERE enabled=1
               AND LOWER(email)=LOWER(?)
             ORDER BY id
             LIMIT 1'
        );

        $st->execute([
            $email,
        ]);

        $row =
            $st->fetch(
                PDO::FETCH_ASSOC
            );

        if ($row) {
            return $row;
        }
    }

    return null;
}

function cpqflow_create_customer(
    PDO $pdo,
    array $request
): int {
    $st = $pdo->prepare(
        'INSERT INTO cp_customers
         (
            source_type,
            source_id,
            name,
            email,
            phone,
            country,
            enabled,
            created_at,
            updated_at
         )
         VALUES(
            ?,?,?,?,?,?,
            1,
            NOW(),
            NOW()
         )'
    );

    $st->execute([
        'web_print_request',
        (int)$request['id'],
        trim(
            (string)($request['customer_name'] ?? '')
        ) ?: 'Cliente web',
        trim(
            (string)($request['email'] ?? '')
        ) ?: null,
        trim(
            (string)($request['phone'] ?? '')
        ) ?: null,
        'MX',
    ]);

    return (int)$pdo->lastInsertId();
}

function cpqflow_quote_number(
    PDO $pdo
): string {
    $prefix =
        'CP-'
        . date('Y')
        . '-';

    $st = $pdo->prepare(
        'SELECT quote_number
         FROM cp_quotes
         WHERE quote_number LIKE ?
         ORDER BY id DESC
         LIMIT 1'
    );

    $st->execute([
        $prefix . '%',
    ]);

    $last = $st->fetchColumn();
    $seq = 1;

    if (
        is_string($last)
        && preg_match(
            '/-(\d+)$/',
            $last,
            $m
        )
    ) {
        $seq =
            (int)$m[1]
            + 1;
    }

    return
        $prefix
        . str_pad(
            (string)$seq,
            5,
            '0',
            STR_PAD_LEFT
        );
}

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    cpqflow_fail(
        'Método no permitido.'
    );
}

if (!csrf_check($_POST['_csrf'] ?? null)) {
    cpqflow_fail(
        'La sesión expiró. Recarga la página.'
    );
}

$requestId = (int)(
    $_POST['request_id']
    ?? 0
);

if ($requestId <= 0) {
    cpqflow_fail(
        'Solicitud web inválida.'
    );
}

$pdo = db();

$condition =
    function_exists('quote_condition_default')
        ? quote_condition_default()
        : null;

$payment = (string)(
    $condition['payment_terms']
    ?? ''
);

$terms = (string)(
    $condition['terms']
    ?? ''
);

$deliveryTime = (string)(
    $condition['delivery_time']
    ?? ''
);

$deliveryPlace = (string)(
    $condition['delivery_place']
    ?? ''
);

try {
    $pdo->beginTransaction();

    $st = $pdo->prepare(
        'SELECT *
         FROM cp_web_quote_requests
         WHERE id=?
         FOR UPDATE'
    );

    $st->execute([
        $requestId,
    ]);

    $request =
        $st->fetch(
            PDO::FETCH_ASSOC
        );

    if (!$request) {
        throw new RuntimeException(
            'No se encontró la solicitud web.'
        );
    }

    $convertedId = (int)(
        $request['converted_quote_id']
        ?? 0
    );

    if ($convertedId > 0) {
        $pdo->commit();

        redirect(
            '/admin/cotizacion.php?id='
            . $convertedId
            . '&from_web=1'
        );
    }

    $files =
        web_flow_request_files(
            $requestId
        );

    if (!$files) {
        throw new RuntimeException(
            'La solicitud no tiene archivos/configuraciones registradas en el expediente.'
        );
    }

    $customer =
        cpqflow_customer(
            $pdo,
            $request
        );

    if (!$customer) {
        $customerId =
            cpqflow_create_customer(
                $pdo,
                $request
            );

        $st = $pdo->prepare(
            'SELECT
                id,
                name,
                email,
                phone,
                address,
                city,
                state,
                zip_code,
                tax_number,
                country
             FROM cp_customers
             WHERE id=?
             LIMIT 1'
        );

        $st->execute([
            $customerId,
        ]);

        $customer =
            $st->fetch(
                PDO::FETCH_ASSOC
            )
            ?: null;
    } else {
        $customerId =
            (int)$customer['id'];
    }

    if (!$customer) {
        throw new RuntimeException(
            'No fue posible asociar o crear el cliente.'
        );
    }

    $quoteNumber =
        cpqflow_quote_number(
            $pdo
        );

    $issueDate = date('Y-m-d');
    $validUntil = date(
        'Y-m-d',
        strtotime('+15 days')
    );

    $uid = (int)(
        current_user()['id']
        ?? 0
    );

    $reference =
        web_flow_reference(
            $requestId
        );

    $fileNames = [];
    $sourceFiles = [];

    foreach ($files as $file) {
        $fileNames[] =
            (string)$file['original_name'];

        $sourceFiles[] = [
            'file_id' => (int)$file['file_id'],
            'item_id' => (int)($file['request_item_id'] ?? 0),
            'name' => (string)$file['original_name'],
            'size' => (string)($file['size_name'] ?? ''),
            'material' => (string)($file['material_name'] ?? ''),
            'finish' => (string)($file['finish_name'] ?? ''),
            'copies' => (int)($file['copies'] ?? 1),
            'pages' => (int)($file['pages'] ?? 1),
            'unit_price' => (float)($file['unit_price'] ?? 0),
            'subtotal' => (float)($file['subtotal'] ?? 0),
        ];
    }

    $requestTotal =
        round(
            array_sum(
                array_map(
                    static fn(array $row): float =>
                        (float)($row['subtotal'] ?? 0),
                    $files
                )
            ),
            2
        );

    $notes = [
        'Solicitud recibida desde la web: '
        . $reference
        . '.',
        count($files)
        . ' archivo(s) original(es) vinculados al expediente.',
    ];

    $internal = [
        'ORIGEN: Solicitud web '
        . $reference,
        'Solicitud web ID: '
        . $requestId,
        'Servicio: impresión',
        'Cliente capturado: '
        . (string)($request['customer_name'] ?? ''),
        'WhatsApp: '
        . (string)($request['phone'] ?? 'No indicado'),
        'Correo: '
        . (string)($request['email'] ?? 'No indicado'),
        'Archivos: '
        . implode(
            ', ',
            $fileNames
        ),
    ];

    $sourceData = [
        'source' => 'web_print',
        'title' => 'Solicitud de impresión web',
        'input' => [
            'request_id' => $requestId,
            'file_count' => count($files),
        ],
        'result' => [
            'subtotal' => $requestTotal,
            'total' => $requestTotal,
        ],
        'web_request_id' => $requestId,
        'request_token' =>
            (string)$request['request_token'],
        'files' => $sourceFiles,
        'created_at' => date('c'),
    ];

    $st = $pdo->prepare(
        'INSERT INTO cp_quotes
         (
            quote_number,
            customer_id,
            status,
            issue_date,
            valid_until,
            client_reference,
            payment_terms,
            delivery_time,
            delivery_place,
            notes,
            terms,
            internal_notes,
            source_calculator,
            source_data,
            created_by,
            updated_by,
            created_at,
            updated_at
         )
         VALUES(
            ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
            NOW(),
            NOW()
         )'
    );

    $st->execute([
        $quoteNumber,
        $customerId,
        'draft',
        $issueDate,
        $validUntil,
        'Solicitud web ' . $reference,
        $payment ?: null,
        $deliveryTime ?: null,
        $deliveryPlace ?: null,
        implode("\n", $notes),
        $terms ?: null,
        implode("\n", $internal),
        'web_print',
        json_encode(
            $sourceData,
            JSON_UNESCAPED_UNICODE
            | JSON_UNESCAPED_SLASHES
        ),
        $uid ?: null,
        $uid ?: null,
    ]);

    $quoteId =
        (int)$pdo->lastInsertId();

    if ($quoteId <= 0) {
        throw new RuntimeException(
            'La cotización no devolvió un ID válido.'
        );
    }

    cp_ensure_quote_public_token(
        $pdo,
        $quoteId
    );

    $itemInsert = $pdo->prepare(
        'INSERT INTO cp_quote_items
         (
            quote_id,
            description,
            quantity,
            unit_price,
            subtotal,
            calculator_source,
            sort_order,
            created_at,
            updated_at
         )
         VALUES(
            ?,?,?,?,?,?,?,
            NOW(),
            NOW()
         )'
    );

    $mapInsert = $pdo->prepare(
        'INSERT INTO cp_web_quote_item_links
         (
            request_id,
            request_item_id,
            request_file_id,
            quote_id,
            quote_item_id,
            created_at
         )
         VALUES(?,?,?,?,?,NOW())'
    );

    $subtotal = 0.0;

    foreach ($files as $index => $file) {
        $billable = (float)(
            $file['billable_units']
            ?? 0
        );

        if ($billable <= 0) {
            $pages = max(
                1,
                (int)(
                    $file['pages']
                    ?? $file['page_count']
                    ?? 1
                )
            );

            $copies = max(
                1,
                (int)($file['copies'] ?? 1)
            );

            $billable =
                $pages
                * $copies;
        }

        $unitPrice =
            round(
                (float)(
                    $file['unit_price']
                    ?? 0
                ),
                2
            );

        $lineSubtotal =
            round(
                (float)(
                    $file['subtotal']
                    ?? ($billable * $unitPrice)
                ),
                2
            );

        if ($lineSubtotal < 0) {
            $lineSubtotal = 0.0;
        }

        $description =
            web_flow_item_description(
                $file
            );

        /*
         * Conservamos la tarifa del cotizador:
         * cantidad = unidades facturables
         * precio unitario = tarifa calculada
         * subtotal = subtotal ya validado por la API pública.
         */
        $itemInsert->execute([
            $quoteId,
            $description,
            $billable,
            $unitPrice,
            $lineSubtotal,
            'web_print',
            $index,
        ]);

        $quoteItemId =
            (int)$pdo->lastInsertId();

        $mapInsert->execute([
            $requestId,
            (int)($file['request_item_id'] ?? 0)
                ?: null,
            (int)$file['file_id'],
            $quoteId,
            $quoteItemId,
        ]);

        $subtotal +=
            $lineSubtotal;
    }

    $subtotal =
        round(
            $subtotal,
            2
        );

    $totals = $pdo->prepare(
        'INSERT INTO cp_quote_totals
         (
            quote_id,
            subtotal,
            discount,
            tax,
            total,
            internal_cost,
            profit,
            margin_pct,
            created_at,
            updated_at
         )
         VALUES(
            ?,?,?,?,?,?,?,?,
            NOW(),
            NOW()
         )'
    );

    $totals->execute([
        $quoteId,
        $subtotal,
        0,
        0,
        $subtotal,
        0,
        0,
        0,
    ]);

    $pdo->prepare(
        'UPDATE cp_web_quote_requests
         SET
            converted_quote_id=?,
            converted_at=NOW(),
            status=?,
            updated_at=NOW()
         WHERE id=?'
    )->execute([
        $quoteId,
        'quoted',
        $requestId,
    ]);

    if (!$pdo->inTransaction()) {
        throw new RuntimeException(
            'La transacción dejó de estar activa antes de confirmar.'
        );
    }

    $pdo->commit();

    redirect(
        '/admin/cotizacion.php?id='
        . $quoteId
        . '&from_web=1'
        . '&web_request_id='
        . $requestId
        . '&converted=1'
    );

} catch (Throwable $e) {
    if ($pdo->inTransaction()) {
        $pdo->rollBack();
    }

    error_log(
        '[SISACT][WEB_FLOW][CPQ->QUOTE] '
        . $e->getMessage()
    );

    cpqflow_fail(
        'La conversión fue revertida. '
        . $e->getMessage()
    );
}
