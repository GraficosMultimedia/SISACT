<?php
declare(strict_types=1);
function cp_integration_table_exists(PDO $pdo,string $table):bool{$s=$pdo->prepare("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE() AND table_name=?");$s->execute([$table]);return(bool)$s->fetchColumn();}
function cp_integration_health(PDO $pdo):array{$tabs=['cp_products','cp_categories','cp_promotions','cp_quotes','cp_orders','cp_payments','cp_invoices','cp_tracking_tokens','cp_web_checkout_sessions','cp_web_quote_requests','cp_projects'];$r=[];foreach($tabs as $t)$r[$t]=cp_integration_table_exists($pdo,$t);return$r;}
