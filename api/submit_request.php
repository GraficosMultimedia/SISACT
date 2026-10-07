<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/bootstrap.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    exit('Método no permitido.');
}

cp_check_csrf($_POST['csrf'] ?? null);

$name  = trim((string)($_POST['customer_name'] ?? ''));
$email = trim((string)($_POST['customer_email'] ?? ''));
$phone = trim((string)($_POST['customer_phone'] ?? ''));

$items = json_decode(
    (string)($_POST['items_json'] ?? '[]'),
    true
);

if (
    $name === '' ||
    !filter_var($email, FILTER_VALIDATE_EMAIL) ||
    $phone === ''
) {
    http_response_code(422);
    exit('Datos de solicitud incompletos.');
}

if (!is_array($items) || !$items) {
    http_response_code(422);
    exit('No se recibieron las configuraciones de los archivos.');
}


/*
|--------------------------------------------------------------------------
| ARCHIVOS
|--------------------------------------------------------------------------
*/

$files = $_FILES['files'] ?? null;

if (!is_array($files) || !isset($files['name'])) {
    http_response_code(422);
    exit(
        'No se recibió ningún archivo. El formulario debe enviar los archivos como files[].'
    );
}

$allowedExt = ['pdf', 'jpg', 'jpeg', 'png'];
$maxBytes = 25 * 1024 * 1024;


/*
|--------------------------------------------------------------------------
| NORMALIZAR FILES
|--------------------------------------------------------------------------
*/

function normalize_uploaded_files(array $files): array
{
    $normalized = [];

    $count = is_array($files['name'] ?? null)
        ? count($files['name'])
        : 0;

    for ($i = 0; $i < $count; $i++) {

        $normalized[] = [
            'name'     => (string)($files['name'][$i] ?? ''),
            'type'     => (string)($files['type'][$i] ?? ''),
            'tmp_name' => (string)($files['tmp_name'][$i] ?? ''),
            'error'    => (int)($files['error'][$i] ?? UPLOAD_ERR_NO_FILE),
            'size'     => (int)($files['size'][$i] ?? 0),
        ];
    }

    return $normalized;
}

$uploaded = normalize_uploaded_files($files);

if (!$uploaded) {
    http_response_code(422);
    exit('No se recibió ningún archivo.');
}


/*
|--------------------------------------------------------------------------
| BASE DE DATOS
|--------------------------------------------------------------------------
*/

$config = require __DIR__ . '/../config/config.php';

$dbCfg = $config['db'];

$dsn =
    'mysql:host=' . $dbCfg['host'] .
    ';dbname=' . $dbCfg['name'] .
    ';charset=' . $dbCfg['charset'];

$db = new PDO(
    $dsn,
    (string)$dbCfg['user'],
    (string)$dbCfg['pass'],
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]
);


/*
|--------------------------------------------------------------------------
| CONSULTAS
|--------------------------------------------------------------------------
|
| IMPORTANTE:
| Usamos cp_print_price_rules porque esa es la tabla que existe
| actualmente en tu base de datos.
|
*/

$sizeStmt = $db->prepare(
    'SELECT *
     FROM cp_print_sizes
     WHERE id = ?
     AND enabled = 1
     LIMIT 1'
);

$matStmt = $db->prepare(
    'SELECT *
     FROM cp_print_materials
     WHERE id = ?
     AND enabled = 1
     LIMIT 1'
);

$finStmt = $db->prepare(
    'SELECT *
     FROM cp_print_finishes
     WHERE id = ?
     AND enabled = 1
     LIMIT 1'
);


/*
|--------------------------------------------------------------------------
| TARIFA
|--------------------------------------------------------------------------
*/

$priceStmt = $db->prepare(
    'SELECT *
     FROM cp_print_price_rules
     WHERE size_id = ?
     AND material_id = ?
     AND (finish_id = ? OR finish_id IS NULL)
     AND (color_mode = ? OR color_mode = "both")
     AND pricing_mode = ?
     AND enabled = 1
     ORDER BY
        CASE WHEN finish_id = ? THEN 0 ELSE 1 END,
        CASE WHEN color_mode = ? THEN 0 ELSE 1 END,
        sort_order ASC,
        id ASC
     LIMIT 1'
);

/*
|--------------------------------------------------------------------------
| VALIDAR ARCHIVOS Y CALCULAR TOTAL
|--------------------------------------------------------------------------
*/

$validated = [];

$total = 0.0;

foreach ($uploaded as $index => $file) {

    if ($file['error'] !== UPLOAD_ERR_OK) {

        http_response_code(422);

        exit(
            'No fue posible recibir el archivo ' .
            basename($file['name']) .
            '. Código: ' .
            $file['error']
        );
    }


    if (!is_uploaded_file($file['tmp_name'])) {

        http_response_code(422);

        exit(
            'El archivo ' .
            basename($file['name']) .
            ' no fue recibido correctamente.'
        );
    }


    if (
        $file['size'] <= 0 ||
        $file['size'] > $maxBytes
    ) {

        http_response_code(422);

        exit(
            'El archivo ' .
            basename($file['name']) .
            ' supera el límite de 25 MB o está vacío.'
        );
    }


    $originalName = basename($file['name']);

    $extension = strtolower(
        pathinfo($originalName, PATHINFO_EXTENSION)
    );


    if (!in_array($extension, $allowedExt, true)) {

        http_response_code(422);

        exit(
            'El archivo ' .
            $originalName .
            ' no tiene un formato permitido.'
        );
    }


    /*
    |--------------------------------------------------------------------------
    | CONFIGURACIÓN DEL ARCHIVO
    |--------------------------------------------------------------------------
    */

    $item = is_array($items[$index] ?? null)
        ? $items[$index]
        : [];


    $sizeId = (int)($item['size_id'] ?? 0);

    $matId = (int)($item['material_id'] ?? 0);

    $finId = (int)($item['finish_id'] ?? 0);


    $color =
        (($item['color_mode'] ?? 'color') === 'bw')
            ? 'bw'
            : 'color';


    $mode =
        (($item['pricing_mode'] ?? 'per_page') === 'per_sheet')
            ? 'per_sheet'
            : 'per_page';


    $copies = max(
        1,
        min(
            9999,
            (int)($item['copies'] ?? 1)
        )
    );


    /*
    |--------------------------------------------------------------------------
    | PÁGINAS
    |--------------------------------------------------------------------------
    */

    $pages = max(
        1,
        min(
            100000,
            (int)($item['pages'] ?? 1)
        )
    );


    /*
    |--------------------------------------------------------------------------
    | BUSCAR TAMAÑO
    |--------------------------------------------------------------------------
    */

    $sizeStmt->execute([$sizeId]);

    $sizeRow = $sizeStmt->fetch();


    /*
    |--------------------------------------------------------------------------
    | BUSCAR MATERIAL
    |--------------------------------------------------------------------------
    */

    $matStmt->execute([$matId]);

    $matRow = $matStmt->fetch();


    /*
    |--------------------------------------------------------------------------
    | BUSCAR ACABADO
    |--------------------------------------------------------------------------
    */

    $finStmt->execute([$finId]);

    $finRow = $finStmt->fetch();


    /*
    |--------------------------------------------------------------------------
    | BUSCAR REGLA DE PRECIO
    |--------------------------------------------------------------------------
    */

    $dbPricingMode = $mode === 'per_sheet'
    ? 'sheet'
    : 'page';

$dbColorMode = $color;

$priceStmt->execute([
    $sizeId,
    $matId,
    $finId,
    $dbColorMode,
    $dbPricingMode,
    $finId,
    $dbColorMode
]);

    $priceRow = $priceStmt->fetch();


    if (
        !$sizeRow ||
        !$matRow ||
        !$finRow ||
        !$priceRow
    ) {

        http_response_code(422);

        exit(
            'Una de las combinaciones seleccionadas ' .
            'no tiene una tarifa activa.'
        );
    }


    /*
    |--------------------------------------------------------------------------
    | CÁLCULO
    |--------------------------------------------------------------------------
    */

    if ($mode === 'per_sheet') {

        $billableUnits = (int)ceil($pages / 2);

    } else {

        $billableUnits = $pages;
    }


    $unitPrice = (float)$priceRow['unit_price'];

    $subtotal =
        $unitPrice *
        $billableUnits *
        $copies;


    $total += $subtotal;


    /*
    |--------------------------------------------------------------------------
    | MIME
    |--------------------------------------------------------------------------
    */

    $mime = '';

    if (function_exists('finfo_open')) {

        $f = finfo_open(FILEINFO_MIME_TYPE);

        if ($f) {

            $mime = (string)finfo_file(
                $f,
                $file['tmp_name']
            );

            finfo_close($f);
        }
    }


    if ($mime === '') {

        $mime = (string)$file['type'];
    }


    if ($mime === '') {

        $mime = 'application/octet-stream';
    }


    /*
    |--------------------------------------------------------------------------
    | NOMBRE INTERNO
    |--------------------------------------------------------------------------
    */

    $stored = bin2hex(
        random_bytes(16)
    ) . '.' . $extension;


    /*
    |--------------------------------------------------------------------------
    | GUARDAR DATOS VALIDADOS
    |--------------------------------------------------------------------------
    */

    $validated[] = [

        'tmp_name' => $file['tmp_name'],

        'stored' => $stored,

        'name' => $originalName,

        'mime' => $mime,

        'size' => $file['size'],

        'extension' => $extension,

        'pages' => $pages,

        'copies' => $copies,

        'billable_units' => $billableUnits,

        'size_id' => $sizeId,

        'size_name' => (string)$sizeRow['name'],

        'width_mm' => $sizeRow['width_mm'] ?? null,

        'height_mm' => $sizeRow['height_mm'] ?? null,

        'orientation' => $item['orientation']
            ?? null,

        'material_id' => $matId,

        'material_name' => (string)$matRow['name'],

        'finish_id' => $finId,

        'finish_name' => (string)$finRow['name'],

        'color' => $color,

        'mode' => $mode,

        'price_rule_id' => (int)$priceRow['id'],

        'unit_price' => $unitPrice,

        'subtotal' => $subtotal,

    ];
}


/*
|--------------------------------------------------------------------------
| VERIFICAR
|--------------------------------------------------------------------------
*/

if (!$validated) {

    http_response_code(422);

    exit(
        'No hay archivos válidos para registrar.'
    );
}


/*
|--------------------------------------------------------------------------
| CARPETA PRINCIPAL
|--------------------------------------------------------------------------
*/

$finalDir =
    __DIR__ .
    '/../uploads/print_requests';


if (
    !is_dir($finalDir) &&
    !mkdir($finalDir, 0775, true) &&
    !is_dir($finalDir)
) {

    http_response_code(500);

    exit(
        'No fue posible preparar la carpeta de archivos.'
    );
}


/*
|--------------------------------------------------------------------------
| TRANSACCIÓN
|--------------------------------------------------------------------------
*/

$db->beginTransaction();

$moved = [];


try {

    /*
    |--------------------------------------------------------------------------
    | CREAR SOLICITUD
    |--------------------------------------------------------------------------
    */

    $st = $db->prepare(
        'INSERT INTO cp_print_requests
        (
            customer_name,
            customer_email,
            customer_phone,
            status,
            total_estimate
        )
        VALUES (?, ?, ?, ?, ?)'
    );


    $st->execute([
        $name,
        $email,
        $phone,
        'new',
        $total
    ]);


    $requestId =
        (int)$db->lastInsertId();


    /*
    |--------------------------------------------------------------------------
    | CARPETA DE LA SOLICITUD
    |--------------------------------------------------------------------------
    */

    $requestDir =
        $finalDir .
        '/' .
        $requestId;


    if (
        !is_dir($requestDir) &&
        !mkdir($requestDir, 0775, true) &&
        !is_dir($requestDir)
    ) {

        throw new RuntimeException(
            'No fue posible crear la carpeta de la solicitud.'
        );
    }


    /*
    |--------------------------------------------------------------------------
    | INSERTAR ITEMS
    |--------------------------------------------------------------------------
    |
    | Utilizamos solamente columnas que realmente existen
    | en cp_print_request_items.
    |
    */

    $itemSt = $db->prepare(
        'INSERT INTO cp_print_request_items
        (
            request_id,
            service_key,
            size_id,
            size_name,
            width_mm,
            height_mm,
            orientation,
            material_id,
            material_name,
            color_mode,
            finish_id,
            finish_name,
            copies,
            pages,
            price_rule_id,
            unit_price,
            subtotal,
            pricing_status,
            notes,
            page_count,
            print_sides,
            sheet_count,
            billable_units,
            service_type,
            pricing_mode,
            quantity,
            created_at,
            updated_at
        )
        VALUES
        (
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,
            ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW()
        )'
    );


    foreach ($validated as $v) {

        /*
        |--------------------------------------------------------------------------
        | MOVER ARCHIVO
        |--------------------------------------------------------------------------
        */

        $finalPath =
            $requestDir .
            '/' .
            $v['stored'];


        if (
            !move_uploaded_file(
                $v['tmp_name'],
                $finalPath
            ) ||
            !is_file($finalPath)
        ) {

            throw new RuntimeException(
                'No fue posible guardar el archivo ' .
                $v['name']
            );
        }


        $moved[] = $finalPath;


        /*
        |--------------------------------------------------------------------------
        | RUTA Y DATOS DEL ARCHIVO
        |--------------------------------------------------------------------------
        |
        | Como la tabla actual no tiene stored_path/original_name,
        | los conservamos dentro de notes en JSON.
        |
        */

        $relativePath =
            'uploads/print_requests/' .
            $requestId .
            '/' .
            $v['stored'];


        $notes = json_encode(
            [
                'original_name' => $v['name'],
                'stored_path' => $relativePath,
                'mime_type' => $v['mime'],
                'file_size' => $v['size'],
                'extension' => $v['extension'],
            ],
            JSON_UNESCAPED_UNICODE |
            JSON_UNESCAPED_SLASHES
        );


        /*
        |--------------------------------------------------------------------------
        | INSERTAR ITEM
        |--------------------------------------------------------------------------
        */

        $itemSt->execute([

            $requestId,

            'document',

            $v['size_id'],

            $v['size_name'],

            $v['width_mm'],

            $v['height_mm'],

            $v['orientation'],

            $v['material_id'],

            $v['material_name'],

            $v['color'],

            $v['finish_id'],

            $v['finish_name'],

            $v['copies'],

            $v['pages'],

            $v['price_rule_id'],

            $v['unit_price'],

            $v['subtotal'],

            'calculated',

            $notes,

            $v['pages'],

            'single',

            $v['pages'] * $v['copies'],

            $v['billable_units'] * $v['copies'],

            'impresion',

            $v['mode'],

            $v['copies'],

        ]);
    }


    /*
    |--------------------------------------------------------------------------
    | CONFIRMAR
    |--------------------------------------------------------------------------
    */

    $db->commit();


    /*
    |--------------------------------------------------------------------------
    | REDIRECCIÓN
    |--------------------------------------------------------------------------
    */

    cp_redirect(
        '../solicitud_enviada.php?id=' .
        $requestId
    );


} catch (Throwable $e) {

    /*
    |--------------------------------------------------------------------------
    | DESHACER TRANSACCIÓN
    |--------------------------------------------------------------------------
    */

    if ($db->inTransaction()) {

        $db->rollBack();
    }


    /*
    |--------------------------------------------------------------------------
    | BORRAR ARCHIVOS
    |--------------------------------------------------------------------------
    */

    foreach ($moved as $path) {

        @unlink($path);
    }


    /*
    |--------------------------------------------------------------------------
    | LOG
    |--------------------------------------------------------------------------
    */

    $errorId =
        bin2hex(
            random_bytes(4)
        );


    error_log(
        'Colibri Print submit_request [' .
        $errorId .
        ']: ' .
        $e->getMessage() .
        ' @ ' .
        $e->getFile() .
        ':' .
        $e->getLine()
    );


    http_response_code(500);

    exit(
        'No fue posible registrar la solicitud. ' .
        'Código de error: ' .
        $errorId
    );
}