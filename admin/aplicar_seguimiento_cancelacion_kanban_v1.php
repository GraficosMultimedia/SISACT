<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

$title = 'Seguimiento · Cancelación + Kanban V1';

$root = dirname(__DIR__);

$trackingPath =
    $root
    . '/seguimiento.php';

$quotePath =
    $root
    . '/admin/cotizacion.php';

$receiptPath =
    $root
    . '/api/comprobante_pago_cliente.php';

$error = null;
$messages = [];

function scv1_backup(string $path): void
{
    if (!is_file($path)) {
        throw new RuntimeException(
            'No se encontró '
            . $path
            . '.'
        );
    }

    $backup =
        $path
        . '.bak_seguimiento_cancelacion_kanban_v1';

    if (
        !is_file($backup)
        && !copy($path, $backup)
    ) {
        throw new RuntimeException(
            'No se pudo crear respaldo de '
            . basename($path)
            . '.'
        );
    }
}

function scv1_write(
    string $path,
    string $content
): void {
    $tmp =
        $path
        . '.scv1.tmp';

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
        @fileperms($path);

    if ($perms !== false) {
        @chmod(
            $tmp,
            $perms & 0777
        );
    }

    if (!rename($tmp, $path)) {
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

function scv1_replace_once(
    string $src,
    string $old,
    string $new,
    string $label
): string {
    $count =
        substr_count(
            $src,
            $old
        );

    if ($count !== 1) {
        throw new RuntimeException(
            $label
            . ': se esperaba exactamente 1 coincidencia y se encontraron '
            . $count
            . '. No se modificó el archivo.'
        );
    }

    return str_replace(
        $old,
        $new,
        $src
    );
}

function scv1_regex_once(
    string $src,
    string $pattern,
    string $replacement,
    string $label
): string {
    $count =
        preg_match_all(
            $pattern,
            $src
        );

    if ($count !== 1) {
        throw new RuntimeException(
            $label
            . ': se esperaba exactamente 1 coincidencia y se encontraron '
            . $count
            . '. No se modificó el archivo.'
        );
    }

    $out =
        preg_replace(
            $pattern,
            $replacement,
            $src,
            1
        );

    if (!is_string($out)) {
        throw new RuntimeException(
            $label
            . ': no se pudo aplicar el cambio.'
        );
    }

    return $out;
}

function scv1_patch_tracking(string $src): string
{
    if (
        str_contains(
            $src,
            'SISACT_TRACKING_CANCEL_GUARD_V1'
        )
    ) {
        return $src;
    }

    /*
     * 1. Helper.
     */
    $includeMarker =
        "require_once __DIR__ . '/includes/company.php';";

    if (!str_contains($src, $includeMarker)) {
        throw new RuntimeException(
            'seguimiento.php: no se encontró includes/company.php.'
        );
    }

    $src =
        str_replace(
            $includeMarker,
            $includeMarker
            . "\n"
            . "require_once __DIR__ . '/includes/seguimiento_cancelacion_kanban_v1.php';\n"
            . "// SISACT_TRACKING_CANCEL_GUARD_V1",
            $src
        );

    /*
     * 2. Estado efectivo.
     */
    $stateMarker =
        "\$trackingCfdis = \$order ? tracking_cfdi_for_order((int)\$order['id']) : [];";

    if (!str_contains($src, $stateMarker)) {
        throw new RuntimeException(
            'seguimiento.php: no se encontró la carga de CFDI/orden.'
        );
    }

    $stateBlock = <<<'PHP'

$trackingGuard = $order
    ? tracking_guard_v1_state((int)$order['id'])
    : tracking_guard_v1_empty_state();

$isCancelled = (bool)($trackingGuard['is_cancelled'] ?? false);

$kanbanStages = tracking_guard_v1_progress_stages();
$kanbanKeys = array_keys($kanbanStages);

$kanbanCurrent = (string)(
    $trackingGuard['current_stage']
    ?? 'pending'
);

if (!isset($kanbanStages[$kanbanCurrent])) {
    $kanbanCurrent = 'pending';
}

$kanbanCurrentIndex = array_search(
    $kanbanCurrent,
    $kanbanKeys,
    true
);

if ($kanbanCurrentIndex === false) {
    $kanbanCurrentIndex = 0;
}

$trackingCurrentMeta =
    tracking_guard_v1_stage_meta(
        $isCancelled
            ? 'cancelled'
            : $kanbanCurrent
    );

$kanbanHistory = $order
    ? tracking_guard_v1_history(
        (int)$order['id'],
        $trackingGuard
    )
    : [];
PHP;

    $src =
        str_replace(
            $stateMarker,
            $stateMarker
            . $stateBlock,
            $src
        );

    /*
     * 3. CSS V1.
     */
    if (
        !str_contains(
            $src,
            'seguimiento-kanban-v1.css'
        )
    ) {
        $headClose = '</head>';

        if (!str_contains($src, $headClose)) {
            throw new RuntimeException(
                'seguimiento.php: no se encontró </head>.'
            );
        }

        $src =
            str_replace(
                $headClose,
                '<link rel="stylesheet" href="/assets/css/seguimiento-kanban-v1.css?v=20261023-1">'
                . "\n"
                . $headClose,
                $src
            );
    }

    /*
     * 4. Hero.
     */
    $src =
        scv1_replace_once(
            $src,
            '<section class="hero-card">',
            '<section class="hero-card <?=$isCancelled?\'is-cancelled\':\'\'?>">',
            'Hero cancelado'
        );

    $src =
        scv1_replace_once(
            $src,
            '<div class="tracking-tagline">Seguimiento actualizado de tu pedido.</div>',
            '<div class="tracking-tagline"><?=$isCancelled?\'Esta orden fue cancelada y su proceso quedó detenido.\':\'Seguimiento actualizado de tu pedido.\'?></div>',
            'Tagline cancelado'
        );

    $pillPattern =
        '#<div class="current-pill">\s*'
        . '<span>Estado actual</span>\s*'
        . '<strong>.*?</strong>\s*'
        . '</div>#s';

    $pillReplacement = <<<'HTML'
<div class="current-pill <?=$isCancelled?'is-cancelled':''?>">
    <span>Estado actual</span>
    <strong><?=$trackingCurrentMeta['icon']?> <?=track_e($trackingCurrentMeta['label'])?></strong>
  </div>
HTML;

    $src =
        scv1_regex_once(
            $src,
            $pillPattern,
            $pillReplacement,
            'Estado actual'
        );

    /*
     * 5. Progreso 1:1 con Kanban.
     */
    $progressPattern =
        '#<section class="progress-card">.*?</section>#s';

    $progressReplacement = <<<'HTML'
<section class="progress-card">
  <div class="section-title">
    <div>
      <span class="eyebrow">PROGRESO</span>
      <h2>Así va tu pedido</h2>
    </div>
  </div>

  <div class="progress-line client-progress">
  <?php foreach ($kanbanStages as $key=>$stage):
      $idx=array_search($key,$kanbanKeys,true);
      $done=$idx < $kanbanCurrentIndex;
      $active=!$isCancelled && $key===$kanbanCurrent;
      $interrupted=$isCancelled && $key===$kanbanCurrent;
      $blocked=$isCancelled && $idx > $kanbanCurrentIndex;
  ?>
    <div class="stage <?=($done?'done ':'').($active?'active ':'').($interrupted?'is-interrupted ':'').($blocked?'is-blocked':'')?>">
      <div class="stage-dot"><?=($done?'✓':($interrupted?'⛔':$stage['icon']))?></div>
      <span><?=track_e($stage['label'])?></span>
    </div>
  <?php endforeach; ?>
  </div>

  <p class="progress-helper">
    El progreso corresponde a todas las etapas del Kanban interno de Producción.
  </p>

  <?php if ($isCancelled): ?>
    <div class="tracking-cancelled-alert">
      <div class="tracking-cancelled-alert-icon">⛔</div>
      <div>
        <strong>Esta orden está cancelada</strong>
        <p><?=nl2br(track_e((string)($trackingGuard['cancel_note'] ?? 'La orden fue cancelada.')))?></p>
        <?php if (!empty($trackingGuard['cancelled_at'])): ?>
          <small>
            Cancelación registrada:
            <?=track_date((string)$trackingGuard['cancelled_at'],'d/m/Y H:i')?>
          </small>
        <?php endif; ?>
      </div>
    </div>
  <?php endif; ?>
</section>
HTML;

    $src =
        scv1_regex_once(
            $src,
            $progressPattern,
            $progressReplacement,
            'Progreso Kanban completo'
        );

    /*
     * 6. Historial exacto de etapas.
     */
    $historyPattern =
        '#<section class="history tracking-card">.*?</section>#s';

    $historyReplacement = <<<'HTML'
<section class="history tracking-card">
  <div class="section-title">
    <div>
      <span class="eyebrow">ACTUALIZACIONES</span>
      <h2>Lo que ha pasado</h2>
    </div>
  </div>

  <?php if (!$kanbanHistory): ?>
    <p class="muted">Aún no hay actualizaciones registradas.</p>
  <?php else: ?>
    <div class="timeline">
      <?php foreach ($kanbanHistory as $entry): ?>
        <div class="timeline-item <?=($entry['key']==='cancelled'?'is-cancelled':'')?>">
          <div class="timeline-dot"><?=$entry['icon']?></div>

          <div>
            <strong><?=track_e($entry['label'])?></strong>
            <time><?=track_date($entry['created_at'],'d/m/Y H:i')?></time>

            <?php if (trim((string)$entry['note']) !== ''): ?>
              <p><?=nl2br(track_e($entry['note']))?></p>
            <?php endif; ?>
          </div>
        </div>
      <?php endforeach; ?>
    </div>
  <?php endif; ?>
</section>
HTML;

    $src =
        scv1_regex_once(
            $src,
            $historyPattern,
            $historyReplacement,
            'Historial Kanban'
        );

    /*
     * 7. Actualización + resumen.
     */
    $twoColPattern =
        '#<section class="two-col">.*?</section>#s';

    $twoColReplacement = <<<'HTML'
<section class="two-col">
  <article class="current-message <?=$isCancelled?'is-cancelled':''?>">
    <span class="eyebrow"><?=$isCancelled?'ESTADO DE LA ORDEN':'ACTUALIZACIÓN'?></span>

    <h2>
      <?=$trackingCurrentMeta['icon']?>
      <?=track_e($trackingCurrentMeta['label'])?>
    </h2>

    <?php if ($isCancelled): ?>
      <p><?=nl2br(track_e((string)($trackingGuard['cancel_note'] ?? 'La orden fue cancelada.')))?></p>
    <?php else: ?>
      <p><?=track_e((string)$trackingCurrentMeta['description'])?></p>
    <?php endif; ?>

    <small>
      Última actualización:
      <?=track_date(
        $isCancelled
          ? ($trackingGuard['cancelled_at'] ?? null)
          : ($trackingGuard['stage_updated_at'] ?? null),
        'd/m/Y H:i'
      )?>
    </small>
  </article>

  <article class="order-summary">
    <span class="eyebrow">INFORMACIÓN DE LA ORDEN</span>

    <div class="info-row">
      <span>Pedido</span>
      <strong><?=track_e($order['order_number'])?></strong>
    </div>

    <div class="info-row">
      <span>Fecha de pedido</span>
      <strong><?=track_date($order['order_date'])?></strong>
    </div>

    <div class="info-row">
      <span>Entrega estimada</span>
      <strong><?=$isCancelled?'No aplica':track_date($order['due_date'])?></strong>
    </div>

    <div class="info-row <?=$isCancelled?'status-cancelled':''?>">
      <span>Estado</span>
      <strong><?=$trackingCurrentMeta['icon']?> <?=track_e($trackingCurrentMeta['label'])?></strong>
    </div>

    <div class="info-row total">
      <span>Total</span>
      <strong><?=track_money((float)$order['total'])?></strong>
    </div>
  </article>
</section>
HTML;

    $src =
        scv1_regex_once(
            $src,
            $twoColPattern,
            $twoColReplacement,
            'Estado y resumen'
        );

    /*
     * 8. No mostrar instrucciones de pago en una orden cancelada.
     */
    $paymentInfo =
        "<?php if (trim((string)(\$company['payment_info'] ?? '')) !== ''): ?>";

    if (str_contains($src, $paymentInfo)) {
        $src =
            str_replace(
                $paymentInfo,
                "<?php if (!\$isCancelled && trim((string)(\$company['payment_info'] ?? '')) !== ''): ?>",
                $src
            );
    }

    /*
     * Badge del resumen.
     */
    $receiptBadge =
        '<span class="receipt-badge"><?= $finance[\'paid_total\'] > 0 ? \'PAGO REGISTRADO\' : \'PAGO PENDIENTE\' ?></span>';

    if (str_contains($src, $receiptBadge)) {
        $src =
            str_replace(
                $receiptBadge,
                '<span class="receipt-badge <?=$isCancelled?\'is-cancelled\':\'\'?>"><?= $isCancelled ? \'ORDEN CANCELADA\' : ($finance[\'paid_total\'] > 0 ? \'PAGO REGISTRADO\' : \'PAGO PENDIENTE\') ?></span>',
                $src
            );
    }

    /*
     * El bloque de anticipo deja de decir "Pago pendiente".
     */
    $firstPaymentMarker =
        "<?php if (\$finance['first_payment']): \$fp=\$finance['first_payment']; ?>";

    if (str_contains($src, $firstPaymentMarker)) {
        $src =
            str_replace(
                $firstPaymentMarker,
                <<<'HTML'
<?php if ($isCancelled): ?>
  <div class="cancel-payment-warning">
    <span>⛔</span>
    <div>
      <strong>No realices pagos para esta orden</strong>
      <small>La orden se encuentra cancelada. Si ya realizaste un pago, comunícate con Administración para revisar el expediente.</small>
    </div>
  </div>
<?php elseif ($finance['first_payment']): $fp=$finance['first_payment']; ?>
HTML,
                $src
            );
    }

    /*
     * PDF operativo: ocultarlo cuando la orden está cancelada.
     * WhatsApp permanece disponible como canal de aclaración.
     */
    $pdfLink =
        '<a class="pdf" href="<?=track_e($pdfUrl)?>">📄 Descargar comprobante PDF</a>';

    if (str_contains($src, $pdfLink)) {
        $src =
            str_replace(
                $pdfLink,
                '<?php if (!$isCancelled): ?><a class="pdf" href="<?=track_e($pdfUrl)?>">📄 Descargar comprobante PDF</a><?php endif; ?>',
                $src
            );
    }

    /*
     * El expediente histórico de comprobantes permanece visible,
     * pero ya no se permite subir uno nuevo.
     */
    $uploadPattern =
        '#<form class="public-receipt-upload".*?</form>#s';

    $uploadReplacement = <<<'HTML'
<?php if (!$isCancelled): ?>
  $0
<?php else: ?>
  <div class="cancel-payment-warning">
    <span>⛔</span>
    <div>
      <strong>Recepción de comprobantes deshabilitada</strong>
      <small>Esta orden está cancelada y no acepta nuevos comprobantes de pago.</small>
    </div>
  </div>
<?php endif; ?>
HTML;

    /*
     * preg_replace no expande $0 si está dentro de heredoc como contenido PHP
     * de forma segura para este caso, así que resolvemos manualmente.
     */
    if (
        preg_match(
            $uploadPattern,
            $src,
            $uploadMatch
        )
    ) {
        $wrapped =
            "<?php if (!\$isCancelled): ?>\n"
            . $uploadMatch[0]
            . "\n<?php else: ?>\n"
            . '<div class="cancel-payment-warning">'
            . '<span>⛔</span>'
            . '<div><strong>Recepción de comprobantes deshabilitada</strong>'
            . '<small>Esta orden está cancelada y no acepta nuevos comprobantes de pago.</small>'
            . '</div></div>'
            . "\n<?php endif; ?>";

        $src =
            preg_replace(
                $uploadPattern,
                $wrapped,
                $src,
                1
            );
    } else {
        throw new RuntimeException(
            'seguimiento.php: no se encontró el formulario de comprobante.'
        );
    }

    return $src;
}

function scv1_patch_quote(string $src): string
{
    if (
        str_contains(
            $src,
            'SISACT_QUOTE_CANCEL_ORDER_SYNC_V1'
        )
    ) {
        return $src;
    }

    $marker =
        "\$st->execute([\$newStatus, current_user()['id'] ?? null, \$id]);";

    if (!str_contains($src, $marker)) {
        throw new RuntimeException(
            'cotizacion.php: no se encontró la actualización del estado.'
        );
    }

    $block = <<<'PHP'

                /* SISACT_QUOTE_CANCEL_ORDER_SYNC_V1
                 * Si una cotización con orden vinculada se cancela,
                 * la orden queda cancelada en el mismo COMMIT.
                 * No se modifica una orden ya entregada.
                 */
                if ($newStatus === 'cancelled') {
                    $linkedOrderStmt = $pdo->prepare(
                        "SELECT id,status
                         FROM cp_orders
                         WHERE quote_id=?
                         LIMIT 1
                         FOR UPDATE"
                    );

                    $linkedOrderStmt->execute([$id]);
                    $linkedOrder = $linkedOrderStmt->fetch(PDO::FETCH_ASSOC);

                    if ($linkedOrder) {
                        $linkedOrderId = (int)$linkedOrder['id'];
                        $linkedOrderStatus = (string)$linkedOrder['status'];

                        if (
                            $linkedOrderId > 0
                            && $linkedOrderStatus !== 'delivered'
                            && $linkedOrderStatus !== 'cancelled'
                        ) {
                            $stageStmt = $pdo->prepare(
                                "SELECT stage
                                 FROM cp_order_status
                                 WHERE order_id=?
                                 LIMIT 1
                                 FOR UPDATE"
                            );

                            $stageStmt->execute([$linkedOrderId]);
                            $oldStage = (string)(
                                $stageStmt->fetchColumn()
                                ?: 'pending'
                            );

                            $note =
                                'Orden cancelada automáticamente al cancelar la cotización '
                                . (string)$quote['quote_number']
                                . '.';

                            $existsStage = $pdo->prepare(
                                'SELECT id
                                 FROM cp_order_status
                                 WHERE order_id=?
                                 LIMIT 1'
                            );

                            $existsStage->execute([$linkedOrderId]);

                            if ($existsStage->fetchColumn()) {
                                $pdo->prepare(
                                    'UPDATE cp_order_status
                                     SET
                                        stage=?,
                                        note=?,
                                        updated_by=?,
                                        updated_at=NOW()
                                     WHERE order_id=?'
                                )->execute([
                                    'cancelled',
                                    $note,
                                    current_user()['id'] ?? null,
                                    $linkedOrderId,
                                ]);
                            } else {
                                $pdo->prepare(
                                    'INSERT INTO cp_order_status
                                     (
                                        order_id,
                                        stage,
                                        note,
                                        updated_by,
                                        created_at,
                                        updated_at
                                     )
                                     VALUES(?,?,?,?,NOW(),NOW())'
                                )->execute([
                                    $linkedOrderId,
                                    'cancelled',
                                    $note,
                                    current_user()['id'] ?? null,
                                ]);
                            }

                            $pdo->prepare(
                                'UPDATE cp_orders
                                 SET
                                    status=?,
                                    updated_by=?,
                                    updated_at=NOW()
                                 WHERE id=?'
                            )->execute([
                                'cancelled',
                                current_user()['id'] ?? null,
                                $linkedOrderId,
                            ]);

                            $pdo->prepare(
                                'INSERT INTO cp_order_history
                                 (
                                    order_id,
                                    old_status,
                                    new_status,
                                    note,
                                    changed_by,
                                    created_at
                                 )
                                 VALUES(?,?,?,?,?,NOW())'
                            )->execute([
                                $linkedOrderId,
                                $oldStage,
                                'cancelled',
                                $note,
                                current_user()['id'] ?? null,
                            ]);
                        }
                    }
                }
PHP;

    return str_replace(
        $marker,
        $marker
        . $block,
        $src
    );
}

function scv1_patch_receipt_api(string $src): string
{
    if (
        str_contains(
            $src,
            'SISACT_RECEIPT_CANCEL_GUARD_V1'
        )
    ) {
        return $src;
    }

    $includeMarker =
        "require_once __DIR__.'/../includes/tracking_activity.php';";

    if (!str_contains($src, $includeMarker)) {
        throw new RuntimeException(
            'comprobante_pago_cliente.php: no se encontró tracking_activity.php.'
        );
    }

    $src =
        str_replace(
            $includeMarker,
            $includeMarker
            . "\n"
            . "require_once __DIR__.'/../includes/seguimiento.php';\n"
            . "require_once __DIR__.'/../includes/seguimiento_cancelacion_kanban_v1.php';\n"
            . "// SISACT_RECEIPT_CANCEL_GUARD_V1",
            $src
        );

    $tryMarker = "try{\n    \$receipt = payment_receipt_upload(";

    if (!str_contains($src, $tryMarker)) {
        throw new RuntimeException(
            'comprobante_pago_cliente.php: no se encontró payment_receipt_upload().'
        );
    }

    return str_replace(
        $tryMarker,
        "try{\n    tracking_guard_v1_assert_active(\$orderId);\n\n    \$receipt = payment_receipt_upload(",
        $src
    );
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
                foreach (
                    [
                        $trackingPath,
                        $quotePath,
                        $receiptPath,
                    ]
                    as $path
                ) {
                    if (!is_file($path)) {
                        throw new RuntimeException(
                            'No se encontró '
                            . $path
                            . '.'
                        );
                    }
                }

                /*
                 * Construir todos los parches en memoria.
                 * Si uno no coincide, no se escribe ninguno.
                 */
                $trackingCurrent =
                    (string)file_get_contents(
                        $trackingPath
                    );

                $quoteCurrent =
                    (string)file_get_contents(
                        $quotePath
                    );

                $receiptCurrent =
                    (string)file_get_contents(
                        $receiptPath
                    );

                $trackingNew =
                    scv1_patch_tracking(
                        $trackingCurrent
                    );

                $quoteNew =
                    scv1_patch_quote(
                        $quoteCurrent
                    );

                $receiptNew =
                    scv1_patch_receipt_api(
                        $receiptCurrent
                    );

                /*
                 * Respaldos.
                 */
                scv1_backup(
                    $trackingPath
                );

                scv1_backup(
                    $quotePath
                );

                scv1_backup(
                    $receiptPath
                );

                /*
                 * Escritura.
                 */
                scv1_write(
                    $trackingPath,
                    $trackingNew
                );

                scv1_write(
                    $quotePath,
                    $quoteNew
                );

                scv1_write(
                    $receiptPath,
                    $receiptNew
                );

                $messages[] =
                    'Seguimiento público ahora valida orden, etapa de producción y cotización.';

                $messages[] =
                    'La barra de progreso muestra Pendiente, Diseño, Aprobación, Impresión, Producción, Calidad, Listo y Entregado.';

                $messages[] =
                    'Una orden cancelada deja de mostrar estado operativo vigente.';

                $messages[] =
                    'Se ocultan instrucciones de pago, carga de comprobantes y PDF operativo cuando la orden está cancelada.';

                $messages[] =
                    'Nuevas cancelaciones de cotización sincronizan automáticamente la orden vinculada.';
            }

            if ($action === 'revert') {
                foreach (
                    [
                        $trackingPath,
                        $quotePath,
                        $receiptPath,
                    ]
                    as $path
                ) {
                    $backup =
                        $path
                        . '.bak_seguimiento_cancelacion_kanban_v1';

                    if (!is_file($backup)) {
                        throw new RuntimeException(
                            'Falta respaldo de '
                            . basename($path)
                            . '.'
                        );
                    }

                    if (!copy($backup, $path)) {
                        throw new RuntimeException(
                            'No se pudo restaurar '
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

                $messages[] =
                    'Archivos restaurados desde respaldo.';
            }
        } catch (Throwable $e) {
            $error =
                $e->getMessage();
        }
    }
}

$helperReady =
    is_file(
        $root
        . '/includes/seguimiento_cancelacion_kanban_v1.php'
    );

$cssReady =
    is_file(
        $root
        . '/assets/css/seguimiento-kanban-v1.css'
    );

require __DIR__ . '/../includes/header.php';
?>
<style>
.scv1{
  max-width:1040px;
  margin:20px auto
}
.scv1-grid{
  display:grid;
  grid-template-columns:repeat(4,minmax(0,1fr));
  gap:10px;
  margin:18px 0
}
.scv1-stat{
  padding:14px;
  border:1px solid rgba(255,255,255,.1);
  border-radius:11px
}
.scv1-stat small{
  display:block;
  color:var(--muted)
}
.scv1-stat strong{
  display:block;
  margin-top:5px
}
.scv1-ok{
  color:#67e7be
}
.scv1-flow{
  padding:15px;
  border:1px solid rgba(82,208,255,.20);
  border-radius:12px;
  background:rgba(82,208,255,.05);
  line-height:1.7
}
@media(max-width:760px){
  .scv1-grid{
    grid-template-columns:1fr 1fr
  }
}
</style>

<div class="scv1">
  <div class="card" style="padding:22px">

    <span class="eyebrow">
      SEGUIMIENTO · VALIDACIÓN DE ESTADO
    </span>

    <h2>
      Cancelación + Kanban completo V1
    </h2>

    <p class="muted">
      Evita que una orden cancelada parezca vigente y alinea la barra pública con todas las etapas reales del Kanban.
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

    <div class="scv1-grid">

      <div class="scv1-stat">
        <small>Validador</small>
        <strong class="<?=$helperReady?'scv1-ok':''?>">
          <?=$helperReady?'✓ listo':'faltante'?>
        </strong>
      </div>

      <div class="scv1-stat">
        <small>Kanban público</small>
        <strong class="<?=$cssReady?'scv1-ok':''?>">
          <?=$cssReady?'✓ listo':'faltante'?>
        </strong>
      </div>

      <div class="scv1-stat">
        <small>Cancelación por orden</small>
        <strong class="scv1-ok">
          ✓ incluida
        </strong>
      </div>

      <div class="scv1-stat">
        <small>Cancelación por cotización</small>
        <strong class="scv1-ok">
          ✓ incluida
        </strong>
      </div>

    </div>

    <div class="scv1-flow">
      <strong>Regla pública</strong><br>
      Si la orden, la etapa de producción o la cotización origen están canceladas:
      <br>
      seguimiento = CANCELADO
      <br>
      progreso detenido
      <br>
      pagos nuevos deshabilitados
      <br>
      comprobantes nuevos deshabilitados.
      <br><br>
      <strong>Etapas visibles:</strong>
      Pendiente → Diseño → Aprobación → Impresión → Producción → Calidad → Listo → Entregado.
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
        Instalar seguimiento V1
      </button>

      <a
        class="btn btn-secondary"
        href="/seguimiento.php"
        target="_blank"
        rel="noopener"
      >
        Abrir seguimiento
      </a>

      <button
        class="btn btn-secondary"
        type="submit"
        name="action"
        value="revert"
        onclick="return confirm('¿Restaurar los archivos anteriores?');"
      >
        Revertir
      </button>
    </form>

  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
