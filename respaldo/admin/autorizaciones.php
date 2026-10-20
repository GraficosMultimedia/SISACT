<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_once __DIR__ . '/../includes/cotizaciones.php';
require_once __DIR__ . '/../includes/ordenes.php';
require_auth();

if (!headers_sent()) {
    header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');
    header('Pragma: no-cache');
    header('Expires: 0');
}

$title = 'Autorizaciones';
$error = null;
$success = null;

function auth_quote_can_be_approved(array $row): bool {
    $status = (string)($row['quote_status'] ?? '');
    return in_array($status, ['draft', 'sent'], true) && empty($row['client_approved_at']);
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!csrf_check($_POST['_csrf'] ?? null)) {
        $error = 'La sesión del formulario expiró. Recarga la página.';
    } elseif (($_POST['action'] ?? '') === 'approve_admin') {
        $quoteId = (int)($_POST['quote_id'] ?? 0);
        if ($quoteId <= 0) {
            $error = 'Cotización no válida.';
        } else {
            try {
                $pdo = db();
                $pdo->beginTransaction();
                $st = $pdo->prepare('SELECT id, quote_number, status FROM cp_quotes WHERE id=? FOR UPDATE');
                $st->execute([$quoteId]);
                $quote = $st->fetch(PDO::FETCH_ASSOC);
                if (!$quote) {
                    throw new RuntimeException('No se encontró la cotización.');
                }
                if (in_array((string)$quote['status'], ['cancelled', 'rejected', 'expired'], true)) {
                    throw new RuntimeException('La cotización está cerrada y no puede autorizarse.');
                }
                $userId = current_user()['id'] ?? null;
                $pdo->prepare('UPDATE cp_quotes SET status=\'approved\', updated_by=?, updated_at=NOW() WHERE id=?')->execute([$userId, $quoteId]);
                $web = $pdo->prepare('SELECT id FROM cp_web_quote_requests WHERE converted_quote_id=? ORDER BY id DESC LIMIT 1');
                $web->execute([$quoteId]);
                $webId = (int)($web->fetchColumn() ?: 0);
                if ($webId > 0) {
                    $pdo->prepare("UPDATE cp_web_quote_requests SET status='closed', updated_at=NOW() WHERE id=?")->execute([$webId]);
                }
                log_activity('approve', 'quotes', 'Cotización ' . $quote['quote_number'] . ' autorizada administrativamente.');
                $pdo->commit();
                redirect('/admin/autorizaciones.php?approved=1');
            } catch (Throwable $e) {
                if (isset($pdo) && $pdo->inTransaction()) {
                    $pdo->rollBack();
                }
                $error = $e->getMessage() ?: 'No se pudo autorizar la cotización.';
            }
        }
    }
}

$q = trim((string)($_GET['q'] ?? ''));
$filter = (string)($_GET['filter'] ?? 'pending');
$allowedFilters = ['pending', 'client', 'admin', 'rejected', 'all'];
if (!in_array($filter, $allowedFilters, true)) {
    $filter = 'pending';
}

// La columna client_approved_at pertenece a la migración de autorización pública.
// Si aún no se ejecutó, la pantalla sigue funcionando y muestra una advertencia.
$hasClientApprovalColumns = false;
try {
    $check = db()->query("SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME='cp_quotes' AND COLUMN_NAME='client_approved_at'");
    $hasClientApprovalColumns = ((int)$check->fetchColumn() > 0);
} catch (Throwable $e) {
    $hasClientApprovalColumns = false;
}

$clientApprovedExpr = $hasClientApprovalColumns ? 'q.client_approved_at' : 'NULL';
$clientIpExpr = $hasClientApprovalColumns ? 'q.client_approval_ip' : 'NULL';

$sql = "SELECT r.id AS web_id, r.request_token, r.customer_name AS web_customer, r.phone, r.email,
               r.status AS web_status, r.created_at AS request_created_at, r.converted_at,
               q.id AS quote_id, q.quote_number, q.status AS quote_status, q.issue_date, q.valid_until,
               {$clientApprovedExpr} AS client_approved_at, {$clientIpExpr} AS client_approval_ip,
               c.name AS customer_name, qt.total,
               o.id AS order_id, o.order_number,
               0 AS is_unconverted
        FROM cp_web_quote_requests r
        INNER JOIN cp_quotes q ON q.id=r.converted_quote_id
        LEFT JOIN cp_customers c ON c.id=q.customer_id
        LEFT JOIN cp_quote_totals qt ON qt.quote_id=q.id
        LEFT JOIN cp_orders o ON o.quote_id=q.id
        WHERE r.converted_quote_id IS NOT NULL";
$params = [];

if ($q !== '') {
    $sql .= ' AND (q.quote_number LIKE ? OR r.customer_name LIKE ? OR c.name LIKE ? OR r.phone LIKE ?)';
    $term = '%' . $q . '%';
    $params = [$term, $term, $term, $term];
}

switch ($filter) {
    case 'pending':
        $sql .= " AND q.status IN ('draft','sent')";
        if ($hasClientApprovalColumns) {
            $sql .= ' AND q.client_approved_at IS NULL';
        }
        break;
    case 'client':
        if ($hasClientApprovalColumns) {
            $sql .= ' AND q.client_approved_at IS NOT NULL';
        } else {
            $sql .= ' AND 1=0';
        }
        break;
    case 'admin':
        $sql .= " AND q.status='approved'";
        if ($hasClientApprovalColumns) {
            $sql .= ' AND q.client_approved_at IS NULL';
        }
        break;
    case 'rejected':
        $sql .= " AND q.status='rejected'";
        break;
}

$sql .= ' ORDER BY r.id DESC LIMIT 300';
$stmt = db()->prepare($sql);
$stmt->execute($params);
$rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

/*
 * Las solicitudes CPQ que todavía NO se han convertido en cotización también
 * deben aparecer en "Pendientes". Antes el INNER JOIN anterior las ocultaba,
 * por eso CPQ-000021/000022 mostraban 0 pendientes.
 */
if (in_array($filter, ['pending', 'all'], true)) {
    $unSql = "SELECT r.id AS web_id, r.request_token, r.customer_name AS web_customer, r.phone, r.email,
                     r.status AS web_status, r.created_at AS request_created_at, r.converted_at,
                     NULL AS quote_id, NULL AS quote_number, NULL AS quote_status, NULL AS issue_date, NULL AS valid_until,
                     NULL AS client_approved_at, NULL AS client_approval_ip,
                     c.name AS customer_name, NULL AS total,
                     NULL AS order_id, NULL AS order_number,
                     1 AS is_unconverted
              FROM cp_web_quote_requests r
              LEFT JOIN cp_customers c ON c.id=r.customer_id
              WHERE r.converted_quote_id IS NULL
                AND r.status NOT IN ('closed','spam')";
    $unParams = [];
    if ($q !== '') {
        $unSql .= ' AND (r.customer_name LIKE ? OR r.phone LIKE ? OR r.email LIKE ? OR r.id LIKE ?)';
        $unTerm = '%' . $q . '%';
        $unParams = [$unTerm, $unTerm, $unTerm, $unTerm];
    }
    $unSql .= ' ORDER BY r.id DESC LIMIT 300';
    $unStmt = db()->prepare($unSql);
    $unStmt->execute($unParams);
    $unRows = $unStmt->fetchAll(PDO::FETCH_ASSOC);
    if ($filter === 'pending') {
        $rows = array_merge($unRows, $rows);
    } else {
        $rows = array_merge($rows, $unRows);
    }
    usort($rows, static function(array $a, array $b): int {
        return ((int)$b['web_id']) <=> ((int)$a['web_id']);
    });
    $rows = array_slice($rows, 0, 300);
}

$counts = ['pending' => 0, 'client' => 0, 'admin' => 0, 'rejected' => 0];
try {
    $countSql = "SELECT
        SUM(CASE WHEN q.status IN ('draft','sent')" . ($hasClientApprovalColumns ? ' AND q.client_approved_at IS NULL' : '') . " THEN 1 ELSE 0 END) pending_count,
        SUM(CASE WHEN " . ($hasClientApprovalColumns ? 'q.client_approved_at IS NOT NULL' : '0=1') . " THEN 1 ELSE 0 END) client_count,
        SUM(CASE WHEN q.status='approved' " . ($hasClientApprovalColumns ? 'AND q.client_approved_at IS NULL' : '') . " THEN 1 ELSE 0 END) admin_count,
        SUM(CASE WHEN q.status='rejected' THEN 1 ELSE 0 END) rejected_count
        FROM cp_web_quote_requests r INNER JOIN cp_quotes q ON q.id=r.converted_quote_id WHERE r.converted_quote_id IS NOT NULL";
    $cr = db()->query($countSql)->fetch(PDO::FETCH_ASSOC) ?: [];
    $counts = [
        'pending' => (int)($cr['pending_count'] ?? 0),
        'client' => (int)($cr['client_count'] ?? 0),
        'admin' => (int)($cr['admin_count'] ?? 0),
        'rejected' => (int)($cr['rejected_count'] ?? 0),
    ];
    $unCount = (int)db()->query("SELECT COUNT(*) FROM cp_web_quote_requests WHERE converted_quote_id IS NULL AND status NOT IN ('closed','spam')")->fetchColumn();
    $counts['pending'] += $unCount;
} catch (Throwable $e) {
    // La tabla principal sigue siendo utilizable aunque el conteo falle.
}

function auth_filter_url(string $filter): string {
    $params = ['filter' => $filter];
    $q = trim((string)($_GET['q'] ?? ''));
    if ($q !== '') $params['q'] = $q;
    return '/admin/autorizaciones.php?' . http_build_query($params);
}

require __DIR__ . '/../includes/header.php';
?>
<style>
.auth-page{display:grid;gap:18px}.auth-toolbar{display:flex;justify-content:space-between;align-items:flex-end;gap:18px;flex-wrap:wrap}.auth-toolbar h2{margin:4px 0}.auth-tabs{display:flex;gap:8px;flex-wrap:wrap}.auth-tab{display:inline-flex;align-items:center;gap:7px;padding:9px 13px;border:1px solid #d9e3ef;border-radius:12px;background:#fff;color:#173a68;text-decoration:none;font-weight:800}.auth-tab.is-active{background:#0d3b73;color:#fff;border-color:#0d3b73}.auth-count{min-width:22px;height:22px;border-radius:999px;display:inline-flex;align-items:center;justify-content:center;background:#edf3fb;color:#173a68;font-size:11px}.auth-tab.is-active .auth-count{background:rgba(255,255,255,.18);color:#fff}.auth-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px}.auth-stat{padding:16px;border:1px solid #dfe8f2;border-radius:14px;background:#fff}.auth-stat small{display:block;color:#6c7b8d;font-weight:700}.auth-stat strong{display:block;font-size:25px;margin-top:5px;color:#0d3b73}.auth-table td{vertical-align:middle}.auth-state{display:inline-flex;padding:5px 9px;border-radius:999px;font-size:11px;font-weight:900}.auth-state.pending{background:#fff4d6;color:#8a5b00}.auth-state.client{background:#e5f8ef;color:#087443}.auth-state.admin{background:#e9f0ff;color:#2456a6}.auth-state.rejected{background:#ffe9eb;color:#a12635}.auth-actions{display:flex;gap:6px;flex-wrap:wrap}.auth-note{font-size:12px;color:#617287}.auth-warning{border:1px solid #f1d28a;background:#fff8e7;color:#745000;padding:12px 14px;border-radius:12px}.auth-search{display:flex;gap:8px;align-items:flex-end;flex-wrap:wrap}.auth-search .field{min-width:280px;flex:1}@media(max-width:900px){.auth-grid{grid-template-columns:repeat(2,minmax(0,1fr))}}@media(max-width:620px){.auth-grid{grid-template-columns:1fr}.auth-toolbar{align-items:stretch}.auth-search .field{min-width:100%}}
</style>

<div class="auth-page">
  <div class="auth-toolbar">
    <div>
      <span class="eyebrow">GESTIÓN COMERCIAL</span>
      <h2>Autorizaciones de clientes</h2>
      <p class="muted">Controla qué cotizaciones están pendientes, cuáles autorizó el cliente y cuáles fueron autorizadas manualmente.</p>
    </div>
  </div>

  <?php if (isset($_GET['approved'])): ?><div class="notice"><span class="ok">✓</span> Cotización autorizada administrativamente.</div><?php endif; ?>
  <?php if ($error): ?><div class="notice danger"><?=e($error)?></div><?php endif; ?>
  <?php if (!$hasClientApprovalColumns): ?><div class="auth-warning"><strong>Falta aplicar la migración de autorización pública.</strong> Ejecuta <code>migration_cliente_autoriza_cotizacion_20260927.sql</code> para poder distinguir las autorizaciones hechas por el cliente.</div><?php endif; ?>

  <div class="auth-grid">
    <div class="auth-stat"><small>Pendientes</small><strong><?=number_format($counts['pending'])?></strong></div>
    <div class="auth-stat"><small>Autorizadas por cliente</small><strong><?=number_format($counts['client'])?></strong></div>
    <div class="auth-stat"><small>Autorizadas por administración</small><strong><?=number_format($counts['admin'])?></strong></div>
    <div class="auth-stat"><small>Rechazadas</small><strong><?=number_format($counts['rejected'])?></strong></div>
  </div>

  <div class="card">
    <div class="auth-tabs">
      <a class="auth-tab <?=$filter==='pending'?'is-active':''?>" href="<?=e(auth_filter_url('pending'))?>">Pendientes <span class="auth-count"><?=number_format($counts['pending'])?></span></a>
      <a class="auth-tab <?=$filter==='client'?'is-active':''?>" href="<?=e(auth_filter_url('client'))?>">Cliente autorizó <span class="auth-count"><?=number_format($counts['client'])?></span></a>
      <a class="auth-tab <?=$filter==='admin'?'is-active':''?>" href="<?=e(auth_filter_url('admin'))?>">Administración <span class="auth-count"><?=number_format($counts['admin'])?></span></a>
      <a class="auth-tab <?=$filter==='rejected'?'is-active':''?>" href="<?=e(auth_filter_url('rejected'))?>">Rechazadas <span class="auth-count"><?=number_format($counts['rejected'])?></span></a>
      <a class="auth-tab <?=$filter==='all'?'is-active':''?>" href="<?=e(auth_filter_url('all'))?>">Todas</a>
    </div>
  </div>

  <div class="card">
    <form method="get" class="auth-search">
      <input type="hidden" name="filter" value="<?=e($filter)?>">
      <div class="field"><label for="authSearch">Buscar</label><input id="authSearch" name="q" value="<?=e($q)?>" placeholder="Folio, cliente o teléfono"></div>
      <button class="btn btn-primary" type="submit">Buscar</button>
      <a class="btn btn-secondary" href="/admin/autorizaciones.php?filter=<?=e($filter)?>">Limpiar</a>
    </form>
  </div>

  <div class="card">
    <div class="section-heading"><div><span class="eyebrow">COTIZACIONES</span><h3>Registro de autorizaciones</h3></div><span class="count-pill"><?=count($rows)?></span></div>
    <?php if (!$rows): ?>
      <div class="empty"><div class="empty-icon">✓</div><strong>No hay registros en esta vista.</strong><p>Las solicitudes web nuevas aparecen aquí. Primero conviértelas en cotización y después podrás autorizarlas.</p></div>
    <?php else: ?>
      <div class="table-wrap"><table class="table auth-table">
        <thead><tr><th>Solicitud</th><th>Cliente</th><th>Cotización</th><th>Total</th><th>Estado</th><th>Fecha</th><th>Acciones</th></tr></thead>
        <tbody>
        <?php foreach ($rows as $row):
          $isUnconverted = !empty($row['is_unconverted']);
          $isClient = !$isUnconverted && !empty($row['client_approved_at']);
          $isAdmin = !$isUnconverted && (string)$row['quote_status'] === 'approved' && !$isClient;
          $isRejected = !$isUnconverted && (string)$row['quote_status'] === 'rejected';
          $stateClass = $isUnconverted ? 'pending' : ($isClient ? 'client' : ($isAdmin ? 'admin' : ($isRejected ? 'rejected' : 'pending')));
          $stateLabel = $isUnconverted ? 'Solicitud pendiente' : ($isClient ? 'Cliente autorizó' : ($isAdmin ? 'Administración autorizó' : ($isRejected ? 'Rechazada' : 'Pendiente')));
          $customer = trim((string)($row['customer_name'] ?: $row['web_customer'] ?: 'Sin cliente'));
        ?>
          <tr>
            <td><strong>CPQ-<?=str_pad((string)$row['web_id'],6,'0',STR_PAD_LEFT)?></strong><small class="auth-note"><?=e(date('d/m/Y H:i',strtotime((string)$row['request_created_at'])))?></small></td>
            <td><?=e($customer)?><br><small class="auth-note"><?=e((string)($row['phone'] ?? ''))?></small></td>
            <td><?php if ($isUnconverted): ?><span class="auth-note">Aún no generada</span><?php else: ?><a class="quote-number" href="/admin/cotizacion.php?id=<?=((int)$row['quote_id'])?>"><?=e((string)$row['quote_number'])?></a><?php endif; ?></td>
            <td><?=quote_money((float)($row['total'] ?? 0))?></td>
            <td><span class="auth-state <?=$stateClass?>"><?=e($stateLabel)?></span><?php if($isClient): ?><small class="auth-note"> <?=e(date('d/m/Y H:i',strtotime((string)$row['client_approved_at'])))?></small><?php endif; ?></td>
            <td><?=!empty($row['valid_until']) ? e(date('d/m/Y',strtotime((string)$row['valid_until']))) : '—'?></td>
            <td><div class="auth-actions">
              <?php if ($isUnconverted): ?>
                <a class="btn btn-sm btn-secondary" href="/admin/cotizaciones_web.php#cpqw3-<?=((int)$row['web_id'])?>">Ver solicitud</a>
                <form method="post" action="/admin/cotizacion_desde_web.php" onsubmit="return confirm('Se creará una cotización formal para CPQ-<?=str_pad((string)$row['web_id'],6,'0',STR_PAD_LEFT)?>. Después podrás autorizarla desde esta sección. ¿Continuar?');">
                  <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="request_id" value="<?=((int)$row['web_id'])?>">
                  <button class="btn btn-sm btn-primary" type="submit">⚡ Convertir en cotización</button>
                </form>
              <?php else: ?>
                <a class="btn btn-sm btn-secondary" href="/admin/cotizacion.php?id=<?=((int)$row['quote_id'])?>">Ver cotización</a>
                <?php if (auth_quote_can_be_approved($row)): ?>
                  <form method="post" onsubmit="return confirm('¿Autorizar administrativamente la cotización <?=e((string)$row['quote_number'])?>?');">
                    <input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><input type="hidden" name="action" value="approve_admin"><input type="hidden" name="quote_id" value="<?=((int)$row['quote_id'])?>">
                    <button class="btn btn-sm btn-primary" type="submit">✓ Autorizar</button>
                  </form>
                <?php elseif (!empty($row['order_id'])): ?>
                  <a class="btn btn-sm btn-secondary" href="/admin/orden.php?id=<?=((int)$row['order_id'])?>">Ver orden</a>
                <?php endif; ?>
              <?php endif; ?>
            </div></td>
          </tr>
        <?php endforeach; ?>
        </tbody>
      </table></div>
    <?php endif; ?>
  </div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
