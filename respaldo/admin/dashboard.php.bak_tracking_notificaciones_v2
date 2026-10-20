<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

$title = 'Dashboard Intelligence';
$pdo = db();
$user = current_user();

function cpdi_money(float $value): string
{
    return '$' . number_format($value, 2, '.', ',');
}

function cpdi_pct(float $value): string
{
    return number_format($value, 1, '.', ',') . '%';
}

function cpdi_date_valid(string $value): bool
{
    if ($value === '') return false;
    $d = DateTimeImmutable::createFromFormat('!Y-m-d', $value);
    return $d instanceof DateTimeImmutable && $d->format('Y-m-d') === $value;
}

function cpdi_table_exists(PDO $pdo, string $table): bool
{
    try {
        $st = $pdo->prepare(
            'SELECT COUNT(*) FROM information_schema.tables
             WHERE table_schema = DATABASE() AND table_name = ?'
        );
        $st->execute([$table]);
        return (int)$st->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function cpdi_scalar(PDO $pdo, string $sql, array $params, array &$issues, float $default = 0.0): float
{
    try {
        $st = $pdo->prepare($sql);
        $st->execute($params);
        $v = $st->fetchColumn();
        return ($v === false || $v === null) ? $default : (float)$v;
    } catch (Throwable $e) {
        $issues[] = $e->getMessage();
        return $default;
    }
}

function cpdi_rows(PDO $pdo, string $sql, array $params, array &$issues): array
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

function cpdi_delta(float $current, float $previous): ?float
{
    if (abs($previous) < 0.00001) {
        return abs($current) < 0.00001 ? 0.0 : null;
    }
    return (($current - $previous) / abs($previous)) * 100;
}

function cpdi_delta_class(?float $delta): string
{
    if ($delta === null || abs($delta) < 0.05) return 'neutral';
    return $delta > 0 ? 'up' : 'down';
}

function cpdi_delta_text(?float $delta): string
{
    if ($delta === null) return 'Nuevo';
    if (abs($delta) < 0.05) return 'Sin cambio';
    return ($delta > 0 ? '+' : '') . number_format($delta, 1, '.', ',') . '%';
}

function cpdi_status_label(string $stage): string
{
    $map = [
        'pending' => 'Pendiente',
        'design' => 'Diseño',
        'prepress' => 'Preprensa',
        'printing' => 'Impresión',
        'finishing' => 'Acabado',
        'quality' => 'Calidad',
        'ready' => 'Listo',
        'delivered' => 'Entregado',
    ];
    return $map[$stage] ?? ucfirst(str_replace('_', ' ', $stage));
}

$issues = [];
$today = new DateTimeImmutable('today');
$period = trim((string)($_GET['period'] ?? 'month'));

switch ($period) {
    case 'today':
        $fromDate = $today;
        $toDate = $today;
        break;

    case '7d':
        $fromDate = $today->modify('-6 days');
        $toDate = $today;
        break;

    case 'prev_month':
        $fromDate = $today->modify('first day of last month');
        $toDate = $today->modify('last day of last month');
        break;

    case 'year':
        $fromDate = $today->modify('first day of January');
        $toDate = $today;
        break;

    case 'custom':
        $fromRaw = trim((string)($_GET['from'] ?? ''));
        $toRaw = trim((string)($_GET['to'] ?? ''));
        if (cpdi_date_valid($fromRaw) && cpdi_date_valid($toRaw)) {
            $fromDate = new DateTimeImmutable($fromRaw);
            $toDate = new DateTimeImmutable($toRaw);
            if ($fromDate > $toDate) {
                [$fromDate, $toDate] = [$toDate, $fromDate];
            }
        } else {
            $period = 'month';
            $fromDate = $today->modify('first day of this month');
            $toDate = $today;
        }
        break;

    case 'month':
    default:
        $period = 'month';
        $fromDate = $today->modify('first day of this month');
        $toDate = $today;
        break;
}

$from = $fromDate->format('Y-m-d');
$to = $toDate->format('Y-m-d');

$days = (int)$fromDate->diff($toDate)->format('%a') + 1;
$prevToDate = $fromDate->modify('-1 day');
$prevFromDate = $prevToDate->modify('-' . max(0, $days - 1) . ' days');
$prevFrom = $prevFromDate->format('Y-m-d');
$prevTo = $prevToDate->format('Y-m-d');

$expensesEnabled = cpdi_table_exists($pdo, 'cp_expenses');

/* KPIs */
$sales = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(total),0)
     FROM cp_orders
     WHERE order_date BETWEEN ? AND ? AND status <> 'cancelled'",
    [$from, $to],
    $issues
);

$orderCount = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_orders
     WHERE order_date BETWEEN ? AND ? AND status <> 'cancelled'",
    [$from, $to],
    $issues
);

$collected = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(amount),0)
     FROM cp_payments
     WHERE payment_date BETWEEN ? AND ? AND status='confirmed'",
    [$from, $to],
    $issues
);

$expenses = $expensesEnabled
    ? cpdi_scalar(
        $pdo,
        "SELECT COALESCE(SUM(amount),0)
         FROM cp_expenses
         WHERE expense_date BETWEEN ? AND ? AND status='paid'",
        [$from, $to],
        $issues
    )
    : 0.0;

$netCashFlow = $collected - $expenses;

$receivable = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(
        GREATEST(
            o.total - COALESCE(
                (SELECT SUM(p.amount)
                 FROM cp_payments p
                 WHERE p.order_id=o.id AND p.status='confirmed'),
                0
            ),
            0
        )
     ),0)
     FROM cp_orders o
     WHERE o.order_date BETWEEN ? AND ? AND o.status <> 'cancelled'",
    [$from, $to],
    $issues
);

$averageTicket = $orderCount > 0 ? $sales / $orderCount : 0.0;

/* Periodo previo */
$prevSales = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(total),0)
     FROM cp_orders
     WHERE order_date BETWEEN ? AND ? AND status <> 'cancelled'",
    [$prevFrom, $prevTo],
    $issues
);

$prevCollected = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(amount),0)
     FROM cp_payments
     WHERE payment_date BETWEEN ? AND ? AND status='confirmed'",
    [$prevFrom, $prevTo],
    $issues
);

$prevExpenses = $expensesEnabled
    ? cpdi_scalar(
        $pdo,
        "SELECT COALESCE(SUM(amount),0)
         FROM cp_expenses
         WHERE expense_date BETWEEN ? AND ? AND status='paid'",
        [$prevFrom, $prevTo],
        $issues
    )
    : 0.0;

$salesDelta = cpdi_delta($sales, $prevSales);
$collectedDelta = cpdi_delta($collected, $prevCollected);
$expenseDelta = $expensesEnabled ? cpdi_delta($expenses, $prevExpenses) : 0.0;

/* Alertas */
$pendingPrintRequests = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_web_quote_requests
     WHERE converted_quote_id IS NULL
       AND status NOT IN ('closed','spam')",
    [],
    $issues
);

$pendingProductionOrders = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_orders o
     LEFT JOIN cp_order_status s ON s.order_id=o.id
     WHERE o.status NOT IN ('cancelled','delivered')
       AND COALESCE(s.stage,'pending')='pending'",
    [],
    $issues
);

$overdueOrders = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_orders
     WHERE due_date IS NOT NULL
       AND due_date < CURDATE()
       AND status NOT IN ('delivered','cancelled')",
    [],
    $issues
);

$overdueBalance = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(
        GREATEST(
            o.total - COALESCE(
                (SELECT SUM(p.amount)
                 FROM cp_payments p
                 WHERE p.order_id=o.id AND p.status='confirmed'),
                0
            ),
            0
        )
     ),0)
     FROM cp_orders o
     WHERE o.due_date IS NOT NULL
       AND o.due_date < CURDATE()
       AND o.status NOT IN ('delivered','cancelled')",
    [],
    $issues
);

$quoteFollowups = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_quotes
     WHERE status='sent'
       AND issue_date <= DATE_SUB(CURDATE(), INTERVAL 3 DAY)",
    [],
    $issues
);

/* Pulso */
$salesTrendState = ($salesDelta === null || $salesDelta >= -5) ? 'good' : 'warn';
$collectionRatio = $sales > 0 ? ($collected / $sales) * 100 : ($collected > 0 ? 100.0 : 0.0);
$collectionState = $collectionRatio >= 75 ? 'good' : ($collectionRatio >= 50 ? 'warn' : 'danger');
$productionState = $pendingProductionOrders <= 3 ? 'good' : ($pendingProductionOrders <= 8 ? 'warn' : 'danger');
$portfolioState = $overdueOrders === 0 ? 'good' : ($overdueOrders <= 3 ? 'warn' : 'danger');

/* Embudo */
$webRequests = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_web_quote_requests
     WHERE DATE(created_at) BETWEEN ? AND ?
       AND status <> 'spam'",
    [$from, $to],
    $issues
);

$quotes = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*) FROM cp_quotes WHERE issue_date BETWEEN ? AND ?",
    [$from, $to],
    $issues
);

$approvedQuotes = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*) FROM cp_quotes
     WHERE issue_date BETWEEN ? AND ? AND status='approved'",
    [$from, $to],
    $issues
);

$paidOrders = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_orders o
     WHERE o.order_date BETWEEN ? AND ?
       AND o.status <> 'cancelled'
       AND COALESCE(
            (SELECT SUM(p.amount)
             FROM cp_payments p
             WHERE p.order_id=o.id AND p.status='confirmed'),
            0
       ) >= o.total",
    [$from, $to],
    $issues
);

$deliveredOrders = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*)
     FROM cp_orders
     WHERE order_date BETWEEN ? AND ? AND status='delivered'",
    [$from, $to],
    $issues
);

$funnel = [
    ['label' => 'Solicitudes', 'value' => $webRequests],
    ['label' => 'Cotizaciones', 'value' => $quotes],
    ['label' => 'Aprobadas', 'value' => $approvedQuotes],
    ['label' => 'Órdenes', 'value' => $orderCount],
    ['label' => 'Pagadas', 'value' => $paidOrders],
    ['label' => 'Entregadas', 'value' => $deliveredOrders],
];
$funnelMax = max(1, ...array_map(static fn($row) => (int)$row['value'], $funnel));

/* Producción */
$productionRows = cpdi_rows(
    $pdo,
    "SELECT COALESCE(s.stage,'pending') AS stage, COUNT(*) AS total
     FROM cp_orders o
     LEFT JOIN cp_order_status s ON s.order_id=o.id
     WHERE o.status NOT IN ('cancelled','delivered')
     GROUP BY COALESCE(s.stage,'pending')
     ORDER BY total DESC",
    [],
    $issues
);
$productionMax = 1;
foreach ($productionRows as $row) {
    $productionMax = max($productionMax, (int)$row['total']);
}

/* Rankings */
$topCustomers = cpdi_rows(
    $pdo,
    "SELECT COALESCE(c.name,'Sin cliente') AS customer_name,
            COUNT(o.id) AS orders_count,
            COALESCE(SUM(o.total),0) AS sales_total
     FROM cp_orders o
     LEFT JOIN cp_customers c ON c.id=o.customer_id
     WHERE o.order_date BETWEEN ? AND ?
       AND o.status <> 'cancelled'
     GROUP BY o.customer_id,c.name
     ORDER BY sales_total DESC,orders_count DESC
     LIMIT 5",
    [$from, $to],
    $issues
);

$topProducts = cpdi_rows(
    $pdo,
    "SELECT oi.description,
            SUM(oi.quantity) AS quantity,
            SUM(oi.subtotal) AS sales_total
     FROM cp_order_items oi
     INNER JOIN cp_orders o ON o.id=oi.order_id
     WHERE o.order_date BETWEEN ? AND ?
       AND o.status <> 'cancelled'
     GROUP BY oi.description
     ORDER BY sales_total DESC,quantity DESC
     LIMIT 5",
    [$from, $to],
    $issues
);

/* Qué cambió desde ayer */
$todaySales = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(total),0) FROM cp_orders
     WHERE order_date=CURDATE() AND status <> 'cancelled'",
    [],
    $issues
);
$yesterdaySales = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(total),0) FROM cp_orders
     WHERE order_date=DATE_SUB(CURDATE(),INTERVAL 1 DAY) AND status <> 'cancelled'",
    [],
    $issues
);
$todayCollected = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(amount),0) FROM cp_payments
     WHERE payment_date=CURDATE() AND status='confirmed'",
    [],
    $issues
);
$todayQuotes = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*) FROM cp_quotes WHERE issue_date=CURDATE()",
    [],
    $issues
);
$todayCustomers = (int)cpdi_scalar(
    $pdo,
    "SELECT COUNT(*) FROM cp_customers WHERE DATE(created_at)=CURDATE()",
    [],
    $issues
);

/* Radar de caja 7 días */
$radarEnd = $today->modify('+7 days')->format('Y-m-d');
$expectedReceivable7 = cpdi_scalar(
    $pdo,
    "SELECT COALESCE(SUM(
        GREATEST(
            o.total - COALESCE(
                (SELECT SUM(p.amount)
                 FROM cp_payments p
                 WHERE p.order_id=o.id AND p.status='confirmed'),
                0
            ),
            0
        )
     ),0)
     FROM cp_orders o
     WHERE o.status <> 'cancelled'
       AND o.due_date BETWEEN CURDATE() AND ?",
    [$radarEnd],
    $issues
);

$plannedExpenses7 = $expensesEnabled
    ? cpdi_scalar(
        $pdo,
        "SELECT COALESCE(SUM(amount),0)
         FROM cp_expenses
         WHERE status='pending'
           AND COALESCE(due_date,expense_date) BETWEEN CURDATE() AND ?",
        [$radarEnd],
        $issues
    )
    : 0.0;

$projected7 = $expectedReceivable7 - $plannedExpenses7;

/* Serie temporal */
$granularity = $days > 92 ? 'month' : 'day';
if ($granularity === 'month') {
    $salesSeries = cpdi_rows(
        $pdo,
        "SELECT DATE_FORMAT(order_date,'%Y-%m') AS bucket,
                COALESCE(SUM(total),0) AS amount
         FROM cp_orders
         WHERE order_date BETWEEN ? AND ? AND status <> 'cancelled'
         GROUP BY DATE_FORMAT(order_date,'%Y-%m')
         ORDER BY bucket",
        [$from, $to],
        $issues
    );
    $incomeSeries = cpdi_rows(
        $pdo,
        "SELECT DATE_FORMAT(payment_date,'%Y-%m') AS bucket,
                COALESCE(SUM(amount),0) AS amount
         FROM cp_payments
         WHERE payment_date BETWEEN ? AND ? AND status='confirmed'
         GROUP BY DATE_FORMAT(payment_date,'%Y-%m')
         ORDER BY bucket",
        [$from, $to],
        $issues
    );
    $expenseSeries = $expensesEnabled ? cpdi_rows(
        $pdo,
        "SELECT DATE_FORMAT(expense_date,'%Y-%m') AS bucket,
                COALESCE(SUM(amount),0) AS amount
         FROM cp_expenses
         WHERE expense_date BETWEEN ? AND ? AND status='paid'
         GROUP BY DATE_FORMAT(expense_date,'%Y-%m')
         ORDER BY bucket",
        [$from, $to],
        $issues
    ) : [];

    $cursor = $fromDate->modify('first day of this month');
    $last = $toDate->modify('first day of this month');
    $formatLabel = static fn(DateTimeImmutable $d): string => $d->format('m/Y');
    $keyFormat = 'Y-m';
    $step = '+1 month';
} else {
    $salesSeries = cpdi_rows(
        $pdo,
        "SELECT order_date AS bucket, COALESCE(SUM(total),0) AS amount
         FROM cp_orders
         WHERE order_date BETWEEN ? AND ? AND status <> 'cancelled'
         GROUP BY order_date ORDER BY order_date",
        [$from, $to],
        $issues
    );
    $incomeSeries = cpdi_rows(
        $pdo,
        "SELECT payment_date AS bucket, COALESCE(SUM(amount),0) AS amount
         FROM cp_payments
         WHERE payment_date BETWEEN ? AND ? AND status='confirmed'
         GROUP BY payment_date ORDER BY payment_date",
        [$from, $to],
        $issues
    );
    $expenseSeries = $expensesEnabled ? cpdi_rows(
        $pdo,
        "SELECT expense_date AS bucket, COALESCE(SUM(amount),0) AS amount
         FROM cp_expenses
         WHERE expense_date BETWEEN ? AND ? AND status='paid'
         GROUP BY expense_date ORDER BY expense_date",
        [$from, $to],
        $issues
    ) : [];

    $cursor = $fromDate;
    $last = $toDate;
    $formatLabel = static fn(DateTimeImmutable $d): string => $d->format('d/m');
    $keyFormat = 'Y-m-d';
    $step = '+1 day';
}

$seriesMap = [
    'sales' => [],
    'income' => [],
    'expense' => [],
];
foreach ($salesSeries as $row) $seriesMap['sales'][(string)$row['bucket']] = (float)$row['amount'];
foreach ($incomeSeries as $row) $seriesMap['income'][(string)$row['bucket']] = (float)$row['amount'];
foreach ($expenseSeries as $row) $seriesMap['expense'][(string)$row['bucket']] = (float)$row['amount'];

$chartData = [];
$guard = 0;
while ($cursor <= $last && $guard < 370) {
    $key = $cursor->format($keyFormat);
    $income = $seriesMap['income'][$key] ?? 0.0;
    $expense = $seriesMap['expense'][$key] ?? 0.0;
    $chartData[] = [
        'label' => $formatLabel($cursor),
        'sales' => $seriesMap['sales'][$key] ?? 0.0,
        'income' => $income,
        'expense' => $expense,
        'net' => $income - $expense,
    ];
    $cursor = $cursor->modify($step);
    $guard++;
}

$periodLabels = [
    'today' => 'Hoy',
    '7d' => 'Últimos 7 días',
    'month' => 'Este mes',
    'prev_month' => 'Mes anterior',
    'year' => 'Este año',
    'custom' => date('d/m/Y', strtotime($from)) . ' – ' . date('d/m/Y', strtotime($to)),
];
$periodLabel = $periodLabels[$period] ?? $periodLabels['month'];

$firstName = trim((string)($user['name'] ?? ''));
if ($firstName !== '') {
    $firstName = preg_split('/\s+/', $firstName)[0] ?? $firstName;
}

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/dashboard-intelligence.css?v=1.0.0">

<section class="di-hero">
    <div>
        <span class="di-eyebrow">COLIBRÍ INTELLIGENCE · V1</span>
        <h2>Hola<?= $firstName !== '' ? ', ' . e($firstName) : '' ?>.</h2>
        <p>Ventas, caja, cobranza y operación en una sola pantalla para tomar decisiones más rápido.</p>
    </div>

    <div class="di-period-wrap">
        <div class="di-quick-periods" aria-label="Periodos rápidos">
            <a class="<?= $period === 'today' ? 'active' : '' ?>" href="?period=today">Hoy</a>
            <a class="<?= $period === '7d' ? 'active' : '' ?>" href="?period=7d">7 días</a>
            <a class="<?= $period === 'month' ? 'active' : '' ?>" href="?period=month">Este mes</a>
            <a class="<?= $period === 'prev_month' ? 'active' : '' ?>" href="?period=prev_month">Anterior</a>
            <a class="<?= $period === 'year' ? 'active' : '' ?>" href="?period=year">Año</a>
        </div>

        <form method="get" class="di-custom-period">
            <input type="hidden" name="period" value="custom">
            <label>
                <span>Desde</span>
                <input type="date" name="from" value="<?=e($from)?>">
            </label>
            <label>
                <span>Hasta</span>
                <input type="date" name="to" value="<?=e($to)?>">
            </label>
            <button type="submit">Aplicar</button>
        </form>
        <small>Periodo activo: <strong><?=e($periodLabel)?></strong></small>
    </div>
</section>

<?php if ($issues): ?>
<section class="di-system-note">
    <strong>Dashboard cargado con protección de consultas.</strong>
    <span>Alguna métrica secundaria no pudo consultarse. El resto del panel continúa disponible.</span>
    <details>
        <summary>Detalle técnico</summary>
        <pre><?=e(implode("\n", array_unique($issues)))?></pre>
    </details>
</section>
<?php endif; ?>

<section class="di-kpis">
    <article class="di-kpi">
        <div class="di-kpi-head"><span>Ventas</span><i class="cyan">↗</i></div>
        <strong><?=e(cpdi_money($sales))?></strong>
        <div class="di-kpi-foot">
            <span><?=number_format($orderCount)?> órdenes</span>
            <b class="<?=e(cpdi_delta_class($salesDelta))?>"><?=e(cpdi_delta_text($salesDelta))?></b>
        </div>
    </article>

    <article class="di-kpi">
        <div class="di-kpi-head"><span>Ingresos cobrados</span><i class="green">$</i></div>
        <strong><?=e(cpdi_money($collected))?></strong>
        <div class="di-kpi-foot">
            <span>Pagos confirmados</span>
            <b class="<?=e(cpdi_delta_class($collectedDelta))?>"><?=e(cpdi_delta_text($collectedDelta))?></b>
        </div>
    </article>

    <article class="di-kpi">
        <div class="di-kpi-head"><span>Egresos</span><i class="pink">↓</i></div>
        <strong><?=e(cpdi_money($expenses))?></strong>
        <div class="di-kpi-foot">
            <span><?= $expensesEnabled ? 'Egresos pagados' : 'Módulo no instalado' ?></span>
            <?php if ($expensesEnabled): ?>
                <b class="<?=e(cpdi_delta_class($expenseDelta !== null ? -$expenseDelta : null))?>"><?=e(cpdi_delta_text($expenseDelta))?></b>
            <?php else: ?>
                <a href="/admin/egresos.php">Activar</a>
            <?php endif; ?>
        </div>
    </article>

    <article class="di-kpi">
        <div class="di-kpi-head"><span>Flujo neto</span><i class="<?= $netCashFlow >= 0 ? 'green' : 'pink' ?>">≈</i></div>
        <strong class="<?= $netCashFlow < 0 ? 'negative-value' : '' ?>"><?=e(cpdi_money($netCashFlow))?></strong>
        <div class="di-kpi-foot"><span>Ingresos − egresos</span><b class="neutral">Caja</b></div>
    </article>

    <article class="di-kpi">
        <div class="di-kpi-head"><span>Por cobrar</span><i class="yellow">◷</i></div>
        <strong><?=e(cpdi_money($receivable))?></strong>
        <div class="di-kpi-foot"><span>Órdenes del periodo</span><b class="neutral">Saldo</b></div>
    </article>

    <article class="di-kpi">
        <div class="di-kpi-head"><span>Ticket promedio</span><i class="blue">◇</i></div>
        <strong><?=e(cpdi_money($averageTicket))?></strong>
        <div class="di-kpi-foot"><span>Por orden</span><b class="neutral"><?=number_format($orderCount)?> ventas</b></div>
    </article>
</section>

<section class="di-grid di-grid-main">
    <article class="di-card di-chart-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">MOVIMIENTO FINANCIERO</span>
                <h3>Ventas, ingresos y egresos</h3>
                <p>El flujo neto usa dinero cobrado menos egresos pagados; no representa utilidad contable.</p>
            </div>
            <div class="di-chart-legend">
                <span><i class="sales"></i>Ventas</span>
                <span><i class="income"></i>Ingresos</span>
                <?php if ($expensesEnabled): ?><span><i class="expense"></i>Egresos</span><?php endif; ?>
            </div>
        </div>
        <div id="di-cash-chart" class="di-chart" aria-label="Gráfica de ventas, ingresos y egresos"></div>
        <script id="di-chart-data" type="application/json"><?=json_encode([
            'expensesEnabled' => $expensesEnabled,
            'rows' => $chartData
        ], JSON_UNESCAPED_UNICODE | JSON_HEX_TAG | JSON_HEX_AMP | JSON_HEX_APOS | JSON_HEX_QUOT)?></script>
    </article>

    <article class="di-card di-pulse-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">PULSO DEL NEGOCIO</span>
                <h3>Estado ejecutivo</h3>
            </div>
        </div>

        <div class="di-pulse-list">
            <div class="di-pulse-item <?=e($salesTrendState)?>">
                <span class="di-light"></span>
                <div><strong>Ventas</strong><small><?=e(cpdi_delta_text($salesDelta))?> vs. periodo anterior</small></div>
            </div>
            <div class="di-pulse-item <?=e($collectionState)?>">
                <span class="di-light"></span>
                <div><strong>Cobranza</strong><small><?=e(cpdi_pct($collectionRatio))?> respecto a ventas del periodo</small></div>
            </div>
            <div class="di-pulse-item <?=e($productionState)?>">
                <span class="di-light"></span>
                <div><strong>Producción</strong><small><?=number_format($pendingProductionOrders)?> orden(es) esperando iniciar</small></div>
            </div>
            <div class="di-pulse-item <?=e($portfolioState)?>">
                <span class="di-light"></span>
                <div><strong>Cartera</strong><small><?=number_format($overdueOrders)?> atrasada(s) · <?=e(cpdi_money($overdueBalance))?></small></div>
            </div>
        </div>
    </article>
</section>

<section class="di-grid di-grid-mid">
    <article class="di-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">CONVERSIÓN</span>
                <h3>Embudo comercial</h3>
                <p>Actividad registrada dentro del periodo seleccionado.</p>
            </div>
        </div>
        <div class="di-funnel">
            <?php foreach ($funnel as $index => $row):
                $width = max(8, ((int)$row['value'] / $funnelMax) * 100);
            ?>
                <div class="di-funnel-row">
                    <div class="di-funnel-meta">
                        <span><?=e($row['label'])?></span>
                        <strong><?=number_format((int)$row['value'])?></strong>
                    </div>
                    <div class="di-funnel-track">
                        <div class="di-funnel-fill f<?=($index % 6) + 1?>" style="width:<?=e(number_format($width, 2, '.', ''))?>%"></div>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </article>

    <article class="di-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">NECESITA TU ATENCIÓN</span>
                <h3>Centro de alertas</h3>
            </div>
        </div>

        <div class="di-alert-list">
            <?php if ($overdueOrders > 0): ?>
                <a class="di-alert danger" href="/admin/reportes.php">
                    <span>!</span>
                    <div><strong><?=number_format($overdueOrders)?> órdenes atrasadas</strong><small>Saldo estimado <?=e(cpdi_money($overdueBalance))?></small></div>
                    <b>Revisar →</b>
                </a>
            <?php endif; ?>

            <?php if ($quoteFollowups > 0): ?>
                <a class="di-alert warn" href="/admin/cotizaciones.php">
                    <span>◷</span>
                    <div><strong><?=number_format($quoteFollowups)?> cotizaciones sin respuesta</strong><small>Enviadas hace 3 días o más</small></div>
                    <b>Seguimiento →</b>
                </a>
            <?php endif; ?>

            <?php if ($pendingPrintRequests > 0): ?>
                <a class="di-alert info" href="/admin/autorizaciones.php">
                    <span>▣</span>
                    <div><strong><?=number_format($pendingPrintRequests)?> solicitudes de impresión</strong><small>Pendientes de revisar o convertir</small></div>
                    <b>Ver →</b>
                </a>
            <?php endif; ?>

            <?php if ($pendingProductionOrders > 0): ?>
                <a class="di-alert good" href="/admin/produccion.php?stage=pending">
                    <span>⚙</span>
                    <div><strong><?=number_format($pendingProductionOrders)?> órdenes por iniciar</strong><small>En columna Pendiente del taller</small></div>
                    <b>Producción →</b>
                </a>
            <?php endif; ?>

            <?php if (!$expensesEnabled): ?>
                <a class="di-alert module" href="/admin/egresos.php">
                    <span>$</span>
                    <div><strong>Activa el módulo de egresos</strong><small>Importa la migración incluida para completar flujo de caja.</small></div>
                    <b>Instrucciones →</b>
                </a>
            <?php endif; ?>

            <?php if ($overdueOrders === 0 && $quoteFollowups === 0 && $pendingPrintRequests === 0 && $pendingProductionOrders === 0 && $expensesEnabled): ?>
                <div class="di-empty-success">✓ No hay alertas críticas en este momento.</div>
            <?php endif; ?>
        </div>
    </article>
</section>

<section class="di-grid di-grid-mid">
    <article class="di-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">TALLER CENTRAL</span>
                <h3>Carga de producción</h3>
            </div>
            <a class="di-text-link" href="/admin/produccion.php">Abrir Kanban →</a>
        </div>

        <?php if (!$productionRows): ?>
            <div class="di-empty">No hay órdenes activas en producción.</div>
        <?php else: ?>
            <div class="di-production-list">
                <?php foreach ($productionRows as $row):
                    $value = (int)$row['total'];
                    $width = max(4, ($value / $productionMax) * 100);
                ?>
                    <div class="di-production-row">
                        <div class="di-production-meta">
                            <span><?=e(cpdi_status_label((string)$row['stage']))?></span>
                            <strong><?=number_format($value)?></strong>
                        </div>
                        <div class="di-production-track"><div style="width:<?=e(number_format($width, 2, '.', ''))?>%"></div></div>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </article>

    <article class="di-card di-radar">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">RADAR DE CAJA</span>
                <h3>Próximos 7 días</h3>
                <p>Proyección operativa basada en saldos con fecha compromiso y egresos pendientes.</p>
            </div>
        </div>

        <div class="di-radar-row">
            <span>Por cobrar previsto</span>
            <strong><?=e(cpdi_money($expectedReceivable7))?></strong>
        </div>
        <div class="di-radar-row">
            <span>Egresos programados</span>
            <strong><?= $expensesEnabled ? e(cpdi_money($plannedExpenses7)) : 'No disponible' ?></strong>
        </div>
        <div class="di-radar-total <?= $projected7 < 0 ? 'negative' : '' ?>">
            <span>Flujo proyectado</span>
            <strong><?=e(cpdi_money($projected7))?></strong>
        </div>

        <a class="di-primary-link" href="/admin/egresos.php"><?= $expensesEnabled ? 'Administrar egresos' : 'Configurar egresos' ?> →</a>
    </article>
</section>

<section class="di-grid di-grid-rank">
    <article class="di-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">CLIENTES</span>
                <h3>Principales clientes</h3>
            </div>
            <a class="di-text-link" href="/admin/reportes.php?from=<?=e($from)?>&to=<?=e($to)?>">Reporte completo →</a>
        </div>

        <?php if (!$topCustomers): ?>
            <div class="di-empty">No hay ventas de clientes en este periodo.</div>
        <?php else: ?>
            <div class="di-ranking">
                <?php foreach ($topCustomers as $i => $row): ?>
                    <div class="di-rank-row">
                        <span class="di-rank-index"><?=($i + 1)?></span>
                        <div class="di-rank-copy">
                            <strong><?=e((string)$row['customer_name'])?></strong>
                            <small><?=number_format((int)$row['orders_count'])?> orden(es)</small>
                        </div>
                        <b><?=e(cpdi_money((float)$row['sales_total']))?></b>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </article>

    <article class="di-card">
        <div class="di-section-head">
            <div>
                <span class="di-eyebrow">PRODUCTOS / SERVICIOS</span>
                <h3>Más vendidos</h3>
            </div>
        </div>

        <?php if (!$topProducts): ?>
            <div class="di-empty">No hay conceptos vendidos en este periodo.</div>
        <?php else: ?>
            <div class="di-ranking">
                <?php foreach ($topProducts as $i => $row): ?>
                    <div class="di-rank-row">
                        <span class="di-rank-index"><?=($i + 1)?></span>
                        <div class="di-rank-copy">
                            <strong><?=e((string)$row['description'])?></strong>
                            <small><?=e(rtrim(rtrim(number_format((float)$row['quantity'], 3, '.', ''), '0'), '.'))?> unidad(es)</small>
                        </div>
                        <b><?=e(cpdi_money((float)$row['sales_total']))?></b>
                    </div>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </article>
</section>

<section class="di-card di-changes">
    <div class="di-section-head">
        <div>
            <span class="di-eyebrow">QUÉ CAMBIÓ</span>
            <h3>Movimiento de hoy</h3>
        </div>
    </div>

    <div class="di-change-grid">
        <div>
            <span>Ventas de hoy</span>
            <strong><?=e(cpdi_money($todaySales))?></strong>
            <?php $todayVsYesterday = cpdi_delta($todaySales, $yesterdaySales); ?>
            <small class="<?=e(cpdi_delta_class($todayVsYesterday))?>"><?=e(cpdi_delta_text($todayVsYesterday))?> vs. ayer</small>
        </div>
        <div>
            <span>Cobrado hoy</span>
            <strong><?=e(cpdi_money($todayCollected))?></strong>
            <small>Pagos confirmados</small>
        </div>
        <div>
            <span>Nuevas cotizaciones</span>
            <strong><?=number_format($todayQuotes)?></strong>
            <small>Registradas hoy</small>
        </div>
        <div>
            <span>Nuevos clientes</span>
            <strong><?=number_format($todayCustomers)?></strong>
            <small>Altas de hoy</small>
        </div>
    </div>
</section>

<script src="/assets/js/dashboard-intelligence.js?v=1.0.0" defer></script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
