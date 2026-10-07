<?php
declare(strict_types=1);

require_once __DIR__ . '/../config/runtime.php';

function print_meter_results(): array
{
    return [
        'good' => 'Impresión buena',
        'test' => 'Test de impresión',
        'cancelled' => 'Cancelada',
        'damaged_jam' => 'Dañada por atrapamiento',
        'reprint' => 'Reimpresión',
    ];
}

function print_meter_result_label(string $status): string
{
    $map = print_meter_results();
    return $map[$status] ?? 'Impresión buena';
}

function print_meter_to_m(float $mm): float
{
    return round(max(0.0, $mm) / 1000, 3);
}

function print_meter_normalize(array $src): array
{
    $lengthMm = max(0.0, (float)($src['job_length_mm'] ?? 0));
    $linearM = max(0.0, (float)($src['linear_m'] ?? 0));

    if ($linearM <= 0 && $lengthMm > 0) {
        $linearM = print_meter_to_m($lengthMm);
    }
    if ($lengthMm <= 0 && $linearM > 0) {
        $lengthMm = round($linearM * 1000, 2);
    }

    $status = (string)($src['result_status'] ?? 'good');
    if (!array_key_exists($status, print_meter_results())) {
        $status = 'good';
    }

    $printedAt = trim((string)($src['printed_at'] ?? ''));
    $printedAt = str_replace('T', ' ', $printedAt);
    if ($printedAt !== '' && preg_match('/^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$/', $printedAt)) {
        $printedAt .= ':00';
    }
    if ($printedAt === '') {
        $printedAt = date('Y-m-d H:i:s');
    }

    return [
        'roll_id' => max(0, (int)($src['roll_id'] ?? 0)),
        'printed_at' => $printedAt,
        'job_name' => trim((string)($src['job_name'] ?? '')),
        'job_length_mm' => round($lengthMm, 2),
        'linear_m' => round($linearM, 3),
        'result_status' => $status,
        'waste_m' => $status === 'good' ? 0.0 : round($linearM, 3),
    ];
}

function print_meter_active_rolls(): array
{
    return db()->query("SELECT id, roll_name, initial_m, remaining_m, opened_at, status FROM cp_print_rolls ORDER BY CASE WHEN status='active' THEN 0 WHEN status='empty' THEN 1 ELSE 2 END, id DESC")->fetchAll();
}

function print_meter_create_roll(string $name, float $meters): int
{
    $name = trim($name);
    if ($name === '') {
        throw new RuntimeException('Indica el nombre o identificación del rollo.');
    }
    if ($meters <= 0) {
        throw new RuntimeException('La longitud inicial del rollo debe ser mayor que 0.');
    }

    $pdo = db();
    $st = $pdo->prepare("INSERT INTO cp_print_rolls(roll_name,initial_m,remaining_m,opened_at,status,created_by,created_at,updated_at) VALUES(?,?,?,NOW(),'active',?,NOW(),NOW())");
    $uid = (int)(current_user()['id'] ?? 0);
    $st->execute([$name, round($meters, 3), round($meters, 3), $uid]);
    return (int)$pdo->lastInsertId();
}

function print_meter_register(array $payload): int
{
    if ($payload['roll_id'] <= 0) {
        throw new RuntimeException('Selecciona el rollo que se está utilizando.');
    }
    if ($payload['job_name'] === '') {
        throw new RuntimeException('Captura el nombre del trabajo de Printexp.');
    }
    if ($payload['linear_m'] <= 0) {
        throw new RuntimeException('Captura el largo del Job Size o los metros lineales.');
    }

    $pdo = db();
    $pdo->beginTransaction();
    try {
        $st = $pdo->prepare('SELECT id, roll_name, remaining_m, status FROM cp_print_rolls WHERE id=? FOR UPDATE');
        $st->execute([$payload['roll_id']]);
        $roll = $st->fetch();
        if (!$roll) {
            throw new RuntimeException('El rollo seleccionado no existe.');
        }
        if ((string)$roll['status'] !== 'active') {
            throw new RuntimeException('El rollo seleccionado no está activo.');
        }
        $remaining = (float)$roll['remaining_m'];
        $consumption = (float)$payload['linear_m'];
        if ($consumption > $remaining + 0.0001) {
            throw new RuntimeException('El rollo solo tiene ' . number_format($remaining, 3) . ' m disponibles.');
        }

        $newRemaining = round(max(0.0, $remaining - $consumption), 3);
        $newStatus = $newRemaining <= 0.0001 ? 'empty' : 'active';

        $ins = $pdo->prepare('INSERT INTO cp_print_meter_logs(roll_id,printed_at,job_name,job_length_mm,linear_m,result_status,waste_m,created_by,created_at) VALUES(?,?,?,?,?,?,?,?,NOW())');
        $ins->execute([
            $payload['roll_id'],
            $payload['printed_at'],
            $payload['job_name'],
            $payload['job_length_mm'],
            $payload['linear_m'],
            $payload['result_status'],
            $payload['waste_m'],
            current_user()['id'] ?? null,
        ]);
        $id = (int)$pdo->lastInsertId();

        $up = $pdo->prepare('UPDATE cp_print_rolls SET remaining_m=?, status=?, updated_at=NOW() WHERE id=?');
        $up->execute([$newRemaining, $newStatus, $payload['roll_id']]);

        $pdo->commit();
        return $id;
    } catch (Throwable $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        throw $e;
    }
}

function print_meter_dashboard(): array
{
    $sql = "SELECT COUNT(*) jobs,
                   COALESCE(SUM(linear_m),0) printed_m,
                   COALESCE(SUM(waste_m),0) waste_m,
                   COALESCE(SUM(CASE WHEN result_status='good' THEN linear_m ELSE 0 END),0) good_m
            FROM cp_print_meter_logs";
    $row = db()->query($sql)->fetch() ?: [];
    return [
        'jobs' => (int)($row['jobs'] ?? 0),
        'printed_m' => (float)($row['printed_m'] ?? 0),
        'waste_m' => (float)($row['waste_m'] ?? 0),
        'good_m' => (float)($row['good_m'] ?? 0),
    ];
}

function print_meter_active_roll(): ?array
{
    $st = db()->query("SELECT id, roll_name, initial_m, remaining_m, opened_at, status FROM cp_print_rolls WHERE status='active' ORDER BY id DESC LIMIT 1");
    $row = $st->fetch();
    return $row ?: null;
}

function print_meter_rows(int $limit = 100): array
{
    $limit = max(1, min(500, $limit));
    $sql = "SELECT l.id,l.printed_at,l.job_name,l.job_length_mm,l.linear_m,l.result_status,l.waste_m,
                   r.roll_name
            FROM cp_print_meter_logs l
            INNER JOIN cp_print_rolls r ON r.id=l.roll_id
            ORDER BY l.id DESC LIMIT {$limit}";
    return db()->query($sql)->fetchAll();
}

function print_meter_roll_analytics(): array
{
    $sql = "SELECT
                r.id,
                r.roll_name,
                r.initial_m,
                r.remaining_m,
                r.opened_at,
                r.status,
                COALESCE(SUM(l.linear_m),0) AS used_m,
                COALESCE(SUM(l.waste_m),0) AS waste_m,
                COALESCE(SUM(CASE WHEN l.result_status='good' THEN l.linear_m ELSE 0 END),0) AS good_m,
                COUNT(l.id) AS jobs
            FROM cp_print_rolls r
            LEFT JOIN cp_print_meter_logs l ON l.roll_id=r.id
            GROUP BY r.id,r.roll_name,r.initial_m,r.remaining_m,r.opened_at,r.status
            ORDER BY CASE WHEN r.status='active' THEN 0 ELSE 1 END, r.id DESC";
    $rows = db()->query($sql)->fetchAll();

    foreach ($rows as &$row) {
        $initial=(float)$row['initial_m'];
        $remaining=max(0.0,(float)$row['remaining_m']);
        $used=max(0.0,(float)$row['used_m']);
        // The inventory balance is authoritative. Used percentage is initial - balance.
        $usedFromBalance=max(0.0,$initial-$remaining);
        $row['used_m']=round($usedFromBalance,3);
        $row['remaining_m']=round($remaining,3);
        $row['initial_m']=round($initial,3);
        $row['used_pct']=$initial>0 ? round(($usedFromBalance/$initial)*100,1) : 0.0;
        $row['remaining_pct']=$initial>0 ? round(($remaining/$initial)*100,1) : 0.0;
        $row['waste_m']=round((float)$row['waste_m'],3);
        $row['good_m']=round((float)$row['good_m'],3);
        $row['jobs']=(int)$row['jobs'];
        if ($row['status']==='empty' || $remaining<=0.0001) {
            $row['health']='empty';
            $row['health_label']='Agotado';
        } elseif ($row['used_pct']>=80) {
            $row['health']='critical';
            $row['health_label']='Casi agotado';
        } elseif ($row['used_pct']>=60) {
            $row['health']='warning';
            $row['health_label']='Consumo alto';
        } else {
            $row['health']='normal';
            $row['health_label']='Disponible';
        }
    }
    unset($row);
    return $rows;
}

function print_meter_usage_breakdown(): array
{
    $rows=print_meter_roll_analytics();
    $totalUsed=0.0;
    $totalRemaining=0.0;
    $totalInitial=0.0;
    $totalWaste=0.0;
    $totalGood=0.0;
    $totalJobs=0;
    foreach($rows as $row){
        $totalInitial+=(float)$row['initial_m'];
        $totalUsed+=(float)$row['used_m'];
        $totalRemaining+=(float)$row['remaining_m'];
        $totalWaste+=(float)$row['waste_m'];
        $totalGood+=(float)$row['good_m'];
        $totalJobs+=(int)$row['jobs'];
    }
    return [
        'rolls'=>$rows,
        'initial_m'=>round($totalInitial,3),
        'used_m'=>round($totalUsed,3),
        'remaining_m'=>round($totalRemaining,3),
        'waste_m'=>round($totalWaste,3),
        'good_m'=>round($totalGood,3),
        'jobs'=>$totalJobs,
        'used_pct'=>$totalInitial>0 ? round(($totalUsed/$totalInitial)*100,1) : 0.0,
        'remaining_pct'=>$totalInitial>0 ? round(($totalRemaining/$totalInitial)*100,1) : 0.0,
        'waste_pct'=>$totalUsed>0 ? round(($totalWaste/$totalUsed)*100,1) : 0.0,
    ];
}

function print_meter_register_safe(array $payload): int
{
    $rollId=(int)($payload['roll_id']??0);
    $rollName=trim((string)($payload['roll_name']??''));

    if($rollId<=0 && $rollName===''){
        throw new RuntimeException('Selecciona el rollo utilizado.');
    }
    if($payload['job_name']===''){
        throw new RuntimeException('Captura el nombre del trabajo en Printexp.');
    }

    $consumption=round((float)$payload['linear_m'],3);
    if($consumption<=0){
        throw new RuntimeException('Captura los metros lineales consumidos.');
    }

    $pdo=db();
    $pdo->beginTransaction();

    try{
        $roll=null;

        // Validación primaria por ID.
        if($rollId>0){
            $st=$pdo->prepare(
                'SELECT id,roll_name,initial_m,remaining_m,status
                 FROM cp_print_rolls
                 WHERE id=?
                 FOR UPDATE'
            );
            $st->execute([$rollId]);
            $candidate=$st->fetch();

            if($candidate){
                $roll=$candidate;

                // El navegador también manda el nombre visible.
                // Si no coincide, resolvemos el ID por nombre activo.
                if($rollName!=='' && strcasecmp(trim((string)$candidate['roll_name']),$rollName)!==0){
                    $st2=$pdo->prepare(
                        'SELECT id,roll_name,initial_m,remaining_m,status
                         FROM cp_print_rolls
                         WHERE roll_name=? AND status="active"
                         ORDER BY id DESC
                         LIMIT 1
                         FOR UPDATE'
                    );
                    $st2->execute([$rollName]);
                    $byName=$st2->fetch();

                    if($byName){
                        $roll=$byName;
                    }else{
                        throw new RuntimeException(
                            'El rollo seleccionado cambió. Recarga la página y vuelve a intentarlo.'
                        );
                    }
                }
            }
        }

        // Fallback por nombre.
        if(!$roll && $rollName!==''){
            $st=$pdo->prepare(
                'SELECT id,roll_name,initial_m,remaining_m,status
                 FROM cp_print_rolls
                 WHERE roll_name=? AND status="active"
                 ORDER BY id DESC
                 LIMIT 1
                 FOR UPDATE'
            );
            $st->execute([$rollName]);
            $roll=$st->fetch();
        }

        if(!$roll){
            throw new RuntimeException('El rollo seleccionado no existe en la base de datos.');
        }
        if((string)$roll['status']!=='active'){
            throw new RuntimeException('El rollo seleccionado ya no está activo.');
        }

        $rollId=(int)$roll['id'];
        $remaining=round((float)$roll['remaining_m'],3);

        if($consumption>$remaining+0.0001){
            throw new RuntimeException(
                'El rollo "' . $roll['roll_name'] . '" solo tiene ' .
                number_format($remaining,3) . ' m disponibles.'
            );
        }

        $newRemaining=round(max(0.0,$remaining-$consumption),3);
        $newStatus=$newRemaining<=0.0001?'empty':'active';
        $uid=(int)(current_user()['id']??0);

        $ins=$pdo->prepare(
            'INSERT INTO cp_print_meter_logs
             (roll_id,printed_at,job_name,job_length_mm,linear_m,result_status,waste_m,created_by,created_at)
             VALUES(?,?,?,?,?,?,?,?,NOW())'
        );
        $ins->execute([
            $rollId,
            (string)$payload['printed_at'],
            (string)$payload['job_name'],
            (float)$payload['job_length_mm'],
            $consumption,
            (string)$payload['result_status'],
            (float)$payload['waste_m'],
            $uid>0?$uid:null
        ]);

        $logId=(int)$pdo->lastInsertId();
        if($logId<=0){
            throw new RuntimeException('La base no devolvió el ID del movimiento.');
        }

        $up=$pdo->prepare(
            'UPDATE cp_print_rolls
             SET remaining_m=?,status=?,updated_at=NOW()
             WHERE id=? AND remaining_m=?'
        );
        $up->execute([$newRemaining,$newStatus,$rollId,$remaining]);

        if($up->rowCount()!==1){
            throw new RuntimeException(
                'No se pudo descontar el metraje del rollo. La operación fue cancelada.'
            );
        }

        $verify=$pdo->prepare(
            'SELECT remaining_m,status FROM cp_print_rolls WHERE id=?'
        );
        $verify->execute([$rollId]);
        $fresh=$verify->fetch();

        if(!$fresh || abs((float)$fresh['remaining_m']-$newRemaining)>0.0001){
            throw new RuntimeException('No se pudo verificar el saldo final del rollo. La operación fue cancelada.');
        }

        $pdo->commit();
        return $logId;
    }catch(Throwable $e){
        if($pdo->inTransaction())$pdo->rollBack();
        throw $e;
    }
}

