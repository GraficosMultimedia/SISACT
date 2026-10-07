<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';

require_auth();

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: /admin/clientes.php');
    exit;
}

// DESACTIVADO: desde la migración de clientes, cp_customers es el catálogo maestro local.
http_response_code(410);
exit('La sincronización de clientes con Akaunting está desactivada. Use el catálogo local de Colibrí Print.');

if (!csrf_check($_POST['_csrf'] ?? null)) {
    http_response_code(400);
    exit('Sesión expirada. Recarga la página e inténtalo nuevamente.');
}

$pdo = db();

try {
    $akaunting = akaunting_db();

    /*
     * Sincronización unidireccional:
     * Akaunting -> Colibrí Print.
     * Nunca modifica clientes source_type=local.
     *
     * Si cp_customers tiene source_id, se usa para conservar la relación
     * con ak4s_contacts.id. Si no existe, se utiliza nombre + teléfono/correo
     * como llave de compatibilidad con instalaciones anteriores.
     */
    $columns = [];
    $columnStmt = $pdo->query("SHOW COLUMNS FROM cp_customers");
    foreach ($columnStmt->fetchAll(PDO::FETCH_ASSOC) as $col) {
        $columns[(string)$col['Field']] = true;
    }

    $hasSourceId = isset($columns['source_id']);

    $contacts = $akaunting->query("SELECT * FROM ak4s_contacts ORDER BY id ASC")->fetchAll(PDO::FETCH_ASSOC);

    $new = 0;
    $updated = 0;
    $unchanged = 0;
    $errors = 0;

    foreach ($contacts as $contact) {
        try {
            $sourceId = isset($contact['id']) ? (int)$contact['id'] : 0;
            $name = trim((string)($contact['name'] ?? $contact['company'] ?? ''));
            if ($name === '') {
                $unchanged++;
                continue;
            }

            $email = trim((string)($contact['email'] ?? ''));
            $phone = trim((string)($contact['phone'] ?? ''));
            $tax = trim((string)($contact['tax_number'] ?? $contact['tax_id'] ?? ''));
            $address = trim((string)($contact['address'] ?? ''));
            $city = trim((string)($contact['city'] ?? ''));
            $state = trim((string)($contact['state'] ?? ''));
            $zip = trim((string)($contact['zip_code'] ?? $contact['postal_code'] ?? ''));
            $country = strtoupper(trim((string)($contact['country'] ?? 'MX')));
            if ($country === '') $country = 'MX';

            $existing = null;

            if ($hasSourceId && $sourceId > 0) {
                $stmt = $pdo->prepare(
                    "SELECT * FROM cp_customers
                     WHERE source_type='akaunting' AND source_id=?
                     LIMIT 1"
                );
                $stmt->execute([$sourceId]);
                $existing = $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
            }

            if (!$existing) {
                $conditions = [];
                $params = [];

                if ($email !== '') {
                    $conditions[] = "(email IS NOT NULL AND email <> '' AND email=?)";
                    $params[] = $email;
                }
                if ($phone !== '') {
                    $conditions[] = "(phone IS NOT NULL AND phone <> '' AND phone=?)";
                    $params[] = $phone;
                }

                if ($conditions) {
                    $stmt = $pdo->prepare(
                        "SELECT * FROM cp_customers
                         WHERE source_type='akaunting'
                         AND (" . implode(' OR ', $conditions) . ")
                         ORDER BY id ASC
                         LIMIT 1"
                    );
                    $stmt->execute($params);
                    $existing = $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
                }
            }

            if (!$existing) {
                $stmt = $pdo->prepare(
                    "SELECT * FROM cp_customers
                     WHERE source_type='akaunting' AND name=?
                     ORDER BY id ASC
                     LIMIT 1"
                );
                $stmt->execute([$name]);
                $existing = $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
            }

            $values = [
                'name'       => $name,
                'email'      => $email !== '' ? $email : null,
                'tax_number' => $tax !== '' ? $tax : null,
                'phone'      => $phone !== '' ? $phone : null,
                'address'    => $address !== '' ? $address : null,
                'city'       => $city !== '' ? $city : null,
                'zip_code'   => $zip !== '' ? $zip : null,
                'state'      => $state !== '' ? $state : null,
                'country'    => $country,
                'enabled'    => 1,
            ];

            if ($existing) {
                $changed = false;
                foreach ($values as $field => $value) {
                    $old = $existing[$field] ?? null;
                    if ((string)$old !== (string)$value) {
                        $changed = true;
                        break;
                    }
                }

                if (!$changed && $hasSourceId && $sourceId > 0 && (int)($existing['source_id'] ?? 0) !== $sourceId) {
                    $changed = true;
                }

                if ($changed) {
                    $sets = [];
                    $params = [];
                    foreach ($values as $field => $value) {
                        if (isset($columns[$field])) {
                            $sets[] = "{$field}=?";
                            $params[] = $value;
                        }
                    }

                    if ($hasSourceId && $sourceId > 0) {
                        $sets[] = "source_id=?";
                        $params[] = $sourceId;
                    }

                    if (isset($columns['updated_at'])) {
                        $sets[] = "updated_at=NOW()";
                    }

                    $params[] = (int)$existing['id'];

                    if ($sets) {
                        $stmt = $pdo->prepare(
                            "UPDATE cp_customers SET " . implode(', ', $sets) . " WHERE id=?"
                        );
                        $stmt->execute($params);
                    }
                    $updated++;
                } else {
                    $unchanged++;
                }
            } else {
                $fields = ['source_type'];
                $placeholders = ['?'];
                $params = ['akaunting'];

                foreach ($values as $field => $value) {
                    if (isset($columns[$field])) {
                        $fields[] = $field;
                        $placeholders[] = '?';
                        $params[] = $value;
                    }
                }

                if ($hasSourceId && $sourceId > 0) {
                    $fields[] = 'source_id';
                    $placeholders[] = '?';
                    $params[] = $sourceId;
                }

                if (isset($columns['created_at'])) {
                    $fields[] = 'created_at';
                    $placeholders[] = 'NOW()';
                }
                if (isset($columns['updated_at'])) {
                    $fields[] = 'updated_at';
                    $placeholders[] = 'NOW()';
                }

                $stmt = $pdo->prepare(
                    "INSERT INTO cp_customers (" . implode(',', $fields) . ")
                     VALUES (" . implode(',', $placeholders) . ")"
                );
                $stmt->execute($params);
                $new++;
            }
        } catch (Throwable $contactError) {
            $errors++;
        }
    }

    if (function_exists('log_activity')) {
        log_activity(
            'sync',
            'customers',
            "Sincronización Akaunting: nuevos={$new}, actualizados={$updated}, sin cambios={$unchanged}, errores={$errors}"
        );
    }

    $message = "Sincronización completada. Nuevos: {$new} · Actualizados: {$updated} · Sin cambios: {$unchanged} · Errores: {$errors}";
    header('Location: /admin/clientes.php?sync=' . urlencode($message));
    exit;
} catch (Throwable $e) {
    header('Location: /admin/clientes.php?sync_error=' . urlencode($e->getMessage()));
    exit;
}
