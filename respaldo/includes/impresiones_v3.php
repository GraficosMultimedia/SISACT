<?php
declare(strict_types=1);

require_once __DIR__ . '/impresiones.php';

/**
 * SISACT · Impresiones V3
 * Extensión compatible con el módulo actual.
 *
 * - No redefine las funciones V1/V2.
 * - Conserva cp_print_rolls y cp_print_meter_logs como tablas principales.
 * - Añade dimensiones, paneles, saldo antes/después y costo histórico.
 */

function print_meter_v3_num(mixed $value): float
{
    $raw = trim((string)$value);
    if ($raw === '') {
        return 0.0;
    }

    $raw = str_replace(',', '.', $raw);
    return is_numeric($raw) ? (float)$raw : 0.0;
}

function print_meter_v3_normalize(array $src): array
{
    $base = print_meter_normalize($src);

    $jobWidthM = max(0.0, print_meter_v3_num($src['job_width_m'] ?? 0));
    $jobLengthM = max(0.0, print_meter_v3_num($src['job_length_m'] ?? 0));

    if ($jobLengthM <= 0 && (float)$base['job_length_mm'] > 0) {
        $jobLengthM = round((float)$base['job_length_mm'] / 1000, 3);
    }

    $rollWidthM = max(0.0, print_meter_v3_num($src['roll_width_m'] ?? 0));

    $costRaw = trim((string)($src['cost_per_linear_m'] ?? ''));
    $costSet = $costRaw !== '';
    $costPerLinearM = max(0.0, print_meter_v3_num($costRaw));

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

function print_meter_v3_create_roll(
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
            updated_at
         )
         VALUES(?,?,?,?,?,NOW(),'active',?,NOW(),NOW())"
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

function print_meter_v3_active_rolls(): array
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
            status
         FROM cp_print_rolls
         ORDER BY
            CASE
                WHEN status='active' THEN 0
                WHEN status='empty' THEN 1
                ELSE 2
            END,
            id DESC"
    )->fetchAll() ?: [];
}

function print_meter_v3_rows(int $limit = 100): array
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

function print_meter_v3_register_safe(array $payload): int
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
                    status
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
                            status
                         FROM cp_print_rolls
                         WHERE roll_name=?
                           AND status="active"
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
                    status
                 FROM cp_print_rolls
                 WHERE roll_name=?
                   AND status="active"
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
