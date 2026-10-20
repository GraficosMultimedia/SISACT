<?php
declare(strict_types=1);

require_once __DIR__ . '/impresiones.php';

/**
 * SISACT · Impresiones Rollos CRUD V3.1.1
 *
 * Complemento para la V3 ya instalada.
 * NO reemplaza las funciones de cálculo/costeo V3.
 */

function print_roll_v311_selectable_rolls(): array
{
    return db()->query(
        "SELECT
            id,
            roll_name,
            initial_m,
            remaining_m,
            width_m,
            cost_per_linear_m,
            opened_at,
            status,
            is_archived
         FROM cp_print_rolls
         WHERE is_archived=0
         ORDER BY
            CASE WHEN status='active' THEN 0 ELSE 1 END,
            id DESC"
    )->fetchAll() ?: [];
}

function print_roll_v311_active_roll(): ?array
{
    $st = db()->query(
        "SELECT
            id,
            roll_name,
            initial_m,
            remaining_m,
            width_m,
            cost_per_linear_m,
            opened_at,
            status,
            is_archived
         FROM cp_print_rolls
         WHERE is_archived=0
           AND status='active'
         ORDER BY id DESC
         LIMIT 1"
    );

    $row = $st->fetch();
    return $row ?: null;
}

function print_roll_v311_management_rows(): array
{
    return db()->query(
        "SELECT
            r.id,
            r.roll_name,
            r.initial_m,
            r.remaining_m,
            r.width_m,
            r.cost_per_linear_m,
            r.opened_at,
            r.status,
            r.is_archived,
            COUNT(l.id) AS jobs,
            COALESCE(SUM(l.linear_m),0) AS logged_m
         FROM cp_print_rolls r
         LEFT JOIN cp_print_meter_logs l
            ON l.roll_id=r.id
         GROUP BY
            r.id,
            r.roll_name,
            r.initial_m,
            r.remaining_m,
            r.width_m,
            r.cost_per_linear_m,
            r.opened_at,
            r.status,
            r.is_archived
         ORDER BY r.is_archived ASC, r.id DESC"
    )->fetchAll() ?: [];
}

function print_roll_v311_usage_breakdown(): array
{
    $rows = db()->query(
        "SELECT
            r.id,
            r.roll_name,
            r.initial_m,
            r.remaining_m,
            r.opened_at,
            r.status,
            r.width_m,
            r.cost_per_linear_m,
            COALESCE(SUM(l.waste_m),0) AS waste_m,
            COALESCE(SUM(CASE WHEN l.result_status='good' THEN l.linear_m ELSE 0 END),0) AS good_m,
            COUNT(l.id) AS jobs
         FROM cp_print_rolls r
         LEFT JOIN cp_print_meter_logs l
            ON l.roll_id=r.id
         WHERE r.is_archived=0
         GROUP BY
            r.id,
            r.roll_name,
            r.initial_m,
            r.remaining_m,
            r.opened_at,
            r.status,
            r.width_m,
            r.cost_per_linear_m
         ORDER BY
            CASE WHEN r.status='active' THEN 0 ELSE 1 END,
            r.id DESC"
    )->fetchAll() ?: [];

    $totalInitial = 0.0;
    $totalUsed = 0.0;
    $totalRemaining = 0.0;
    $totalWaste = 0.0;
    $totalGood = 0.0;
    $totalJobs = 0;

    foreach ($rows as &$row) {
        $initial = max(0.0, (float)$row['initial_m']);
        $remaining = max(0.0, (float)$row['remaining_m']);
        $used = max(0.0, $initial - $remaining);

        $row['initial_m'] = round($initial, 3);
        $row['remaining_m'] = round($remaining, 3);
        $row['used_m'] = round($used, 3);
        $row['used_pct'] = $initial > 0
            ? round(($used / $initial) * 100, 1)
            : 0.0;
        $row['remaining_pct'] = $initial > 0
            ? round(($remaining / $initial) * 100, 1)
            : 0.0;
        $row['waste_m'] = round((float)$row['waste_m'], 3);
        $row['good_m'] = round((float)$row['good_m'], 3);
        $row['jobs'] = (int)$row['jobs'];

        if ($row['status'] === 'empty' || $remaining <= 0.0001) {
            $row['health'] = 'empty';
            $row['health_label'] = 'Agotado';
        } elseif ($row['used_pct'] >= 80) {
            $row['health'] = 'critical';
            $row['health_label'] = 'Casi agotado';
        } elseif ($row['used_pct'] >= 60) {
            $row['health'] = 'warning';
            $row['health_label'] = 'Consumo alto';
        } else {
            $row['health'] = 'normal';
            $row['health_label'] = 'Disponible';
        }

        $totalInitial += $initial;
        $totalUsed += $used;
        $totalRemaining += $remaining;
        $totalWaste += (float)$row['waste_m'];
        $totalGood += (float)$row['good_m'];
        $totalJobs += (int)$row['jobs'];
    }
    unset($row);

    return [
        'rolls' => $rows,
        'initial_m' => round($totalInitial, 3),
        'used_m' => round($totalUsed, 3),
        'remaining_m' => round($totalRemaining, 3),
        'waste_m' => round($totalWaste, 3),
        'good_m' => round($totalGood, 3),
        'jobs' => $totalJobs,
        'used_pct' => $totalInitial > 0
            ? round(($totalUsed / $totalInitial) * 100, 1)
            : 0.0,
        'remaining_pct' => $totalInitial > 0
            ? round(($totalRemaining / $totalInitial) * 100, 1)
            : 0.0,
        'waste_pct' => $totalUsed > 0
            ? round(($totalWaste / $totalUsed) * 100, 1)
            : 0.0,
    ];
}

function print_roll_v311_get(int $rollId, bool $lock = false): ?array
{
    $sql =
        "SELECT
            id,
            roll_name,
            initial_m,
            remaining_m,
            width_m,
            cost_per_linear_m,
            opened_at,
            status,
            is_archived
         FROM cp_print_rolls
         WHERE id=?"
        . ($lock ? " FOR UPDATE" : "");

    $st = db()->prepare($sql);
    $st->execute([$rollId]);

    return $st->fetch() ?: null;
}

function print_roll_v311_audit(
    PDO $pdo,
    int $rollId,
    string $action,
    ?array $before,
    ?array $after,
    string $note = ''
): void {
    $uid = (int)(current_user()['id'] ?? 0);

    $st = $pdo->prepare(
        "INSERT INTO cp_print_roll_adjustments
         (
            roll_id,
            action_name,
            before_json,
            after_json,
            note,
            created_by,
            created_at
         )
         VALUES(?,?,?,?,?,?,NOW())"
    );

    $st->execute([
        $rollId > 0 ? $rollId : null,
        $action,
        $before
            ? json_encode($before, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
            : null,
        $after
            ? json_encode($after, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES)
            : null,
        trim($note) !== '' ? trim($note) : null,
        $uid > 0 ? $uid : null,
    ]);
}

function print_roll_v311_update(
    int $rollId,
    string $name,
    float $initialM,
    float $remainingM,
    float $widthM,
    float $costPerLinearM,
    string $note = ''
): void {
    $name = trim($name);
    $initialM = round(max(0.0, $initialM), 3);
    $remainingM = round(max(0.0, $remainingM), 3);
    $widthM = round(max(0.0, $widthM), 3);
    $costPerLinearM = round(max(0.0, $costPerLinearM), 2);

    if ($rollId <= 0) {
        throw new RuntimeException('Rollo inválido.');
    }
    if ($name === '') {
        throw new RuntimeException('El nombre del rollo no puede quedar vacío.');
    }
    if ($initialM <= 0) {
        throw new RuntimeException('Los metros iniciales deben ser mayores que 0.');
    }
    if ($remainingM > $initialM + 0.0001) {
        throw new RuntimeException(
            'Los metros disponibles no pueden superar los metros iniciales.'
        );
    }
    if ($widthM <= 0) {
        throw new RuntimeException('El ancho útil debe ser mayor que 0.');
    }

    $pdo = db();
    $pdo->beginTransaction();

    try {
        $st = $pdo->prepare(
            "SELECT *
             FROM cp_print_rolls
             WHERE id=?
             FOR UPDATE"
        );
        $st->execute([$rollId]);
        $before = $st->fetch();

        if (!$before) {
            throw new RuntimeException('El rollo ya no existe.');
        }

        $dup = $pdo->prepare(
            "SELECT COUNT(*)
             FROM cp_print_rolls
             WHERE id<>?
               AND roll_name=?
               AND is_archived=0"
        );
        $dup->execute([$rollId, $name]);

        if ((int)$dup->fetchColumn() > 0) {
            throw new RuntimeException(
                'Ya existe otro rollo no archivado con ese nombre.'
            );
        }

        $status = $remainingM <= 0.0001
            ? 'empty'
            : 'active';

        $pdo->prepare(
            "UPDATE cp_print_rolls
             SET
                roll_name=?,
                initial_m=?,
                remaining_m=?,
                width_m=?,
                cost_per_linear_m=?,
                status=?,
                updated_at=NOW()
             WHERE id=?"
        )->execute([
            $name,
            $initialM,
            $remainingM,
            $widthM,
            $costPerLinearM,
            $status,
            $rollId,
        ]);

        $after = [
            'id' => $rollId,
            'roll_name' => $name,
            'initial_m' => $initialM,
            'remaining_m' => $remainingM,
            'width_m' => $widthM,
            'cost_per_linear_m' => $costPerLinearM,
            'status' => $status,
            'is_archived' => (int)($before['is_archived'] ?? 0),
        ];

        print_roll_v311_audit(
            $pdo,
            $rollId,
            'edit',
            $before,
            $after,
            $note
        );

        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

function print_roll_v311_archive(int $rollId, string $note = ''): void
{
    $pdo = db();
    $pdo->beginTransaction();

    try {
        $st = $pdo->prepare(
            "SELECT *
             FROM cp_print_rolls
             WHERE id=?
             FOR UPDATE"
        );
        $st->execute([$rollId]);
        $before = $st->fetch();

        if (!$before) {
            throw new RuntimeException('El rollo no existe.');
        }

        $pdo->prepare(
            "UPDATE cp_print_rolls
             SET is_archived=1, updated_at=NOW()
             WHERE id=?"
        )->execute([$rollId]);

        $after = $before;
        $after['is_archived'] = 1;

        print_roll_v311_audit(
            $pdo,
            $rollId,
            'archive',
            $before,
            $after,
            $note
        );

        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

function print_roll_v311_restore(int $rollId, string $note = ''): void
{
    $pdo = db();
    $pdo->beginTransaction();

    try {
        $st = $pdo->prepare(
            "SELECT *
             FROM cp_print_rolls
             WHERE id=?
             FOR UPDATE"
        );
        $st->execute([$rollId]);
        $before = $st->fetch();

        if (!$before) {
            throw new RuntimeException('El rollo no existe.');
        }

        $dup = $pdo->prepare(
            "SELECT COUNT(*)
             FROM cp_print_rolls
             WHERE id<>?
               AND roll_name=?
               AND is_archived=0"
        );
        $dup->execute([$rollId, (string)$before['roll_name']]);

        if ((int)$dup->fetchColumn() > 0) {
            throw new RuntimeException(
                'Ya existe otro rollo no archivado con el mismo nombre.'
            );
        }

        $pdo->prepare(
            "UPDATE cp_print_rolls
             SET is_archived=0, updated_at=NOW()
             WHERE id=?"
        )->execute([$rollId]);

        $after = $before;
        $after['is_archived'] = 0;

        print_roll_v311_audit(
            $pdo,
            $rollId,
            'restore',
            $before,
            $after,
            $note
        );

        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

function print_roll_v311_delete(int $rollId, string $note = ''): void
{
    $pdo = db();
    $pdo->beginTransaction();

    try {
        $st = $pdo->prepare(
            "SELECT *
             FROM cp_print_rolls
             WHERE id=?
             FOR UPDATE"
        );
        $st->execute([$rollId]);
        $before = $st->fetch();

        if (!$before) {
            throw new RuntimeException('El rollo ya no existe.');
        }

        $jobs = $pdo->prepare(
            "SELECT COUNT(*)
             FROM cp_print_meter_logs
             WHERE roll_id=?"
        );
        $jobs->execute([$rollId]);

        if ((int)$jobs->fetchColumn() > 0) {
            throw new RuntimeException(
                'Este rollo tiene historial. Debes archivarlo para conservar la trazabilidad.'
            );
        }

        print_roll_v311_audit(
            $pdo,
            $rollId,
            'delete',
            $before,
            null,
            $note
        );

        $pdo->prepare(
            "DELETE FROM cp_print_rolls
             WHERE id=?"
        )->execute([$rollId]);

        $pdo->commit();
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

function print_roll_v311_assert_selectable(int $rollId): void
{
    if ($rollId <= 0) {
        throw new RuntimeException('Selecciona un rollo válido.');
    }

    $st = db()->prepare(
        "SELECT status,is_archived
         FROM cp_print_rolls
         WHERE id=?
         LIMIT 1"
    );
    $st->execute([$rollId]);
    $row = $st->fetch();

    if (!$row) {
        throw new RuntimeException('El rollo seleccionado ya no existe.');
    }

    if ((int)$row['is_archived'] === 1) {
        throw new RuntimeException(
            'El rollo seleccionado está archivado y no puede recibir nuevos trabajos.'
        );
    }

    if ((string)$row['status'] !== 'active') {
        throw new RuntimeException(
            'El rollo seleccionado ya no está activo.'
        );
    }
}
