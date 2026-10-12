<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Instalar desglose PDF';
$root = dirname(__DIR__);
$orderFile = $root . '/orden_pdf.php';
$trackingFile = $root . '/seguimiento_comprobante.php';
$helperFile = $root . '/includes/order_commercial_breakdown.php';

$messages = [];
$error = null;

function pdv1_replace_once(string $content, string $search, string $replace, string $label): string
{
    $count = substr_count($content, $search);
    if ($count !== 1) {
        throw new RuntimeException(
            $label . ': se esperaba 1 coincidencia y se encontraron ' . $count .
            '. No se modificó el archivo.'
        );
    }
    return str_replace($search, $replace, $content);
}

function pdv1_atomic_write(string $path, string $content): void
{
    $tmp = $path . '.pdfv1.tmp';
    if (file_put_contents($tmp, $content, LOCK_EX) === false) {
        throw new RuntimeException('No se pudo escribir archivo temporal: ' . basename($path));
    }
    @chmod($tmp, fileperms($path) & 0777);
    if (!rename($tmp, $path)) {
        @unlink($tmp);
        throw new RuntimeException('No se pudo reemplazar: ' . basename($path));
    }
}

function pdv1_backup(string $path): string
{
    $backup = $path . '.bak_pdf_desglose_v1';
    if (!is_file($backup)) {
        if (!copy($path, $backup)) {
            throw new RuntimeException('No se pudo crear respaldo de ' . basename($path));
        }
    }
    return $backup;
}

function pdv1_patch_order(string $src): string
{
    if (str_contains($src, "order_commercial_breakdown.php")) return $src;

    $src = pdv1_replace_once(
        $src,
        "require_once __DIR__ . '/includes/cotizaciones.php';",
        "require_once __DIR__ . '/includes/cotizaciones.php';\nrequire_once __DIR__ . '/includes/order_commercial_breakdown.php';",
        'orden_pdf.php · include'
    );

    $src = pdv1_replace_once(
        $src,
        "function generate_order_pdf(array \$order,array \$customer,array \$quote,array \$items,array \$finance,array \$payments,array \$history,array \$company, string \$logoPath='', int \$photoCount=0):string{",
        "function generate_order_pdf(array \$order,array \$customer,array \$quote,array \$items,array \$finance,array \$payments,array \$history,array \$company, string \$logoPath='', int \$photoCount=0, array \$commercial=[]):string{",
        'orden_pdf.php · firma'
    );

    $oldSummary = <<<'PHP'
  $y-=8;$pdf->setFill(...$light);$pdf->fillRect(319,$y-120,238,120);$pdf->setStroke(...$border);$pdf->rect(319,$y-120,238,120);
  $pdf->setFill(...$red);$pdf->text('RESUMEN FINANCIERO',7.8,335,$y-18,true);
  $rows=[['Total del servicio',(float)$finance['order_total'],$navy],['Pagado / anticipo',(float)$finance['paid_total'],$green],['Saldo pendiente',(float)$finance['balance'],$yellow]];$ty=$y-43;foreach($rows as $r){$pdf->setFill(...$slate);$pdf->text($r[0],8,335,$ty,false);$pdf->setFill(...$r[2]);$pdf->textRight(cmoney($r[1]),11,540,$ty,true);$ty-=23;}
PHP;

    $newSummary = <<<'PHP'
  $y-=8;$pdf->setFill(...$light);$pdf->fillRect(319,$y-120,238,120);$pdf->setStroke(...$border);$pdf->rect(319,$y-120,238,120);
  $pdf->setFill(...$red);$pdf->text('RESUMEN FINANCIERO',7.8,335,$y-18,true);
  $rows=[];
  if(($commercial['available']??false)===true){
      $rows[]=['Subtotal',(float)$commercial['subtotal'],$navy];
      if(($commercial['has_discount']??false)===true){
          $rows[]=['Descuento ('.(string)$commercial['discount_label'].')',-(float)$commercial['discount'],$red];
      }
      if(($commercial['has_tax']??false)===true){
          $rows[]=['IVA ('.(string)$commercial['tax_label'].')',(float)$commercial['tax'],$cyan];
      }
  }
  $rows[]=['Total del servicio',(float)$finance['order_total'],$navy];
  $rows[]=['Pagado / anticipo',(float)$finance['paid_total'],$green];
  $rows[]=['Saldo pendiente',(float)$finance['balance'],$yellow];
  $step=count($rows)>3?14.5:23;
  $amountSize=count($rows)>3?8.8:11;
  $labelSize=count($rows)>3?7.1:8;
  $ty=$y-40;
  foreach($rows as $r){
      $pdf->setFill(...$slate);$pdf->text($r[0],$labelSize,335,$ty,false);
      $pdf->setFill(...$r[2]);$pdf->textRight(cmoney($r[1]),$amountSize,540,$ty,true);
      $ty-=$step;
  }
PHP;

    $src = pdv1_replace_once(
        $src,
        $oldSummary,
        $newSummary,
        'orden_pdf.php · resumen financiero'
    );

    $src = pdv1_replace_once(
        $src,
        "\$finance=finance_order_summary(\$id);",
        "\$finance=finance_order_summary(\$id);\n\$commercial=order_commercial_breakdown(\$id,\$items,(float)(\$finance['order_total']??0));",
        'orden_pdf.php · cálculo comercial'
    );

    $src = pdv1_replace_once(
        $src,
        "generate_order_pdf(\$order,\$customer,\$quote,\$items,\$finance,\$payments,\$history,\$company,\$logoPath,\$photoCount)",
        "generate_order_pdf(\$order,\$customer,\$quote,\$items,\$finance,\$payments,\$history,\$company,\$logoPath,\$photoCount,\$commercial)",
        'orden_pdf.php · llamada'
    );

    return $src;
}

function pdv1_patch_tracking(string $src): string
{
    if (str_contains($src, "order_commercial_breakdown.php")) return $src;

    $src = pdv1_replace_once(
        $src,
        "require_once __DIR__ . '/includes/cotizacion_pdf_renderer.php';",
        "require_once __DIR__ . '/includes/cotizacion_pdf_renderer.php';\nrequire_once __DIR__ . '/includes/order_commercial_breakdown.php';",
        'seguimiento_comprobante.php · include'
    );

    $src = pdv1_replace_once(
        $src,
        "\$total=(float)\$finance['order_total']; \$paid=(float)\$finance['paid_total']; \$balance=(float)\$finance['balance'];",
        "\$total=(float)\$finance['order_total']; \$paid=(float)\$finance['paid_total']; \$balance=(float)\$finance['balance'];\n\$commercial=order_commercial_breakdown(\$orderId,\$items,\$total);",
        'seguimiento_comprobante.php · cálculo comercial'
    );

    $oldRows = <<<'PHP'
foreach([['Total del servicio',$money($total)],['Pagado',$money($paid)],['Saldo pendiente',$money($balance)]] as $j=>$r){if($j===2){$pdf->fill(...$redBg);$pdf->fillRect(42,$y-32,528,32);}$pdf->fill(...($j===2&&$balance>0?$pink:$navy));$pdf->text($r[0],9,58,$y-18,$j===2);$pdf->text($r[1],$j===2?16:10,480,$y-18,true);$pdf->stroke(...$border);$pdf->line(42,$y-33,570,$y-33);$y-=33;}
PHP;

    $newRows = <<<'PHP'
$detailRows=[];
if(($commercial['available']??false)===true){
    $detailRows[]=['Subtotal',$money((float)$commercial['subtotal']),false,$navy];
    if(($commercial['has_discount']??false)===true){
        $detailRows[]=['Descuento ('.(string)$commercial['discount_label'].')','-'.$money((float)$commercial['discount']),false,$pink];
    }
    if(($commercial['has_tax']??false)===true){
        $detailRows[]=['IVA ('.(string)$commercial['tax_label'].')',$money((float)$commercial['tax']),false,$teal];
    }
}
$detailRows[]=['Total del servicio',$money($total),true,$navy];
$detailRows[]=['Pagado',$money($paid),false,$teal];
$detailRows[]=['Saldo pendiente',$money($balance),true,($balance>0?$pink:$teal)];
foreach($detailRows as $r){
    $isEmphasis=(bool)$r[2];
    if($r[0]==='Saldo pendiente'){
        $pdf->fill(...($balance>0?$redBg:$greenBg));$pdf->fillRect(42,$y-27,528,27);
    }
    $pdf->fill(...$r[3]);
    $pdf->text($r[0],8.5,58,$y-15,$isEmphasis);
    $pdf->text($r[1],$isEmphasis?12:9.5,480,$y-15,true);
    $pdf->stroke(...$border);$pdf->line(42,$y-28,570,$y-28);
    $y-=28;
}
PHP;

    $src = pdv1_replace_once(
        $src,
        $oldRows,
        $newRows,
        'seguimiento_comprobante.php · detalle financiero'
    );

    return $src;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión expiró. Recarga la página.';
    } else {
        $action = (string)($_POST['action'] ?? '');

        try {
            if ($action === 'install') {
                if (!is_file($orderFile) || !is_file($trackingFile) || !is_file($helperFile)) {
                    throw new RuntimeException('Faltan archivos del paquete o del sistema.');
                }

                $orderSrc = file_get_contents($orderFile);
                $trackingSrc = file_get_contents($trackingFile);
                if ($orderSrc === false || $trackingSrc === false) {
                    throw new RuntimeException('No se pudieron leer los generadores PDF.');
                }

                $patchedOrder = pdv1_patch_order($orderSrc);
                $patchedTracking = pdv1_patch_tracking($trackingSrc);

                pdv1_backup($orderFile);
                pdv1_backup($trackingFile);

                pdv1_atomic_write($orderFile, $patchedOrder);
                pdv1_atomic_write($trackingFile, $patchedTracking);

                $messages[] = 'Parche V1 aplicado correctamente.';
                $messages[] = 'Se crearon respaldos .bak_pdf_desglose_v1.';
                $messages[] = 'Prueba el PDF de Orden y el PDF de Seguimiento antes de actualizar GitHub.';
            }

            if ($action === 'revert') {
                $orderBackup = $orderFile . '.bak_pdf_desglose_v1';
                $trackingBackup = $trackingFile . '.bak_pdf_desglose_v1';

                if (!is_file($orderBackup) || !is_file($trackingBackup)) {
                    throw new RuntimeException('No se encontraron ambos respaldos V1.');
                }

                if (!copy($orderBackup, $orderFile) || !copy($trackingBackup, $trackingFile)) {
                    throw new RuntimeException('No se pudo restaurar uno de los archivos.');
                }

                $messages[] = 'Se restauraron los generadores PDF desde los respaldos V1.';
            }
        } catch (Throwable $e) {
            $error = $e->getMessage();
        }
    }
}

$orderInstalled = is_file($orderFile)
    && str_contains((string)@file_get_contents($orderFile), 'order_commercial_breakdown.php');
$trackingInstalled = is_file($trackingFile)
    && str_contains((string)@file_get_contents($trackingFile), 'order_commercial_breakdown.php');

require __DIR__ . '/../includes/header.php';
?>
<div class="card" style="max-width:900px;margin:20px auto;padding:20px">
    <span class="eyebrow">MANTENIMIENTO CONTROLADO</span>
    <h2>PDF Orden + Seguimiento · Descuento / IVA V1</h2>
    <p class="muted">
        Este instalador modifica únicamente <code>orden_pdf.php</code> y
        <code>seguimiento_comprobante.php</code>. Conserva respaldo automático.
    </p>

    <?php if ($error): ?>
        <div class="notice danger"><?=e($error)?></div>
    <?php endif; ?>

    <?php foreach ($messages as $message): ?>
        <div class="notice"><?=e($message)?></div>
    <?php endforeach; ?>

    <div style="display:grid;gap:8px;margin:18px 0">
        <div>Orden PDF: <strong><?= $orderInstalled ? '✓ instalado' : 'pendiente' ?></strong></div>
        <div>Seguimiento PDF: <strong><?= $trackingInstalled ? '✓ instalado' : 'pendiente' ?></strong></div>
        <div>Helper: <strong><?= is_file($helperFile) ? '✓ disponible' : '✕ faltante' ?></strong></div>
    </div>

    <form method="post" style="display:flex;gap:10px;flex-wrap:wrap">
        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
        <button class="btn btn-primary" type="submit" name="action" value="install">
            Aplicar parche V1
        </button>
        <button class="btn btn-secondary" type="submit" name="action" value="revert"
                onclick="return confirm('¿Restaurar los PDF anteriores desde el respaldo V1?');">
            Revertir
        </button>
    </form>

    <p class="muted" style="margin-top:18px">
        Después de probar, elimina <code>admin/aplicar_pdf_desglose_v1.php</code> del servidor.
    </p>
</div>
<?php require __DIR__ . '/../includes/footer.php'; ?>
