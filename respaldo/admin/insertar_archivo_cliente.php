<?php
declare(strict_types=1);

if (!function_exists('cp_quote_web_attachment_block')) {
    function cp_quote_web_attachment_block(array $quote): void {
        $sourceData = [];
        if (!empty($quote['source_data'])) {
            $decoded = json_decode((string)$quote['source_data'], true);
            if (is_array($decoded)) {
                $sourceData = $decoded;
            }
        }

        $webRequestId = (int)($sourceData['web_request_id'] ?? 0);
        $payload = is_array($sourceData['payload'] ?? null) ? $sourceData['payload'] : [];
        $attachment = is_array($payload['attachment'] ?? null) ? $payload['attachment'] : [];

        $path = trim((string)($attachment['relative_path'] ?? ''));
        $name = trim((string)($attachment['original_name'] ?? ''));
        $mime = trim((string)($attachment['mime'] ?? ''));
        $size = (int)($attachment['size'] ?? 0);

        $safePath = '';
        if ($path !== '' && preg_match('#^/uploads/cotizador/[A-Za-z0-9/_\.-]+$#', $path)) {
            $safePath = $path;
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

        if ($safePath === '' && $webRequestId <= 0) {
            return;
        }
        ?>
        <section class="quote-client-file no-print" aria-labelledby="quote-client-file-title">
            <div class="quote-client-file-head">
                <div>
                    <span class="eyebrow">EXPEDIENTE · ARCHIVO DEL CLIENTE</span>
                    <h4 id="quote-client-file-title">Documento recibido con la solicitud</h4>
                    <p>Material original enviado por el cliente y conservado con esta cotización.</p>
                </div>
                <?php if ($webRequestId > 0): ?>
                    <a class="quote-file-cpq" href="/admin/cotizaciones_web.php?focus=<?= $webRequestId ?>">
                        CPQ-<?= str_pad((string)$webRequestId, 6, '0', STR_PAD_LEFT) ?>
                    </a>
                <?php endif; ?>
            </div>

            <?php if ($safePath !== ''): ?>
                <div class="quote-client-file-card">
                    <div class="quote-client-file-icon">📎</div>
                    <div class="quote-client-file-info">
                        <strong><?= e($name !== '' ? $name : basename($safePath)) ?></strong>
                        <span><?= e($mime !== '' ? $mime : 'Archivo recibido') ?><?= $displaySize !== '' ? ' · ' . e($displaySize) : '' ?></span>
                    </div>
                    <div class="quote-client-file-actions">
                        <a class="btn btn-secondary" href="<?= e($safePath) ?>" target="_blank" rel="noopener">Abrir</a>
                        <a class="btn btn-primary" href="<?= e($safePath) ?>" download>Descargar</a>
                    </div>
                </div>
            <?php else: ?>
                <div class="quote-client-file-empty">
                    <strong>Solicitud web vinculada.</strong>
                    <span>No hay un archivo adjunto conservado en los datos de esta solicitud.</span>
                </div>
            <?php endif; ?>
        </section>
        <?php
    }
}
