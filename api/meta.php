<?php
declare(strict_types=1);
require __DIR__ . '/../bootstrap.php';

$pdo = db();
$sizes = $pdo->query("SELECT id,name,code,width_mm,height_mm,orientation,is_custom FROM cp_print_sizes WHERE enabled=1 ORDER BY sort_order,id")->fetchAll();
$materials = $pdo->query("SELECT id,name,code,unit_label FROM cp_print_materials WHERE enabled=1 ORDER BY sort_order,id")->fetchAll();
$finishes = $pdo->query("SELECT id,name,code FROM cp_print_finishes WHERE enabled=1 ORDER BY sort_order,id")->fetchAll();
$prices = $pdo->query("SELECT id,size_id,material_id,finish_id,color_mode,pricing_mode,unit_price,min_qty FROM cp_print_prices WHERE enabled=1 ORDER BY id")->fetchAll();

json_response(['ok'=>true,'sizes'=>$sizes,'materials'=>$materials,'finishes'=>$finishes,'prices'=>$prices]);
