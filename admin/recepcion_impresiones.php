<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/bootstrap.php';

$title = 'Recepción de impresiones';
require_once __DIR__ . '/../includes/header.php';

$db = cp_db();
$requests = $db->query(
    "SELECT r.*, COUNT(i.id) AS files, COALESCE(SUM(i.page_count),0) AS pages
     FROM cp_print_requests r
     LEFT JOIN cp_print_request_items i ON i.request_id = r.id
     WHERE COALESCE(r.archive_status,'active')='active'
     GROUP BY r.id
     ORDER BY r.id DESC"
)->fetchAll();
?>

<section class="card">
    <div class="card-header">
        <div>
            <h2>Recepción de impresiones</h2>
            <p>Cada archivo conserva sus páginas, configuración y costo.</p>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="impresion_precios.php">Precios</a>
            <a class="btn btn-secondary" href="recepcion_historial.php">Historial</a>
            <a class="btn btn-primary" href="../solicitar_impresion.php">Ver formulario</a>
        </div>
    </div>

    <div class="table-responsive">
        <table class="admin-table">
            <thead>
                <tr>
                    <th>Folio</th>
                    <th>Cliente</th>
                    <th>Archivos</th>
                    <th>Páginas</th>
                    <th>Estado</th>
                    <th>Total</th>
                    <th>Fecha</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <?php foreach ($requests as $r): ?>
                <tr>
                    <td><strong>#<?= (int)$r['id'] ?></strong></td>
                    <td>
                        <?= cp_e($r['customer_name']) ?><br>
                        <small><?= cp_e($r['customer_email']) ?> · <?= cp_e($r['customer_phone']) ?></small>
                    </td>
                    <td><?= (int)$r['files'] ?></td>
                    <td><?= (int)$r['pages'] ?></td>
                    <td><?= cp_e($r['status']) ?></td>
                    <td><strong><?= cp_money($r['total_estimate']) ?></strong></td>
                    <td><?= cp_e($r['created_at']) ?></td>
                    <td><a class="btn btn-secondary btn-sm" href="recepcion_detalle.php?id=<?= (int)$r['id'] ?>">Ver detalle</a></td>
                </tr>
            <?php endforeach; ?>
            <?php if (!$requests): ?>
                <tr><td colspan="8">No hay trabajos pendientes de recepción.</td></tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</section>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
