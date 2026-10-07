<?php
declare(strict_types=1);

if (!function_exists('cp_product_options_get')) {
    function cp_product_options_get(PDO $pdo, int $productId): array
    {
        if ($productId <= 0) return [];

        try {
            $groupsStmt = $pdo->prepare("
                SELECT id,product_id,name,code,input_type,required,help_text,placeholder,
                       min_length,max_length,min_value,max_value,accept,sort_order
                FROM cp_product_option_groups
                WHERE product_id=? AND enabled=1
                ORDER BY sort_order ASC,id ASC
            ");
            $groupsStmt->execute([$productId]);
            $groups = $groupsStmt->fetchAll(PDO::FETCH_ASSOC);
        } catch (Throwable $e) {
            return [];
        }

        if (!$groups) return [];

        $valueStmt = $pdo->prepare("
            SELECT id,group_id,label,value,price_delta,sku_suffix,sort_order
            FROM cp_product_option_values
            WHERE group_id=? AND enabled=1
            ORDER BY sort_order ASC,id ASC
        ");

        foreach ($groups as &$group) {
            $group['id'] = (int)$group['id'];
            $group['product_id'] = (int)$group['product_id'];
            $group['required'] = (int)$group['required'] === 1;
            $group['min_length'] = $group['min_length'] !== null ? (int)$group['min_length'] : null;
            $group['max_length'] = $group['max_length'] !== null ? (int)$group['max_length'] : null;
            $group['min_value'] = $group['min_value'] !== null ? (float)$group['min_value'] : null;
            $group['max_value'] = $group['max_value'] !== null ? (float)$group['max_value'] : null;
            $group['values'] = [];

            try {
                $valueStmt->execute([$group['id']]);
                foreach ($valueStmt->fetchAll(PDO::FETCH_ASSOC) as $value) {
                    $value['id'] = (int)$value['id'];
                    $value['group_id'] = (int)$value['group_id'];
                    $value['price_delta'] = is_numeric($value['price_delta']) ? (float)$value['price_delta'] : 0.0;
                    $group['values'][] = $value;
                }
            } catch (Throwable $e) {
                $group['values'] = [];
            }
        }
        unset($group);

        return $groups;
    }
}
