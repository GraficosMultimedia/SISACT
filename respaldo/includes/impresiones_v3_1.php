<?php
declare(strict_types=1);

require_once __DIR__ . '/impresiones.php';

/**
 * SISACT · Impresiones V3.1
 * Extensión compatible con el módulo actual.
 *
 * - No redefine las funciones V1/V2.
 * - Conserva cp_print_rolls y cp_print_meter_logs como tablas principales.
 * - Añade dimensiones, paneles, saldo antes/después y costo histórico.
 */

function print_meter_v31_num(mixed $value): float
{
    $raw = trim((string)$value);
    if ($raw === '') {
        return 0.0;
    }

    $raw = str_replace(',', '.', $raw);
    return is_numeric($raw) ? (float)$raw : 0.0;
}

function print_meter_v31_normalize(array $src): array
{
    $base = print_meter_normalize($src);

    $jobWidthM = max(0.0, print_meter_v31_num($src['job_width_m'] ?? 0));
    $jobLengthM = max(0.0, print_meter_v31_num($src['job_length_m'] ?? 0));

    if ($jobLengthM <= 0 && (float)$base['job_length_mm'] > 0) {
        $jobLengthM = round((float)$base['job_length_mm'] / 1000, 3);
    }

    $rollWidthM = max(0.0, print_meter_v31_num($src['roll_width_m'] ?? 0));

    $costRaw = trim((string)($src['cost_per_linear_m'] ?? ''));
    $costSet = $costRaw !== '';
    $costPerLinearM = max(0.0, print_meter_v31_num($costRaw));

    $panels = max(1, (int)($src['panels'] ?? 1));

    $base['roll_name'] = trim((string)($src['roll_name'] ?? ''));
    $base['job_width_m'] = round($jobWidthM, 3);
    $base['job_length_m'] = round($jobLengthM, 3);
    $base['area_m2'] = round($jobWidthM * $jobLengthM, 3);
    $base['roll_width_m'] = round($rollWidthM, 3);
    $base['panels'] = $panels;
    $base['cost_per_linear_m'] = round($costPerLinearM, 2);
    $base['cost_per_linear_m_set'] = $costSet;

    return $base;
}

function print_meter_v31_create_roll(
    string $name,
    float $meters,
    float $widthM,
    float $costPerLinearM
): int {
    $name = trim($name);
    $meters = round(max(0.0, $meters), 3);
    $widthM = round(max(0.0, $widthM), 3);
    $costPerLinearM = round(max(0.0, $costPerLinearM), 2);

    if ($name === '') {
        throw new RuntimeException('Indica el nombre o identificación del rollo.');
    }

    if ($meters <= 0) {
        throw new RuntimeException('La longitud inicial del rollo debe ser mayor que 0.');
    }

    if ($widthM <= 0) {
        throw new RuntimeException('Captura el ancho útil del rollo en metros.');
    }

    $pdo = db();

    $dup = $pdo->prepare(
        "SELECT COUNT(*)
         FROM cp_print_rolls
         WHERE roll_name=?
           AND is_archived=0"
    );
    $dup->execute([$name]);

    if ((int)$dup->fetchColumn() > 0) {
        throw new RuntimeException('Ya existe un rollo no archivado con ese nombre.');
    }

    $st = $pdo->prepare(
        "INSERT INTO cp_print_rolls
         (
            roll_name,
            initial_m,
            remaining_m,
            width_m,
            cost_per_linear_m,
            opened_at,
            status,
            created_by,
            created_at,
            updated_at,
            is_archived
         )
         VALUES(?,?,?,?,?,NOW(),'active',?,NOW(),NOW(),0)"
    );

    $uid = (int)(current_user()['id'] ?? 0);

    $st->execute([
        $name,
        $meters,
        $meters,
        $widthM,
        $costPerLinearM,
        $uid > 0 ? $uid : null,
    ]);

    return (int)$pdo->lastInsertId();
}

function print_meter_v31_active_rolls(): array
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
           AND status='active'
         ORDER BY id DESC"
    )->fetchAll() ?: [];
}

function print_meter_v31_active_roll(): ?array
{
    $rows = print_meter_v31_active_rolls();
    return $rows[0] ?? null;
}

function print_meter_v31_roll_profiles(): array
{
    $rows = print_meter_v31_active_rolls();
    $out = [];

    foreach ($rows as $row) {
        $out[(int)$row['id']] = [
            'id' => (int)$row['id'],
            'name' => (string)$row['roll_name'],
            'initial_m' => round((float)$row['initial_m'], 3),
            'remaining_m' => round((float)$row['remaining_m'], 3),
            'width_m' => round((float)$row['width_m'], 3),
            'cost_per_linear_m' => round((float)$row['cost_per_linear_m'], 2),
            'status' => (string)$row['status'],
        ];
    }

    return $out;
}

function print_meter_v31_rolls_for_management(): array
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

function print_meter_v31_usage_breakdown(): array
{
    $rows = db()->query(
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
            r.width_m,
            r.cost_per_linear_m,
            r.opened_at,
            r.status,
            r.is_archived
         ORDER BY CASE WHEN r.status='active' THEN 0 ELSE 1 END, r.id DESC"
    )->fetchAll() ?: [];

    $totalUsed = 0.0;
    $totalRemaining = 0.0;
    $totalInitial = 0.0;
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
        $row['used_pct'] = $initial > 0 ? round(($used / $initial) * 100, 1) : 0.0;
        $row['remaining_pct'] = $initial > 0 ? round(($remaining / $initial) * 100, 1) : 0.0;
        $row['waste_m'] = round((float)$row['waste_m'], 3);
        $row['good_m'] = round((float)$row['good_m'], 3);
        $row['jobs'] = (int)$row['jobs'];

        if ((string)$row['status'] === 'empty' || $remaining <= 0.0001) {
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
        'used_pct' => $totalInitial > 0 ? round(($totalUsed / $totalInitial) * 100, 1) : 0.0,
        'remaining_pct' => $totalInitial > 0 ? round(($totalRemaining / $totalInitial) * 100, 1) : 0.0,
        'waste_pct' => $totalUsed > 0 ? round(($totalWaste / $totalUsed) * 100, 1) : 0.0,
    ];
}

function print_meter_v31_rows(int $limit = 100): array
{
    $limit = max(1, min(500, $limit));

    return db()->query(
        "SELECT
            l.id,
            l.printed_at,
            l.job_name,
            l.job_length_mm,
            l.job_width_m,
            l.job_length_m,
            l.area_m2,
            l.panels,
            l.roll_width_m,
            l.linear_m_before,
            l.linear_m,
            l.linear_m_after,
            l.cost_per_linear_m,
            l.material_cost,
            l.result_status,
            l.waste_m,
            r.roll_name
         FROM cp_print_meter_logs l
         INNER JOIN cp_print_rolls r
            ON r.id=l.roll_id
         ORDER BY l.id DESC
         LIMIT {$limit}"
    )->fetchAll() ?: [];
}

function print_meter_v31_register_safe(array $payload): int
{
    $rollId = (int)($payload['roll_id'] ?? 0);
    $rollName = trim((string)($payload['roll_name'] ?? ''));

    if ($rollId <= 0 && $rollName === '') {
        throw new RuntimeException('Selecciona el rollo utilizado.');
    }

    if (trim((string)($payload['job_name'] ?? '')) === '') {
        throw new RuntimeException('Captura el nombre del trabajo en Printexp.');
    }

    $pdo = db();
    $pdo->beginTransaction();

    try {
        $roll = null;

        if ($rollId > 0) {
            $st = $pdo->prepare(
                'SELECT
                    id,
                    roll_name,
                    initial_m,
                    remaining_m,
                    width_m,
                    cost_per_linear_m,
                    status,
                    is_archived
                 FROM cp_print_rolls
                 WHERE id=?
                 FOR UPDATE'
            );

            $st->execute([$rollId]);
            $candidate = $st->fetch();

            if ($candidate) {
                $roll = $candidate;

                if (
                    $rollName !== ''
                    && strcasecmp(
                        trim((string)$candidate['roll_name']),
                        $rollName
                    ) !== 0
                ) {
                    $st2 = $pdo->prepare(
                        'SELECT
                            id,
                            roll_name,
                            initial_m,
                            remaining_m,
                            width_m,
                            cost_per_linear_m,
                            status,
                            is_archived
                         FROM cp_print_rolls
                         WHERE roll_name=?
                           AND status="active"
                           AND is_archived=0
                         ORDER BY id DESC
                         LIMIT 1
                         FOR UPDATE'
                    );

                    $st2->execute([$rollName]);
                    $byName = $st2->fetch();

                    if (!$byName) {
                        throw new RuntimeException(
                            'El rollo seleccionado cambió. Recarga la página y vuelve a intentarlo.'
                        );
                    }

                    $roll = $byName;
                }
            }
        }

        if (!$roll && $rollName !== '') {
            $st = $pdo->prepare(
                'SELECT
                    id,
                    roll_name,
                    initial_m,
                    remaining_m,
                    width_m,
                    cost_per_linear_m,
                    status,
                    is_archived
                 FROM cp_print_rolls
                 WHERE roll_name=?
                   AND status="active"
                   AND is_archived=0
                 ORDER BY id DESC
                 LIMIT 1
                 FOR UPDATE'
            );

            $st->execute([$rollName]);
            $roll = $st->fetch();
        }

        if (!$roll) {
            throw new RuntimeException(
                'El rollo seleccionado no existe en la base de datos.'
            );
        }

        if ((int)($roll['is_archived'] ?? 0) === 1) {
            throw new RuntimeException(
                'El rollo seleccionado está archivado.'
            );
        }

        if ((string)$roll['status'] !== 'active') {
            throw new RuntimeException(
                'El rollo seleccionado ya no está activo.'
            );
        }

        $rollId = (int)$roll['id'];
        $remainingBefore = round((float)$roll['remaining_m'], 3);

        $jobWidthM = round(
            max(0.0, (float)($payload['job_width_m'] ?? 0)),
            3
        );

        $jobLengthM = round(
            max(0.0, (float)($payload['job_length_m'] ?? 0)),
            3
        );

        if (
            $jobLengthM <= 0
            && (float)($payload['job_length_mm'] ?? 0) > 0
        ) {
            $jobLengthM = round(
                (float)$payload['job_length_mm'] / 1000,
                3
            );
        }

        $rollWidthFromDb = round(
            max(0.0, (float)($roll['width_m'] ?? 0)),
            3
        );

        $rollWidthEntered = round(
            max(0.0, (float)($payload['roll_width_m'] ?? 0)),
            3
        );

        $rollWidthM = $rollWidthEntered > 0
            ? $rollWidthEntered
            : $rollWidthFromDb;

        $costFromDb = round(
            max(0.0, (float)($roll['cost_per_linear_m'] ?? 0)),
            2
        );

        $costPerLinearM = !empty($payload['cost_per_linear_m_set'])
            ? round(
                max(0.0, (float)$payload['cost_per_linear_m']),
                2
            )
            : $costFromDb;

        $panels = max(1, (int)($payload['panels'] ?? 1));

        /*
         * Cálculo correcto:
         * - área = ancho × largo
         * - paneles = ceil(ancho trabajo / ancho rollo)
         * - metros lineales = largo × paneles
         *
         * Si no hay dimensiones suficientes, conserva la captura manual
         * de linear_m para compatibilidad con registros anteriores.
         */
        if (
            $jobWidthM > 0
            && $jobLengthM > 0
            && $rollWidthM > 0
        ) {
            $panels = max(
                1,
                (int)ceil(
                    ($jobWidthM / $rollWidthM) - 0.0000001
                )
            );

            $consumption = round(
                $jobLengthM * $panels,
                3
            );
        } else {
            $consumption = round(
                max(0.0, (float)($payload['linear_m'] ?? 0)),
                3
            );
        }

        if ($consumption <= 0) {
            throw new RuntimeException(
                'Captura largo y ancho del trabajo o los metros lineales consumidos.'
            );
        }

        if ($consumption > $remainingBefore + 0.0001) {
            throw new RuntimeException(
                'El rollo "' . $roll['roll_name'] .
                '" solo tiene ' .
                number_format($remainingBefore, 3) .
                ' m disponibles.'
            );
        }

        $areaM2 = round(
            max(0.0, $jobWidthM * $jobLengthM),
            3
        );

        $remainingAfter = round(
            max(0.0, $remainingBefore - $consumption),
            3
        );

        $materialCost = round(
            $consumption * $costPerLinearM,
            2
        );

        $newStatus = $remainingAfter <= 0.0001
            ? 'empty'
            : 'active';

        $status = (string)($payload['result_status'] ?? 'good');

        if (!array_key_exists($status, print_meter_results())) {
            $status = 'good';
        }

        $wasteM = $status === 'good'
            ? 0.0
            : $consumption;

        $jobLengthMm = $jobLengthM > 0
            ? round($jobLengthM * 1000, 2)
            : round((float)($payload['job_length_mm'] ?? 0), 2);

        $uid = (int)(current_user()['id'] ?? 0);

        $ins = $pdo->prepare(
            'INSERT INTO cp_print_meter_logs
             (
                roll_id,
                printed_at,
                job_name,
                job_length_mm,
                job_width_m,
                job_length_m,
                area_m2,
                panels,
                roll_width_m,
                linear_m_before,
                linear_m,
                linear_m_after,
                cost_per_linear_m,
                material_cost,
                result_status,
                waste_m,
                created_by,
                created_at
             )
             VALUES(
                ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW()
             )'
        );

        $ins->execute([
            $rollId,
            (string)$payload['printed_at'],
            (string)$payload['job_name'],
            $jobLengthMm,
            $jobWidthM,
            $jobLengthM,
            $areaM2,
            $panels,
            $rollWidthM,
            $remainingBefore,
            $consumption,
            $remainingAfter,
            $costPerLinearM,
            $materialCost,
            $status,
            $wasteM,
            $uid > 0 ? $uid : null,
        ]);

        $logId = (int)$pdo->lastInsertId();

        if ($logId <= 0) {
            throw new RuntimeException(
                'La base no devolvió el ID del movimiento.'
            );
        }

        $up = $pdo->prepare(
            'UPDATE cp_print_rolls
             SET
                remaining_m=?,
                width_m=?,
                cost_per_linear_m=?,
                status=?,
                updated_at=NOW()
             WHERE id=?
               AND remaining_m=?'
        );

        $up->execute([
            $remainingAfter,
            $rollWidthM,
            $costPerLinearM,
            $newStatus,
            $rollId,
            $remainingBefore,
        ]);

        if ($up->rowCount() !== 1) {
            throw new RuntimeException(
                'No se pudo descontar el metraje del rollo. La operación fue cancelada.'
            );
        }

        $verify = $pdo->prepare(
            'SELECT
                remaining_m,
                width_m,
                cost_per_linear_m,
                status
             FROM cp_print_rolls
             WHERE id=?'
        );

        $verify->execute([$rollId]);
        $fresh = $verify->fetch();

        if (
            !$fresh
            || abs(
                (float)$fresh['remaining_m']
                - $remainingAfter
            ) > 0.0001
        ) {
            throw new RuntimeException(
                'No se pudo verificar el saldo final del rollo. La operación fue cancelada.'
            );
        }

        $pdo->commit();

        return $logId;
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }

        throw $e;
    }
}


function print_meter_v31_audit(
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
        $before ? json_encode($before, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) : null,
        $after ? json_encode($after, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES) : null,
        trim($note) !== '' ? trim($note) : null,
        $uid > 0 ? $uid : null,
    ]);
}

function print_meter_v31_get_roll(int $rollId, bool $forUpdate = false): ?array
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
        . ($forUpdate ? " FOR UPDATE" : "");

    $st = db()->prepare($sql);
    $st->execute([$rollId]);

    return $st->fetch() ?: null;
}

function print_meter_v31_update_roll(
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
        throw new RuntimeException('Los metros disponibles no pueden superar los metros iniciales.');
    }
    if ($widthM <= 0) {
        throw new RuntimeException('El ancho útil del rollo debe ser mayor que 0.');
    }

    $pdo = db();
    $pdo->beginTransaction();

    try {
        $st = $pdo->prepare(
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
            throw new RuntimeException('Ya existe otro rollo activo/no archivado con ese nombre.');
        }

        $status = $remainingM <= 0.0001 ? 'empty' : 'active';

        $up = $pdo->prepare(
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
        );

        $up->execute([
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
            'is_archived' => (int)$before['is_archived'],
        ];

        print_meter_v31_audit(
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

function print_meter_v31_archive_roll(int $rollId, string $note = ''): void
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

        print_meter_v31_audit(
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

function print_meter_v31_restore_roll(int $rollId, string $note = ''): void
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
                'No se puede restaurar porque ya existe otro rollo no archivado con el mismo nombre.'
            );
        }

        $status = (float)$before['remaining_m'] <= 0.0001
            ? 'empty'
            : 'active';

        $pdo->prepare(
            "UPDATE cp_print_rolls
             SET is_archived=0, status=?, updated_at=NOW()
             WHERE id=?"
        )->execute([$status, $rollId]);

        $after = $before;
        $after['is_archived'] = 0;
        $after['status'] = $status;

        print_meter_v31_audit(
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

function print_meter_v31_delete_roll(int $rollId, string $note = ''): void
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
        $count = (int)$jobs->fetchColumn();

        if ($count > 0) {
            throw new RuntimeException(
                'Este rollo tiene historial de impresión. Para conservar la trazabilidad debes archivarlo, no eliminarlo.'
            );
        }

        print_meter_v31_audit(
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
