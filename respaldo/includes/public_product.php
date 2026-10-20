<?php
declare(strict_types=1);

if (!function_exists('cp_public_product_get')) {
    function cp_public_product_get(PDO $pdo, int $productId): ?array
    {
        if ($productId <= 0) return null;

        $stmt = $pdo->prepare("
            SELECT
                p.id,
                p.name,
                p.sku,
                p.description,
                p.sale_price,
                p.pricing_type,
                p.category_id,
                c.name AS category_name
            FROM cp_products p
            LEFT JOIN cp_categories c ON c.id=p.category_id
            WHERE p.id=?
              AND p.enabled=1
              AND p.visible_web=1
            LIMIT 1
        ");
        $stmt->execute([$productId]);
        $product = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$product) return null;

        $imageStmt = $pdo->prepare("
            SELECT id,path,alt_text,sort_order
            FROM cp_product_images
            WHERE product_id=? AND enabled=1
            ORDER BY sort_order ASC,id ASC
        ");
        $imageStmt->execute([$productId]);
        $product['images'] = $imageStmt->fetchAll(PDO::FETCH_ASSOC);

        $product['id'] = (int)$product['id'];
        $product['category_id'] = (int)($product['category_id'] ?? 0);
        $product['sale_price'] = $product['sale_price'] !== null && is_numeric($product['sale_price'])
            ? (float)$product['sale_price']
            : null;

        return $product;
    }
}

if (!function_exists('cp_public_product_related')) {
    function cp_public_product_related(PDO $pdo, int $categoryId, int $excludeId, int $limit = 4): array
    {
        if ($categoryId <= 0 || $limit <= 0) return [];
        $limit = max(1, min(8, $limit));

        $sql = "
            SELECT
                p.id,p.name,p.sale_price,p.pricing_type,p.category_id,
                (
                    SELECT i.path
                    FROM cp_product_images i
                    WHERE i.product_id=p.id AND i.enabled=1
                    ORDER BY i.sort_order ASC, i.id ASC
                    LIMIT 1
                ) AS image_path,
                c.name AS category_name
            FROM cp_products p
            INNER JOIN cp_categories c ON c.id=p.category_id
            WHERE p.enabled=1
              AND p.visible_web=1
              AND p.category_id=?
              AND p.id<>?
            ORDER BY p.id DESC
            LIMIT {$limit}
        ";
        $stmt = $pdo->prepare($sql);
        $stmt->execute([$categoryId, $excludeId]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($rows as &$row) {
            $row['id'] = (int)$row['id'];
            $row['category_id'] = (int)$row['category_id'];
            $row['sale_price'] = $row['sale_price'] !== null && is_numeric($row['sale_price'])
                ? (float)$row['sale_price']
                : null;
            $row['image_url'] = cp_catalog_image_url($row['image_path'] ?? '');
            $row['url'] = cp_public_route('/producto.php', ['id' => $row['id']]);
            $row['pricing_label'] = cp_catalog_pricing_label((string)$row['pricing_type']);
        }
        unset($row);

        return $rows;
    }
}
