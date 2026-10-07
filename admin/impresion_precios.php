<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/bootstrap.php';

$db = cp_db();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = trim((string)($_POST['section_action'] ?? ''));
    try {
        cp_check_csrf($_POST['csrf'] ?? null);

        if ($action === 'catalog_save') {
            $type = trim((string)($_POST['type'] ?? ''));
            $id = (int)($_POST['id'] ?? 0);
            $allowed = ['size', 'material', 'finish'];
            if (!in_array($type, $allowed, true)) {
                throw new RuntimeException('Tipo de catálogo no válido.');
            }

            if ($type === 'size') {
                $name = trim((string)($_POST['name'] ?? ''));
                $code = strtolower(trim((string)($_POST['code'] ?? '')));
                if ($id > 0 && $code === '') { $q=$db->prepare('SELECT code FROM cp_print_sizes WHERE id=?'); $q->execute([$id]); $code=(string)$q->fetchColumn(); }
                $width = (float)($_POST['width_mm'] ?? 0);
                $height = (float)($_POST['height_mm'] ?? 0);
                $orientation = trim((string)($_POST['orientation'] ?? 'portrait'));
                $custom = isset($_POST['is_custom']) ? 1 : 0;
                $sort = (int)($_POST['sort_order'] ?? 0);
                if ($name === '' || $code === '' || $width <= 0 || $height <= 0) {
                    throw new RuntimeException('Completa nombre, código y medidas válidas.');
                }
                if (!in_array($orientation, ['portrait', 'landscape'], true)) $orientation = 'portrait';

                if ($id > 0) {
                    $st = $db->prepare('UPDATE cp_print_sizes SET name=?,code=?,width_mm=?,height_mm=?,orientation=?,is_custom=?,sort_order=?,enabled=?,updated_at=NOW() WHERE id=?');
                    $st->execute([$name,$code,$width,$height,$orientation,$custom,$sort,isset($_POST['enabled']) ? 1 : 0,$id]);
                } else {
                    $st = $db->prepare('INSERT INTO cp_print_sizes (name,code,width_mm,height_mm,orientation,is_custom,enabled,sort_order,created_at,updated_at) VALUES (?,?,?,?,?,?,1,?,NOW(),NOW())');
                    $st->execute([$name,$code,$width,$height,$orientation,$custom,$sort]);
                }
            } elseif ($type === 'material') {
                $name = trim((string)($_POST['name'] ?? ''));
                $code = strtolower(trim((string)($_POST['code'] ?? '')));
                if ($id > 0 && $code === '') { $q=$db->prepare('SELECT code FROM cp_print_materials WHERE id=?'); $q->execute([$id]); $code=(string)$q->fetchColumn(); }
                $unit = trim((string)($_POST['unit_label'] ?? 'hoja')) ?: 'hoja';
                $sort = (int)($_POST['sort_order'] ?? 0);
                if ($name === '' || $code === '') throw new RuntimeException('Completa nombre y código.');

                if ($id > 0) {
                    $st = $db->prepare('UPDATE cp_print_materials SET name=?,code=?,unit_label=?,sort_order=?,enabled=?,updated_at=NOW() WHERE id=?');
                    $st->execute([$name,$code,$unit,$sort,isset($_POST['enabled']) ? 1 : 0,$id]);
                } else {
                    $st = $db->prepare('INSERT INTO cp_print_materials (name,code,enabled,sort_order,created_at,updated_at,unit_label) VALUES (?,?,1,?,NOW(),NOW(),?)');
                    $st->execute([$name,$code,$sort,$unit]);
                }
            } else {
                $name = trim((string)($_POST['name'] ?? ''));
                $code = strtolower(trim((string)($_POST['code'] ?? '')));
                if ($id > 0 && $code === '') { $q=$db->prepare('SELECT code FROM cp_print_finishes WHERE id=?'); $q->execute([$id]); $code=(string)$q->fetchColumn(); }
                $sort = (int)($_POST['sort_order'] ?? 0);
                if ($name === '' || $code === '') throw new RuntimeException('Completa nombre y código.');

                if ($id > 0) {
                    $st = $db->prepare('UPDATE cp_print_finishes SET name=?,code=?,sort_order=?,enabled=?,updated_at=NOW() WHERE id=?');
                    $st->execute([$name,$code,$sort,isset($_POST['enabled']) ? 1 : 0,$id]);
                } else {
                    $st = $db->prepare('INSERT INTO cp_print_finishes (name,code,enabled,sort_order,created_at,updated_at) VALUES (?,?,1,?,NOW(),NOW())');
                    $st->execute([$name,$code,$sort]);
                }
            }
            cp_redirect('impresion_precios.php?ok=' . rawurlencode('Catálogo guardado correctamente'));
        }

        if ($action === 'catalog_delete') {
            $type = trim((string)($_POST['type'] ?? ''));
            $id = (int)($_POST['id'] ?? 0);
            $table = ['size'=>'cp_print_sizes','material'=>'cp_print_materials','finish'=>'cp_print_finishes'][$type] ?? null;
            $column = ['size'=>'size_id','material'=>'material_id','finish'=>'finish_id'][$type] ?? null;
            if (!$table || !$column || $id < 1) throw new RuntimeException('Registro no válido.');

            $refs = 0;
            foreach (['cp_print_prices','cp_print_request_items','cp_print_price_rules'] as $refTable) {
                try {
                    $st = $db->prepare("SELECT COUNT(*) FROM {$refTable} WHERE {$column}=?");
                    $st->execute([$id]);
                    $refs += (int)$st->fetchColumn();
                } catch (Throwable $ignored) {}
            }

            if ($refs > 0) {
                $st = $db->prepare("UPDATE {$table} SET enabled=0, updated_at=NOW() WHERE id=?");
                $st->execute([$id]);
                cp_redirect('impresion_precios.php?ok=' . rawurlencode('Tiene historial relacionado y fue desactivado para conservar la integridad.'));
            }

            $st = $db->prepare("DELETE FROM {$table} WHERE id=?");
            $st->execute([$id]);
            cp_redirect('impresion_precios.php?ok=' . rawurlencode('Registro eliminado correctamente'));
        }

        if ($action === 'price_save') {
            $id = (int)($_POST['id'] ?? 0);
            $sizeId = (int)($_POST['size_id'] ?? 0);
            $materialId = (int)($_POST['material_id'] ?? 0);
            $finishId = (int)($_POST['finish_id'] ?? 0);
            $colorMode = trim((string)($_POST['color_mode'] ?? 'color'));
            $pricingMode = trim((string)($_POST['pricing_mode'] ?? 'per_page'));
            $unitPrice = (float)($_POST['unit_price'] ?? 0);
            $minQty = max(1, (int)($_POST['min_qty'] ?? 1));

            if ($sizeId < 1 || $materialId < 1 || $finishId < 1 || $unitPrice < 0) {
                throw new RuntimeException('Datos de tarifa inválidos.');
            }
            if (!in_array($colorMode, ['color','bw'], true) || !in_array($pricingMode, ['per_page','per_sheet'], true)) {
                throw new RuntimeException('Modo de tarifa inválido.');
            }

            $find = $db->prepare('SELECT id FROM cp_print_prices WHERE size_id=? AND material_id=? AND finish_id=? AND color_mode=? AND pricing_mode=? AND id<>? LIMIT 1');
            $find->execute([$sizeId,$materialId,$finishId,$colorMode,$pricingMode,$id]);
            if ($find->fetchColumn()) throw new RuntimeException('Ya existe una tarifa con esa combinación.');

            if ($id > 0) {
                $st = $db->prepare('UPDATE cp_print_prices SET size_id=?,material_id=?,finish_id=?,color_mode=?,pricing_mode=?,unit_price=?,min_qty=?,updated_at=NOW() WHERE id=?');
                $st->execute([$sizeId,$materialId,$finishId,$colorMode,$pricingMode,$unitPrice,$minQty,$id]);
            } else {
                $st = $db->prepare('INSERT INTO cp_print_prices (size_id,material_id,finish_id,color_mode,pricing_mode,unit_price,min_qty,enabled,created_at,updated_at) VALUES (?,?,?,?,?,?,?,1,NOW(),NOW())');
                $st->execute([$sizeId,$materialId,$finishId,$colorMode,$pricingMode,$unitPrice,$minQty]);
            }
            cp_redirect('impresion_precios.php?ok=' . rawurlencode('Tarifa guardada correctamente'));
        }

        if ($action === 'price_delete') {
            $id = (int)($_POST['id'] ?? 0);
            if ($id < 1) throw new RuntimeException('Tarifa no válida.');
            $st = $db->prepare('DELETE FROM cp_print_prices WHERE id=?');
            $st->execute([$id]);
            if ($st->rowCount() < 1) throw new RuntimeException('La tarifa no existe o ya fue eliminada.');
            cp_redirect('impresion_precios.php?ok=' . rawurlencode('Tarifa eliminada correctamente'));
        }

        throw new RuntimeException('Acción no válida.');
    } catch (Throwable $e) {
        cp_redirect('impresion_precios.php?ok=' . rawurlencode('No se pudo completar la operación: ' . $e->getMessage()));
    }
}

$sizes = $db->query("SELECT * FROM cp_print_sizes ORDER BY sort_order,id")->fetchAll();
$materials = $db->query("SELECT * FROM cp_print_materials ORDER BY sort_order,id")->fetchAll();
$finishes = $db->query("SELECT * FROM cp_print_finishes ORDER BY sort_order,id")->fetchAll();
$prices = $db->query("
    SELECT p.*, s.name AS size_name, m.name AS material_name, f.name AS finish_name
    FROM cp_print_prices p
    JOIN cp_print_sizes s ON s.id=p.size_id
    JOIN cp_print_materials m ON m.id=p.material_id
    JOIN cp_print_finishes f ON f.id=p.finish_id
    ORDER BY s.sort_order,m.sort_order,f.sort_order,p.color_mode,p.pricing_mode
")->fetchAll();

$msg = $_GET['ok'] ?? '';
$editPriceId = (int)($_GET['edit_price'] ?? 0);

$title = 'Configuración de impresión';
require __DIR__ . '/../includes/header.php';
?>
<style>
/* v10: rediseño visual aislado de admin/impresion_precios.php.
   La capa POST/CSRF/SQL anterior se conserva arriba sin cambios. */
.print-config-v10{--v10-bg:#091b2e;--v10-bg2:#0d2741;--v10-line:#214b70;--v10-line2:#2c638d;--v10-text:#eef7ff;--v10-muted:#89a9c7;--v10-cyan:#25d7ff;--v10-blue:#178cff;--v10-danger:#ff8fa7;max-width:1400px;margin:0 auto;padding:0 24px 42px;color:var(--v10-text)}
.print-config-v10 *{box-sizing:border-box}
.print-config-v10 .v10-opbar{display:flex;align-items:center;justify-content:space-between;gap:16px;margin:0 0 16px;padding:12px 14px;border:1px solid var(--v10-line);border-radius:14px;background:rgba(10,31,52,.78);box-shadow:0 10px 28px rgba(0,0,0,.14)}
.print-config-v10 .v10-opcopy{display:flex;align-items:center;gap:9px;min-width:0}.print-config-v10 .v10-opcopy strong{font-size:12px;letter-spacing:.08em;text-transform:uppercase;color:#a9c8e4}.print-config-v10 .v10-opdot{width:8px;height:8px;border-radius:50%;background:var(--v10-cyan);box-shadow:0 0 14px rgba(37,215,255,.55)}
.print-config-v10 .v10-oplinks{display:flex;gap:8px;flex-wrap:wrap}.print-config-v10 .v10-oplinks a{display:inline-flex;align-items:center;justify-content:center;min-height:36px;padding:8px 12px;border-radius:9px;text-decoration:none;font-size:11px;font-weight:800;border:1px solid var(--v10-line2);background:#153654;color:#dff3ff;transition:transform .16s ease,background .16s ease,border-color .16s ease}.print-config-v10 .v10-oplinks a.primary{background:linear-gradient(100deg,#1388ff,#22d7ff);border-color:transparent;color:#fff}.print-config-v10 .v10-oplinks a:hover{transform:translateY(-1px);background:#1a4569}
.print-config-v10 .v10-message{margin:0 0 16px;padding:11px 13px;border:1px solid #1b6c68;border-radius:12px;background:#0b302e;color:#7df0c9;font-size:12px;font-weight:700}
.print-config-v10 .v10-catalog-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:12px;margin-bottom:14px}
.print-config-v10 .v10-catalog-card{position:relative;overflow:hidden;min-height:214px;padding:15px;border:1px solid var(--v10-line);border-radius:15px;background:linear-gradient(145deg,rgba(13,39,65,.98),rgba(7,24,42,.98));box-shadow:0 13px 32px rgba(0,0,0,.16);transition:transform .22s ease,border-color .22s ease,box-shadow .22s ease}.print-config-v10 .v10-catalog-card:nth-child(1){animation:v10Rise .38s ease both}.print-config-v10 .v10-catalog-card:nth-child(2){animation:v10Rise .38s .08s ease both}.print-config-v10 .v10-catalog-card:nth-child(3){animation:v10Rise .38s .16s ease both}.print-config-v10 .v10-catalog-card:hover{transform:translateY(-3px);border-color:#3273a2;box-shadow:0 18px 40px rgba(0,0,0,.23)}
.print-config-v10 .v10-card-glow{position:absolute;width:130px;height:130px;right:-58px;top:-70px;border-radius:50%;background:rgba(37,215,255,.09);filter:blur(1px);pointer-events:none}.print-config-v10 .v10-card-top{display:flex;justify-content:space-between;align-items:flex-start;gap:10px}.print-config-v10 .v10-card-title{display:flex;gap:10px;min-width:0}.print-config-v10 .v10-number{width:31px;height:31px;flex:0 0 31px;display:grid;place-items:center;border-radius:10px;background:#123b5d;border:1px solid #24628b;color:var(--v10-cyan);font-weight:900;font-size:12px}.print-config-v10 .v10-card-title h2{margin:0;color:#f3f9ff;font-size:15px}.print-config-v10 .v10-card-title p{margin:3px 0 0;color:var(--v10-muted);font-size:10px;line-height:1.35}.print-config-v10 .v10-count{white-space:nowrap;padding:5px 8px;border:1px solid #28587e;border-radius:999px;background:#0a2138;color:#9dc7e6;font-size:9px;font-weight:900}
.print-config-v10 .v10-preview{display:grid;gap:5px;margin:14px 0 12px}.print-config-v10 .v10-preview-row{display:flex;align-items:center;justify-content:space-between;gap:10px;padding:7px 8px;border:1px solid rgba(38,78,111,.72);border-radius:8px;background:rgba(3,17,30,.45);font-size:10px}.print-config-v10 .v10-preview-row b{overflow:hidden;text-overflow:ellipsis;white-space:nowrap;color:#eaf5ff}.print-config-v10 .v10-preview-row span{white-space:nowrap;color:#72b2df}.print-config-v10 .v10-card-bottom{display:flex;align-items:center;justify-content:space-between;gap:8px;margin-top:auto}.print-config-v10 .v10-hint{font-size:9px;color:#688aa8}.print-config-v10 .v10-manage{min-height:34px!important;padding:7px 12px!important}
.print-config-v10 .v10-price-card{padding:15px;border:1px solid var(--v10-line);border-radius:15px;background:linear-gradient(145deg,rgba(13,39,65,.98),rgba(7,24,42,.98));box-shadow:0 13px 32px rgba(0,0,0,.16);animation:v10Rise .42s .23s ease both}.print-config-v10 .v10-price-head{display:flex;align-items:center;justify-content:space-between;gap:12px;margin-bottom:11px}.print-config-v10 .v10-price-head h2{margin:0;color:#f3f9ff;font-size:17px}.print-config-v10 .v10-price-head p{margin:3px 0 0;color:var(--v10-muted);font-size:10px}.print-config-v10 .v10-price-list{border:1px solid #1d4566;border-radius:11px;overflow:hidden}.print-config-v10 .v10-price-row{display:grid;grid-template-columns:1.05fr 1.05fr 1.05fr .9fr .55fr auto;align-items:center;gap:9px;padding:9px 10px;border-bottom:1px solid #173852;background:rgba(6,23,40,.5);transition:background .16s ease}.print-config-v10 .v10-price-row:last-child{border-bottom:0}.print-config-v10 .v10-price-row:hover{background:rgba(17,49,78,.62)}.print-config-v10 .v10-price-row.head{background:#0a2035;color:#78a6ca;text-transform:uppercase;letter-spacing:.06em;font-size:9px;font-weight:900}.print-config-v10 .v10-cell{min-width:0;color:#eaf5ff;font-size:11px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.print-config-v10 .v10-mode{display:inline-flex;max-width:100%;padding:4px 7px;border:1px solid #285678;border-radius:999px;background:#0a2239;color:#9dc7e5;font-size:9px;font-weight:800;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}.print-config-v10 .v10-price{font-weight:900;color:#fff}.print-config-v10 .v10-row-actions{display:flex;justify-content:flex-end;gap:6px;white-space:nowrap}.print-config-v10 .v10-row-actions .cp-btn{min-height:32px!important;padding:6px 10px!important;font-size:10px!important}
.print-config-v10 .v10-empty{padding:26px;text-align:center;color:#7898b4;font-size:12px}

/* Popup */
.print-config-v10 .v10-modal{position:fixed;inset:0;z-index:99999;display:flex;align-items:center;justify-content:center;padding:18px;background:rgba(2,9,17,.78);backdrop-filter:blur(8px);opacity:0;visibility:hidden;pointer-events:none;transition:opacity .18s ease,visibility .18s ease}.print-config-v10 .v10-modal.is-open{opacity:1;visibility:visible;pointer-events:auto}.print-config-v10 .v10-dialog{width:min(650px,100%);max-height:min(88vh,780px);overflow:auto;border:1px solid #2e6792;border-radius:18px;background:linear-gradient(160deg,#0e2d4b,#071a2e 68%,#061424);box-shadow:0 35px 100px rgba(0,0,0,.58);transform:translateY(18px) scale(.97);transition:transform .22s cubic-bezier(.2,.8,.2,1)}.print-config-v10 .v10-modal.is-open .v10-dialog{transform:none}.print-config-v10 .v10-dialog-head{display:flex;align-items:flex-start;justify-content:space-between;gap:12px;padding:17px 18px;border-bottom:1px solid #1e496b}.print-config-v10 .v10-dialog-kicker{font-size:9px;font-weight:900;letter-spacing:.14em;color:var(--v10-cyan)}.print-config-v10 .v10-dialog-head h3{margin:3px 0 0;color:#f5fbff;font-size:19px}.print-config-v10 .v10-dialog-head p{margin:4px 0 0;color:#87a9c6;font-size:11px}.print-config-v10 .v10-close{width:32px;height:32px;border:1px solid #315b7e;border-radius:9px;background:#0a2037;color:#cde5f7;font-size:20px;line-height:1;cursor:pointer}.print-config-v10 .v10-dialog-body{padding:17px 18px}.print-config-v10 .v10-stepbar{display:grid;grid-template-columns:1fr 1fr 1fr;gap:7px;margin-bottom:14px}.print-config-v10 .v10-step{padding:7px 8px;border-radius:8px;background:#092039;border:1px solid #1d4565;color:#7598b6;font-size:9px;font-weight:800;text-align:center}.print-config-v10 .v10-step.is-active{border-color:#2a8dc0;color:#dff7ff;background:#0d2d49}.print-config-v10 .v10-field-grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px}.print-config-v10 .v10-field{display:grid;gap:5px}.print-config-v10 .v10-field.full{grid-column:1/-1}.print-config-v10 .v10-field label{font-size:10px;font-weight:900;letter-spacing:.04em;text-transform:uppercase;color:#8eb0ca}.print-config-v10 .v10-modal input,.print-config-v10 .v10-modal select{width:100%;min-height:39px;padding:8px 10px;border:1px solid #315b80;border-radius:9px;background:#06182a;color:#eff8ff;font:inherit;font-size:12px;outline:none}.print-config-v10 .v10-modal input:focus,.print-config-v10 .v10-modal select:focus{border-color:#29d6ff;box-shadow:0 0 0 3px rgba(41,214,255,.11)}
.print-config-v10 .v10-switch-wrap{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:10px 11px;border:1px solid #204968;border-radius:10px;background:#091f34}.print-config-v10 .v10-switch-copy strong{display:block;font-size:11px;color:#e7f4ff}.print-config-v10 .v10-switch-copy span{display:block;margin-top:2px;font-size:9px;color:#7195b3}.print-config-v10 .v10-switch{position:relative;width:45px;height:25px;flex:0 0 45px}.print-config-v10 .v10-switch input{position:absolute;opacity:0;width:1px;height:1px}.print-config-v10 .v10-switch-track{position:absolute;inset:0;border-radius:999px;background:#17334d;border:1px solid #315a7d;cursor:pointer;transition:.18s ease}.print-config-v10 .v10-switch-track:after{content:"";position:absolute;top:3px;left:3px;width:17px;height:17px;border-radius:50%;background:#91abc0;box-shadow:0 2px 5px rgba(0,0,0,.3);transition:.18s ease}.print-config-v10 .v10-switch input:checked + .v10-switch-track{background:#087ed4;border-color:#2bcfff;box-shadow:0 0 0 3px rgba(43,207,255,.08)}.print-config-v10 .v10-switch input:checked + .v10-switch-track:after{transform:translateX(20px);background:#fff}.print-config-v10 .v10-switch input:focus-visible + .v10-switch-track{outline:2px solid #fff;outline-offset:2px}
.print-config-v10 .v10-dialog-foot{display:flex;align-items:center;justify-content:space-between;gap:9px;padding:13px 18px;border-top:1px solid #1e496b;background:rgba(3,14,25,.38)}.print-config-v10 .v10-foot-group{display:flex;gap:7px;align-items:center;flex-wrap:wrap}.print-config-v10 .v10-dialog-foot .cp-btn{min-height:36px!important}.print-config-v10 .v10-danger-note{font-size:9px;color:#7f9eb8;margin:0 0 8px}.print-config-v10 .v10-confirm{padding:8px 10px;border:1px solid #7b3549;border-radius:8px;background:#421d2b;color:#ffb9c7;font-size:10px;font-weight:900;cursor:pointer}
.print-config-v10 .v10-toast{position:fixed;right:18px;bottom:18px;z-index:100000;opacity:0;transform:translateY(8px);pointer-events:none;padding:10px 13px;border:1px solid #2b7894;border-radius:10px;background:#0b2941;color:#dff8ff;font-size:11px;font-weight:800;transition:.2s ease}.print-config-v10 .v10-toast.show{opacity:1;transform:none}
@keyframes v10Rise{from{opacity:0;transform:translateY(9px)}to{opacity:1;transform:none}}
@media(max-width:1050px){.print-config-v10 .v10-catalog-grid{grid-template-columns:1fr 1fr}.print-config-v10 .v10-catalog-card:nth-child(3){grid-column:1/-1}.print-config-v10 .v10-price-row{grid-template-columns:1fr 1fr 1fr}.print-config-v10 .v10-row-actions{grid-column:1/-1;justify-content:flex-start}}
@media(max-width:720px){.print-config-v10{padding:0 10px 28px}.print-config-v10 .v10-opbar,.print-config-v10 .v10-price-head{align-items:stretch;flex-direction:column}.print-config-v10 .v10-oplinks a{flex:1}.print-config-v10 .v10-catalog-grid{grid-template-columns:1fr}.print-config-v10 .v10-catalog-card:nth-child(3){grid-column:auto}.print-config-v10 .v10-price-row.head{display:none}.print-config-v10 .v10-price-row{grid-template-columns:1fr 1fr;gap:7px;padding:12px}.print-config-v10 .v10-price-row:not(.head){border-bottom:1px solid #214560}.print-config-v10 .v10-cell{white-space:normal}.print-config-v10 .v10-cell:nth-child(1):before{content:'Tamaño';display:block;margin-bottom:2px;color:#688dad;font-size:8px;text-transform:uppercase;font-weight:900}.print-config-v10 .v10-cell:nth-child(2):before{content:'Material';display:block;margin-bottom:2px;color:#688dad;font-size:8px;text-transform:uppercase;font-weight:900}.print-config-v10 .v10-cell:nth-child(3):before{content:'Acabado';display:block;margin-bottom:2px;color:#688dad;font-size:8px;text-transform:uppercase;font-weight:900}.print-config-v10 .v10-cell:nth-child(4):before{content:'Modo';display:block;margin-bottom:2px;color:#688dad;font-size:8px;text-transform:uppercase;font-weight:900}.print-config-v10 .v10-cell:nth-child(5):before{content:'Precio';display:block;margin-bottom:2px;color:#688dad;font-size:8px;text-transform:uppercase;font-weight:900}.print-config-v10 .v10-row-actions{grid-column:1/-1}.print-config-v10 .v10-row-actions .cp-btn{flex:1}.print-config-v10 .v10-dialog{max-height:92vh;border-radius:15px}.print-config-v10 .v10-field-grid{grid-template-columns:1fr}.print-config-v10 .v10-field.full{grid-column:auto}.print-config-v10 .v10-dialog-foot{align-items:stretch;flex-direction:column}.print-config-v10 .v10-foot-group{width:100%}.print-config-v10 .v10-foot-group .cp-btn{flex:1}.print-config-v10 .v10-dialog-foot form{width:100%}.print-config-v10 .v10-dialog-foot form .cp-btn{width:100%}}

/* v11: legibilidad para lectura cómoda, sin alterar lógica ni funcionalidad */
.print-config-v10{font-size:14px}
.print-config-v10 .v10-opcopy strong{font-size:13px}
.print-config-v10 .v10-oplinks a{font-size:13px;min-height:40px;padding:9px 14px}
.print-config-v10 .v10-message{font-size:14px;padding:12px 14px}
.print-config-v10 .v10-card-title h2{font-size:18px}
.print-config-v10 .v10-card-title p{font-size:12px}
.print-config-v10 .v10-number{font-size:14px;width:34px;height:34px;flex-basis:34px}
.print-config-v10 .v10-count{font-size:11px;padding:6px 9px}
.print-config-v10 .v10-preview{gap:7px;margin:15px 0 13px}
.print-config-v10 .v10-preview-row{padding:9px 10px;font-size:13px;min-height:36px}
.print-config-v10 .v10-hint{font-size:11px}
.print-config-v10 .v10-manage{min-height:38px!important;padding:8px 14px!important;font-size:13px!important}
.print-config-v10 .v10-price-card{padding:17px}
.print-config-v10 .v10-price-head h2{font-size:19px}
.print-config-v10 .v10-price-head p{font-size:12px}
.print-config-v10 .v10-price-row{gap:10px;padding:11px 12px}
.print-config-v10 .v10-price-row.head{font-size:11px}
.print-config-v10 .v10-cell{font-size:13px}
.print-config-v10 .v10-mode{font-size:11px;padding:5px 8px}
.print-config-v10 .v10-row-actions{gap:7px}
.print-config-v10 .v10-row-actions .cp-btn{min-height:36px!important;padding:7px 11px!important;font-size:12px!important}
.print-config-v10 .v10-empty{font-size:14px}
.print-config-v10 .v10-dialog-head{padding:19px 20px}
.print-config-v10 .v10-dialog-kicker{font-size:11px}
.print-config-v10 .v10-dialog-head h3{font-size:21px}
.print-config-v10 .v10-dialog-head p{font-size:13px}
.print-config-v10 .v10-dialog-body{padding:19px 20px}
.print-config-v10 .v10-step{padding:9px 10px;font-size:11px}
.print-config-v10 .v10-field{gap:6px}
.print-config-v10 .v10-field label{font-size:12px}
.print-config-v10 .v10-modal input,.print-config-v10 .v10-modal select{min-height:43px;padding:9px 11px;font-size:14px}
.print-config-v10 .v10-switch-wrap{padding:12px 13px}
.print-config-v10 .v10-switch-copy strong{font-size:13px}
.print-config-v10 .v10-switch-copy span{font-size:11px}
.print-config-v10 .v10-dialog-foot{padding:14px 20px}
.print-config-v10 .v10-danger-note{font-size:11px}
.print-config-v10 .v10-confirm{font-size:12px}
.print-config-v10 .v10-toast{font-size:13px;padding:11px 14px}
@media(max-width:720px){
  .print-config-v10{font-size:14px}
  .print-config-v10 .v10-oplinks a{font-size:14px;min-height:42px}
  .print-config-v10 .v10-card-title h2{font-size:19px}
  .print-config-v10 .v10-card-title p{font-size:13px}
  .print-config-v10 .v10-preview-row{font-size:14px;padding:10px}
  .print-config-v10 .v10-hint{font-size:12px}
  .print-config-v10 .v10-manage{font-size:14px!important}
  .print-config-v10 .v10-price-head h2{font-size:20px}
  .print-config-v10 .v10-price-head p{font-size:13px}
  .print-config-v10 .v10-price-row{padding:13px}
  .print-config-v10 .v10-cell{font-size:14px}
  .print-config-v10 .v10-cell:nth-child(1):before,.print-config-v10 .v10-cell:nth-child(2):before,.print-config-v10 .v10-cell:nth-child(3):before,.print-config-v10 .v10-cell:nth-child(4):before,.print-config-v10 .v10-cell:nth-child(5):before{font-size:10px}
  .print-config-v10 .v10-row-actions .cp-btn{font-size:13px!important;min-height:40px!important}
  .print-config-v10 .v10-dialog-head h3{font-size:22px}
  .print-config-v10 .v10-dialog-head p{font-size:14px}
  .print-config-v10 .v10-field label{font-size:13px}
  .print-config-v10 .v10-modal input,.print-config-v10 .v10-modal select{font-size:15px;min-height:45px}
}
</style>

<div class="print-config-v10">
  <div class="v10-opbar">
    <div class="v10-opcopy"><span class="v10-opdot"></span><strong>Operación de impresiones</strong></div>
    <div class="v10-oplinks">
      <a class="primary" href="recepcion_impresiones.php">▣ Recepción de impresiones</a>
      <a href="recepcion_historial.php">▤ Historial de impresiones</a>
    </div>
  </div>

  <?php if ($msg): ?><div class="v10-message">✓ <?= cp_e($msg) ?></div><?php endif; ?>

  <div class="v10-catalog-grid">
    <?php
    $cards = [
      ['size','1','Tamaños','Nombre, código, medidas y disponibilidad.',$sizes],
      ['material','2','Materiales','Nombre, código, unidad y disponibilidad.',$materials],
      ['finish','3','Acabados','Nombre, código y disponibilidad.',$finishes],
    ];
    foreach ($cards as [$type,$num,$name,$desc,$rows]):
    ?>
      <section class="v10-catalog-card" data-card-type="<?= cp_e($type) ?>">
        <span class="v10-card-glow" aria-hidden="true"></span>
        <div class="v10-card-top">
          <div class="v10-card-title">
            <div class="v10-number"><?= $num ?></div>
            <div><h2><?= cp_e($name) ?></h2><p><?= cp_e($desc) ?></p></div>
          </div>
          <span class="v10-count"><?= count($rows) ?> registros</span>
        </div>
        <div class="v10-preview">
          <?php foreach (array_slice($rows,0,3) as $row): ?>
            <div class="v10-preview-row">
              <b><?= cp_e($row['name']) ?></b>
              <span><?php if ($type==='size'): ?><?= cp_e($row['width_mm'].' × '.$row['height_mm'].' mm') ?><?php elseif ($type==='material'): ?><?= cp_e($row['unit_label']) ?><?php else: ?><?= cp_e($row['code']) ?><?php endif; ?></span>
            </div>
          <?php endforeach; ?>
          <?php if (count($rows)>3): ?><div class="v10-preview-row"><b>+ <?= count($rows)-3 ?> más</b><span>Administrar</span></div><?php endif; ?>
        </div>
        <div class="v10-card-bottom">
          <span class="v10-hint">Edición y altas desde popup</span>
          <button type="button" class="cp-btn cp-btn-soft v10-manage" data-catalog="<?= cp_e($type) ?>">Administrar</button>
        </div>
      </section>
    <?php endforeach; ?>
  </div>

  <section class="v10-price-card">
    <div class="v10-price-head">
      <div><h2>Matriz de tarifas</h2><p>La parte que realmente controla el precio del formulario.</p></div>
      <button type="button" class="cp-btn cp-btn-primary" id="v10-new-price">＋ Nueva tarifa</button>
    </div>

    <div class="v10-price-list">
      <div class="v10-price-row head"><div>Tamaño</div><div>Material</div><div>Acabado</div><div>Modo</div><div>Precio</div><div>Acciones</div></div>
      <?php if (!$prices): ?><div class="v10-empty">No hay tarifas registradas.</div><?php endif; ?>
      <?php foreach ($prices as $p): ?>
        <div class="v10-price-row">
          <div class="v10-cell"><?= cp_e($p['size_name']) ?></div>
          <div class="v10-cell"><?= cp_e($p['material_name']) ?></div>
          <div class="v10-cell"><?= cp_e($p['finish_name']) ?></div>
          <div class="v10-cell"><span class="v10-mode"><?= cp_e($p['color_mode'].' · '.$p['pricing_mode']) ?></span></div>
          <div class="v10-cell v10-price">$<?= number_format((float)$p['unit_price'],2,'.',',') ?></div>
          <div class="v10-row-actions">
            <button type="button" class="cp-btn cp-btn-soft v10-edit-price" data-price-id="<?= (int)$p['id'] ?>">Editar</button>
            <button type="button" class="cp-btn cp-btn-danger v10-delete-price" data-price-id="<?= (int)$p['id'] ?>">Eliminar</button>
          </div>
        </div>
      <?php endforeach; ?>
    </div>
  </section>

  <!-- Popup de catálogos -->
  <div class="v10-modal" id="v10-catalog-modal" aria-hidden="true">
    <div class="v10-dialog" role="dialog" aria-modal="true" aria-labelledby="v10-catalog-title">
      <div class="v10-dialog-head">
        <div><div class="v10-dialog-kicker">CATÁLOGO</div><h3 id="v10-catalog-title">Administrar</h3><p id="v10-catalog-desc">Selecciona un registro o crea uno nuevo.</p></div>
        <button type="button" class="v10-close" data-v10-close="v10-catalog-modal" aria-label="Cerrar">×</button>
      </div>
      <form method="post" action="catalog_save.php" id="v10-catalog-form">
        <div class="v10-dialog-body">
          <div class="v10-stepbar"><div class="v10-step is-active">1 · Registro</div><div class="v10-step">2 · Datos</div><div class="v10-step">3 · Guardar</div></div>
          <div class="v10-field-grid">
            <div class="v10-field full"><label for="v10-catalog-record">Registro</label><select id="v10-catalog-record"><option value="">＋ Nuevo registro</option></select></div>
            <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>">
            <input type="hidden" name="type" id="v10-catalog-type" value="">
            <input type="hidden" name="id" id="v10-catalog-id" value="">
            <div id="v10-catalog-fields" class="v10-field-grid full"></div>
          </div>
        </div>
        <div class="v10-dialog-foot">
          <div class="v10-foot-group">
            <button type="button" class="cp-btn cp-btn-soft" id="v10-catalog-new">＋ Nuevo</button>
            <button type="button" class="cp-btn cp-btn-soft" id="v10-catalog-clear">Limpiar</button>
            <button type="button" class="cp-btn cp-btn-danger" id="v10-catalog-delete" style="display:none">Eliminar</button>
          </div>
          <div class="v10-foot-group">
            <button type="button" class="cp-btn cp-btn-soft" data-v10-close="v10-catalog-modal">Cancelar</button>
            <button type="submit" class="cp-btn cp-btn-primary">Guardar</button>
          </div>
        </div>
      </form>
      <form id="v10-catalog-delete-form" method="post" action="catalog_save.php" hidden>
        <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>"><input type="hidden" name="type" id="v10-delete-type"><input type="hidden" name="id" id="v10-delete-id">
      </form>
    </div>
  </div>

  <!-- Popup de matriz de tarifas -->
  <div class="v10-modal" id="v10-price-modal" aria-hidden="true">
    <div class="v10-dialog" role="dialog" aria-modal="true" aria-labelledby="v10-price-title">
      <div class="v10-dialog-head">
        <div><div class="v10-dialog-kicker">MATRIZ DE TARIFAS</div><h3 id="v10-price-title">Nueva tarifa</h3><p>Guarda o edita una combinación sin alterar el listado.</p></div>
        <button type="button" class="v10-close" data-v10-close="v10-price-modal" aria-label="Cerrar">×</button>
      </div>
      <form method="post" action="price_save.php" id="v10-price-form">
        <div class="v10-dialog-body">
          <div class="v10-stepbar"><div class="v10-step is-active">1 · Combinación</div><div class="v10-step">2 · Precio</div><div class="v10-step">3 · Guardar</div></div>
          <input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>"><input type="hidden" name="id" id="v10-price-id" value="">
          <div class="v10-field-grid">
            <div class="v10-field"><label for="v10-price-size">Tamaño</label><select id="v10-price-size" name="size_id" required><option value="">Seleccionar</option><?php foreach ($sizes as $s): ?><option value="<?= (int)$s['id'] ?>"><?= cp_e($s['name']) ?></option><?php endforeach; ?></select></div>
            <div class="v10-field"><label for="v10-price-material">Material</label><select id="v10-price-material" name="material_id" required><option value="">Seleccionar</option><?php foreach ($materials as $m): ?><option value="<?= (int)$m['id'] ?>"><?= cp_e($m['name']) ?></option><?php endforeach; ?></select></div>
            <div class="v10-field"><label for="v10-price-finish">Acabado</label><select id="v10-price-finish" name="finish_id" required><option value="">Seleccionar</option><?php foreach ($finishes as $f): ?><option value="<?= (int)$f['id'] ?>"><?= cp_e($f['name']) ?></option><?php endforeach; ?></select></div>
            <div class="v10-field"><label for="v10-price-color">Modo</label><select id="v10-price-color" name="color_mode"><option value="color">Color</option><option value="bw">B/N</option></select></div>
            <div class="v10-field"><label for="v10-price-value">Precio</label><input id="v10-price-value" type="number" name="unit_price" step=".01" min="0" placeholder="0.00" required></div>
            <div class="v10-field"><label for="v10-price-mode">Cobro</label><select id="v10-price-mode" name="pricing_mode"><option value="per_page">Por página</option><option value="per_sheet">Por hoja</option></select></div>
            <div class="v10-field"><label for="v10-price-minqty">Cantidad mínima</label><input id="v10-price-minqty" type="number" name="min_qty" min="1" value="1" required></div>
          </div>
        </div>
        <div class="v10-dialog-foot">
          <div class="v10-foot-group"><button type="button" class="cp-btn cp-btn-soft" id="v10-price-clear">Limpiar</button><button type="button" class="cp-btn cp-btn-danger" id="v10-price-delete" style="display:none">Eliminar</button></div>
          <div class="v10-foot-group"><button type="button" class="cp-btn cp-btn-soft" data-v10-close="v10-price-modal">Cancelar</button><button type="submit" class="cp-btn cp-btn-primary">Guardar tarifa</button></div>
        </div>
      </form>
    </div>
  </div>

  <div class="v10-toast" id="v10-toast" role="status" aria-live="polite">Listo</div>
</div>

<script>
(function(){
  const catalogData = <?= json_encode(['size'=>array_values($sizes),'material'=>array_values($materials),'finish'=>array_values($finishes)], JSON_HEX_TAG|JSON_HEX_APOS|JSON_HEX_AMP|JSON_HEX_QUOT) ?>;
  const priceData = <?= json_encode(array_values($prices), JSON_HEX_TAG|JSON_HEX_APOS|JSON_HEX_AMP|JSON_HEX_QUOT) ?>;
  const meta = {
    size:{title:'Tamaños',desc:'Nombre, código, medidas y disponibilidad.'},
    material:{title:'Materiales',desc:'Nombre, código, unidad y disponibilidad.'},
    finish:{title:'Acabados',desc:'Nombre, código y disponibilidad.'}
  };
  const $ = (id)=>document.getElementById(id);
  const catalogModal=$('v10-catalog-modal'), priceModal=$('v10-price-modal');
  const catalogForm=$('v10-catalog-form'), priceForm=$('v10-price-form');
  const catalogType=$('v10-catalog-type'), catalogId=$('v10-catalog-id'), recordSelect=$('v10-catalog-record');
  const catalogFieldsEl=$('v10-catalog-fields'), catalogTitle=$('v10-catalog-title'), catalogDesc=$('v10-catalog-desc'), catalogDelete=$('v10-catalog-delete');
  const priceId=$('v10-price-id'), priceTitle=$('v10-price-title'), toast=$('v10-toast');
  let activeCatalog='size';

  function esc(v){return String(v??'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;').replace(/'/g,'&#039;')}
  function openModal(m){m.classList.add('is-open');m.setAttribute('aria-hidden','false');document.body.style.overflow='hidden'}
  function closeModal(m){m.classList.remove('is-open');m.setAttribute('aria-hidden','true');document.body.style.overflow=''}
  function toastMsg(t){toast.textContent=t;toast.classList.add('show');clearTimeout(window.v10ToastTimer);window.v10ToastTimer=setTimeout(()=>toast.classList.remove('show'),1800)}
  function catalogFields(type,row){
    const active=row ? Number(row.enabled)===1 : true;
    const switchHtml=`<div class="v10-switch-wrap v10-field full"><div class="v10-switch-copy"><strong>Disponible</strong><span>Si está apagado, el registro queda fuera del cotizador.</span></div><label class="v10-switch"><input name="enabled" type="checkbox" value="1" ${active?'checked':''} aria-label="Registro disponible"><span class="v10-switch-track"></span></label></div>`;
    if(type==='size') return `
      <div class="v10-field"><label>Nombre</label><input name="name" required value="${esc(row?.name)}"></div>
      <div class="v10-field"><label>Código</label><input name="code" required value="${esc(row?.code)}"></div>
      <div class="v10-field"><label>Ancho (mm)</label><input name="width_mm" type="number" step=".01" min=".01" required value="${esc(row?.width_mm)}"></div>
      <div class="v10-field"><label>Alto (mm)</label><input name="height_mm" type="number" step=".01" min=".01" required value="${esc(row?.height_mm)}"></div>
      ${switchHtml}`;
    if(type==='material') return `
      <div class="v10-field"><label>Nombre</label><input name="name" required value="${esc(row?.name)}"></div>
      <div class="v10-field"><label>Código</label><input name="code" required value="${esc(row?.code)}"></div>
      <div class="v10-field"><label>Unidad</label><input name="unit_label" required value="${esc(row?.unit_label)}"></div>
      ${switchHtml}`;
    return `
      <div class="v10-field"><label>Nombre</label><input name="name" required value="${esc(row?.name)}"></div>
      <div class="v10-field"><label>Código</label><input name="code" required value="${esc(row?.code)}"></div>
      ${switchHtml}`;
  }
  function populateCatalog(id){
    recordSelect.innerHTML='<option value="">＋ Nuevo registro</option>';
    (catalogData[activeCatalog]||[]).forEach(r=>{const o=document.createElement('option');o.value=r.id;o.textContent=r.name||('Registro #'+r.id);if(Number(r.id)===Number(id))o.selected=true;recordSelect.appendChild(o)});
  }
  function openCatalog(type,id){
    activeCatalog=type;catalogType.value=type;
    const row=(catalogData[type]||[]).find(r=>Number(r.id)===Number(id))||null;
    catalogId.value=row?row.id:'';populateCatalog(row?.id||'');catalogTitle.textContent=(row?'Editar ':'Nuevo ')+meta[type].title.slice(0,-1);catalogDesc.textContent=meta[type].desc;catalogFieldsEl.innerHTML=catalogFieldsFor(type,row);catalogDelete.style.display=row?'inline-flex':'none';catalogDelete.dataset.id=row?.id||'';openModal(catalogModal);
  }
  function catalogFieldsFor(type,row){return catalogFieldsHtml(type,row)}
  function catalogFieldsHtml(type,row){return catalogFields(type,row)}

  document.querySelectorAll('.v10-manage').forEach(b=>b.addEventListener('click',()=>openCatalog(b.dataset.catalog,'')));
  recordSelect.addEventListener('change',()=>openCatalog(activeCatalog,recordSelect.value));
  $('v10-catalog-new').addEventListener('click',()=>openCatalog(activeCatalog,''));
  $('v10-catalog-clear').addEventListener('click',()=>{catalogId.value='';populateCatalog('');catalogFieldsEl.innerHTML=catalogFields(activeCatalog,null);catalogDelete.style.display='none';catalogTitle.textContent='Nuevo '+meta[activeCatalog].title.slice(0,-1);toastMsg('Formulario limpio')});
  catalogDelete.addEventListener('click',()=>{const id=catalogDelete.dataset.id;if(!id)return;if(!confirm('Si el registro tiene historial o tarifas relacionadas, se desactivará para proteger los datos. ¿Continuar?'))return;$('v10-delete-type').value=activeCatalog;$('v10-delete-id').value=id;$('v10-catalog-delete-form').submit()});
  catalogForm.addEventListener('submit',()=>{if(!catalogId.value){catalogId.value=''}});

  function resetPrice(){priceForm.reset();priceId.value='';priceTitle.textContent='Nueva tarifa';$('v10-price-minqty').value='1'}
  function openPrice(id){resetPrice();const p=priceData.find(r=>Number(r.id)===Number(id));if(p){priceId.value=p.id;priceTitle.textContent='Editar tarifa';$('v10-price-size').value=p.size_id;$('v10-price-material').value=p.material_id;$('v10-price-finish').value=p.finish_id;$('v10-price-color').value=p.color_mode;$('v10-price-value').value=p.unit_price;$('v10-price-mode').value=p.pricing_mode;$('v10-price-minqty').value=p.min_qty||1}$('v10-price-delete').style.display=p?'inline-flex':'none';openModal(priceModal)}
  $('v10-new-price').addEventListener('click',()=>openPrice(''));
  document.querySelectorAll('.v10-edit-price').forEach(b=>b.addEventListener('click',()=>openPrice(b.dataset.priceId)));
  $('v10-price-clear').addEventListener('click',()=>{resetPrice();$('v10-price-delete').style.display='none';toastMsg('Formulario limpio')});
  $('v10-price-delete').addEventListener('click',()=>{const id=priceId.value;if(!id){toastMsg('Selecciona una tarifa');return}if(!confirm('¿Eliminar definitivamente esta tarifa?'))return;const f=document.createElement('form');f.method='post';f.action='price_delete.php';f.innerHTML='<input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>"><input type="hidden" name="id" value="'+esc(id)+'">';document.body.appendChild(f);f.submit()});
  document.querySelectorAll('.v10-delete-price').forEach(b=>b.addEventListener('click',()=>{if(!confirm('¿Eliminar definitivamente esta tarifa?'))return;const f=document.createElement('form');f.method='post';f.action='price_delete.php';f.innerHTML='<input type="hidden" name="csrf" value="<?= cp_e(cp_csrf()) ?>"><input type="hidden" name="id" value="'+esc(b.dataset.priceId)+'">';document.body.appendChild(f);f.submit()}));
  document.querySelectorAll('[data-v10-close]').forEach(b=>b.addEventListener('click',()=>closeModal($(b.dataset.v10Close))));
  [catalogModal,priceModal].forEach(m=>m.addEventListener('click',e=>{if(e.target===m)closeModal(m)}));
  document.addEventListener('keydown',e=>{if(e.key==='Escape'){closeModal(catalogModal);closeModal(priceModal)}});
})();
</script>

<?php require __DIR__ . '/../includes/footer.php'; ?>
