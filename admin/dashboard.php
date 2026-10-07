<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_auth();

$title = 'Dashboard';

$localCustomers = 0;
$localProducts = 0;
$activity = 0;
$akaCustomers = 0;
$akaProducts = 0;
$akaStatus = 'Sin conexión';

/*
 * Contadores usados por las notificaciones del dashboard.
 * No se modifica ninguna tabla: son consultas de solo lectura.
 */
$pendingPrintRequests = 0;
$pendingProductionOrders = 0;

try {
    $pdo = db();

    $localCustomers = (int)$pdo->query('SELECT COUNT(*) FROM cp_customers')->fetchColumn();
    $localProducts = (int)$pdo->query('SELECT COUNT(*) FROM cp_products')->fetchColumn();
    $activity = (int)$pdo->query('SELECT COUNT(*) FROM cp_activity_log')->fetchColumn();

    /*
     * Solicitudes de impresión todavía no convertidas en cotización.
     * Se excluyen solicitudes cerradas y spam.
     */
    $pendingPrintRequests = (int)$pdo->query(
        "SELECT COUNT(*)
         FROM cp_web_quote_requests
         WHERE converted_quote_id IS NULL
           AND status NOT IN ('closed', 'spam')"
    )->fetchColumn();

    /*
     * Órdenes que todavía están en Pendiente dentro del Kanban.
     * COALESCE permite detectar también órdenes que aún no tienen fila
     * en cp_order_status, ya que producción las considera 'pending'.
     */
    $pendingProductionOrders = (int)$pdo->query(
        "SELECT COUNT(*)
         FROM cp_orders o
         LEFT JOIN cp_order_status s ON s.order_id = o.id
         WHERE o.status NOT IN ('cancelled', 'delivered')
           AND COALESCE(s.stage, 'pending') = 'pending'"
    )->fetchColumn();

    try {
        $akaCustomers = (int)akaunting_db()->query(
            "SELECT COUNT(*)
             FROM ak4s_contacts
             WHERE company_id=1
               AND type='customer'
               AND deleted_at IS NULL"
        )->fetchColumn();

        $akaProducts = (int)akaunting_db()->query(
            "SELECT COUNT(*)
             FROM ak4s_items
             WHERE company_id=1
               AND enabled=1
               AND deleted_at IS NULL"
        )->fetchColumn();

        $akaStatus = 'Conectado';
    } catch (Throwable $e) {
        $akaStatus = 'Sin conexión';
    }
} catch (Throwable $e) {
    /*
     * El dashboard debe seguir cargando aunque falle una consulta
     * secundaria. Los contadores quedan en cero.
     */
}

require __DIR__ . '/../includes/header.php';
?>

<style>
.cp-dashboard-notifications {
    display:grid;
    gap:12px;
    margin:0 0 18px;
}

.cp-dashboard-notice {
    display:flex;
    align-items:center;
    gap:14px;
    padding:15px 18px;
    border:1px solid #2d6fa8;
    border-radius:14px;
    background:#0d2138;
    color:#fff;
    box-shadow:0 12px 30px rgba(0,0,0,.18);
}

.cp-dashboard-notice-icon {
    width:42px;
    height:42px;
    flex:0 0 42px;
    display:flex;
    align-items:center;
    justify-content:center;
    border-radius:12px;
    background:#123f70;
    font-size:21px;
}

.cp-dashboard-notice-body {
    flex:1;
    min-width:0;
}

.cp-dashboard-notice-body strong {
    display:block;
    margin-bottom:3px;
}

.cp-dashboard-notice-body span {
    color:#b9d3ed;
    font-size:13px;
}

.cp-dashboard-notice-actions {
    display:flex;
    gap:8px;
    flex-wrap:wrap;
}

.cp-dashboard-notice-btn {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    min-height:38px;
    padding:8px 13px;
    border-radius:10px;
    border:1px solid #2b79b8;
    background:#159fe6;
    color:#fff;
    text-decoration:none;
    font-weight:800;
    white-space:nowrap;
}

.cp-dashboard-notice-btn:hover {
    filter:brightness(1.08);
}

.cp-dashboard-notice-dismiss {
    border:0;
    background:transparent;
    color:#8fb4d8;
    cursor:pointer;
    font-size:20px;
    line-height:1;
    padding:5px;
}

.cp-dashboard-notice[data-kind="production"] {
    border-color:#4b7f54;
}

.cp-dashboard-notice[data-kind="production"] .cp-dashboard-notice-icon {
    background:#194629;
}

.cp-dashboard-notice[data-kind="production"] .cp-dashboard-notice-btn {
    background:#18864b;
    border-color:#249a5b;
}

@media (max-width:700px) {
    .cp-dashboard-notice {
        align-items:flex-start;
        flex-wrap:wrap;
    }

    .cp-dashboard-notice-body {
        flex-basis:calc(100% - 60px);
    }

    .cp-dashboard-notice-actions {
        width:100%;
        padding-left:56px;
    }
}
</style>

<div
    id="cp-dashboard-notifications"
    class="cp-dashboard-notifications"
    data-print-requests="<?=e((string)$pendingPrintRequests)?>"
    data-production-orders="<?=e((string)$pendingProductionOrders)?>"
></div>

<script>
(function () {
    'use strict';

    var container = document.getElementById('cp-dashboard-notifications');
    if (!container) return;

    var printRequests = parseInt(container.dataset.printRequests || '0', 10);
    var productionOrders = parseInt(container.dataset.productionOrders || '0', 10);

    var STORAGE_PRINT = 'cp_dashboard_seen_print_requests_v1';
    var STORAGE_PRODUCTION = 'cp_dashboard_seen_production_orders_v1';

    function readSeen(key) {
        try {
            return parseInt(window.localStorage.getItem(key) || '0', 10);
        } catch (e) {
            return 0;
        }
    }

    function writeSeen(key, value) {
        try {
            window.localStorage.setItem(key, String(value));
        } catch (e) {
            /* El popup sigue funcionando aunque localStorage no esté disponible. */
        }
    }

    function createNotice(kind, icon, title, message, href, buttonText) {
        var notice = document.createElement('div');
        notice.className = 'cp-dashboard-notice';
        notice.dataset.kind = kind;

        var iconEl = document.createElement('div');
        iconEl.className = 'cp-dashboard-notice-icon';
        iconEl.setAttribute('aria-hidden', 'true');
        iconEl.textContent = icon;

        var body = document.createElement('div');
        body.className = 'cp-dashboard-notice-body';

        var strong = document.createElement('strong');
        strong.textContent = title;

        var span = document.createElement('span');
        span.textContent = message;

        body.appendChild(strong);
        body.appendChild(span);

        var actions = document.createElement('div');
        actions.className = 'cp-dashboard-notice-actions';

        var link = document.createElement('a');
        link.className = 'cp-dashboard-notice-btn';
        link.href = href;
        link.textContent = buttonText;

        var close = document.createElement('button');
        close.type = 'button';
        close.className = 'cp-dashboard-notice-dismiss';
        close.setAttribute('aria-label', 'Cerrar notificación');
        close.textContent = '×';
        close.addEventListener('click', function () {
            notice.remove();
        });

        actions.appendChild(link);
        actions.appendChild(close);

        notice.appendChild(iconEl);
        notice.appendChild(body);
        notice.appendChild(actions);

        return notice;
    }

    /*
     * Las notificaciones se muestran en CADA visita al dashboard
     * mientras exista al menos una solicitud/orden pendiente.
     * No se utiliza localStorage para ocultarlas entre visitas.
     */
    if (printRequests > 0) {
        container.appendChild(createNotice(
            'print',
            '🖨️',
            'Nuevas solicitudes de impresión',
            printRequests === 1
                ? 'Tienes 1 solicitud pendiente de revisar.'
                : 'Tienes ' + printRequests + ' solicitudes pendientes de revisar.',
            '/admin/autorizaciones.php',
            'Ver solicitudes'
        ));
    }

    if (productionOrders > 0) {
        container.appendChild(createNotice(
            'production',
            '🔧',
            'Nueva orden pendiente en producción',
            productionOrders === 1
                ? 'Hay 1 orden esperando en la columna Pendiente del Kanban.'
                : 'Hay ' + productionOrders + ' órdenes esperando en la columna Pendiente del Kanban.',
            '/admin/produccion.php?stage=pending',
            'Ver producción'
        ));
    }

})();
</script>

<section class="hero">
    <div>
        <span class="eyebrow">NÚCLEO DE PLATAFORMA</span>
        <h2 style="margin:8px 0">Hola, <?=e(current_user()['name'])?> 👋</h2>
        <p class="muted">Fase 3 instalada. Esta pantalla confirma que la nueva plataforma funciona de forma independiente y puede consultar el histórico de Akaunting.</p>
    </div>
    <div class="notice">
        <strong>Akaunting:</strong>
        <span class="<?= $akaStatus === 'Conectado' ? 'ok' : 'danger' ?>"><?=e($akaStatus)?></span>
        <br>
        <span class="muted">Lectura de clientes y productos</span>
    </div>
</section>

<section class="cards">
    <div class="card">
        <span class="muted">Clientes locales</span>
        <div class="metric"><?=number_format($localCustomers)?></div>
        <span class="pill">Base Colibrí</span>
    </div>
    <div class="card">
        <span class="muted">Productos locales</span>
        <div class="metric"><?=number_format($localProducts)?></div>
        <span class="pill">Base Colibrí</span>
    </div>
    <div class="card">
        <span class="muted">Clientes históricos</span>
        <div class="metric"><?=number_format($akaCustomers)?></div>
        <span class="pill">Akaunting</span>
    </div>
    <div class="card">
        <span class="muted">Productos históricos</span>
        <div class="metric"><?=number_format($akaProducts)?></div>
        <span class="pill">Akaunting</span>
    </div>
</section>

<section class="grid2">
    <div class="card">
        <h3>Arquitectura inicial</h3>
        <p class="muted">La plataforma nueva trabaja sobre <strong>colibrip_abcsistema</strong>. Akaunting se consulta aparte y no se modifica desde esta fase.</p>
        <table class="table">
            <tr><th>Componente</th><th>Estado</th></tr>
            <tr><td>Base nueva</td><td class="ok">✓ Operativa</td></tr>
            <tr><td>Sesiones / Login</td><td class="ok">✓ Operativa</td></tr>
            <tr><td>Lectura Akaunting</td><td class="ok">✓ Operativa</td></tr>
            <tr><td>Registro de actividad</td><td class="ok">✓ Operativa</td></tr>
        </table>
    </div>

    <div class="card">
        <h3>Próximas fases</h3>
        <table class="table">
            <tr><td>02</td><td>Clientes</td><td><span class="pill">Operativa</span></td></tr>
            <tr><td>03</td><td>Catálogo</td><td><span class="pill">Operativa</span></td></tr>
            <tr><td>04</td><td>Cotizador</td><td><span class="pill">Pendiente</span></td></tr>
            <tr><td>05</td><td>Cotizaciones</td><td><span class="pill">Pendiente</span></td></tr>
        </table>
    </div>
</section>

<?php require __DIR__ . '/../includes/footer.php'; ?>
