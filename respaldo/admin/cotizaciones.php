<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_auth();

if (!headers_sent()) {
    header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
    header('Pragma: no-cache');
    header('Expires: 0');
}

$title = 'Cotizaciones';
$error = null;

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['action'] ?? '') === 'delete') {
        $id = (int)($_POST['id'] ?? 0);
        if ($id > 0) {
            try {
                $stmt = db()->prepare('DELETE FROM cp_quotes WHERE id=?');
                $stmt->execute([$id]);
                log_activity('delete', 'quotes', 'Cotización eliminada #' . $id);
                redirect('/admin/cotizaciones.php?deleted=1');
            } catch (Throwable $e) {
                $error = 'No se pudo eliminar la cotización. Si ya está relacionada con una orden, primero gestiona esa orden.';
            }
        }
    }
}

function qws_scalar(string $sql, array $params = [], float $default = 0.0): float
{
    try {
        $st = db()->prepare($sql);
        $st->execute($params);
        $value = $st->fetchColumn();
        return ($value === false || $value === null) ? $default : (float)$value;
    } catch (Throwable $e) {
        return $default;
    }
}

function qws_primary_action(array $row): array
{
    $id = (int)($row['id'] ?? 0);
    $status = (string)($row['status'] ?? '');
    $orderId = (int)($row['order_id'] ?? 0);
    $orderNumber = trim((string)($row['order_number'] ?? ''));

    if ($orderId > 0) {
        return [
            'label' => $orderNumber !== '' ? 'Ver orden ' . $orderNumber : 'Ver orden',
            'url' => '/admin/orden.php?id=' . $orderId,
            'class' => 'order',
        ];
    }
    if ($status === 'approved') {
        return [
            'label' => 'Crear orden',
            'url' => '/admin/orden_nueva.php?quote_id=' . $id,
            'class' => 'approved',
        ];
    }
    if ($status === 'draft') {
        return [
            'label' => 'Continuar',
            'url' => '/admin/cotizacion_nueva.php?id=' . $id,
            'class' => 'draft',
        ];
    }
    if ($status === 'sent') {
        return [
            'label' => 'Dar seguimiento',
            'url' => '/admin/whatsapp.php?source=quote&id=' . $id . '&template=quote_sent',
            'class' => 'sent',
        ];
    }
    return [
        'label' => 'Revisar',
        'url' => '/admin/cotizacion.php?id=' . $id,
        'class' => 'default',
    ];
}

function qws_list_url(array $changes = []): string
{
    $params = $_GET;
    foreach ($changes as $key => $value) {
        if ($value === null || $value === '') {
            unset($params[$key]);
        } else {
            $params[$key] = $value;
        }
    }
    return '/admin/cotizaciones.php' . ($params ? '?' . http_build_query($params) : '');
}

$statusFilters = [
    '' => 'Todas',
    'approved' => 'Aprobadas',
    'sent' => 'En espera',
    'draft' => 'Borradores',
    'rejected' => 'Rechazadas',
    'expired' => 'Vencidas',
    'cancelled' => 'Canceladas',
];

$statusCounts = array_fill_keys(array_keys($statusFilters), 0);

try {
    $rows = db()->query(
        "SELECT status, COUNT(*) AS total
         FROM cp_quotes
         GROUP BY status"
    )->fetchAll(PDO::FETCH_ASSOC);

    foreach ($rows as $row) {
        $key = (string)$row['status'];
        if (array_key_exists($key, $statusCounts)) {
            $statusCounts[$key] = (int)$row['total'];
        }
    }
} catch (Throwable $e) {
}

$statusCounts[''] = array_sum(array_filter(
    $statusCounts,
    static fn($key) => $key !== '',
    ARRAY_FILTER_USE_KEY
));

$monthStart = date('Y-m-01');
$today = date('Y-m-d');

$quotedThisMonth = qws_scalar(
    "SELECT COALESCE(SUM(t.total),0)
     FROM cp_quotes q
     INNER JOIN cp_quote_totals t ON t.quote_id=q.id
     WHERE q.issue_date BETWEEN ? AND ?
       AND q.status <> 'cancelled'",
    [$monthStart, $today]
);

$approvedThisMonth = (int)qws_scalar(
    "SELECT COUNT(*)
     FROM cp_quotes
     WHERE issue_date BETWEEN ? AND ?
       AND status='approved'",
    [$monthStart, $today]
);

$sentThisMonth = (int)qws_scalar(
    "SELECT COUNT(*)
     FROM cp_quotes
     WHERE issue_date BETWEEN ? AND ?
       AND status='sent'",
    [$monthStart, $today]
);

$resolvedThisMonth = (int)qws_scalar(
    "SELECT COUNT(*)
     FROM cp_quotes
     WHERE issue_date BETWEEN ? AND ?
       AND status IN ('approved','rejected','expired')",
    [$monthStart, $today]
);

$conversionThisMonth = $resolvedThisMonth > 0
    ? ($approvedThisMonth / $resolvedThisMonth) * 100
    : 0.0;

$staleSent = (int)qws_scalar(
    "SELECT COUNT(*)
     FROM cp_quotes
     WHERE status='sent'
       AND issue_date <= DATE_SUB(CURDATE(), INTERVAL 3 DAY)"
);

$expiredByDate = (int)qws_scalar(
    "SELECT COUNT(*)
     FROM cp_quotes
     WHERE status IN ('draft','sent')
       AND valid_until IS NOT NULL
       AND valid_until < CURDATE()"
);

$approvedNoOrder = (int)qws_scalar(
    "SELECT COUNT(*)
     FROM cp_quotes q
     LEFT JOIN cp_orders o ON o.quote_id=q.id
     WHERE q.status='approved'
       AND o.id IS NULL"
);

$q = trim((string)($_GET['q'] ?? ''));
$status = (string)($_GET['status'] ?? '');
$focus = (string)($_GET['focus'] ?? '');

$allowedFocus = ['', 'stale', 'expired_date', 'approved_no_order'];
if (!in_array($focus, $allowedFocus, true)) {
    $focus = '';
}

$sql = "
    SELECT
        q.*,
        c.name AS customer_name,
        t.total AS quote_total,
        t.internal_cost,
        t.profit,
        o.id AS order_id,
        o.order_number,
        o.status AS order_status
    FROM cp_quotes q
    LEFT JOIN cp_customers c ON c.id=q.customer_id
    LEFT JOIN cp_quote_totals t ON t.quote_id=q.id
    LEFT JOIN cp_orders o ON o.quote_id=q.id
    WHERE 1=1
";
$params = [];

if ($q !== '') {
    $sql .= " AND (
        q.quote_number LIKE ?
        OR c.name LIKE ?
        OR q.notes LIKE ?
        OR q.client_reference LIKE ?
    )";
    $like = '%' . $q . '%';
    array_push($params, $like, $like, $like, $like);
}

if (array_key_exists($status, $statusFilters) && $status !== '') {
    $sql .= ' AND q.status=?';
    $params[] = $status;
}

if ($focus === 'stale') {
    $sql .= " AND q.status='sent'
              AND q.issue_date <= DATE_SUB(CURDATE(), INTERVAL 3 DAY)";
} elseif ($focus === 'expired_date') {
    $sql .= " AND q.status IN ('draft','sent')
              AND q.valid_until IS NOT NULL
              AND q.valid_until < CURDATE()";
} elseif ($focus === 'approved_no_order') {
    $sql .= " AND q.status='approved'
              AND o.id IS NULL";
}

$sql .= ' ORDER BY q.id DESC LIMIT 200';

$stmt = db()->prepare($sql);
$stmt->execute($params);
$quotes = $stmt->fetchAll(PDO::FETCH_ASSOC);
$pending = !empty($_SESSION['cp_pending_quote']);

$focusLabels = [
    '' => 'Cotizaciones',
    'stale' => 'En espera de seguimiento',
    'expired_date' => 'Vigencia vencida',
    'approved_no_order' => 'Aprobadas sin orden',
];

require __DIR__ . '/../includes/header.php';
?>
<link rel="stylesheet" href="/assets/css/cotizaciones.css?v=20260917-10">
<link rel="stylesheet" href="/assets/css/cotizaciones-workspace-v1.css?v=1.0.0">

<div class="qws-page">
    <section class="qws-hero">
        <div class="qws-hero-copy">
            <span class="qws-eyebrow">COTIZACIONES · WORKSPACE</span>
            <h2>Centro comercial</h2>
            <p>Encuentra la cotización, identifica qué requiere atención y ejecuta la siguiente acción sin recorrer varias pantallas.</p>
        </div>
        <div class="qws-hero-actions">
            <?=action_button('＋ Nueva cotización', '/admin/cotizacion_nueva.php', 'btn btn-primary')?>
            <?php if ($pending): ?>
                <?=action_button('Usar cálculo pendiente', '/admin/cotizacion_nueva.php?from=calculator', 'btn btn-secondary')?>
            <?php endif; ?>
        </div>
    </section>

    <?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
    <?php if (isset($_GET['saved'])): ?><div class="notice"><span class="ok">✓</span> Cotización guardada correctamente.</div><?php endif; ?>
    <?php if (isset($_GET['deleted'])): ?><div class="notice"><span class="ok">✓</span> Cotización eliminada.</div><?php endif; ?>

    <section class="qws-kpis" aria-label="Resumen de cotizaciones">
        <article class="qws-kpi">
            <span>Cotizado este mes</span>
            <strong><?=quote_money($quotedThisMonth)?></strong>
            <small>Importe no cancelado</small>
        </article>
        <article class="qws-kpi">
            <span>En espera</span>
            <strong><?=number_format($statusCounts['sent'])?></strong>
            <small><?=number_format($sentThisMonth)?> creadas este mes</small>
        </article>
        <article class="qws-kpi">
            <span>Aprobadas este mes</span>
            <strong><?=number_format($approvedThisMonth)?></strong>
            <small>Listas para convertir en orden</small>
        </article>
        <article class="qws-kpi qws-kpi-highlight">
            <span>Conversión resuelta</span>
            <strong><?=number_format($conversionThisMonth, 1)?>%</strong>
            <small>Aprobadas / cotizaciones resueltas</small>
        </article>
    </section>

    <?php if ($staleSent > 0 || $expiredByDate > 0 || $approvedNoOrder > 0): ?>
    <section class="qws-attention">
        <div class="qws-attention-head">
            <div>
                <span class="qws-eyebrow">NECESITAN ATENCIÓN</span>
                <h3>Siguiente movimiento comercial</h3>
            </div>
            <?php if ($focus !== ''): ?>
                <a href="<?=e(qws_list_url(['focus' => null]))?>">Quitar filtro</a>
            <?php endif; ?>
        </div>

        <div class="qws-attention-grid">
            <?php if ($staleSent > 0): ?>
                <a class="qws-attention-item follow <?= $focus === 'stale' ? 'is-active' : '' ?>"
                   href="<?=e(qws_list_url(['focus' => 'stale', 'status' => null]))?>">
                    <span class="qws-attention-icon">◷</span>
                    <div>
                        <strong><?=number_format($staleSent)?> en espera</strong>
                        <small>Llevan 3 días o más desde su fecha de emisión.</small>
                    </div>
                    <b>Seguimiento →</b>
                </a>
            <?php endif; ?>

            <?php if ($expiredByDate > 0): ?>
                <a class="qws-attention-item expired <?= $focus === 'expired_date' ? 'is-active' : '' ?>"
                   href="<?=e(qws_list_url(['focus' => 'expired_date', 'status' => null]))?>">
                    <span class="qws-attention-icon">!</span>
                    <div>
                        <strong><?=number_format($expiredByDate)?> con vigencia vencida</strong>
                        <small>Siguen en borrador o enviadas.</small>
                    </div>
                    <b>Revisar →</b>
                </a>
            <?php endif; ?>

            <?php if ($approvedNoOrder > 0): ?>
                <a class="qws-attention-item approved <?= $focus === 'approved_no_order' ? 'is-active' : '' ?>"
                   href="<?=e(qws_list_url(['focus' => 'approved_no_order', 'status' => null]))?>">
                    <span class="qws-attention-icon">✓</span>
                    <div>
                        <strong><?=number_format($approvedNoOrder)?> aprobadas sin orden</strong>
                        <small>Ya pueden pasar a producción.</small>
                    </div>
                    <b>Convertir →</b>
                </a>
            <?php endif; ?>
        </div>
    </section>
    <?php endif; ?>

    <section class="card qws-controls">
        <form method="get" class="qws-search-form" id="qwsSearchForm">
            <div class="qws-search-wrap">
                <span aria-hidden="true">⌕</span>
                <input id="qwsSearch" type="search" name="q" value="<?=e($q)?>"
                       placeholder="Buscar folio, cliente, proyecto o notas" autocomplete="off">
            </div>

            <?php if ($status !== ''): ?><input type="hidden" name="status" value="<?=e($status)?>"><?php endif; ?>
            <?php if ($focus !== ''): ?><input type="hidden" name="focus" value="<?=e($focus)?>"><?php endif; ?>

            <button class="btn btn-primary" type="submit">Buscar</button>
            <?php if ($q !== '' || $status !== '' || $focus !== ''): ?>
                <a class="btn btn-secondary" href="/admin/cotizaciones.php">Limpiar</a>
            <?php endif; ?>
        </form>

        <div class="qws-status-scroll" aria-label="Filtrar por estado">
            <?php foreach ($statusFilters as $key => $label): ?>
                <a class="qws-chip <?= $status === $key && $focus === '' ? 'is-active' : '' ?>"
                   href="<?=e(qws_list_url(['status' => $key, 'focus' => null]))?>">
                    <span><?=e($label)?></span>
                    <b><?=number_format($statusCounts[$key] ?? 0)?></b>
                </a>
            <?php endforeach; ?>
        </div>
    </section>

    <section class="card qws-results">
        <div class="qws-results-head">
            <div>
                <span class="qws-eyebrow">BANDEJA COMERCIAL</span>
                <h3><?=e($focus !== '' ? $focusLabels[$focus] : ($statusFilters[$status] ?? 'Cotizaciones'))?></h3>
                <?php if ($q !== ''): ?><p>Resultados para <strong><?=e($q)?></strong></p><?php endif; ?>
            </div>
            <div class="qws-results-count">
                <strong><?=number_format(count($quotes))?></strong>
                <span><?=count($quotes) >= 200 ? 'mostradas · límite 200' : 'resultados'?></span>
            </div>
        </div>

        <?php if (!$quotes): ?>
            <div class="qws-empty">
                <div>🧾</div>
                <strong>No hay cotizaciones para estos filtros.</strong>
                <p>Prueba con otro estado o limpia la búsqueda.</p>
                <a class="btn btn-secondary" href="/admin/cotizaciones.php">Ver todas</a>
            </div>
        <?php else: ?>

            <div class="qws-desktop-list">
                <div class="qws-list-head">
                    <span>Cotización</span><span>Cliente / proyecto</span><span>Fecha</span>
                    <span>Estado</span><span>Total</span><span>Siguiente acción</span><span></span>
                </div>

                <?php foreach ($quotes as $row):
                    $rowStatus = (string)$row['status'];
                    $primary = qws_primary_action($row);
                    $expiredVisual = !empty($row['valid_until'])
                        && strtotime((string)$row['valid_until']) < strtotime(date('Y-m-d'))
                        && in_array($rowStatus, ['draft', 'sent'], true);
                ?>
                <article class="qws-list-row <?= $expiredVisual ? 'is-overdue' : '' ?>">
                    <div class="qws-folio">
                        <a href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>"><?=e((string)$row['quote_number'])?></a>
                        <small><?=e(quote_source_label($row['source_calculator']))?></small>
                    </div>

                    <div class="qws-customer">
                        <strong><?=e((string)($row['customer_name'] ?? 'Sin cliente'))?></strong>
                        <small><?=e((string)($row['client_reference'] ?: 'Sin referencia de proyecto'))?></small>
                    </div>

                    <div class="qws-date">
                        <strong><?=e(date('d/m/Y', strtotime((string)$row['issue_date'])))?></strong>
                        <small>
                            <?=!empty($row['valid_until'])
                                ? 'Vig. ' . e(date('d/m/Y', strtotime((string)$row['valid_until'])))
                                : 'Sin vigencia'?>
                        </small>
                    </div>

                    <div>
                        <span class="status-badge status-<?=e($rowStatus)?>"><?=e(quote_status_label($rowStatus))?></span>
                        <?php if ($expiredVisual): ?><small class="qws-overdue-note">Vigencia vencida</small><?php endif; ?>
                    </div>

                    <div class="qws-money"><?=quote_money((float)($row['quote_total'] ?? 0))?></div>

                    <div>
                        <a class="qws-primary-action <?=e($primary['class'])?>" href="<?=e($primary['url'])?>">
                            <?=e($primary['label'])?> →
                        </a>
                    </div>

                    <div class="qws-menu-cell">
                        <details class="qws-menu">
                            <summary aria-label="Más acciones">⋯</summary>
                            <div class="qws-menu-pop">
                                <a href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>">Ver detalle</a>
                                <a href="/admin/cotizacion_nueva.php?id=<?=((int)$row['id'])?>">Editar</a>
                                <a href="/admin/cotizacion_pdf_2paginas.php?id=<?=((int)$row['id'])?>" target="_blank" rel="noopener">PDF</a>
                                <a href="/admin/whatsapp.php?source=quote&id=<?=((int)$row['id'])?>&template=quote_sent">WhatsApp</a>
                                <?php if ((int)($row['order_id'] ?? 0) <= 0): ?>
                                    <form method="post" onsubmit="return confirm('¿Seguro que deseas borrar esta cotización? Esta acción no se puede deshacer.');">
                                        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<?=((int)$row['id'])?>">
                                        <button type="submit">Borrar</button>
                                    </form>
                                <?php endif; ?>
                            </div>
                        </details>
                    </div>
                </article>
                <?php endforeach; ?>
            </div>

            <div class="qws-mobile-list">
                <?php foreach ($quotes as $row):
                    $rowStatus = (string)$row['status'];
                    $primary = qws_primary_action($row);
                    $expiredVisual = !empty($row['valid_until'])
                        && strtotime((string)$row['valid_until']) < strtotime(date('Y-m-d'))
                        && in_array($rowStatus, ['draft', 'sent'], true);
                ?>
                <article class="qws-mobile-card <?= $expiredVisual ? 'is-overdue' : '' ?>">
                    <div class="qws-mobile-top">
                        <div>
                            <small><?=e(quote_source_label($row['source_calculator']))?></small>
                            <a href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>"><?=e((string)$row['quote_number'])?></a>
                        </div>
                        <span class="status-badge status-<?=e($rowStatus)?>"><?=e(quote_status_label($rowStatus))?></span>
                    </div>

                    <div class="qws-mobile-customer">
                        <strong><?=e((string)($row['customer_name'] ?? 'Sin cliente'))?></strong>
                        <?php if (!empty($row['client_reference'])): ?><span><?=e((string)$row['client_reference'])?></span><?php endif; ?>
                    </div>

                    <div class="qws-mobile-meta">
                        <div><span>Total</span><strong><?=quote_money((float)($row['quote_total'] ?? 0))?></strong></div>
                        <div><span>Vigencia</span><strong><?=!empty($row['valid_until']) ? e(date('d/m/Y', strtotime((string)$row['valid_until']))) : '—'?></strong></div>
                    </div>

                    <?php if ($expiredVisual): ?><div class="qws-mobile-warning">⚠ La vigencia ya terminó y la cotización sigue activa.</div><?php endif; ?>

                    <div class="qws-mobile-actions">
                        <a class="qws-mobile-primary <?=e($primary['class'])?>" href="<?=e($primary['url'])?>"><?=e($primary['label'])?></a>
                        <details class="qws-menu qws-menu-mobile">
                            <summary aria-label="Más acciones">⋯</summary>
                            <div class="qws-menu-pop">
                                <a href="/admin/cotizacion.php?id=<?=((int)$row['id'])?>">Ver detalle</a>
                                <a href="/admin/cotizacion_nueva.php?id=<?=((int)$row['id'])?>">Editar</a>
                                <a href="/admin/cotizacion_pdf_2paginas.php?id=<?=((int)$row['id'])?>" target="_blank" rel="noopener">PDF</a>
                                <a href="/admin/whatsapp.php?source=quote&id=<?=((int)$row['id'])?>&template=quote_sent">WhatsApp</a>
                                <?php if ((int)($row['order_id'] ?? 0) <= 0): ?>
                                    <form method="post" onsubmit="return confirm('¿Seguro que deseas borrar esta cotización? Esta acción no se puede deshacer.');">
                                        <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<?=((int)$row['id'])?>">
                                        <button type="submit">Borrar</button>
                                    </form>
                                <?php endif; ?>
                            </div>
                        </details>
                    </div>
                </article>
                <?php endforeach; ?>
            </div>
        <?php endif; ?>
    </section>
</div>

<script src="/assets/js/cotizaciones-workspace-v1.js?v=1.0.0" defer></script>
<?php require __DIR__ . '/../includes/footer.php'; ?>
