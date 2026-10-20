<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/tracking_activity.php';
require_auth();

$title = 'Diagnóstico Tracking Activity';

function tad_table_exists(string $table): bool
{
    try {
        $st = db()->prepare(
            'SELECT COUNT(*) FROM information_schema.tables
             WHERE table_schema = DATABASE() AND table_name = ?'
        );
        $st->execute([$table]);
        return (int)$st->fetchColumn() > 0;
    } catch (Throwable $e) {
        return false;
    }
}

function tad_count(string $sql): int
{
    try {
        return (int)(db()->query($sql)->fetchColumn() ?: 0);
    } catch (Throwable $e) {
        return -1;
    }
}

$eventsTable = tad_table_exists('cp_tracking_events');
$readsTable = tad_table_exists('cp_tracking_event_reads');
$invoiceDocsTable = tad_table_exists('cp_invoice_documents');
$trackingTokensTable = tad_table_exists('cp_tracking_tokens');

$totalEvents = $eventsTable ? tad_count('SELECT COUNT(*) FROM cp_tracking_events') : -1;
$trackingViews = $eventsTable ? tad_count("SELECT COUNT(*) FROM cp_tracking_events WHERE event_type='tracking_view'") : -1;
$pdfEvents = $eventsTable ? tad_count("SELECT COUNT(*) FROM cp_tracking_events WHERE event_type='cfdi_pdf_opened'") : -1;
$xmlEvents = $eventsTable ? tad_count("SELECT COUNT(*) FROM cp_tracking_events WHERE event_type='cfdi_xml_downloaded'") : -1;
$receiptEvents = $eventsTable ? tad_count("SELECT COUNT(*) FROM cp_tracking_events WHERE event_type='payment_receipt_uploaded'") : -1;

$user = current_user();
$userId = (int)($user['id'] ?? 0);
$latestId = $eventsTable ? tracking_activity_latest_id() : 0;
$unread = ($eventsTable && $readsTable && $userId > 0)
    ? tracking_activity_unread_count($userId)
    : 0;

$recentRaw = [];
if ($eventsTable) {
    try {
        $recentRaw = db()->query(
            "SELECT e.id,e.event_type,e.order_id,e.customer_id,e.document_id,
                    e.invoice_id,e.device_type,e.created_at,
                    o.order_number,
                    COALESCE(c.name,'Cliente') customer_name
             FROM cp_tracking_events e
             LEFT JOIN cp_orders o ON o.id=e.order_id
             LEFT JOIN cp_customers c ON c.id=e.customer_id
             ORDER BY e.id DESC
             LIMIT 20"
        )->fetchAll(PDO::FETCH_ASSOC) ?: [];
    } catch (Throwable $e) {
        $recentRaw = [];
    }
}

$types = tracking_activity_event_types();

$trackingFile = dirname(__DIR__) . '/includes/tracking_activity.php';
$dashboardFile = dirname(__DIR__) . '/admin/dashboard.php';

$trackingText = is_file($trackingFile) ? (string)@file_get_contents($trackingFile) : '';
$dashboardText = is_file($dashboardFile) ? (string)@file_get_contents($dashboardFile) : '';

$whatsappV2 = str_contains($trackingText, 'SISACT_TRACKING_ACTIVITY_V2_WHATSAPP');
$dashboardV11 = str_contains($dashboardText, 'dashboard-intelligence.js?v=1.1.0');

require __DIR__ . '/../includes/header.php';
?>
<style>
.tad-wrap{max-width:1100px;margin:20px auto}
.tad-grid{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:10px}
.tad-stat{padding:15px}
.tad-stat small,.tad-stat strong{display:block}
.tad-stat strong{font-size:22px;margin-top:4px}
.tad-ok{color:#47d7aa}.tad-bad{color:#ff7b8b}.tad-warn{color:#f4c95d}
.tad-table{width:100%;border-collapse:collapse;margin-top:12px}
.tad-table th,.tad-table td{padding:9px;border-bottom:1px solid rgba(255,255,255,.08);text-align:left;font-size:12px}
@media(max-width:760px){.tad-grid{grid-template-columns:1fr 1fr}.tad-table{display:block;overflow:auto}}
</style>

<div class="tad-wrap">
<div class="card" style="padding:22px">
    <span class="eyebrow">DIAGNÓSTICO</span>
    <h2>Tracking Activity + Dashboard</h2>
    <p class="muted">
        Esta pantalla no genera eventos. Solo comprueba las tablas, el código instalado
        y los registros existentes.
    </p>

    <div class="tad-grid">
        <div class="card tad-stat">
            <small>cp_tracking_events</small>
            <strong class="<?=$eventsTable?'tad-ok':'tad-bad'?>"><?=$eventsTable?'OK':'FALTA'?></strong>
        </div>
        <div class="card tad-stat">
            <small>cp_tracking_event_reads</small>
            <strong class="<?=$readsTable?'tad-ok':'tad-bad'?>"><?=$readsTable?'OK':'FALTA'?></strong>
        </div>
        <div class="card tad-stat">
            <small>Filtro WhatsApp V2</small>
            <strong class="<?=$whatsappV2?'tad-ok':'tad-warn'?>"><?=$whatsappV2?'OK':'ANTERIOR'?></strong>
        </div>
        <div class="card tad-stat">
            <small>Dashboard JS</small>
            <strong class="<?=$dashboardV11?'tad-ok':'tad-warn'?>"><?=$dashboardV11?'v1.1.0':'ANTERIOR'?></strong>
        </div>
    </div>

    <div class="tad-grid" style="margin-top:10px">
        <div class="card tad-stat"><small>Total eventos</small><strong><?=max(0,$totalEvents)?></strong></div>
        <div class="card tad-stat"><small>Revisó orden</small><strong><?=max(0,$trackingViews)?></strong></div>
        <div class="card tad-stat"><small>PDF factura</small><strong><?=max(0,$pdfEvents)?></strong></div>
        <div class="card tad-stat"><small>XML factura</small><strong><?=max(0,$xmlEvents)?></strong></div>
    </div>

    <div class="card" style="padding:15px;margin-top:10px">
        <strong>Estado adicional</strong>
        <p class="muted" style="margin-bottom:0">
            cp_invoice_documents: <b><?=$invoiceDocsTable?'OK':'FALTA'?></b> ·
            cp_tracking_tokens: <b><?=$trackingTokensTable?'OK':'FALTA'?></b> ·
            Usuario admin ID: <b><?=$userId?></b> ·
            Último evento: <b><?=$latestId?></b> ·
            No leídos para este usuario: <b><?=$unread?></b> ·
            Comprobantes enviados: <b><?=max(0,$receiptEvents)?></b>
        </p>
    </div>

    <div style="margin-top:18px">
        <a class="btn btn-primary" href="/admin/tracking_activity_feed.php?limit=10" target="_blank">
            Ver JSON del feed
        </a>
        <a class="btn btn-secondary" href="/admin/dashboard.php">
            Volver al Dashboard
        </a>
    </div>
</div>

<div class="card" style="padding:22px;margin-top:14px">
    <h3>Últimos eventos registrados</h3>

    <?php if (!$eventsTable): ?>
        <div class="notice danger">La tabla cp_tracking_events no existe.</div>
    <?php elseif (!$recentRaw): ?>
        <div class="notice">
            La tabla existe, pero todavía no contiene eventos.
            Abre un enlace de seguimiento desde otro dispositivo y vuelve a esta pantalla.
        </div>
    <?php else: ?>
    <table class="tad-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Cliente</th>
                <th>Orden</th>
                <th>Evento</th>
                <th>Dispositivo</th>
                <th>Fecha</th>
            </tr>
        </thead>
        <tbody>
        <?php foreach ($recentRaw as $row):
            $meta = $types[(string)$row['event_type']] ?? ['icon'=>'•','label'=>(string)$row['event_type']];
        ?>
            <tr>
                <td><?=e((string)$row['id'])?></td>
                <td><?=e((string)$row['customer_name'])?></td>
                <td><?=e((string)($row['order_number']??$row['order_id']))?></td>
                <td><?=e($meta['icon'].' '.$meta['label'])?></td>
                <td><?=e((string)($row['device_type']??'unknown'))?></td>
                <td><?=e((string)$row['created_at'])?></td>
            </tr>
        <?php endforeach; ?>
        </tbody>
    </table>
    <?php endif; ?>
</div>
</div>

<?php require __DIR__ . '/../includes/footer.php'; ?>
