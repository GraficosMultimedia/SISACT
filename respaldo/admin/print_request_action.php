<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';

cp_check_csrf($_POST['csrf'] ?? null);
$db = cp_db();
$id = (int)($_POST['id'] ?? 0);
$action = (string)($_POST['action'] ?? '');

if ($id <= 0) cp_redirect('recepcion_impresiones.php?error=Solicitud inválida');

$st = $db->prepare('SELECT * FROM cp_print_requests WHERE id=? LIMIT 1');
$st->execute([$id]);
$request = $st->fetch();
if (!$request) cp_redirect('recepcion_impresiones.php?error=Solicitud no encontrada');

function print_request_file_path(string $storedPath): ?string {
    $root = realpath(__DIR__ . '/..');
    if (!$root) return null;
    $path = $storedPath;
    if (str_starts_with($path, '/')) $path = ltrim($path, '/');
    $candidate = realpath($root . '/' . $path);
    $uploads = realpath($root . '/uploads');
    if (!$candidate || !$uploads) return null;
    if (!str_starts_with($candidate, $uploads . DIRECTORY_SEPARATOR) || !is_file($candidate)) return null;
    return $candidate;
}

function print_request_archive_path(string $storedPath, int $id): ?string {
    $root = realpath(__DIR__ . '/..');
    if (!$root) return null;
    $source = print_request_file_path($storedPath);
    if (!$source) return null;
    $name = basename($source);
    $archiveDir = $root . '/uploads/print_requests_archived/' . $id;
    if (!is_dir($archiveDir) && !mkdir($archiveDir, 0775, true) && !is_dir($archiveDir)) {
        throw new RuntimeException('No fue posible crear la carpeta de archivo.');
    }
    $target = $archiveDir . '/' . $name;
    if (!rename($source, $target)) throw new RuntimeException('No fue posible mover el archivo al historial.');
    return 'uploads/print_requests_archived/' . $id . '/' . $name;
}

try {
    if ($action === 'complete') {
        $db->prepare("UPDATE cp_print_requests SET status='completed', updated_at=NOW() WHERE id=?")->execute([$id]);
        if (function_exists('log_activity')) log_activity('update','print_reception','Solicitud de impresión #'.$id.' marcada como completada.');
        cp_redirect('recepcion_detalle.php?id='.$id.'&ok=completed');
    }

    if ($action === 'archive') {
        if (($request['status'] ?? '') !== 'completed') cp_redirect('recepcion_detalle.php?id='.$id.'&error=Primero marca la impresión como realizada.');

        $files = $db->prepare('SELECT id,stored_path FROM cp_web_quote_files WHERE request_id=? ORDER BY id');
        $files->execute([$id]);
        $rows = $files->fetchAll();
        $moved = [];
        foreach ($rows as $file) {
            $newPath = print_request_archive_path((string)$file['stored_path'], $id);
            if ($newPath) {
                $db->prepare('UPDATE cp_web_quote_files SET stored_path=? WHERE id=?')->execute([$newPath, (int)$file['id']]);
                $moved[] = $newPath;
            }
        }
        $db->prepare("UPDATE cp_print_requests SET archive_status='archived', archived_at=NOW(), archived_by=NULL, updated_at=NOW() WHERE id=?")->execute([$id]);
        if (function_exists('log_activity')) log_activity('update','print_reception','Solicitud de impresión #'.$id.' archivada.');
        cp_redirect('recepcion_detalle.php?id='.$id.'&ok=archived');
    }

    if ($action === 'delete') {
        if (($request['status'] ?? '') !== 'completed') cp_redirect('recepcion_detalle.php?id='.$id.'&error=Solo puedes eliminar trabajos con impresión realizada.');

        $files = $db->prepare('SELECT id,stored_path,quote_id,order_id FROM cp_web_quote_files WHERE request_id=? ORDER BY id');
        $files->execute([$id]);
        $rows = $files->fetchAll();
        foreach ($rows as $file) {
            if (!empty($file['quote_id']) || !empty($file['order_id'])) {
                cp_redirect('recepcion_detalle.php?id='.$id.'&error=Este trabajo está vinculado a una cotización u orden y no puede eliminarse completamente. Puedes conservarlo o eliminar solo el archivo desde el módulo correspondiente.');
            }
        }

        $db->beginTransaction();
        foreach ($rows as $file) {
            $path = print_request_file_path((string)$file['stored_path']);
            if ($path && is_file($path)) @unlink($path);
        }
        $db->prepare('DELETE FROM cp_print_request_items WHERE request_id=?')->execute([$id]);
        $db->prepare('DELETE FROM cp_web_quote_files WHERE request_id=?')->execute([$id]);
        $db->prepare('DELETE FROM cp_print_requests WHERE id=?')->execute([$id]);
        $db->commit();
        if (function_exists('log_activity')) log_activity('delete','print_reception','Solicitud de impresión #'.$id.' eliminada junto con sus archivos.');
        cp_redirect('recepcion_impresiones.php?ok=deleted');
    }

    cp_redirect('recepcion_detalle.php?id='.$id.'&error=Acción no válida');
} catch (Throwable $e) {
    if ($db->inTransaction()) $db->rollBack();
    cp_redirect('recepcion_detalle.php?id='.$id.'&error='.rawurlencode($e->getMessage()));
}
