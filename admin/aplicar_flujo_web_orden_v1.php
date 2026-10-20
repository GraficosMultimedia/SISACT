<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Flujo Web → Orden Formal V1';

$root = dirname(__DIR__);
$templateRoot =
    $root
    . '/install/web_print_flow_v1';

$error = null;
$messages = [];

function wpf1_column_exists(
    string $table,
    string $column
): bool {
    $st = db()->prepare(
        'SELECT COUNT(*)
         FROM information_schema.columns
         WHERE table_schema=DATABASE()
           AND table_name=?
           AND column_name=?'
    );

    $st->execute([
        $table,
        $column,
    ]);

    return (int)$st->fetchColumn() > 0;
}

function wpf1_table_exists(
    string $table
): bool {
    $st = db()->prepare(
        'SELECT COUNT(*)
         FROM information_schema.tables
         WHERE table_schema=DATABASE()
           AND table_name=?'
    );

    $st->execute([
        $table,
    ]);

    return (int)$st->fetchColumn() > 0;
}

function wpf1_migrate(): void
{
    if (
        !wpf1_column_exists(
            'cp_web_quote_requests',
            'converted_order_id'
        )
    ) {
        db()->exec(
            "ALTER TABLE cp_web_quote_requests
             ADD COLUMN converted_order_id BIGINT UNSIGNED NULL AFTER converted_at"
        );
    }

    if (
        !wpf1_column_exists(
            'cp_web_quote_requests',
            'converted_order_at'
        )
    ) {
        db()->exec(
            "ALTER TABLE cp_web_quote_requests
             ADD COLUMN converted_order_at DATETIME NULL AFTER converted_order_id"
        );
    }

    if (
        !wpf1_table_exists(
            'cp_web_quote_item_links'
        )
    ) {
        db()->exec(
            "CREATE TABLE cp_web_quote_item_links (
                id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                request_id BIGINT UNSIGNED NOT NULL,
                request_item_id BIGINT UNSIGNED NULL,
                request_file_id BIGINT UNSIGNED NOT NULL,
                quote_id BIGINT UNSIGNED NOT NULL,
                quote_item_id BIGINT UNSIGNED NOT NULL,
                created_at DATETIME NOT NULL,
                PRIMARY KEY (id),
                UNIQUE KEY uq_web_quote_item_link (request_item_id, quote_item_id),
                KEY idx_web_quote_item_request (request_id),
                KEY idx_web_quote_item_quote (quote_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }

    if (
        !wpf1_table_exists(
            'cp_web_quote_order_files'
        )
    ) {
        db()->exec(
            "CREATE TABLE cp_web_quote_order_files (
                id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
                request_id BIGINT UNSIGNED NOT NULL,
                request_file_id BIGINT UNSIGNED NOT NULL,
                order_id BIGINT UNSIGNED NOT NULL,
                order_photo_id BIGINT UNSIGNED NOT NULL,
                created_at DATETIME NOT NULL,
                PRIMARY KEY (id),
                UNIQUE KEY uq_web_order_file (request_file_id, order_id),
                KEY idx_web_order_request (request_id),
                KEY idx_web_order_order (order_id)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci"
        );
    }
}

function wpf1_backup(
    string $path
): void {
    if (!is_file($path)) {
        return;
    }

    $backup =
        $path
        . '.bak_web_flow_v1';

    if (
        !is_file($backup)
        && !copy(
            $path,
            $backup
        )
    ) {
        throw new RuntimeException(
            'No se pudo respaldar '
            . basename($path)
            . '.'
        );
    }
}

function wpf1_write(
    string $path,
    string $content
): void {
    $tmp =
        $path
        . '.wpf1.tmp';

    if (
        file_put_contents(
            $tmp,
            $content,
            LOCK_EX
        )
        === false
    ) {
        throw new RuntimeException(
            'No se pudo escribir '
            . basename($path)
            . '.'
        );
    }

    $perms =
        @fileperms(
            $path
        );

    if ($perms !== false) {
        @chmod(
            $tmp,
            $perms & 0777
        );
    }

    if (
        !rename(
            $tmp,
            $path
        )
    ) {
        @unlink($tmp);

        throw new RuntimeException(
            'No se pudo reemplazar '
            . basename($path)
            . '.'
        );
    }

    if (
        function_exists(
            'opcache_invalidate'
        )
    ) {
        @opcache_invalidate(
            $path,
            true
        );
    }
}

function wpf1_template(
    string $relative
): string {
    global $templateRoot;

    $path =
        $templateRoot
        . '/'
        . ltrim(
            $relative,
            '/'
        );

    if (!is_file($path)) {
        throw new RuntimeException(
            'Falta la plantilla '
            . $relative
            . '.'
        );
    }

    $content =
        file_get_contents(
            $path
        );

    if ($content === false) {
        throw new RuntimeException(
            'No se pudo leer la plantilla '
            . $relative
            . '.'
        );
    }

    return $content;
}

function wpf1_patch_quote_detail(
    string $src
): string {
    if (
        str_contains(
            $src,
            "includes/web_print_flow.php"
        )
    ) {
        return $src;
    }

    $needle =
        "require_once __DIR__ . '/../includes/company.php';";

    if (
        substr_count(
            $src,
            $needle
        ) !== 1
    ) {
        throw new RuntimeException(
            'cotizacion.php: no se encontró el marcador de includes/company.php.'
        );
    }

    return str_replace(
        $needle,
        $needle
        . "\n"
        . "require_once __DIR__ . '/../includes/web_print_flow.php';\n"
        . "// SISACT_WEB_PRINT_FLOW_V1",
        $src
    );
}

function wpf1_patch_tracking(
    string $src
): string {
    if (
        !str_contains(
            $src,
            "includes/web_print_flow.php"
        )
    ) {
        $needle =
            "require_once __DIR__ . '/includes/company.php';";

        if (
            substr_count(
                $src,
                $needle
            ) !== 1
        ) {
            throw new RuntimeException(
                'seguimiento.php: no se encontró includes/company.php.'
            );
        }

        $src = str_replace(
            $needle,
            $needle
            . "\n"
            . "require_once __DIR__ . '/includes/web_print_flow.php';",
            $src
        );
    }

    if (
        !str_contains(
            $src,
            'SISACT_WEB_REQUEST_TRACKING_V1'
        )
    ) {
        $needle =
            "\$order = \$token !== '' ? tracking_order_by_token(\$token) : null;";

        if (
            substr_count(
                $src,
                $needle
            ) !== 1
        ) {
            throw new RuntimeException(
                'seguimiento.php: no se encontró la carga de order por token.'
            );
        }

        $block = <<<'PHP'

/* SISACT_WEB_REQUEST_TRACKING_V1 */
if (!$order && $token !== '') {
    $webRequest = web_flow_request_by_token($token);

    if ($webRequest) {
        require __DIR__ . '/includes/web_print_tracking_view.php';
        exit;
    }
}
PHP;

        $src = str_replace(
            $needle,
            $needle
            . $block,
            $src
        );
    }

    return $src;
}

function wpf1_patch_order_new(
    string $src
): string {
    if (
        !str_contains(
            $src,
            "includes/web_print_flow.php"
        )
    ) {
        $needle =
            "require_once __DIR__ . '/../includes/ordenes.php';";

        if (
            substr_count(
                $src,
                $needle
            ) !== 1
        ) {
            throw new RuntimeException(
                'orden_nueva.php: no se encontró includes/ordenes.php.'
            );
        }

        $src = str_replace(
            $needle,
            $needle
            . "\n"
            . "require_once __DIR__ . '/../includes/web_print_flow.php';",
            $src
        );
    }

    if (
        !str_contains(
            $src,
            'SISACT_WEB_ORDER_FILES_V1'
        )
    ) {
        $needle =
            "\$internalNotes=trim((string)(\$_POST['internal_notes'] ?? ''));";

        if (
            substr_count(
                $src,
                $needle
            ) !== 1
        ) {
            throw new RuntimeException(
                'orden_nueva.php: no se encontró internal_notes.'
            );
        }

        $src = str_replace(
            $needle,
            $needle
            . "\n"
            . "        /* SISACT_WEB_ORDER_FILES_V1 */\n"
            . "        \$webRequestId=web_flow_request_id_for_quote(\$quoteId);\n"
            . "        \$webCopiedFiles=[];",
            $src
        );

        $historyNeedle =
            "\$pdo->prepare('INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at) VALUES(?,?,?,?,?,NOW())')\n"
            . "                    ->execute([\$orderId,null,'pending','Orden creada desde '.\$quote['quote_number'],\$uid]);";

        if (
            substr_count(
                $src,
                $historyNeedle
            ) !== 1
        ) {
            throw new RuntimeException(
                'orden_nueva.php: no se encontró el historial de creación de orden.'
            );
        }

        $importBlock = <<<'PHP'

                if($webRequestId>0){
                    $importedFiles=web_flow_import_request_files_to_order(
                        $pdo,
                        $webRequestId,
                        $orderId,
                        $uid,
                        $webCopiedFiles
                    );

                    web_flow_bind_request_token_to_order(
                        $pdo,
                        $webRequestId,
                        $orderId
                    );

                    web_flow_link_order(
                        $pdo,
                        $webRequestId,
                        $orderId
                    );

                    if($importedFiles>0){
                        $pdo->prepare(
                            'INSERT INTO cp_order_history(order_id,old_status,new_status,note,changed_by,created_at)
                             VALUES(?,?,?,?,?,NOW())'
                        )->execute([
                            $orderId,
                            'pending',
                            'pending',
                            $importedFiles.' archivo(s) del cliente importados automáticamente desde '.web_flow_reference($webRequestId),
                            $uid
                        ]);
                    }
                }
PHP;

        $src = str_replace(
            $historyNeedle,
            $historyNeedle
            . $importBlock,
            $src
        );

        $catchNeedle =
            "if(isset(\$pdo)&&\$pdo->inTransaction())\$pdo->rollBack();";

        if (
            substr_count(
                $src,
                $catchNeedle
            ) !== 1
        ) {
            throw new RuntimeException(
                'orden_nueva.php: no se encontró rollback del catch.'
            );
        }

        $src = str_replace(
            $catchNeedle,
            $catchNeedle
            . "\n"
            . "            if(!empty(\$webCopiedFiles)){foreach(\$webCopiedFiles as \$webCopiedFile){@unlink(\$webCopiedFile);}}",
            $src
        );
    }

    return $src;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error =
            'La sesión expiró. Recarga la página.';
    } else {
        try {
            $action =
                (string)(
                    $_POST['action']
                    ?? ''
                );

            if ($action === 'install') {
                $targets = [
                    'admin/cotizaciones_web.php',
                    'admin/cotizacion_desde_web.php',
                    'admin/cotizacion.php',
                    'admin/orden_nueva.php',
                    'seguimiento.php',
                ];

                foreach ($targets as $target) {
                    if (
                        !is_file(
                            $root
                            . '/'
                            . $target
                        )
                    ) {
                        throw new RuntimeException(
                            'No se encontró '
                            . $target
                            . '.'
                        );
                    }
                }

                /*
                 * Construir todo ANTES de modificar.
                 */
                $quoteDetailCurrent =
                    (string)file_get_contents(
                        $root
                        . '/admin/cotizacion.php'
                    );

                $orderCurrent =
                    (string)file_get_contents(
                        $root
                        . '/admin/orden_nueva.php'
                    );

                $trackingCurrent =
                    (string)file_get_contents(
                        $root
                        . '/seguimiento.php'
                    );

                $quoteDetailNew =
                    wpf1_patch_quote_detail(
                        $quoteDetailCurrent
                    );

                $orderNew =
                    wpf1_patch_order_new(
                        $orderCurrent
                    );

                $trackingNew =
                    wpf1_patch_tracking(
                        $trackingCurrent
                    );

                $webQuotesNew =
                    wpf1_template(
                        'admin/cotizaciones_web.php'
                    );

                $converterNew =
                    wpf1_template(
                        'admin/cotizacion_desde_web.php'
                    );

                /*
                 * Migración idempotente.
                 */
                wpf1_migrate();

                foreach ($targets as $target) {
                    wpf1_backup(
                        $root
                        . '/'
                        . $target
                    );
                }

                wpf1_write(
                    $root
                    . '/admin/cotizaciones_web.php',
                    $webQuotesNew
                );

                wpf1_write(
                    $root
                    . '/admin/cotizacion_desde_web.php',
                    $converterNew
                );

                wpf1_write(
                    $root
                    . '/admin/cotizacion.php',
                    $quoteDetailNew
                );

                wpf1_write(
                    $root
                    . '/admin/orden_nueva.php',
                    $orderNew
                );

                wpf1_write(
                    $root
                    . '/seguimiento.php',
                    $trackingNew
                );

                $messages[] =
                    'Migración de trazabilidad aplicada.';

                $messages[] =
                    'Solicitudes web ahora muestran todos los archivos y configuraciones.';

                $messages[] =
                    'Conversión CPQ → Cotización conserva conceptos y precios.';

                $messages[] =
                    'Cotización muestra el expediente completo de archivos.';

                $messages[] =
                    'Orden formal importa automáticamente los archivos del cliente.';

                $messages[] =
                    'El mismo token público continúa funcionando antes y después de crear la orden.';
            }

            if ($action === 'revert') {
                $targets = [
                    'admin/cotizaciones_web.php',
                    'admin/cotizacion_desde_web.php',
                    'admin/cotizacion.php',
                    'admin/orden_nueva.php',
                    'seguimiento.php',
                ];

                foreach ($targets as $target) {
                    $path =
                        $root
                        . '/'
                        . $target;

                    $backup =
                        $path
                        . '.bak_web_flow_v1';

                    if (!is_file($backup)) {
                        throw new RuntimeException(
                            'Falta respaldo de '
                            . $target
                            . '.'
                        );
                    }

                    if (!copy($backup, $path)) {
                        throw new RuntimeException(
                            'No se pudo restaurar '
                            . $target
                            . '.'
                        );
                    }

                    if (
                        function_exists(
                            'opcache_invalidate'
                        )
                    ) {
                        @opcache_invalidate(
                            $path,
                            true
                        );
                    }
                }

                $messages[] =
                    'Archivos principales restaurados.';

                $messages[] =
                    'Las tablas y columnas de trazabilidad se conservaron para no perder información.';
            }
        } catch (Throwable $e) {
            $error =
                $e->getMessage();
        }
    }
}

$status = [
    'order_columns' =>
        wpf1_column_exists(
            'cp_web_quote_requests',
            'converted_order_id'
        )
        && wpf1_column_exists(
            'cp_web_quote_requests',
            'converted_order_at'
        ),

    'quote_links' =>
        wpf1_table_exists(
            'cp_web_quote_item_links'
        ),

    'order_files' =>
        wpf1_table_exists(
            'cp_web_quote_order_files'
        ),

    'helper' =>
        is_file(
            $root
            . '/includes/web_print_flow.php'
        ),

    'file_endpoint' =>
        is_file(
            $root
            . '/admin/archivo_web.php'
        ),
];

require __DIR__ . '/../includes/header.php';
?>
<style>
.wpf-installer{
  max-width:1050px;
  margin:20px auto
}
.wpf-installer-grid{
  display:grid;
  grid-template-columns:repeat(5,minmax(0,1fr));
  gap:10px;
  margin:18px 0
}
.wpf-installer-stat{
  padding:14px;
  border:1px solid rgba(255,255,255,.1);
  border-radius:11px
}
.wpf-installer-stat small{
  display:block;
  color:var(--muted)
}
.wpf-installer-stat strong{
  display:block;
  margin-top:5px
}
.wpf-installer-ok{
  color:#67e7be
}
.wpf-installer-flow{
  padding:15px;
  border:1px solid rgba(82,208,255,.20);
  border-radius:12px;
  background:rgba(82,208,255,.05);
  line-height:1.7
}
@media(max-width:850px){
  .wpf-installer-grid{
    grid-template-columns:1fr 1fr
  }
}
</style>

<div class="wpf-installer">
  <div class="card" style="padding:22px">

    <span class="eyebrow">
      RECEPCIÓN WEB · EXPEDIENTE ÚNICO
    </span>

    <h2>
      Flujo Web → Orden Formal V1
    </h2>

    <p class="muted">
      Une archivos, configuración, cotización, orden y seguimiento del cliente sin volver a pedir ni recapturar la información.
    </p>

    <?php if ($error): ?>
      <div class="notice danger">
        <?=e($error)?>
      </div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
      <div class="notice">
        <span class="ok">✓</span>
        <?=e($message)?>
      </div>
    <?php endforeach; ?>

    <div class="wpf-installer-grid">

      <div class="wpf-installer-stat">
        <small>Vínculo Orden</small>
        <strong class="<?=$status['order_columns'] ? 'wpf-installer-ok' : ''?>">
          <?=$status['order_columns'] ? '✓ listo' : 'pendiente'?>
        </strong>
      </div>

      <div class="wpf-installer-stat">
        <small>CPQ → Conceptos</small>
        <strong class="<?=$status['quote_links'] ? 'wpf-installer-ok' : ''?>">
          <?=$status['quote_links'] ? '✓ listo' : 'pendiente'?>
        </strong>
      </div>

      <div class="wpf-installer-stat">
        <small>Archivos → Orden</small>
        <strong class="<?=$status['order_files'] ? 'wpf-installer-ok' : ''?>">
          <?=$status['order_files'] ? '✓ listo' : 'pendiente'?>
        </strong>
      </div>

      <div class="wpf-installer-stat">
        <small>Helper</small>
        <strong class="<?=$status['helper'] ? 'wpf-installer-ok' : ''?>">
          <?=$status['helper'] ? '✓ listo' : 'faltante'?>
        </strong>
      </div>

      <div class="wpf-installer-stat">
        <small>Descarga protegida</small>
        <strong class="<?=$status['file_endpoint'] ? 'wpf-installer-ok' : ''?>">
          <?=$status['file_endpoint'] ? '✓ lista' : 'faltante'?>
        </strong>
      </div>

    </div>

    <div class="wpf-installer-flow">
      <strong>Flujo final</strong><br>
      Cliente envía archivos
      → CPQ conserva expediente
      → Administración revisa y descarga
      → Convertir crea conceptos/precios
      → Cotización conserva archivos
      → Aprobada crea orden
      → archivos pasan a cp_order_photos
      → el mismo enlace público continúa como seguimiento de la orden.
    </div>

    <form
      method="post"
      style="display:flex;gap:10px;flex-wrap:wrap;margin-top:18px"
    >
      <input
        type="hidden"
        name="_csrf"
        value="<?=e(csrf_token())?>"
      >

      <button
        class="btn btn-primary"
        type="submit"
        name="action"
        value="install"
      >
        Instalar flujo V1
      </button>

      <a
        class="btn btn-secondary"
        href="/admin/cotizaciones_web.php"
      >
        Abrir solicitudes web
      </a>

      <button
        class="btn btn-secondary"
        type="submit"
        name="action"
        value="revert"
        onclick="return confirm('¿Restaurar los archivos anteriores? Las tablas de trazabilidad se conservarán.');"
      >
        Revertir archivos
      </button>
    </form>

  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
