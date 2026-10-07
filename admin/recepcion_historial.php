<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/bootstrap.php';

$title = 'Historial de impresiones';
require_once __DIR__ . '/../includes/header.php';

$db = cp_db();
$rows = $db->query(
    "SELECT r.*, COUNT(i.id) AS files, COALESCE(SUM(i.page_count),0) AS pages
     FROM cp_print_requests r
     LEFT JOIN cp_print_request_items i ON i.request_id = r.id
     WHERE r.archive_status='archived'
     GROUP BY r.id
     ORDER BY r.archived_at DESC, r.id DESC"
)->fetchAll();
?>

<section class="card">
    <div class="card-header">
        <div>
            <h2>Historial de impresiones</h2>
            <p>Trabajos finalizados cuyos archivos y registros fueron conservados.</p>
        </div>
        <div class="actions">
            <a class="btn btn-secondary" href="recepcion_impresiones.php">Recepción</a>
            <a class="btn btn-secondary" href="impresion_precios.php">Precios</a>
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
                    <th>Total</th>
                    <th>Archivado</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
            <?php foreach ($rows as $r): ?>
                <tr>
                    <td><strong>#<?= (int)$r['id'] ?></strong></td>
                    <td><?= cp_e($r['customer_name']) ?><br><small><?= cp_e($r['customer_phone']) ?></small></td>
                    <td><?= (int)$r['files'] ?></td>
                    <td><?= (int)$r['pages'] ?></td>
                    <td><strong><?= cp_money($r['total_estimate']) ?></strong></td>
                    <td><?= cp_e($r['archived_at'] ?? '') ?></td>
                    <td><a class="btn btn-secondary btn-sm" href="recepcion_detalle.php?id=<?= (int)$r['id'] ?>">Ver detalle</a></td>
                </tr>
            <?php endforeach; ?>
            <?php if (!$rows): ?>
                <tr><td colspan="7">No hay trabajos archivados.</td></tr>
            <?php endif; ?>
            </tbody>
        </table>
    </div>
</section>

<?php require_once __DIR__ . '/../includes/footer.php'; ?>
