<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/expense_cfdi.php';
require_once __DIR__ . '/../includes/company.php';
require_auth();

$title = 'Egresos';
$pdo = db();
$user = current_user();
$issues = [];
$message = null;
$error = null;
$importResult = null;

function cpe_table_exists(PDO $pdo, string $table): bool
{
    try {
        $st = $pdo->prepare(
            'SELECT COUNT(*) FROM information_schema.tables
             WHERE table_schema=DATABASE() AND table_name=?'
        );
        $st->execute([$table]);
        return (int)$st->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function cpe_money(float $value): string
{
    return '$' . number_format($value, 2, '.', ',');
}

$categories = expense_cfdi_categories();
$installed = cpe_table_exists($pdo, 'cp_expenses');
$cfdiInstalled = $installed && expense_cfdi_tables_ready();
$company = company_profile();
$companyRfc = strtoupper(trim((string)($company['rfc'] ?? '')));

if ($installed && $_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'Sesión inválida. Recarga la página.';
    } else {
        $action = trim((string)($_POST['action'] ?? ''));

        if ($action === 'import_cfdi') {
            if (!$cfdiInstalled) {
                $error = 'Primero ejecuta database/sql/022_expense_cfdi_documents.sql.';
            } else {
                try {
                    $categoryOverride = trim((string)($_POST['import_category'] ?? ''));
                    if ($categoryOverride === 'auto') $categoryOverride = '';

                    $importResult = expense_cfdi_import_batch(
                        is_array($_FILES['cfdi_xml'] ?? null) ? $_FILES['cfdi_xml'] : [],
                        (int)($user['id'] ?? 0),
                        $companyRfc,
                        isset($_POST['allow_rfc_mismatch']),
                        $categoryOverride
                    );

                    if ((int)$importResult['imported'] > 0) {
                        $message =
                            (int)$importResult['imported'] . ' egreso(s) CFDI registrado(s) · ' .
                            cpe_money((float)$importResult['total']) . ' importados.';
                    } elseif ((int)$importResult['duplicates'] > 0 && (int)$importResult['errors'] === 0) {
                        $message = 'Los XML seleccionados ya estaban registrados. No se duplicaron egresos.';
                    }
                } catch (Throwable $e) {
                    $error = 'No se pudieron procesar los XML. ' . $e->getMessage();
                }
            }
        }

        if ($action === 'create') {
            $expenseDate = trim((string)($_POST['expense_date'] ?? ''));
            $dueDate = trim((string)($_POST['due_date'] ?? ''));
            $category = trim((string)($_POST['category'] ?? 'Otros'));
            $supplier = trim((string)($_POST['supplier'] ?? ''));
            $description = trim((string)($_POST['description'] ?? ''));
            $amount = (float)($_POST['amount'] ?? 0);
            $paymentMethod = trim((string)($_POST['payment_method'] ?? 'other'));
            $reference = trim((string)($_POST['reference'] ?? ''));
            $receiptReference = trim((string)($_POST['receipt_reference'] ?? ''));
            $orderIdRaw = trim((string)($_POST['order_id'] ?? ''));
            $orderId = $orderIdRaw !== '' ? (int)$orderIdRaw : null;
            $status = trim((string)($_POST['status'] ?? 'paid'));
            $notes = trim((string)($_POST['notes'] ?? ''));

            $validStatuses = ['paid','pending','cancelled'];
            if (!in_array($status, $validStatuses, true)) $status = 'paid';

            if ($expenseDate === '' || $description === '' || $amount <= 0) {
                $error = 'Fecha, descripción e importe mayor a cero son obligatorios.';
            } else {
                try {
                    $st = $pdo->prepare(
                        "INSERT INTO cp_expenses
                        (expense_date,due_date,category,supplier,description,amount,payment_method,reference,
                         receipt_reference,order_id,status,notes,created_by,updated_by,created_at,updated_at)
                         VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())"
                    );
                    $st->execute([
                        $expenseDate,
                        $dueDate !== '' ? $dueDate : null,
                        $category !== '' ? $category : 'Otros',
                        $supplier !== '' ? $supplier : null,
                        $description,
                        $amount,
                        $paymentMethod !== '' ? $paymentMethod : 'other',
                        $reference !== '' ? $reference : null,
                        $receiptReference !== '' ? $receiptReference : null,
                        $orderId,
                        $status,
                        $notes !== '' ? $notes : null,
                        (int)($user['id'] ?? 0) ?: null,
                        (int)($user['id'] ?? 0) ?: null,
                    ]);

                    log_activity(
                        'create',
                        'expenses',
                        'Egreso registrado: ' . $description . ' · ' . cpe_money($amount)
                    );

                    redirect('/admin/egresos.php?saved=1');
                } catch (Throwable $e) {
                    $error = 'No se pudo guardar el egreso. ' . $e->getMessage();
                }
            }
        }

        if ($action === 'cancel') {
            $id = (int)($_POST['id'] ?? 0);
            if ($id > 0) {
                try {
                    $st = $pdo->prepare(
                        "UPDATE cp_expenses
                         SET status='cancelled', updated_by=?, updated_at=NOW()
                         WHERE id=?"
                    );
                    $st->execute([(int)($user['id'] ?? 0) ?: null, $id]);
                    log_activity('cancel', 'expenses', 'Egreso cancelado ID ' . $id);
                    redirect('/admin/egresos.php?cancelled=1');
                } catch (Throwable $e) {
                    $error = 'No se pudo cancelar el egreso. ' . $e->getMessage();
                }
            }
        }
    }
}

if (isset($_GET['saved'])) $message = 'Egreso registrado correctamente.';
if (isset($_GET['cancelled'])) $message = 'Egreso cancelado. Se conserva el registro para auditoría.';

$from = trim((string)($_GET['from'] ?? date('Y-m-01')));
$to = trim((string)($_GET['to'] ?? date('Y-m-d')));
if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $from)) $from = date('Y-m-01');
if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $to)) $to = date('Y-m-d');

$rows = [];
$totalPaid = 0.0;
$totalPending = 0.0;
$orders = [];
$cfdiCount = 0;

if ($installed) {
    try {
        if ($cfdiInstalled) {
            $st = $pdo->prepare(
                "SELECT e.*,o.order_number,
                        d.id AS cfdi_document_id,d.uuid AS cfdi_uuid,d.issuer_rfc,d.receiver_rfc,d.total AS cfdi_total
                 FROM cp_expenses e
                 LEFT JOIN cp_orders o ON o.id=e.order_id
                 LEFT JOIN cp_expense_documents d
                   ON d.id=(SELECT MAX(d2.id) FROM cp_expense_documents d2 WHERE d2.expense_id=e.id)
                 WHERE e.expense_date BETWEEN ? AND ?
                 ORDER BY e.expense_date DESC,e.id DESC
                 LIMIT 250"
            );
        } else {
            $st = $pdo->prepare(
                "SELECT e.*,o.order_number,
                        NULL AS cfdi_document_id,NULL AS cfdi_uuid,NULL AS issuer_rfc,NULL AS receiver_rfc,NULL AS cfdi_total
                 FROM cp_expenses e
                 LEFT JOIN cp_orders o ON o.id=e.order_id
                 WHERE e.expense_date BETWEEN ? AND ?
                 ORDER BY e.expense_date DESC,e.id DESC
                 LIMIT 250"
            );
        }
        $st->execute([$from, $to]);
        $rows = $st->fetchAll(PDO::FETCH_ASSOC);

        foreach ($rows as $row) {
            if (!empty($row['cfdi_document_id'])) $cfdiCount++;
        }

        $st = $pdo->prepare(
            "SELECT
                COALESCE(SUM(CASE WHEN status='paid' THEN amount ELSE 0 END),0) AS paid,
                COALESCE(SUM(CASE WHEN status='pending' THEN amount ELSE 0 END),0) AS pending
             FROM cp_expenses
             WHERE expense_date BETWEEN ? AND ?"
        );
        $st->execute([$from, $to]);
        $totals = $st->fetch(PDO::FETCH_ASSOC) ?: [];
        $totalPaid = (float)($totals['paid'] ?? 0);
        $totalPending = (float)($totals['pending'] ?? 0);

        $orders = $pdo->query(
            "SELECT id,order_number,total
             FROM cp_orders
             WHERE status <> 'cancelled'
             ORDER BY id DESC
             LIMIT 150"
        )->fetchAll(PDO::FETCH_ASSOC);
    } catch (Throwable $e) {
        $issues[] = $e->getMessage();
    }
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/egresos.css?v=1.0.0">
<link rel="stylesheet" href="/assets/css/egresos-cfdi-v1.css?v=1.0.0">

<section class="eg-head">
    <div>
        <span class="eg-eyebrow">CONTROL DE CAJA</span>
        <h2>Egresos</h2>
        <p>Registra salidas reales, compromisos de pago y facturas XML de proveedores.</p>
    </div>
    <div class="eg-head-actions">
        <a class="eg-back" href="/admin/reportes.php#control-administrativo">Balance administrativo</a>
        <a class="eg-back" href="/admin/dashboard.php">← Dashboard Intelligence</a>
    </div>
</section>

<?php if (!$installed): ?>
<section class="eg-install">
    <div class="eg-install-icon">$</div>
    <div>
        <h3>Módulo de egresos pendiente de instalar</h3>
        <p>El dashboard funciona aunque esta tabla todavía no exista. Para activar egresos importa manualmente:</p>
        <code>sql/dashboard_intelligence_v1_expenses.sql</code>
        <p>La migración solamente crea <strong>cp_expenses</strong>; no altera tablas, conexiones ni datos existentes.</p>
    </div>
</section>
<?php else: ?>

<?php if ($message): ?><div class="eg-message success"><?=e($message)?></div><?php endif; ?>
<?php if ($error): ?><div class="eg-message error"><?=e($error)?></div><?php endif; ?>

<?php if ($importResult): ?>
<section class="eg-import-result">
    <div class="eg-import-summary">
        <div><span>Importados</span><strong><?=number_format((int)$importResult['imported'])?></strong></div>
        <div><span>Duplicados</span><strong><?=number_format((int)$importResult['duplicates'])?></strong></div>
        <div><span>Errores</span><strong><?=number_format((int)$importResult['errors'])?></strong></div>
        <div><span>Total registrado</span><strong><?=e(cpe_money((float)$importResult['total']))?></strong></div>
    </div>
    <div class="eg-import-items">
        <?php foreach (($importResult['items'] ?? []) as $item): ?>
            <div class="eg-import-item <?=e((string)($item['status'] ?? 'error'))?>">
                <span><?=($item['status'] ?? '') === 'imported' ? '✓' : (($item['status'] ?? '') === 'duplicate' ? '⚠' : '✕')?></span>
                <div>
                    <strong><?=e((string)($item['file'] ?? 'XML'))?></strong>
                    <small><?=e((string)($item['message'] ?? ''))?>
                        <?php if (isset($item['amount'])): ?> · <?=e(cpe_money((float)$item['amount']))?><?php endif; ?>
                        <?php if (!empty($item['category'])): ?> · <?=e((string)$item['category'])?><?php endif; ?>
                    </small>
                </div>
            </div>
        <?php endforeach; ?>
    </div>
</section>
<?php endif; ?>

<section class="eg-stats eg-stats-v1">
    <article><span>Pagado en periodo</span><strong><?=e(cpe_money($totalPaid))?></strong><small>Impacta flujo neto</small></article>
    <article><span>Pendiente</span><strong><?=e(cpe_money($totalPending))?></strong><small>Compromisos registrados</small></article>
    <article><span>Movimientos</span><strong><?=number_format(count($rows))?></strong><small>Máximo 250 visibles</small></article>
    <article><span>Con CFDI XML</span><strong><?=number_format($cfdiCount)?></strong><small>En el listado visible</small></article>
</section>

<section class="eg-cfdi-import-card">
    <div class="eg-card-head">
        <span class="eg-eyebrow">IMPORTACIÓN FISCAL</span>
        <h3>Registrar egresos desde XML CFDI</h3>
        <p>Selecciona varias facturas. SISACT obtiene proveedor, fecha, conceptos, forma de pago y <strong>Total</strong> del XML.</p>
    </div>

    <?php if (!$cfdiInstalled): ?>
        <div class="eg-cfdi-install">
            <strong>Falta activar el expediente XML de egresos.</strong>
            <span>Ejecuta <code>database/sql/022_expense_cfdi_documents.sql</code> y vuelve a cargar esta página.</span>
        </div>
    <?php else: ?>
    <form method="post" enctype="multipart/form-data" class="eg-cfdi-form">
        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
        <input type="hidden" name="action" value="import_cfdi">

        <label class="eg-upload-box">
            <span class="eg-upload-icon">XML</span>
            <span>
                <strong>Seleccionar facturas XML</strong>
                <small>CFDI 4.0 · máximo 30 archivos por operación · hasta 5 MB por XML</small>
            </span>
            <input type="file" name="cfdi_xml[]" accept=".xml,application/xml,text/xml" multiple required>
        </label>

        <div class="eg-cfdi-options">
            <label>
                <span>Categoría</span>
                <select name="import_category">
                    <option value="auto">Automática según concepto</option>
                    <?php foreach ($categories as $category): ?>
                        <option value="<?=e($category)?>"><?=e($category)?></option>
                    <?php endforeach; ?>
                </select>
            </label>

            <div class="eg-rfc-box">
                <span>RFC configurado</span>
                <strong><?=e($companyRfc !== '' ? $companyRfc : 'NO CONFIGURADO')?></strong>
                <small>
                    <?php if ($companyRfc === ''): ?>
                        Configúralo en Datos de empresa para validar el receptor del XML.
                    <?php else: ?>
                        SISACT comparará este RFC contra el receptor de cada factura.
                    <?php endif; ?>
                </small>
            </div>
        </div>

        <label class="eg-check">
            <input type="checkbox" name="allow_rfc_mismatch" value="1">
            <span>Permitir importar XML cuyo RFC receptor sea diferente al configurado en SISACT.</span>
        </label>

        <div class="eg-cfdi-help">
            <span><b>PUE</b> → egreso Pagado</span>
            <span><b>PPD</b> → egreso Pendiente</span>
            <span><b>01</b> Efectivo · <b>03</b> Transferencia · <b>04/28/29</b> Tarjeta</span>
            <span>UUID y SHA-256 impiden duplicar una factura.</span>
        </div>

        <button class="eg-submit eg-import-submit" type="submit">Importar XML como egresos</button>
    </form>
    <?php endif; ?>
</section>

<section class="eg-grid">
    <article class="eg-card">
        <div class="eg-card-head">
            <span class="eg-eyebrow">NUEVO MOVIMIENTO</span>
            <h3>Registrar egreso manual</h3>
        </div>

        <form method="post" class="eg-form">
            <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
            <input type="hidden" name="action" value="create">

            <div class="eg-form-grid">
                <label>
                    <span>Fecha *</span>
                    <input type="date" name="expense_date" value="<?=e(date('Y-m-d'))?>" required>
                </label>

                <label>
                    <span>Fecha compromiso</span>
                    <input type="date" name="due_date">
                </label>

                <label>
                    <span>Categoría *</span>
                    <select name="category">
                        <?php foreach ($categories as $category): ?>
                            <option value="<?=e($category)?>"><?=e($category)?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <label>
                    <span>Estado *</span>
                    <select name="status">
                        <option value="paid">Pagado</option>
                        <option value="pending">Pendiente</option>
                    </select>
                </label>

                <label>
                    <span>Proveedor</span>
                    <input type="text" name="supplier" maxlength="190" placeholder="Nombre del proveedor">
                </label>

                <label>
                    <span>Importe *</span>
                    <input type="number" name="amount" min="0.01" step="0.01" required placeholder="0.00">
                </label>

                <label>
                    <span>Método</span>
                    <select name="payment_method">
                        <option value="cash">Efectivo</option>
                        <option value="transfer">Transferencia</option>
                        <option value="card">Tarjeta</option>
                        <option value="other">Otro</option>
                    </select>
                </label>

                <label>
                    <span>Orden relacionada</span>
                    <select name="order_id">
                        <option value="">Sin relación</option>
                        <?php foreach ($orders as $order): ?>
                            <option value="<?=e((string)$order['id'])?>"><?=e((string)$order['order_number'])?> · <?=e(cpe_money((float)$order['total']))?></option>
                        <?php endforeach; ?>
                    </select>
                </label>

                <label class="wide">
                    <span>Descripción *</span>
                    <input type="text" name="description" maxlength="500" required placeholder="Ej. Compra de vinil adhesivo">
                </label>

                <label>
                    <span>Referencia</span>
                    <input type="text" name="reference" maxlength="190" placeholder="Folio / transferencia">
                </label>

                <label>
                    <span>Comprobante / referencia</span>
                    <input type="text" name="receipt_reference" maxlength="500" placeholder="Folio, URL o ubicación">
                </label>

                <label class="wide">
                    <span>Notas</span>
                    <textarea name="notes" rows="3" placeholder="Información adicional"></textarea>
                </label>
            </div>

            <button class="eg-submit" type="submit">Registrar egreso</button>
        </form>
    </article>

    <article class="eg-card">
        <div class="eg-card-head eg-filter-head">
            <div>
                <span class="eg-eyebrow">HISTORIAL</span>
                <h3>Movimientos</h3>
            </div>
            <form method="get" class="eg-filter">
                <input type="date" name="from" value="<?=e($from)?>">
                <input type="date" name="to" value="<?=e($to)?>">
                <button type="submit">Filtrar</button>
            </form>
        </div>

        <?php if (!$rows): ?>
            <div class="eg-empty">No hay egresos en el periodo seleccionado.</div>
        <?php else: ?>
            <div class="eg-table-wrap">
                <table class="eg-table eg-table-v1">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Concepto</th>
                            <th>Categoría</th>
                            <th>Orden</th>
                            <th>Estado</th>
                            <th>Importe</th>
                            <th>Fiscal</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                    <?php foreach ($rows as $row): ?>
                        <tr>
                            <td data-label="Fecha"><?=e(date('d/m/Y', strtotime((string)$row['expense_date'])))?></td>
                            <td data-label="Concepto">
                                <strong><?=e((string)$row['description'])?></strong>
                                <?php if (!empty($row['supplier'])): ?><small><?=e((string)$row['supplier'])?></small><?php endif; ?>
                                <?php if (!empty($row['cfdi_uuid'])): ?>
                                    <small class="eg-uuid">UUID <?=e((string)$row['cfdi_uuid'])?></small>
                                <?php endif; ?>
                            </td>
                            <td data-label="Categoría"><?=e((string)$row['category'])?></td>
                            <td data-label="Orden"><?=e((string)($row['order_number'] ?? '—'))?></td>
                            <td data-label="Estado"><span class="eg-status <?=e((string)$row['status'])?>"><?=e((string)$row['status'])?></span></td>
                            <td data-label="Importe"><strong><?=e(cpe_money((float)$row['amount']))?></strong></td>
                            <td data-label="Fiscal">
                                <?php if (!empty($row['cfdi_document_id'])): ?>
                                    <a class="eg-cfdi-link" href="/admin/egreso_cfdi.php?id=<?=((int)$row['cfdi_document_id'])?>">🧾 XML</a>
                                <?php else: ?>
                                    <span class="eg-no-cfdi">Sin XML</span>
                                <?php endif; ?>
                            </td>
                            <td data-label="Acción">
                                <?php if (($row['status'] ?? '') !== 'cancelled'): ?>
                                    <form method="post" onsubmit="return confirm('¿Cancelar este egreso? El registro se conservará para auditoría.');">
                                        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="id" value="<?=e((string)$row['id'])?>">
                                        <button class="eg-cancel" type="submit">Cancelar</button>
                                    </form>
                                <?php endif; ?>
                            </td>
                        </tr>
                    <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
        <?php endif; ?>
    </article>
</section>

<?php if ($issues): ?>
<section class="eg-message error">
    El módulo cargó con observaciones técnicas.
    <details><summary>Ver detalle</summary><pre><?=e(implode("\n", array_unique($issues)))?></pre></details>
</section>
<?php endif; ?>

<?php endif; ?>
<?php require __DIR__ . '/../includes/footer.php'; ?>
