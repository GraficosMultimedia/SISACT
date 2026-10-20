<?php
declare(strict_types=1);

/*
 * Colibrí Print - parche puntual CFDI impuesto trasladado.
 *
 * Este parche NO reemplaza facturacion.php ni cfdi.php completos.
 * Modifica únicamente la lectura del impuesto trasladado del XML y crea
 * respaldos antes de tocar los archivos.
 */

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$root = dirname(__DIR__);
$facturacion = $root . '/admin/facturacion.php';
$cfdi = $root . '/includes/cfdi.php';

function backup_once(string $file, string $suffix): string {
    $backup = $file . '.bak-' . $suffix;
    if (!copy($file, $backup)) {
        throw new RuntimeException('No se pudo crear respaldo de ' . basename($file));
    }
    return $backup;
}

function replace_exact(string $source, string $old, string $new, string $label): string {
    if (!str_contains($source, $old)) {
        throw new RuntimeException('No se encontró el bloque esperado en ' . $label . '. El archivo no fue modificado.');
    }
    return str_replace($old, $new, $source, $count) && $count === 1
        ? str_replace($old, $new, $source)
        : throw new RuntimeException('El bloque esperado en ' . $label . ' no es único. No se aplicó el cambio.');
}

$stamp = date('Ymd-His');
$changed = [];
$backups = [];

try {
    if (!is_file($facturacion) || !is_file($cfdi)) {
        throw new RuntimeException('No se encontraron los archivos funcionales de facturación/CFDI.');
    }

    $factContent = file_get_contents($facturacion);
    $cfdiContent = file_get_contents($cfdi);
    if ($factContent === false || $cfdiContent === false) {
        throw new RuntimeException('No se pudieron leer los archivos funcionales.');
    }

    /* Backend: fuente fiscal = TotalImpuestosTrasladados. Si algún CFDI no trae
       el atributo agregado, sumamos los Traslado/@Importe como respaldo. */
    $oldBackend = <<<'PHPBLOCK'
    $impuestos=cfdi_xpath($xml,'/cfdi:Comprobante/cfdi:Impuestos');
    $tax=cfdi_attr($impuestos,'TotalImpuestosTrasladados');
PHPBLOCK;
    $newBackend = <<<'PHPBLOCK'
    $impuestos=cfdi_xpath($xml,'/cfdi:Comprobante/cfdi:Impuestos');
    $tax=cfdi_attr($impuestos,'TotalImpuestosTrasladados');
    if($tax===''){
        $taxTotal=0.0; $taxFound=false;
        foreach(($xml->xpath('/cfdi:Comprobante/cfdi:Impuestos/cfdi:Traslados/cfdi:Traslado')?:[]) as $traslado){
            $importe=cfdi_attr($traslado,'Importe');
            if($importe!==''){ $taxTotal+=(float)$importe; $taxFound=true; }
        }
        if($taxFound) $tax=number_format($taxTotal,2,'.','');
    }
PHPBLOCK;

    /* Navegador: lectura robusta del nodo cfdi:Impuestos y respaldo por suma
       de cfdi:Traslado/@Importe. Esto garantiza que el input visible reciba
       430.32 cuando el XML contiene TotalImpuestosTrasladados="430.32". */
    $oldJs = "        const uuid=attr(tfd,'UUID'), subtotal=attr(root,'SubTotal'), total=attr(root,'Total'), tax=attr(imp,'TotalImpuestosTrasladados');";
    $newJs = <<<'JSBLOCK'
        const uuid=attr(tfd,'UUID'), subtotal=attr(root,'SubTotal'), total=attr(root,'Total');
        let taxNode=imp;
        if(!taxNode){ taxNode=local(root,'Impuestos'); }
        let tax=taxNode?attr(taxNode,'TotalImpuestosTrasladados'):'';
        if(tax===''){
          const traslados=[...root.getElementsByTagNameNS('*','Traslado')];
          let taxSum=0, taxFound=false;
          traslados.forEach(node=>{
            const importe=attr(node,'Importe');
            if(importe!==''){ taxSum+=(parseFloat(importe)||0); taxFound=true; }
          });
          if(taxFound) tax=taxSum.toFixed(2);
        }
JSBLOCK;

    $newFact = str_replace($oldJs, $newJs, $factContent, $jsCount);
    if ($jsCount !== 1) {
        throw new RuntimeException('No se encontró exactamente una lectura de impuesto en admin/facturacion.php. No se modificó ningún archivo.');
    }

    $newCfdi = str_replace($oldBackend, $newBackend, $cfdiContent, $backendCount);
    if ($backendCount !== 1) {
        throw new RuntimeException('No se encontró exactamente una lectura de impuesto en includes/cfdi.php. No se modificó ningún archivo.');
    }

    $backups[] = backup_once($facturacion, $stamp);
    $backups[] = backup_once($cfdi, $stamp);

    if (file_put_contents($facturacion, $newFact, LOCK_EX) === false) {
        throw new RuntimeException('No se pudo guardar admin/facturacion.php.');
    }
    $changed[] = 'admin/facturacion.php';

    if (file_put_contents($cfdi, $newCfdi, LOCK_EX) === false) {
        throw new RuntimeException('No se pudo guardar includes/cfdi.php.');
    }
    $changed[] = 'includes/cfdi.php';

    foreach ($changed as $file) {
        $full = $root . '/' . $file;
        $lint = [];
        exec('php -l ' . escapeshellarg($full) . ' 2>&1', $lint, $code);
        if ($code !== 0) {
            throw new RuntimeException('PHP detectó un error después del cambio en ' . $file . ': ' . implode(" ", $lint));
        }
    }

    $testXml = '<?xml version="1.0" encoding="UTF-8"?><cfdi:Comprobante xmlns:cfdi="http://www.sat.gob.mx/cfd/4" Version="4.0" SubTotal="3019.50" Total="3502.62"><cfdi:Impuestos TotalImpuestosTrasladados="430.32"/></cfdi:Comprobante>';
    libxml_use_internal_errors(true);
    $test = simplexml_load_string($testXml, 'SimpleXMLElement', LIBXML_NONET|LIBXML_NOBLANKS);
    if ($test === false) throw new RuntimeException('No se pudo ejecutar la prueba interna del XML.');
    $test->registerXPathNamespace('cfdi','http://www.sat.gob.mx/cfd/4');
    $node = $test->xpath('/cfdi:Comprobante/cfdi:Impuestos');
    $testTax = ($node && isset($node[0])) ? (string)($node[0]->attributes()['TotalImpuestosTrasladados'] ?? '') : '';
    if ($testTax !== '430.32') {
        throw new RuntimeException('La prueba interna no obtuvo 430.32.');
    }

    $ok = true;
    $message = 'Parche aplicado. El impuesto trasladado ahora se toma de TotalImpuestosTrasladados y tiene respaldo por suma de Traslado/Importe.';
} catch (Throwable $e) {
    $ok = false;
    $message = $e->getMessage();
    /* Si algo falla después de modificar un archivo, restaura desde los respaldos. */
    if ($backups) {
        foreach ($backups as $backup) {
            $original = preg_replace('/\.bak-' . preg_quote($stamp, '/') . '$/', '', $backup);
            if ($original && is_file($backup)) @copy($backup, $original);
        }
    }
}
?>
<!doctype html>
<html lang="es"><head><meta charset="utf-8"><title>Parche CFDI</title>
<style>body{font-family:system-ui;background:#071321;color:#eef6ff;margin:0;padding:40px}.box{max-width:760px;margin:auto;background:#0d2036;border:1px solid #21486d;border-radius:16px;padding:28px}.ok{color:#39e6a0}.err{color:#ff7385}.mono{font-family:ui-monospace,monospace;background:#081727;padding:12px;border-radius:10px}.btn{display:inline-block;padding:10px 16px;border-radius:10px;background:#18bff0;color:#fff;text-decoration:none;margin-top:18px}</style></head><body><div class="box">
<h1>Parche CFDI · Impuesto trasladado</h1>
<p class="<?= $ok ? 'ok' : 'err' ?>"><strong><?= $ok ? '✓ Cambio aplicado correctamente' : '✕ No se aplicó el cambio' ?></strong></p>
<p><?=htmlspecialchars($message, ENT_QUOTES, 'UTF-8')?></p>
<?php if($ok): ?><div class="mono">XML: TotalImpuestosTrasladados="430.32" → campo "Impuesto trasladado" = 430.32</div><p>Se conservaron respaldos .bak-<?=htmlspecialchars($stamp, ENT_QUOTES, 'UTF-8')?> de los dos archivos.</p><?php endif; ?>
<a class="btn" href="/admin/facturacion.php">Volver a Facturación</a>
</div></body></html>
