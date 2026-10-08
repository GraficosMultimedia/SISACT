<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

$title = 'Egresos';
$pdo = db();
$user = current_user();
$issues = [];
$message = null;
$error = null;

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

$installed = cpe_table_exists($pdo, 'cp_expenses');

if ($installed && $_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'Sesión inválida. Recarga la página.';
    } else {
        $action = trim((string)($_POST['action'] ?? ''));

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

if ($installed) {
    try {
        $st = $pdo->prepare(
            "SELECT e.*,
                    o.order_number
             FROM cp_expenses e
             LEFT JOIN cp_orders o ON o.id=e.order_id
             WHERE e.expense_date BETWEEN ? AND ?
             ORDER BY e.expense_date DESC,e.id DESC
             LIMIT 250"
        );
        $st->execute([$from, $to]);
        $rows = $st->fetchAll(PDO::FETCH_ASSOC);

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

$categories = [
    'Materiales',
    'Nómina',
    'Servicios',
    'Renta',
    'Publicidad',
    'Mantenimiento',
    'Transporte',
    'Impuestos',
    'Equipo',
    'Otros',
];

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/egresos.css?v=1.0.0">

<section class="eg-head">
    <div>
        <span class="eg-eyebrow">CONTROL DE CAJA</span>
        <h2>Egresos</h2>
        <p>Registra salidas reales y compromisos de pago sin modificar el módulo de pagos de clientes.</p>
    </div>
    <a class="eg-back" href="/admin/dashboard.php">← Dashboard Intelligence</a>
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

<section class="eg-stats">
    <article><span>Pagado en periodo</span><strong><?=e(cpe_money($totalPaid))?></strong><small>Impacta flujo neto</small></article>
    <article><span>Pendiente</span><strong><?=e(cpe_money($totalPending))?></strong><small>Compromisos registrados</small></article>
    <article><span>Movimientos</span><strong><?=number_format(count($rows))?></strong><small>Máximo 250 visibles</small></article>
</section>

<section class="eg-grid">
    <article class="eg-card">
        <div class="eg-card-head">
            <span class="eg-eyebrow">NUEVO MOVIMIENTO</span>
            <h3>Registrar egreso</h3>
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
                <table class="eg-table">
                    <thead>
                        <tr>
                            <th>Fecha</th>
                            <th>Concepto</th>
                            <th>Categoría</th>
                            <th>Orden</th>
                            <th>Estado</th>
                            <th>Importe</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($rows as $row): ?>
                            <tr>
                                <td><?=e(date('d/m/Y', strtotime((string)$row['expense_date'])))?></td>
                                <td>
                                    <strong><?=e((string)$row['description'])?></strong>
                                    <?php if (!empty($row['supplier'])): ?><small><?=e((string)$row['supplier'])?></small><?php endif; ?>
                                </td>
                                <td><?=e((string)$row['category'])?></td>
                                <td><?=e((string)($row['order_number'] ?? '—'))?></td>
                                <td><span class="eg-status <?=e((string)$row['status'])?>"><?=e((string)$row['status'])?></span></td>
                                <td><strong><?=e(cpe_money((float)$row['amount']))?></strong></td>
                                <td>
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
