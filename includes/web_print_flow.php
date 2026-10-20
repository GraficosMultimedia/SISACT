<?php
declare(strict_types=1);

/**
 * SISACT · Flujo Web → Cotización → Orden V1
 *
 * Fuente maestra del expediente:
 * cp_web_quote_requests
 *   -> cp_web_quote_files
 *   -> cp_print_request_items
 *   -> cp_quotes / cp_quote_items
 *   -> cp_orders / cp_order_items
 *   -> cp_order_photos
 */

function web_flow_e(?string $value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function web_flow_table_exists(string $table): bool
{
    try {
        $st = db()->prepare(
            'SELECT COUNT(*)
             FROM information_schema.tables
             WHERE table_schema=DATABASE()
               AND table_name=?'
        );
        $st->execute([$table]);
        return (int)$st->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function web_flow_column_exists(string $table, string $column): bool
{
    try {
        $st = db()->prepare(
            'SELECT COUNT(*)
             FROM information_schema.columns
             WHERE table_schema=DATABASE()
               AND table_name=?
               AND column_name=?'
        );
        $st->execute([$table, $column]);
        return (int)$st->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function web_flow_reference(int $requestId): string
{
    return 'CPQ-' . str_pad((string)$requestId, 6, '0', STR_PAD_LEFT);
}

function web_flow_money(float $value): string
{
    return '$' . number_format($value, 2, '.', ',');
}

function web_flow_format_bytes(int $bytes): string
{
    if ($bytes >= 1048576) {
        return number_format($bytes / 1048576, 2) . ' MB';
    }
    if ($bytes >= 1024) {
        return number_format($bytes / 1024, 1) . ' KB';
    }
    return number_format(max(0, $bytes)) . ' B';
}

function web_flow_color_label(string $color): string
{
    return strtolower($color) === 'bw'
        ? 'Blanco y negro'
        : 'Color';
}

function web_flow_request_files(int $requestId): array
{
    if (
        $requestId <= 0
        || !web_flow_table_exists('cp_web_quote_files')
    ) {
        return [];
    }

    $sql =
        'SELECT
            f.id AS file_id,
            f.request_id,
            f.original_name,
            f.stored_path,
            f.mime_type,
            f.extension,
            f.size_bytes,
            f.sha256,
            f.page_count AS file_page_count,
            f.created_at AS file_created_at,

            i.id AS request_item_id,
            i.service_key,
            i.size_id,
            i.size_name,
            i.width_mm,
            i.height_mm,
            i.orientation,
            i.material_id,
            i.material_name,
            i.color_mode,
            i.finish_id,
            i.finish_name,
            i.copies,
            i.pages,
            i.unit_price,
            i.subtotal,
            i.pricing_status,
            i.notes,
            i.page_count,
            i.print_sides,
            i.sheet_count,
            i.billable_units,
            i.service_type,
            i.pricing_mode,
            i.quantity
         FROM cp_web_quote_files f
         LEFT JOIN cp_print_request_items i
           ON i.file_id=f.id
          AND i.request_id=f.request_id
         WHERE f.request_id=?
         ORDER BY f.id ASC, i.id ASC';

    $st = db()->prepare($sql);
    $st->execute([$requestId]);

    return $st->fetchAll(PDO::FETCH_ASSOC) ?: [];
}

function web_flow_request_total(int $requestId): float
{
    if (
        $requestId <= 0
        || !web_flow_table_exists('cp_print_request_items')
    ) {
        return 0.0;
    }

    $st = db()->prepare(
        'SELECT COALESCE(SUM(subtotal),0)
         FROM cp_print_request_items
         WHERE request_id=?'
    );
    $st->execute([$requestId]);

    return round((float)$st->fetchColumn(), 2);
}

function web_flow_request_file_count(int $requestId): int
{
    if (
        $requestId <= 0
        || !web_flow_table_exists('cp_web_quote_files')
    ) {
        return 0;
    }

    $st = db()->prepare(
        'SELECT COUNT(*)
         FROM cp_web_quote_files
         WHERE request_id=?'
    );
    $st->execute([$requestId]);

    return (int)$st->fetchColumn();
}

function web_flow_request_by_token(string $token): ?array
{
    if (!preg_match('/^[a-f0-9]{64}$/i', $token)) {
        return null;
    }

    $orderCols = '';
    if (web_flow_column_exists('cp_web_quote_requests', 'converted_order_id')) {
        $orderCols =
            ',r.converted_order_id,r.converted_order_at';
    }

    $st = db()->prepare(
        "SELECT
            r.id,
            r.request_token,
            r.customer_id,
            r.service_key,
            r.customer_name,
            r.email,
            r.phone,
            r.quantity,
            r.status,
            r.created_at,
            r.updated_at,
            r.converted_quote_id,
            r.converted_at
            {$orderCols},
            q.quote_number,
            q.status AS quote_status
         FROM cp_web_quote_requests r
         LEFT JOIN cp_quotes q
           ON q.id=r.converted_quote_id
         WHERE r.request_token=?
         LIMIT 1"
    );

    $st->execute([$token]);
    $row = $st->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        return null;
    }

    $requestId = (int)$row['id'];

    $row['reference'] = web_flow_reference($requestId);
    $row['file_count'] = web_flow_request_file_count($requestId);
    $row['estimate_total'] = web_flow_request_total($requestId);

    return $row;
}

function web_flow_request_id_for_quote(int $quoteId): int
{
    if ($quoteId <= 0) {
        return 0;
    }

    if (web_flow_column_exists('cp_web_quote_requests', 'converted_quote_id')) {
        $st = db()->prepare(
            'SELECT id
             FROM cp_web_quote_requests
             WHERE converted_quote_id=?
             ORDER BY id DESC
             LIMIT 1'
        );
        $st->execute([$quoteId]);
        $id = (int)($st->fetchColumn() ?: 0);

        if ($id > 0) {
            return $id;
        }
    }

    try {
        $st = db()->prepare(
            'SELECT source_data
             FROM cp_quotes
             WHERE id=?
             LIMIT 1'
        );
        $st->execute([$quoteId]);

        $sourceData = (string)($st->fetchColumn() ?: '');
        if ($sourceData !== '') {
            $decoded = json_decode($sourceData, true);

            if (is_array($decoded)) {
                return (int)($decoded['web_request_id'] ?? 0);
            }
        }
    } catch (Throwable $e) {
        return 0;
    }

    return 0;
}

function web_flow_file_row(int $fileId): ?array
{
    if ($fileId <= 0) {
        return null;
    }

    $st = db()->prepare(
        'SELECT
            f.*,
            r.customer_name,
            r.service_key,
            r.converted_quote_id
         FROM cp_web_quote_files f
         INNER JOIN cp_web_quote_requests r
           ON r.id=f.request_id
         WHERE f.id=?
         LIMIT 1'
    );

    $st->execute([$fileId]);
    $row = $st->fetch(PDO::FETCH_ASSOC);

    return $row ?: null;
}

function web_flow_resolve_source_file(array $file): string
{
    $stored = trim((string)($file['stored_path'] ?? ''));

    if (
        $stored === ''
        || !str_starts_with(
            $stored,
            '/uploads/cotizador/impresiones/'
        )
    ) {
        throw new RuntimeException(
            'La ruta del archivo web no es válida.'
        );
    }

    $projectRoot = realpath(__DIR__ . '/..');
    $allowedRoot = realpath(
        __DIR__ . '/../uploads/cotizador/impresiones'
    );

    if (!$projectRoot || !$allowedRoot) {
        throw new RuntimeException(
            'No se pudo resolver el almacenamiento de solicitudes web.'
        );
    }

    $candidate = realpath(
        $projectRoot . $stored
    );

    if (
        !$candidate
        || !is_file($candidate)
        || !str_starts_with(
            str_replace('\\', '/', $candidate),
            rtrim(
                str_replace('\\', '/', $allowedRoot),
                '/'
            ) . '/'
        )
    ) {
        throw new RuntimeException(
            'El archivo solicitado no existe o está fuera del almacenamiento autorizado.'
        );
    }

    return $candidate;
}

function web_flow_item_description(array $row): string
{
    $parts = [];

    $name = trim(
        (string)($row['original_name'] ?? '')
    );

    $parts[] = $name !== ''
        ? $name
        : 'Archivo del cliente';

    $size = trim(
        (string)($row['size_name'] ?? '')
    );
    if ($size !== '') {
        $parts[] = $size;
    }

    $material = trim(
        (string)($row['material_name'] ?? '')
    );
    if ($material !== '') {
        $parts[] = $material;
    }

    $finish = trim(
        (string)($row['finish_name'] ?? '')
    );
    if ($finish !== '') {
        $parts[] = $finish;
    }

    $parts[] = web_flow_color_label(
        (string)($row['color_mode'] ?? 'color')
    );

    $pages = max(
        1,
        (int)(
            $row['pages']
            ?? $row['page_count']
            ?? $row['file_page_count']
            ?? 1
        )
    );

    $copies = max(
        1,
        (int)($row['copies'] ?? 1)
    );

    $parts[] =
        $pages . ' pág.'
        . ' × '
        . $copies . ' copia(s)';

    $notes = trim(
        (string)($row['notes'] ?? '')
    );

    if ($notes !== '') {
        $parts[] = 'Nota: ' . $notes;
    }

    $description =
        'Impresión · ' . implode(' · ', $parts);

    if (function_exists('mb_substr')) {
        return mb_substr(
            $description,
            0,
            500
        );
    }

    return substr($description, 0, 500);
}

function web_flow_item_caption(array $row, int $requestId): string
{
    $bits = [
        web_flow_reference($requestId),
    ];

    foreach (
        [
            'size_name',
            'material_name',
            'finish_name',
        ]
        as $key
    ) {
        $value = trim(
            (string)($row[$key] ?? '')
        );

        if ($value !== '') {
            $bits[] = $value;
        }
    }

    $bits[] = web_flow_color_label(
        (string)($row['color_mode'] ?? 'color')
    );

    return implode(' · ', $bits);
}

function web_flow_import_request_files_to_order(
    PDO $pdo,
    int $requestId,
    int $orderId,
    int $userId,
    array &$copiedFiles = []
): int {
    if ($requestId <= 0 || $orderId <= 0) {
        return 0;
    }

    if (!web_flow_table_exists('cp_order_photos')) {
        throw new RuntimeException(
            'La orden no tiene instalado el almacenamiento cp_order_photos.'
        );
    }

    if (!web_flow_table_exists('cp_web_quote_order_files')) {
        throw new RuntimeException(
            'Falta la tabla de vínculo de archivos web con órdenes.'
        );
    }

    $rows = web_flow_request_files(
        $requestId
    );

    if (!$rows) {
        return 0;
    }

    $projectRoot = realpath(
        __DIR__ . '/..'
    );

    if (!$projectRoot) {
        throw new RuntimeException(
            'No se pudo resolver la raíz de SISACT.'
        );
    }

    $destDir =
        $projectRoot
        . '/uploads/orders/'
        . $orderId;

    if (
        !is_dir($destDir)
        && !mkdir(
            $destDir,
            0755,
            true
        )
    ) {
        throw new RuntimeException(
            'No se pudo crear la carpeta de archivos de la orden.'
        );
    }

    $count = 0;

    foreach ($rows as $row) {
        $webFileId = (int)($row['file_id'] ?? 0);

        if ($webFileId <= 0) {
            continue;
        }

        $exists = $pdo->prepare(
            'SELECT order_photo_id
             FROM cp_web_quote_order_files
             WHERE request_file_id=?
               AND order_id=?
             LIMIT 1'
        );

        $exists->execute([
            $webFileId,
            $orderId,
        ]);

        if ((int)($exists->fetchColumn() ?: 0) > 0) {
            continue;
        }

        $source = web_flow_resolve_source_file(
            $row
        );

        $original = trim(
            (string)($row['original_name'] ?? 'archivo')
        );

        if ($original === '') {
            $original = 'archivo';
        }

        if (strlen($original) > 190) {
            $original = substr(
                $original,
                0,
                190
            );
        }

        $ext = strtolower(
            (string)($row['extension'] ?? '')
        );

        if ($ext === '') {
            $ext = strtolower(
                (string)pathinfo(
                    $original,
                    PATHINFO_EXTENSION
                )
            );
        }

        if (!preg_match('/^[a-z0-9]{1,10}$/', $ext)) {
            $ext = 'bin';
        }

        $destName =
            bin2hex(random_bytes(18))
            . '.'
            . $ext;

        $dest =
            $destDir
            . '/'
            . $destName;

        if (!copy($source, $dest)) {
            throw new RuntimeException(
                'No se pudo copiar '
                . $original
                . ' al expediente de la orden.'
            );
        }

        $copiedFiles[] = $dest;

        $publicPath =
            '/uploads/orders/'
            . $orderId
            . '/'
            . $destName;

        $size = (int)($row['size_bytes'] ?? 0);
        if ($size <= 0) {
            $size = (int)(
                @filesize($dest)
                ?: 0
            );
        }

        $mime = trim(
            (string)($row['mime_type'] ?? '')
        );

        if ($mime === '') {
            $mime = (string)(
                (new finfo(FILEINFO_MIME_TYPE))
                ->file($dest)
            );
        }

        $caption = web_flow_item_caption(
            $row,
            $requestId
        );

        $photo = $pdo->prepare(
            'INSERT INTO cp_order_photos
             (
                order_id,
                file_path,
                original_name,
                mime_type,
                file_size,
                photo_type,
                caption,
                created_by,
                created_at,
                updated_at
             )
             VALUES(
                ?,?,?,?,?,?,?,?,
                NOW(),
                NOW()
             )'
        );

        $photo->execute([
            $orderId,
            $publicPath,
            $original,
            $mime,
            $size,
            'client_file',
            $caption,
            $userId > 0
                ? $userId
                : null,
        ]);

        $photoId = (int)$pdo->lastInsertId();

        $link = $pdo->prepare(
            'INSERT INTO cp_web_quote_order_files
             (
                request_id,
                request_file_id,
                order_id,
                order_photo_id,
                created_at
             )
             VALUES(?,?,?,?,NOW())'
        );

        $link->execute([
            $requestId,
            $webFileId,
            $orderId,
            $photoId,
        ]);

        $count++;
    }

    return $count;
}

function web_flow_bind_request_token_to_order(
    PDO $pdo,
    int $requestId,
    int $orderId
): void {
    if ($requestId <= 0 || $orderId <= 0) {
        return;
    }

    $st = $pdo->prepare(
        'SELECT request_token
         FROM cp_web_quote_requests
         WHERE id=?
         LIMIT 1'
    );

    $st->execute([$requestId]);

    $token = trim(
        (string)($st->fetchColumn() ?: '')
    );

    if (
        !preg_match(
            '/^[a-f0-9]{64}$/i',
            $token
        )
    ) {
        throw new RuntimeException(
            'La solicitud web no tiene un token de seguimiento válido.'
        );
    }

    $check = $pdo->prepare(
        'SELECT order_id
         FROM cp_tracking_tokens
         WHERE token=?
         LIMIT 1'
    );

    $check->execute([$token]);
    $existing = (int)(
        $check->fetchColumn()
        ?: 0
    );

    if ($existing > 0 && $existing !== $orderId) {
        throw new RuntimeException(
            'El token público ya está asociado a otra orden.'
        );
    }

    if ($existing <= 0) {
        $pdo->prepare(
            'INSERT INTO cp_tracking_tokens
             (
                order_id,
                token,
                active,
                created_at
             )
             VALUES(?,?,1,NOW())'
        )->execute([
            $orderId,
            $token,
        ]);
    }
}

function web_flow_link_order(
    PDO $pdo,
    int $requestId,
    int $orderId
): void {
    if ($requestId <= 0 || $orderId <= 0) {
        return;
    }

    if (
        web_flow_column_exists(
            'cp_web_quote_requests',
            'converted_order_id'
        )
    ) {
        $pdo->prepare(
            'UPDATE cp_web_quote_requests
             SET
                converted_order_id=?,
                converted_order_at=NOW(),
                status=?,
                updated_at=NOW()
             WHERE id=?'
        )->execute([
            $orderId,
            'closed',
            $requestId,
        ]);
    } else {
        $pdo->prepare(
            'UPDATE cp_web_quote_requests
             SET
                status=?,
                updated_at=NOW()
             WHERE id=?'
        )->execute([
            'closed',
            $requestId,
        ]);
    }
}

/**
 * Reemplaza el bloque antiguo de UN solo archivo en cotizacion.php.
 * cotizacion.php ya protege esta función con function_exists().
 */
if (!function_exists('cp_quote_web_attachment_block')) {
    function cp_quote_web_attachment_block(array $quote): void
    {
        $quoteId = (int)($quote['id'] ?? 0);
        $requestId = 0;

        $sourceData = $quote['source_data'] ?? '';

        if (is_string($sourceData) && trim($sourceData) !== '') {
            $decoded = json_decode(
                $sourceData,
                true
            );

            if (is_array($decoded)) {
                $requestId = (int)(
                    $decoded['web_request_id']
                    ?? 0
                );
            }
        } elseif (is_array($sourceData)) {
            $requestId = (int)(
                $sourceData['web_request_id']
                ?? 0
            );
        }

        if ($requestId <= 0 && $quoteId > 0) {
            $requestId =
                web_flow_request_id_for_quote(
                    $quoteId
                );
        }

        if ($requestId <= 0) {
            return;
        }

        try {
            $files = web_flow_request_files(
                $requestId
            );
        } catch (Throwable $e) {
            $files = [];
        }

        ?>
        <section
            class="quote-client-file no-print"
            aria-labelledby="quote-client-file-title"
        >
            <div class="quote-client-file-top">
                <div class="quote-client-file-heading">
                    <div class="quote-client-file-icon">📎</div>
                    <div>
                        <span class="eyebrow">
                            EXPEDIENTE · ARCHIVOS DEL CLIENTE
                        </span>
                        <h4 id="quote-client-file-title">
                            Material recibido desde <?=web_flow_e(web_flow_reference($requestId))?>
                        </h4>
                        <p>
                            Estos archivos acompañarán automáticamente la orden de servicio cuando la cotización sea aprobada.
                        </p>
                    </div>
                </div>

                <a
                    class="quote-client-file-origin"
                    href="/admin/cotizaciones_web.php?focus=<?=$requestId?>"
                >
                    <?=web_flow_e(web_flow_reference($requestId))?> ↗
                </a>
            </div>

            <?php if ($files): ?>
                <?php foreach ($files as $file): ?>
                    <div class="quote-client-file-record">
                        <div class="quote-client-file-data">
                            <strong>
                                <?=web_flow_e((string)$file['original_name'])?>
                            </strong>

                            <div>
                                <span class="quote-client-file-badge">
                                    <?=web_flow_e(strtoupper((string)($file['extension'] ?? 'ARCHIVO')))?>
                                </span>

                                <span>
                                    <?=web_flow_e(web_flow_format_bytes((int)($file['size_bytes'] ?? 0)))?>
                                </span>

                                <?php if (!empty($file['size_name'])): ?>
                                    <span>
                                        <?=web_flow_e((string)$file['size_name'])?>
                                    </span>
                                <?php endif; ?>

                                <?php if (!empty($file['material_name'])): ?>
                                    <span>
                                        <?=web_flow_e((string)$file['material_name'])?>
                                    </span>
                                <?php endif; ?>

                                <span>
                                    <?=web_flow_e(web_flow_color_label((string)($file['color_mode'] ?? 'color')))?>
                                </span>
                            </div>
                        </div>

                        <div class="quote-client-file-actions">
                            <a
                                class="btn btn-secondary"
                                href="/admin/archivo_web.php?id=<?=((int)$file['file_id'])?>&mode=inline"
                                target="_blank"
                                rel="noopener"
                            >
                                Ver archivo
                            </a>

                            <a
                                class="btn btn-primary"
                                href="/admin/archivo_web.php?id=<?=((int)$file['file_id'])?>&mode=download"
                            >
                                Descargar
                            </a>
                        </div>
                    </div>
                <?php endforeach; ?>
            <?php else: ?>
                <div class="quote-client-file-missing">
                    <strong>
                        La solicitud está vinculada, pero no se encontraron archivos registrados.
                    </strong>
                </div>
            <?php endif; ?>
        </section>
        <?php
    }
}
