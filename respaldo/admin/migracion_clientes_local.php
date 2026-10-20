<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';
require_once __DIR__ . '/../includes/actions.php';
require_auth();

$title = 'Migración de clientes a base local';
$pdo = db();
$message = null;
$error = null;
$executed = false;

function mig_norm(?string $value): string {
    $s = trim((string)$value);
    if ($s === '') return '';
    if (function_exists('iconv')) {
        $x = @iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $s);
        if ($x !== false) $s = $x;
    }
    $s = strtolower($s);
    return preg_replace('/[^a-z0-9]+/', '', $s) ?? '';
}
function mig_phone(?string $value): string {
    $digits = preg_replace('/\D+/', '', (string)$value) ?? '';
    return strlen($digits) > 10 ? substr($digits, -10) : $digits;
}
function mig_candidate(PDO $pdo, array $row): ?array {
    $email = strtolower(trim((string)($row['email'] ?? '')));
    $phone = mig_phone($row['phone'] ?? '');
    $name = mig_norm($row['name'] ?? '');
    $tax = mig_norm($row['tax_number'] ?? '');
    $all = $pdo->query('SELECT * FROM cp_customers WHERE enabled=1')->fetchAll(PDO::FETCH_ASSOC);
    $matches = function(array $r) use ($email,$phone,$name,$tax): array {
        $reasons=[];
        if($tax!=='' && mig_norm($r['tax_number']??'')===$tax) $reasons[]='tax';
        if($email!=='' && strtolower(trim((string)($r['email']??'')))===$email) $reasons[]='email';
        if($phone!=='' && mig_phone($r['phone']??'')===$phone) $reasons[]='phone';
        if($name!=='' && mig_norm($r['name']??'')===$name) $reasons[]='name';
        return $reasons;
    };
    $strong=[];
    foreach($all as $r){
        if((int)$r['id']===(int)$row['id']) continue;
        $reasons=$matches($r);
        if(!$reasons) continue;
        $hasStrong = in_array('tax',$reasons,true) || in_array('email',$reasons,true) || in_array('phone',$reasons,true);
        $sameName = in_array('name',$reasons,true);
        // Never merge solely on a shared name. For an identifier match with a
        // conflicting non-empty name, require a second identifier or exact name.
        if($hasStrong && ($sameName || count($reasons)>=2)) $strong[]=['row'=>$r,'reason'=>implode('+',$reasons)];
    }
    if(count($strong)!==1) return null;
    return $strong[0];
}
function mig_reference_count(PDO $pdo, int $customerId): int {
    $total = 0;
    foreach ([
        ['cp_quotes','customer_id'],['cp_orders','customer_id'],['cp_payments','customer_id'],
        ['cp_invoices','customer_id'],['cp_whatsapp_chats','customer_id'],['cp_whatsapp_log','customer_id'],
        ['cp_web_quote_requests','customer_id']
    ] as [$table,$column]) {
        try { $st=$pdo->prepare("SELECT COUNT(*) FROM {$table} WHERE {$column}=?"); $st->execute([$customerId]); $total+=(int)$st->fetchColumn(); } catch(Throwable $e) {}
    }
    return $total;
}
function mig_choose_canonical(PDO $pdo, array $a, array $b): array {
    $aRef=mig_reference_count($pdo,(int)$a['id']);
    $bRef=mig_reference_count($pdo,(int)$b['id']);
    $aLocal=(($a['source_type']??'') === 'local') ? 1 : 0;
    $bLocal=(($b['source_type']??'') === 'local') ? 1 : 0;
    if ($aRef !== $bRef) return $aRef > $bRef ? [$a,$b,'more_references'] : [$b,$a,'more_references'];
    if ($aLocal !== $bLocal) return $aLocal ? [$a,$b,'local_preferred'] : [$b,$a,'local_preferred'];
    return ((int)$a['id'] <= (int)$b['id']) ? [$a,$b,'lower_id'] : [$b,$a,'lower_id'];
}
function mig_backup(PDO $pdo): string {
    $suffix=date('Ymd_His');
    $table='cp_customers_backup_'.$suffix;
    $pdo->exec("CREATE TABLE `{$table}` LIKE cp_customers");
    $pdo->exec("INSERT INTO `{$table}` SELECT * FROM cp_customers");
    return $table;
}
function mig_execute(PDO $pdo): array {
    $backup=mig_backup($pdo);
    $pdo->exec("CREATE TABLE IF NOT EXISTS cp_customer_merge_map (
        old_customer_id INT UNSIGNED NOT NULL,
        canonical_customer_id INT UNSIGNED NOT NULL,
        confidence VARCHAR(30) NOT NULL,
        reason VARCHAR(255) NOT NULL,
        created_at DATETIME NOT NULL,
        PRIMARY KEY (old_customer_id),
        KEY idx_cp_customer_merge_canonical (canonical_customer_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");

    // 1) Reconcile web requests using the information captured at submission.
    $reqs=$pdo->query("SELECT id,customer_id,customer_name,email,phone FROM cp_web_quote_requests ORDER BY id")->fetchAll(PDO::FETCH_ASSOC);
    $reconciled=0;
    foreach($reqs as $r){
        $current=(int)($r['customer_id']??0);
        $best=null;
        $email=strtolower(trim((string)($r['email']??'')));
        $phone=mig_phone($r['phone']??'');
        $name=mig_norm($r['customer_name']??'');
        if($email!==''){
            $st=$pdo->prepare("SELECT * FROM cp_customers WHERE enabled=1 AND LOWER(email)=? ORDER BY id"); $st->execute([$email]);
            $rows=$st->fetchAll(PDO::FETCH_ASSOC);
            $same=array_values(array_filter($rows,fn($x)=>$name!=='' && mig_norm($x['name']??'')===$name));
            if(count($same)===1)$best=$same[0];
        }
        if(!$best && $phone!==''){
            $st=$pdo->query("SELECT * FROM cp_customers WHERE enabled=1 AND phone<>''");
            $rows=array_values(array_filter($st->fetchAll(PDO::FETCH_ASSOC),fn($x)=>mig_phone($x['phone']??'')===$phone));
            if($name!==''){
                $same=array_values(array_filter($rows,fn($x)=>mig_norm($x['name']??'')===$name));
                if(count($same)===1)$best=$same[0];
            }
            if(!$best && count($rows)===1)$best=$rows[0];
        }
        if(!$best && $name!==''){
            $st=$pdo->query("SELECT * FROM cp_customers WHERE enabled=1");
            $rows=array_values(array_filter($st->fetchAll(PDO::FETCH_ASSOC),fn($x)=>mig_norm($x['name']??'')===$name));
            if(count($rows)===1)$best=$rows[0];
        }
        if($best && (int)$best['id']!==$current){
            $u=$pdo->prepare('UPDATE cp_web_quote_requests SET customer_id=?,updated_at=NOW() WHERE id=?');
            $u->execute([(int)$best['id'],(int)$r['id']]); $reconciled++;
        }
    }

    // 2) Merge high-confidence duplicate customers.
    $rows=$pdo->query('SELECT * FROM cp_customers ORDER BY id')->fetchAll(PDO::FETCH_ASSOC);
    $merged=0; $skipped=0;
    foreach($rows as $row){
        $id=(int)$row['id'];
        $exists=$pdo->prepare('SELECT 1 FROM cp_customers WHERE id=?'); $exists->execute([$id]);
        if(!$exists->fetchColumn()) continue;
        $cand=mig_candidate($pdo,$row);
        if(!$cand){$skipped++; continue;}
        [$canonical,$duplicate,$reason]=mig_choose_canonical($pdo,$row,$cand['row']);
        $cid=(int)$canonical['id']; $did=(int)$duplicate['id'];
        if($cid===$did) continue;
        $pdo->beginTransaction();
        try{
            // Fill missing canonical data from duplicate without overwriting trusted values.
            $pdo->prepare("UPDATE cp_customers c JOIN cp_customers d ON d.id=? SET
                c.email=COALESCE(NULLIF(c.email,''),d.email), c.tax_number=COALESCE(NULLIF(c.tax_number,''),d.tax_number),
                c.phone=COALESCE(NULLIF(c.phone,''),d.phone), c.address=COALESCE(NULLIF(c.address,''),d.address),
                c.city=COALESCE(NULLIF(c.city,''),d.city), c.zip_code=COALESCE(NULLIF(c.zip_code,''),d.zip_code),
                c.state=COALESCE(NULLIF(c.state,''),d.state), c.country=COALESCE(NULLIF(c.country,''),d.country),
                c.notes=COALESCE(NULLIF(c.notes,''),d.notes), c.updated_at=NOW() WHERE c.id=?")->execute([$did,$cid]);
            foreach ([
                ['cp_quotes','customer_id'],['cp_orders','customer_id'],['cp_payments','customer_id'],['cp_invoices','customer_id'],
                ['cp_whatsapp_chats','customer_id'],['cp_whatsapp_log','customer_id'],['cp_web_quote_requests','customer_id']
            ] as [$table,$column]){
                try{$st=$pdo->prepare("UPDATE {$table} SET {$column}=? WHERE {$column}=?");$st->execute([$cid,$did]);}catch(Throwable $e){}
            }
            $map=$pdo->prepare('INSERT INTO cp_customer_merge_map(old_customer_id,canonical_customer_id,confidence,reason,created_at) VALUES(?,?,?,?,NOW()) ON DUPLICATE KEY UPDATE canonical_customer_id=VALUES(canonical_customer_id),confidence=VALUES(confidence),reason=VALUES(reason),created_at=NOW()');
            $map->execute([$did,$cid,'high',$reason]);
            $pdo->prepare('DELETE FROM cp_customers WHERE id=?')->execute([$did]);
            $pdo->commit(); $merged++;
        }catch(Throwable $e){if($pdo->inTransaction())$pdo->rollBack();throw $e;}
    }
    // 3) The local catalog becomes canonical. Preserve the data, remove Akaunting provenance.
    $converted=(int)$pdo->exec("UPDATE cp_customers SET source_type='local', source_id=NULL, updated_at=NOW() WHERE source_type='akaunting' OR source_type IS NULL OR source_type=''");
    return compact('backup','reconciled','merged','skipped','converted');
}

if($_SERVER['REQUEST_METHOD']==='POST'){
    if(!csrf_check($_POST['_csrf']??null)){ $error='La sesión expiró. Recarga la página.'; }
    elseif(($_POST['confirm']??'')!=='MIGRAR'){ $error='Escribe MIGRAR para confirmar la operación.'; }
    else{
        try{$pdo->beginTransaction();$pdo->commit();$result=mig_execute($pdo);$executed=true;$message='Migración completada. Respaldo: '.$result['backup'].'. Solicitudes reconciliadas: '.$result['reconciled'].'. Duplicados fusionados: '.$result['merged'].'. Clientes convertidos a local: '.$result['converted'].'.';}
        catch(Throwable $e){if($pdo->inTransaction())$pdo->rollBack();$error='La migración fue detenida: '.$e->getMessage();}
    }
}

$total=(int)$pdo->query('SELECT COUNT(*) FROM cp_customers')->fetchColumn();
$aka=(int)$pdo->query("SELECT COUNT(*) FROM cp_customers WHERE source_type='akaunting'")->fetchColumn();
$local=(int)$pdo->query("SELECT COUNT(*) FROM cp_customers WHERE source_type='local'")->fetchColumn();
$web=(int)$pdo->query("SELECT COUNT(*) FROM cp_web_quote_requests WHERE customer_id IS NOT NULL")->fetchColumn();
?><!doctype html><html lang="es-MX"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title><?=e($title)?></title><style>body{margin:0;background:#071321;color:#eef7ff;font-family:Arial,sans-serif;padding:30px}.box{max-width:980px;margin:30px auto;background:#0c1d2b;border:1px solid #284d66;border-radius:18px;padding:28px}.cards{display:grid;grid-template-columns:repeat(4,1fr);gap:12px}.card{background:#09182b;border:1px solid #31577e;border-radius:12px;padding:16px}.n{font-size:28px;font-weight:900}.ok{color:#55e6a5}.warn{color:#ffd56a}.danger{color:#ff7189}.btn{display:inline-block;border:0;border-radius:10px;padding:12px 16px;font-weight:900;background:#1dbfe8;color:#04131c;cursor:pointer}.input{background:#061322;color:#fff;border:1px solid #31577e;border-radius:10px;padding:12px;width:100%;box-sizing:border-box}.notice{padding:14px;border-radius:10px;background:#09182b;border:1px solid #31577e;margin:15px 0}.back{color:#7edcff;text-decoration:none}</style></head><body><div class="box"><a class="back" href="/admin/clientes.php">← Clientes</a><h1>Migración de clientes a base local</h1><p>Esta operación hace que <strong>cp_customers</strong> sea la única fuente de clientes de Colibrí Print. Akaunting no se modifica.</p><div class="cards"><div class="card">Total<div class="n"><?=number_format($total)?></div></div><div class="card">Akaunting<div class="n warn"><?=number_format($aka)?></div></div><div class="card">Locales<div class="n ok"><?=number_format($local)?></div></div><div class="card">Solicitudes web vinculadas<div class="n"><?=number_format($web)?></div></div></div><div class="notice"><strong>Qué hará:</strong><ul><li>creará un respaldo completo de <code>cp_customers</code>;</li><li>reconciliará solicitudes web usando nombre, correo y teléfono capturados;</li><li>fusionará duplicados de alta confianza y conservará las referencias de cotizaciones, órdenes, pagos, facturas y WhatsApp;</li><li>convertirá todos los registros restantes a <code>source_type=local</code>;</li><li>no borrará ni modificará la base Akaunting.</li></ul></div><?php if($message):?><div class="notice"><span class="ok">✓</span> <?=e($message)?></div><?php endif;?><?php if($error):?><div class="notice"><span class="danger">✕</span> <?=e($error)?></div><?php endif;?><?php if(!$executed):?><form method="post" onsubmit="return confirm('Esta operación modificará los IDs de clientes y fusionará duplicados. Ya debe existir un respaldo externo de la base de datos. ¿Continuar?')"><input type="hidden" name="_csrf" value="<?=e(csrf_token())?>"><label>Escribe <strong>MIGRAR</strong> para confirmar</label><input class="input" name="confirm" autocomplete="off" placeholder="MIGRAR" required><br><br><button class="btn" type="submit">Ejecutar migración</button></form><?php endif;?><p class="notice"><strong>Después de migrar:</strong> se debe instalar el parche de código que elimina la sincronización/búsqueda de clientes en Akaunting. No ejecutes nuevamente el antiguo botón de sincronización.</p></div></body></html>
