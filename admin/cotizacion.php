<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_once __DIR__ . '/../includes/company.php';

if (!function_exists('cp_quote_web_attachment_block')) {
    function cp_quote_web_attachment_block(array $quote): void {
        $sourceData = [];

        if (isset($quote['source_data'])) {
            if (is_array($quote['source_data'])) {
                $sourceData = $quote['source_data'];
            } elseif (is_string($quote['source_data']) && trim($quote['source_data']) !== '') {
                $decoded = json_decode($quote['source_data'], true);
                if (is_array($decoded)) {
                    $sourceData = $decoded;
                }
            }
        }

        $webRequestId = (int)($sourceData['web_request_id'] ?? 0);
        $payload = is_array($sourceData['payload'] ?? null) ? $sourceData['payload'] : [];
        $attachment = is_array($payload['attachment'] ?? null) ? $payload['attachment'] : [];

        /*
         * Fallback: si source_data no conserva el archivo, buscamos la
         * solicitud web original usando web_request_id.
         */
        if ($webRequestId > 0 && empty($attachment)) {
            try {
                $st = db()->prepare('SELECT request_text FROM cp_web_quote_requests WHERE id=? LIMIT 1');
                $st->execute([$webRequestId]);
                $requestText = (string)($st->fetchColumn() ?: '');

                $marker = strpos($requestText, '[CPQ_JSON]');
                if ($marker !== false) {
                    $fallback = json_decode(trim(substr($requestText, $marker + strlen('[CPQ_JSON]'))), true);
                    if (is_array($fallback)) {
                        $fallbackAttachment = is_array($fallback['attachment'] ?? null)
                            ? $fallback['attachment']
                            : [];
                        if ($fallbackAttachment) {
                            $attachment = $fallbackAttachment;
                        }
                    }
                }
            } catch (Throwable $e) {
                error_log('[ColibriPrint][quote attachment] ' . $e->getMessage());
            }
        }

        $path = trim((string)($attachment['relative_path'] ?? ''));
        $name = trim((string)($attachment['original_name'] ?? ''));
        $mime = trim((string)($attachment['mime'] ?? ''));
        $size = (int)($attachment['size'] ?? 0);

        /*
         * Solamente se presentan rutas internas del almacén del cotizador.
         * No se permite una URL externa ni traversal.
         */
        $safePath = '';
        if ($path !== '' && preg_match('#^/uploads/cotizador/[A-Za-z0-9/_\.-]+$#', $path)) {
            $safePath = $path;
        }

        if ($safePath === '' && $webRequestId <= 0) {
            return;
        }

        $displaySize = '';
        if ($size > 0) {
            if ($size >= 1048576) {
                $displaySize = number_format($size / 1048576, 2) . ' MB';
            } elseif ($size >= 1024) {
                $displaySize = number_format($size / 1024, 1) . ' KB';
            } else {
                $displaySize = number_format($size) . ' B';
            }
        }

        $typeLabel = $mime !== '' ? strtoupper((string)preg_replace('#^.*?/|;.*$#', '', $mime)) : 'ARCHIVO';
        ?>
        <section class="quote-client-file no-print" aria-labelledby="quote-client-file-title">
            <div class="quote-client-file-top">
                <div class="quote-client-file-heading">
                    <div class="quote-client-file-icon">📎</div>
                    <div>
                        <span class="eyebrow">EXPEDIENTE · ARCHIVO DEL CLIENTE</span>
                        <h4 id="quote-client-file-title">Material recibido para producir el proyecto</h4>
                        <p>Archivo conservado con la solicitud web de origen. No es necesario volver a pedirlo al cliente.</p>
                    </div>
                </div>

                <?php if ($webRequestId > 0): ?>
                    <a class="quote-client-file-origin" href="/admin/cotizaciones_web.php?focus=<?= $webRequestId ?>">
                        CPQ-<?= str_pad((string)$webRequestId, 6, '0', STR_PAD_LEFT) ?> ↗
                    </a>
                <?php endif; ?>
            </div>

            <?php if ($safePath !== ''): ?>
                <div class="quote-client-file-record">
                    <div class="quote-client-file-data">
                        <strong title="<?= e($name !== '' ? $name : basename($safePath)) ?>">
                            <?= e($name !== '' ? $name : basename($safePath)) ?>
                        </strong>
                        <div>
                            <span class="quote-client-file-badge"><?= e($typeLabel) ?></span>
                            <?php if ($displaySize !== ''): ?>
                                <span><?= e($displaySize) ?></span>
                            <?php endif; ?>
                            <span>Archivo del cliente</span>
                        </div>
                    </div>

                    <div class="quote-client-file-actions">
                        <a class="btn btn-secondary" href="<?= e($safePath) ?>" target="_blank" rel="noopener">
                            Ver archivo
                        </a>
                        <a class="btn btn-primary" href="<?= e($safePath) ?>" download>
                            Descargar
                        </a>
                    </div>
                </div>
            <?php else: ?>
                <div class="quote-client-file-missing">
                    <strong>Solicitud web vinculada, pero no se encontró el archivo.</strong>
                    <span>El expediente CPQ sí está asociado a esta cotización.</span>
                </div>
            <?php endif; ?>
        </section>
        <?php
    }
}

require_auth();

$id = (int)($_GET['id'] ?? 0);
$quote = quote_get($id);
if (!$quote) redirect('/admin/cotizaciones.php');
$title = 'Cotización ' . $quote['quote_number'];
$error = null;
$orderLinked = order_for_quote($id);
$company = company_profile();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['action'] ?? '') === 'status') {
        $newStatus = (string)($_POST['status'] ?? '');
        if (!array_key_exists($newStatus, quote_statuses())) {
            $error = 'Estado no válido.';
        } else {
            try {
                $pdo = db();
                $pdo->beginTransaction();
                $st = $pdo->prepare('UPDATE cp_quotes SET status=?,updated_by=?,updated_at=NOW() WHERE id=?');
                $st->execute([$newStatus, current_user()['id'] ?? null, $id]);
                $web = $pdo->prepare('SELECT id FROM cp_web_quote_requests WHERE converted_quote_id=? LIMIT 1');
                $web->execute([$id]);
                $webId = (int)($web->fetchColumn() ?: 0);
                if ($webId > 0) {
                    $webStatus = $newStatus === 'sent' ? 'quoted' : ($newStatus === 'approved' ? 'closed' : null);
                    if ($webStatus !== null) {
                        $pdo->prepare('UPDATE cp_web_quote_requests SET status=?,updated_at=NOW() WHERE id=?')->execute([$webStatus,$webId]);
                    }
                }
                $pdo->commit();
                log_activity('update', 'quotes', 'Estado de cotización actualizado #' . $id . ' a ' . $newStatus);
                redirect('/admin/cotizacion.php?id=' . $id . '&status_saved=1');
            } catch (Throwable $e) {
                $error = 'No se pudo actualizar el estado.';
            }
        }
    }
}

$items = quote_items($id);
$costs = quote_costs($id);
$totals = quote_totals($id);

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizaciones.css?v=20260917-7">
<link rel="stylesheet" href="/assets/css/quote-client-file-v2.css?v=20260920-2">
<div class="quote-toolbar no-print">
    <div>
        <span class="eyebrow">COTIZACIÓN FORMAL</span>
        <h2><?=e($quote['quote_number'])?></h2>
        <p class="muted">Revisión comercial. Los costos internos permanecen separados del documento del cliente.</p>
    </div>
    <div class="quote-toolbar-actions">
        <a class="btn btn-primary" href="/admin/whatsapp.php?source=quote&id=<?=((int)$id)?>&template=quote_sent">💬 WhatsApp</a>
       <a class="btn btn-primary"
       href="/admin/cotizacion_pdf_2paginas.php?id=<?=((int)$id)?>"
       target="_blank"
       rel="noopener">
        📄 PDF Cotización
    </a>

        <?=edit_button('/admin/cotizacion_nueva.php?id='.$id)?>
        <?php if ($orderLinked): ?>
            <?=action_button('Ver orden '.$orderLinked['order_number'], '/admin/orden.php?id='.(int)$orderLinked['id'], 'btn btn-secondary')?>
        <?php elseif ($quote['status'] === 'approved'): ?>
            <?=action_button('Crear orden de servicio', '/admin/orden_nueva.php?quote_id='.$id, 'btn btn-primary')?>
        <?php endif; ?>
        <?=action_button('Nueva', '/admin/cotizacion_nueva.php', 'btn btn-secondary')?>
        <?=cancel_button('/admin/cotizaciones.php')?>
    </div>
</div>
<?php if ($error): ?><div class="notice danger no-print"><?=e($error)?></div><?php endif; ?>
<?php if (isset($_GET['saved'])): ?><div class="notice no-print"><span class="ok">✓</span> Cotización guardada correctamente.</div><?php endif; ?><?php if (isset($_GET['order_synced'])): ?><div class="notice no-print"><span class="ok">✓</span> La orden vinculada fue sincronizada con los datos comerciales de esta cotización.</div><?php endif; ?><?php if (isset($_GET['order_sync_error'])): ?><div class="notice danger no-print">La cotización se guardó, pero la orden vinculada no pudo sincronizarse. Revisa la ficha de la orden.</div><?php endif; ?><?php if (isset($_GET['order_sync_locked'])): ?><div class="notice no-print">La cotización se guardó. La orden vinculada está cerrada y se conserva su información histórica.</div><?php endif; ?>
<?php if (isset($_GET['status_saved'])): ?><div class="notice no-print"><span class="ok">✓</span> Estado actualizado.</div><?php endif; ?>

<div class="quote-view-grid">
    <main>
        <article class="card quote-document">
            <div class="formal-company-head">
                <div class="formal-company-brand">
                    <?php if ($company['logo_path']): ?><img src="<?=e($company['logo_path'])?>" alt="<?=e($company['trade_name'] ?: $company['legal_name'])?>"><?php endif; ?>
                    <div><strong><?=e($company['trade_name'] ?: $company['legal_name'])?></strong><small><?=e($company['legal_name'])?></small></div>
                </div>
                <div class="formal-company-data">
                    <?php if ($company['rfc']): ?><div>RFC: <?=e($company['rfc'])?></div><?php endif; ?>
                    <?php if ($company['address']): ?><div><?=e($company['address'])?><?= $company['neighborhood'] ? ', ' . e($company['neighborhood']) : '' ?></div><?php endif; ?>
                    <div><?=e(trim($company['city'] . ($company['state'] ? ', ' . $company['state'] : '') . ($company['postal_code'] ? ' C.P. ' . $company['postal_code'] : '')))?></div>
                    <?php if ($company['phone'] || $company['email']): ?><div><?=e(trim($company['phone'] . ($company['email'] ? ' · ' . $company['email'] : '')))?></div><?php endif; ?>
                    <?php if ($company['website']): ?><div><?=e($company['website'])?></div><?php endif; ?>
                </div>
            </div>
            <div class="formal-document-title">
                <div><span class="eyebrow">COTIZACIÓN</span><h3><?=e($quote['quote_number'])?></h3></div>
                <div class="formal-meta"><div><span>Fecha</span><strong><?=e(date('d/m/Y', strtotime((string)$quote['issue_date'])))?></strong></div><?php if ($quote['valid_until']): ?><div><span>Vigencia</span><strong><?=e(date('d/m/Y', strtotime((string)$quote['valid_until'])))?></strong></div><?php endif; ?></div>
            </div>

            <div class="customer-box formal-customer">
                <div><span>DATOS DEL CLIENTE</span><strong><?=e($quote['customer_name'] ?? 'Sin cliente')?></strong></div>
                <div class="customer-data-grid">
                  <?php if ($quote['customer_tax_number']): ?><small><b>RFC:</b> <?=e($quote['customer_tax_number'])?></small><?php endif; ?>
                  <?php if ($quote['customer_email']): ?><small><b>Correo:</b> <?=e($quote['customer_email'])?></small><?php endif; ?>
                  <?php if ($quote['customer_phone']): ?><small><b>Teléfono:</b> <?=e($quote['customer_phone'])?></small><?php endif; ?>
                  <?php if ($quote['customer_address']): ?><small><b>Domicilio:</b> <?=e($quote['customer_address'])?><?= $quote['customer_city'] ? ', ' . e($quote['customer_city']) : '' ?><?= $quote['customer_state'] ? ', ' . e($quote['customer_state']) : '' ?><?= $quote['customer_zip_code'] ? ' C.P. ' . e($quote['customer_zip_code']) : '' ?></small><?php endif; ?>
                </div>
            </div>
            <?php if ($quote['client_reference'] || $quote['payment_terms'] || $quote['delivery_time'] || $quote['delivery_place']): ?>
            <div class="formal-reference-grid">
              <?php if ($quote['client_reference']): ?><div><span>Referencia / proyecto</span><strong><?=e($quote['client_reference'])?></strong></div><?php endif; ?>
              <?php if ($quote['payment_terms']): ?><div><span>Condiciones de pago</span><strong><?=e($quote['payment_terms'])?></strong></div><?php endif; ?>
              <?php if ($quote['delivery_time']): ?><div><span>Tiempo de entrega</span><strong><?=e($quote['delivery_time'])?></strong></div><?php endif; ?>
              <?php if ($quote['delivery_place']): ?><div><span>Lugar de entrega</span><strong><?=e($quote['delivery_place'])?></strong></div><?php endif; ?>
            </div>
            <?php endif; ?>
            <?php cp_quote_web_attachment_block($quote); ?>

            <table class="table document-items">
                <thead><tr><th>Descripción</th><th>Cant.</th><th>Precio unitario</th><th>Importe</th></tr></thead>
                <tbody>
                <?php foreach ($items as $item): ?>
                    <tr><td><?=e($item['description'])?></td><td><?=e((string)$item['quantity'])?></td><td><?=quote_money((float)$item['unit_price'])?></td><td><?=quote_money((float)$item['subtotal'])?></td></tr>
                <?php endforeach; ?>
                </tbody>
            </table>

            <div class="document-total">
                <div><span>Subtotal</span><strong><?=quote_money((float)$totals['subtotal'])?></strong></div>
                <div><span>Descuento</span><strong><?=quote_money((float)$totals['discount'])?></strong></div>
                <div><span>Impuestos</span><strong><?=quote_money((float)$totals['tax'])?></strong></div>
                <div class="grand"><span>Total</span><strong><?=quote_money((float)$totals['total'])?></strong></div>
            </div>

            <?php if ($quote['notes']): ?><div class="document-section"><h4>Notas</h4><p><?=nl2br(e($quote['notes']))?></p></div><?php endif; ?>
            <?php if ($quote['terms']): ?><div class="document-section"><h4>Condiciones comerciales</h4><p><?=nl2br(e($quote['terms']))?></p></div><?php endif; ?>
            <?php if ($company['payment_info']): ?><div class="document-section"><h4>Información para pago</h4><p><?=nl2br(e($company['payment_info']))?></p></div><?php endif; ?>
            <div class="document-footer"><strong><?=e($company['trade_name'] ?: $company['legal_name'])?></strong> · <?=e($company['quote_footer'])?> · <?=e($quote['quote_number'])?></div>
        </article>
    </main>

    <aside class="no-print">
        <div class="card status-card">
            <span class="eyebrow">ESTADO</span>
            <h3>Actualizar estado</h3>
            <form method="post">
                <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                <input type="hidden" name="action" value="status">
                <select name="status">
                    <?php foreach (quote_statuses() as $key => $label): ?><option value="<?=e($key)?>" <?=$quote['status'] === $key ? 'selected' : ''?>><?=e($label)?></option><?php endforeach; ?>
                </select>
                <button class="btn btn-primary full" type="submit">Guardar estado</button>
            </form>
            <?php if (!$orderLinked && $quote['status'] !== 'approved'): ?>
                <small class="help-text">Al marcar la cotización como <strong>Aprobada</strong> aparecerá la opción para crear la orden de servicio.</small>
            <?php endif; ?>
        </div>

        <div class="card internal-card">
            <span class="eyebrow">🔒 INTERNO</span>
            <h3>Rentabilidad</h3>
            <div class="internal-number"><span>Costo de producción</span><strong><?=quote_money((float)$totals['internal_cost'])?></strong></div>
            <div class="internal-number"><span>Utilidad</span><strong><?=quote_money((float)$totals['profit'])?></strong></div>
            <div class="internal-number"><span>Margen</span><strong><?=number_format((float)$totals['margin_pct'],2)?>%</strong></div>
            <?php if ($costs): ?>
                <div class="cost-list"><h4>Desglose de costos</h4><?php foreach ($costs as $cost): ?><div><span><?=e($cost['concept'])?></span><strong><?=quote_money((float)$cost['amount'])?></strong></div><?php endforeach; ?></div>
            <?php endif; ?>
            <small>Esta información es interna y no se imprime en la cotización.</small>
        </div>
    </aside>
</div>
<script>
(function(){
  const btn=document.getElementById('quoteWhatsappPdf');
  if(!btn) return;
  btn.addEventListener('click', function(){
    const waUrl=btn.dataset.waUrl||'';
    const pdfUrl=btn.dataset.pdfUrl||'';
    const quoteId=btn.dataset.quoteId||'';
    if(!waUrl||!pdfUrl) return;

    if(quoteId){
      fetch('/admin/whatsapp.php?action=log_quote_prepare&quote_id='+encodeURIComponent(quoteId),{credentials:'same-origin',cache:'no-store'}).catch(()=>{});
    }

    // Abre WhatsApp Web directamente con el mensaje ya preparado.
    window.open(waUrl,'colibri_whatsapp');

    // Abre el PDF en otra pestaña para que el operador pueda verlo antes de pulsar Enviar.
    window.open(pdfUrl,'colibri_quote_pdf');

    const old=btn.textContent;
    btn.disabled=true;
    btn.textContent='✓ WhatsApp + PDF listos';
    setTimeout(()=>{btn.disabled=false;btn.textContent=old;},3500);
  });
})();
</script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
