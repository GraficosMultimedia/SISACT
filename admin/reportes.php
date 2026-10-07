<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

$title = 'Reportes';
$pdo = db();

function report_escape($value): string
{
    return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8');
}

function report_money2(float $value): string
{
    return '$' . number_format($value, 2, '.', ',');
}

function report_pct2(float $value): string
{
    return number_format($value, 1, '.', ',') . '%';
}

function report_status_label2(string $status, string $type): string
{
    $orders = [
        'pending' => 'Pendiente',
        'in_progress' => 'En proceso',
        'completed' => 'Completada',
        'delivered' => 'Entregada',
        'cancelled' => 'Cancelada',
    ];
    $quotes = [
        'draft' => 'Borrador',
        'sent' => 'Enviada',
        'approved' => 'Aprobada',
        'rejected' => 'Rechazada',
        'expired' => 'Vencida',
        'cancelled' => 'Cancelada',
    ];
    $map = $type === 'quote' ? $quotes : $orders;
    return $map[$status] ?? $status;
}

function report_date_valid2(string $value): bool
{
    if ($value === '') return false;
    $d = DateTimeImmutable::createFromFormat('!Y-m-d', $value);
    return $d instanceof DateTimeImmutable && $d->format('Y-m-d') === $value;
}

function report_scalar2(PDO $pdo, string $sql, array $params, array &$issues, float $default = 0.0): float
{
    try {
        $st = $pdo->prepare($sql);
        $st->execute($params);
        $value = $st->fetchColumn();
        return ($value === false || $value === null) ? $default : (float)$value;
    } catch (Throwable $e) {
        $issues[] = $e->getMessage();
        return $default;
    }
}

function report_rows2(PDO $pdo, string $sql, array $params, array &$issues): array
{
    try {
        $st = $pdo->prepare($sql);
        $st->execute($params);
        return $st->fetchAll(PDO::FETCH_ASSOC);
    } catch (Throwable $e) {
        $issues[] = $e->getMessage();
        return [];
    }
}

$today = new DateTimeImmutable('today');
$defaultFrom = $today->modify('first day of this month')->format('Y-m-d');
$from = trim((string)($_GET['from'] ?? $defaultFrom));
$to = trim((string)($_GET['to'] ?? $today->format('Y-m-d')));
if (!report_date_valid2($from)) $from = $defaultFrom;
if (!report_date_valid2($to)) $to = $today->format('Y-m-d');
if ($from > $to) [$from, $to] = [$to, $from];

$issues = [];

if ((string)($_GET['export'] ?? '') === 'csv') {
    $rows = report_rows2($pdo,
        'SELECT o.order_number,
                COALESCE(c.name, "Sin cliente") AS customer_name,
                o.order_date,o.due_date,o.status,o.total
         FROM cp_orders o
         LEFT JOIN cp_customers c ON c.id=o.customer_id
         WHERE o.order_date BETWEEN ? AND ?
         ORDER BY o.order_date DESC,o.id DESC',
        [$from, $to], $issues);

    header('Content-Type: text/csv; charset=UTF-8');
    header('Content-Disposition: attachment; filename="reporte_colibri_' . $from . '_' . $to . '.csv"');
    echo "\xEF\xBB\xBF";
    $out = fopen('php://output', 'wb');
    fputcsv($out, ['Orden','Cliente','Fecha','Fecha compromiso','Estado','Total'], ';');
    foreach ($rows as $row) {
        fputcsv($out, [
            $row['order_number'] ?? '',
            $row['customer_name'] ?? '',
            $row['order_date'] ?? '',
            $row['due_date'] ?? '',
            report_status_label2((string)($row['status'] ?? ''), 'order'),
            number_format((float)($row['total'] ?? 0), 2, '.', ''),
        ], ';');
    }
    fclose($out);
    exit;
}

$ordersTotal = report_scalar2($pdo,
    "SELECT COALESCE(SUM(o.total),0) FROM cp_orders o WHERE o.order_date BETWEEN ? AND ? AND o.status <> 'cancelled'",
    [$from,$to], $issues);
$ordersCount = (int)report_scalar2($pdo,
    "SELECT COUNT(*) FROM cp_orders o WHERE o.order_date BETWEEN ? AND ? AND o.status <> 'cancelled'",
    [$from,$to], $issues);
$cancelledOrders = (int)report_scalar2($pdo,
    "SELECT COUNT(*) FROM cp_orders o WHERE o.order_date BETWEEN ? AND ? AND o.status = 'cancelled'",
    [$from,$to], $issues);

$quotesCount = (int)report_scalar2($pdo,
    'SELECT COUNT(*) FROM cp_quotes WHERE issue_date BETWEEN ? AND ?', [$from,$to], $issues);
$approvedQuotesCount = (int)report_scalar2($pdo,
    "SELECT COUNT(*) FROM cp_quotes WHERE issue_date BETWEEN ? AND ? AND status='approved'",
    [$from,$to], $issues);
$approvedQuoteValue = report_scalar2($pdo,
    "SELECT COALESCE(SUM(COALESCE(t.total,0)),0)
     FROM cp_quotes q
     LEFT JOIN cp_quote_totals t ON t.quote_id=q.id
     WHERE q.issue_date BETWEEN ? AND ? AND q.status='approved'",
    [$from,$to], $issues);

$collected = report_scalar2($pdo,
    "SELECT COALESCE(SUM(p.amount),0) FROM cp_payments p WHERE p.payment_date BETWEEN ? AND ? AND p.status='confirmed'",
    [$from,$to], $issues);
$balanceOrdersPeriod = report_scalar2($pdo,
    "SELECT COALESCE(SUM(GREATEST(o.total - COALESCE((SELECT SUM(p2.amount) FROM cp_payments p2 WHERE p2.order_id=o.id AND p2.status='confirmed'),0),0)),0)
     FROM cp_orders o
     WHERE o.order_date BETWEEN ? AND ? AND o.status <> 'cancelled'",
    [$from,$to], $issues);
$invoiced = report_scalar2($pdo,
    "SELECT COALESCE(SUM(i.total),0) FROM cp_invoices i WHERE i.invoice_date BETWEEN ? AND ? AND i.status <> 'cancelled'",
    [$from,$to], $issues);
$invoiceCount = (int)report_scalar2($pdo,
    "SELECT COUNT(*) FROM cp_invoices WHERE invoice_date BETWEEN ? AND ? AND status <> 'cancelled'",
    [$from,$to], $issues);

$quoteConversion = $quotesCount > 0 ? ($approvedQuotesCount / $quotesCount) * 100 : 0;
$averageOrder = $ordersCount > 0 ? ($ordersTotal / $ordersCount) : 0;

$statusRows = report_rows2($pdo,
    'SELECT status,COUNT(*) AS count,COALESCE(SUM(total),0) AS total
     FROM cp_orders WHERE order_date BETWEEN ? AND ? GROUP BY status ORDER BY count DESC',
    [$from,$to], $issues);

$quoteStatusRows = report_rows2($pdo,
    'SELECT q.status,COUNT(*) AS count,COALESCE(SUM(COALESCE(t.total,0)),0) AS total
     FROM cp_quotes q LEFT JOIN cp_quote_totals t ON t.quote_id=q.id
     WHERE q.issue_date BETWEEN ? AND ? GROUP BY q.status ORDER BY count DESC',
    [$from,$to], $issues);

$topCustomers = report_rows2($pdo,
    "SELECT COALESCE(c.name,'Sin cliente') AS customer_name,
            COUNT(o.id) AS orders_count,
            COALESCE(SUM(CASE WHEN o.status <> 'cancelled' THEN o.total ELSE 0 END),0) AS sales_total,
            COALESCE(SUM(CASE WHEN o.status NOT IN ('cancelled','delivered') THEN o.total ELSE 0 END),0) AS open_total
     FROM cp_orders o LEFT JOIN cp_customers c ON c.id=o.customer_id
     WHERE o.order_date BETWEEN ? AND ?
     GROUP BY o.customer_id,c.name
     ORDER BY sales_total DESC,orders_count DESC LIMIT 8",
    [$from,$to], $issues);

$topProducts = report_rows2($pdo,
    "SELECT oi.description,SUM(oi.quantity) AS quantity,SUM(oi.subtotal) AS sales_total
     FROM cp_order_items oi INNER JOIN cp_orders o ON o.id=oi.order_id
     WHERE o.order_date BETWEEN ? AND ? AND o.status <> 'cancelled'
     GROUP BY oi.description ORDER BY sales_total DESC,quantity DESC LIMIT 8",
    [$from,$to], $issues);

$monthly = report_rows2($pdo,
    "SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS ym,
            DATE_FORMAT(o.order_date,'%b %Y') AS label,
            COALESCE(SUM(CASE WHEN o.status <> 'cancelled' THEN o.total ELSE 0 END),0) AS sales_total,
            SUM(CASE WHEN o.status <> 'cancelled' THEN 1 ELSE 0 END) AS order_count
     FROM cp_orders o
     WHERE o.order_date BETWEEN ? AND ?
     GROUP BY DATE_FORMAT(o.order_date,'%Y-%m') ORDER BY ym ASC",
    [$from,$to], $issues);

$overdueOrders = report_rows2($pdo,
    "SELECT o.id,o.order_number,o.due_date,o.status,o.total,
            COALESCE(c.name,'Sin cliente') AS customer_name,
            DATEDIFF(CURDATE(),o.due_date) AS days_late
     FROM cp_orders o LEFT JOIN cp_customers c ON c.id=o.customer_id
     WHERE o.due_date IS NOT NULL AND o.due_date < CURDATE()
       AND o.status NOT IN ('delivered','cancelled')
     ORDER BY o.due_date ASC,o.id ASC LIMIT 8", [], $issues);

$activePromotions = (int)report_scalar2($pdo,
    "SELECT COUNT(*) FROM cp_promotions WHERE status='active' AND start_date <= CURDATE() AND (end_date IS NULL OR end_date >= CURDATE())",
    [], $issues);

$maxMonthly = 0.0;
foreach ($monthly as $row) $maxMonthly = max($maxMonthly, (float)$row['sales_total']);
$periodLabel = date('d/m/Y', strtotime($from)) . ' al ' . date('d/m/Y', strtotime($to));

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/reportes.css?v=20260917-2">

<div class="report-toolbar no-print">
  <div><span class="eyebrow">FASE 12 · REPORTES Y ADMINISTRACIÓN</span><h2>Reportes</h2><p class="muted">Resumen comercial, operativo y financiero de Colibrí Print.</p></div>
  <div class="toolbar-actions">
    <a class="btn btn-secondary" href="/admin/reportes.php?from=<?=report_escape($from)?>&to=<?=report_escape($to)?>&export=csv">⬇️ Exportar CSV</a>
    <button class="btn btn-secondary" type="button" onclick="window.print()">🖨️ Imprimir</button>
  </div>
</div>

<?php if ($issues): ?>
<section class="card no-print" style="margin-bottom:16px;border-color:#8b4d4d">
  <strong>El reporte cargó con observaciones.</strong>
  <p class="muted" style="margin:6px 0 0">Se protegieron las consultas para evitar que un problema aislado de estructura vuelva a producir HTTP 500.</p>
  <details style="margin-top:8px"><summary>Ver detalle técnico</summary><pre style="white-space:pre-wrap;font-size:12px;overflow:auto"><?=report_escape(implode("\n", array_unique($issues)))?></pre></details>
</section>
<?php endif; ?>

<section class="card report-filter-card no-print">
  <form method="get" class="report-filter-form">
    <div class="field"><label>Desde</label><input type="date" name="from" value="<?=report_escape($from)?>"></div>
    <div class="field"><label>Hasta</label><input type="date" name="to" value="<?=report_escape($to)?>"></div>
    <div class="filter-actions"><button class="btn btn-primary" type="submit">Actualizar reporte</button><a class="btn btn-secondary" href="/admin/reportes.php">Este mes</a></div>
  </form>
  <div class="report-period">Periodo: <strong><?=report_escape($periodLabel)?></strong></div>
</section>

<section class="report-stats">
  <article class="stat-card"><span class="stat-label">Ventas por órdenes</span><strong><?=report_escape(report_money2($ordersTotal))?></strong><small><?=report_escape((string)$ordersCount)?> órdenes no canceladas</small></article>
  <article class="stat-card"><span class="stat-label">Cobrado en periodo</span><strong><?=report_escape(report_money2($collected))?></strong><small>Pagos confirmados</small></article>
  <article class="stat-card"><span class="stat-label">Saldo de órdenes</span><strong><?=report_escape(report_money2($balanceOrdersPeriod))?></strong><small>Saldo actual de órdenes del periodo</small></article>
  <article class="stat-card"><span class="stat-label">Facturado</span><strong><?=report_escape(report_money2($invoiced))?></strong><small><?=report_escape((string)$invoiceCount)?> documentos válidos</small></article>
  <article class="stat-card"><span class="stat-label">Cotización → aprobada</span><strong><?=report_escape(report_pct2($quoteConversion))?></strong><small><?=report_escape((string)$approvedQuotesCount)?> de <?=report_escape((string)$quotesCount)?> cotizaciones</small></article>
  <article class="stat-card"><span class="stat-label">Ticket promedio</span><strong><?=report_escape(report_money2($averageOrder))?></strong><small>Por orden del periodo</small></article>
</section>

<section class="report-grid two-columns">
  <article class="card report-card"><div class="section-heading"><div><span class="eyebrow">TENDENCIA</span><h3>Ventas por mes</h3></div><span class="count-pill"><?=count($monthly)?></span></div>
    <?php if (!$monthly): ?><p class="empty">No hay ventas para el periodo seleccionado.</p><?php else: ?><div class="bar-chart">
      <?php foreach ($monthly as $row): $value=(float)$row['sales_total']; $width=$maxMonthly>0?max(2,($value/$maxMonthly)*100):2; ?><div class="bar-row"><div class="bar-label"><?=report_escape($row['label'])?></div><div class="bar-track"><div class="bar-fill" style="width:<?=report_escape(number_format($width,2,'.',''))?>%"></div></div><div class="bar-value"><?=report_escape(report_money2($value))?></div></div><?php endforeach; ?>
    </div><?php endif; ?>
  </article>
  <article class="card report-card"><div class="section-heading"><div><span class="eyebrow">OPERACIÓN</span><h3>Estado de órdenes</h3></div><span class="count-pill"><?=report_escape((string)$ordersCount)?></span></div>
    <?php if (!$statusRows): ?><p class="empty">No hay órdenes en el periodo.</p><?php else: ?><div class="status-list"><?php foreach($statusRows as $row): ?><div class="status-row"><div><strong><?=report_escape(report_status_label2((string)$row['status'],'order'))?></strong><small><?=report_escape((string)$row['count'])?> orden(es)</small></div><strong><?=report_escape(report_money2((float)$row['total']))?></strong></div><?php endforeach; ?></div><?php endif; ?>
  </article>
</section>

<section class="report-grid two-columns">
  <article class="card report-card"><div class="section-heading"><div><span class="eyebrow">CLIENTES</span><h3>Principales clientes</h3></div></div>
    <?php if (!$topCustomers): ?><p class="empty">No hay datos de clientes.</p><?php else: ?><div class="report-table-wrap"><table class="report-table"><thead><tr><th>Cliente</th><th>Órdenes</th><th>Ventas</th><th>Abierto</th></tr></thead><tbody><?php foreach($topCustomers as $row): ?><tr><td><?=report_escape($row['customer_name'])?></td><td><?=report_escape($row['orders_count'])?></td><td><?=report_escape(report_money2((float)$row['sales_total']))?></td><td><?=report_escape(report_money2((float)$row['open_total']))?></td></tr><?php endforeach; ?></tbody></table></div><?php endif; ?>
  </article>
  <article class="card report-card"><div class="section-heading"><div><span class="eyebrow">PRODUCTOS</span><h3>Más vendidos por importe</h3></div></div>
    <?php if (!$topProducts): ?><p class="empty">No hay conceptos vendidos en el periodo.</p><?php else: ?><div class="report-table-wrap"><table class="report-table"><thead><tr><th>Concepto</th><th>Cantidad</th><th>Importe</th></tr></thead><tbody><?php foreach($topProducts as $row): ?><tr><td><?=report_escape($row['description'])?></td><td><?=report_escape(rtrim(rtrim(number_format((float)$row['quantity'],3,'.',''),'0'),'.'))?></td><td><?=report_escape(report_money2((float)$row['sales_total']))?></td></tr><?php endforeach; ?></tbody></table></div><?php endif; ?>
  </article>
</section>

<section class="report-grid two-columns">
  <article class="card report-card"><div class="section-heading"><div><span class="eyebrow">COTIZACIONES</span><h3>Estado de cotizaciones</h3></div></div>
    <?php if (!$quoteStatusRows): ?><p class="empty">No hay cotizaciones en el periodo.</p><?php else: ?><div class="status-list"><?php foreach($quoteStatusRows as $row): ?><div class="status-row"><div><strong><?=report_escape(report_status_label2((string)$row['status'],'quote'))?></strong><small><?=report_escape((string)$row['count'])?> cotización(es)</small></div><strong><?=report_escape(report_money2((float)$row['total']))?></strong></div><?php endforeach; ?></div><?php endif; ?>
  </article>
  <article class="card report-card"><div class="section-heading"><div><span class="eyebrow">ATENCIÓN</span><h3>Órdenes vencidas</h3></div><span class="count-pill"><?=report_escape((string)count($overdueOrders))?></span></div>
    <?php if (!$overdueOrders): ?><p class="empty success-text">No hay órdenes vencidas abiertas. ✅</p><?php else: ?><div class="overdue-list"><?php foreach($overdueOrders as $row): ?><a class="overdue-item" href="/admin/orden.php?id=<?=((int)$row['id'])?>"><div><strong><?=report_escape($row['order_number'])?></strong><small><?=report_escape($row['customer_name'])?> · vencida <?=report_escape($row['days_late'])?> día(s)</small></div><span><?=report_escape(report_money2((float)$row['total']))?></span></a><?php endforeach; ?></div><?php endif; ?>
  </article>
</section>

<section class="report-admin-grid">
  <article class="card report-card compact-card"><span class="eyebrow">ADMINISTRACIÓN</span><h3>Indicadores de control</h3><div class="admin-checks"><div><strong><?=report_escape((string)$cancelledOrders)?></strong><span>Órdenes canceladas en periodo</span></div><div><strong><?=report_escape((string)$activePromotions)?></strong><span>Promociones activas hoy</span></div><div><strong><?=report_escape(report_money2($approvedQuoteValue))?></strong><span>Valor de cotizaciones aprobadas</span></div></div></article>
  <article class="card report-card compact-card print-note"><span class="eyebrow">DEFINICIONES</span><h3>Cómo leer este reporte</h3><p>Ventas usa la fecha de la orden y excluye órdenes canceladas. Cobrado usa la fecha del pago y solo considera pagos confirmados. El saldo usa el total de cada orden menos sus pagos confirmados registrados.</p></article>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
