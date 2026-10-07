<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/bootstrap.php';

header('Content-Type: application/json; charset=utf-8');

try {
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        http_response_code(405);
        echo json_encode(['ok'=>false,'message'=>'Método no permitido.'], JSON_UNESCAPED_UNICODE);
        exit;
    }

    cp_check_csrf($_POST['csrf'] ?? null);

    if (!isset($_FILES['files']) || !is_array($_FILES['files']['name'] ?? null)) {
        throw new RuntimeException('No se recibieron archivos.');
    }

    $token = bin2hex(random_bytes(16));
    $tmpDir = CP_TMP_DIR . '/' . $token;

    if (!mkdir($tmpDir, 0775, true) && !is_dir($tmpDir)) {
        throw new RuntimeException('No fue posible preparar el almacenamiento temporal.');
    }

    $allowed = [
        'pdf'  => ['application/pdf'],
        'jpg'  => ['image/jpeg'],
        'jpeg' => ['image/jpeg'],
        'png'  => ['image/png'],
    ];

    $result = [];
    $count = count($_FILES['files']['name']);

    for ($i = 0; $i < $count; $i++) {
        $error = (int)($_FILES['files']['error'][$i] ?? UPLOAD_ERR_NO_FILE);
        if ($error !== UPLOAD_ERR_OK) {
            throw new RuntimeException('No fue posible subir uno de los archivos. Código: '.$error);
        }

        $original = basename((string)$_FILES['files']['name'][$i]);
        $size = (int)$_FILES['files']['size'][$i];
        $tmp = (string)$_FILES['files']['tmp_name'][$i];

        if ($original === '' || !is_uploaded_file($tmp)) {
            throw new RuntimeException('Uno de los archivos recibidos no es válido.');
        }

        if ($size <= 0 || $size > CP_MAX_FILE_BYTES) {
            throw new RuntimeException('El archivo "'.$original.'" supera el límite de 25 MB o está vacío.');
        }

        $ext = strtolower(pathinfo($original, PATHINFO_EXTENSION));
        if (!isset($allowed[$ext])) {
            throw new RuntimeException('El formato "'.$ext.'" no está permitido. Usa PDF, JPG o PNG.');
        }

        $mime = '';
        if (function_exists('finfo_open')) {
            $fi = finfo_open(FILEINFO_MIME_TYPE);
            if ($fi) {
                $mime = (string)finfo_file($fi, $tmp);
                finfo_close($fi);
            }
        }

        // Para imágenes validamos el MIME; para PDF aceptamos application/pdf.
        if ($mime !== '' && !in_array($mime, $allowed[$ext], true)) {
            throw new RuntimeException('El contenido de "'.$original.'" no coincide con su extensión.');
        }

        $stored = bin2hex(random_bytes(16)) . '.' . $ext;
        $destination = $tmpDir . '/' . $stored;

        if (!move_uploaded_file($tmp, $destination)) {
            throw new RuntimeException('No fue posible guardar temporalmente "'.$original.'".');
        }

        // IMPORTANTE: no se analiza el archivo y no se intenta contar páginas.
        $result[] = [
            'token_name' => $stored,
            'name' => $original,
            'extension' => $ext,
            'size' => $size,
            'pages' => 0,
            'page_source' => 'manual',
            'analysis_status' => 'manual',
        ];
    }

    echo json_encode([
        'ok' => true,
        'token' => $token,
        'files' => $result,
    ], JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
} catch (Throwable $e) {
    error_log('Colibri Print upload: '.$e->getMessage().' @ '.$e->getFile().':'.$e->getLine());
    http_response_code($e instanceof RuntimeException ? 422 : 500);
    echo json_encode([
        'ok' => false,
        'message' => $e->getMessage(),
    ], JSON_UNESCAPED_UNICODE);
}
