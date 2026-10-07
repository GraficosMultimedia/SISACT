<?php
declare(strict_types=1);

require_once dirname(__DIR__) . '/config/runtime.php';
require_once dirname(__DIR__) . '/includes/company.php';

$publicConfig = dirname(__DIR__) . '/config/public.php';
if (is_file($publicConfig)) {
    require_once $publicConfig;
}

if (!function_exists('cp_public_base_path')) {
    function cp_public_base_path(): string
    {
        static $base = null;
        if ($base !== null) return $base;

        $documentRoot = isset($_SERVER['DOCUMENT_ROOT']) ? realpath((string)$_SERVER['DOCUMENT_ROOT']) : false;
        $projectRoot = realpath(dirname(__DIR__));

        if ($documentRoot && $projectRoot) {
            $doc = rtrim(str_replace('\\', '/', $documentRoot), '/');
            $root = str_replace('\\', '/', $projectRoot);
            if ($root === $doc) return $base = '';
            $prefix = $doc . '/';
            if (str_starts_with($root, $prefix)) {
                $relative = trim(substr($root, strlen($prefix)), '/');
                return $base = $relative !== '' ? '/' . $relative : '';
            }
        }

        $script = str_replace('\\', '/', (string)($_SERVER['SCRIPT_NAME'] ?? '/'));
        $candidate = trim(dirname($script), '/.');
        if ($candidate !== '' && str_ends_with($candidate, '/api')) {
            $candidate = dirname($candidate);
        }
        return $base = $candidate !== '' ? '/' . trim($candidate, '/') : '';
    }
}

if (!function_exists('cp_public_url')) {
    function cp_public_url(string $path = ''): string
    {
        $path = trim($path);
        if ($path === '') return cp_public_base_path() !== '' ? cp_public_base_path() . '/' : '/';
        if (preg_match('#^(?:https?:)?//#i', $path)) return $path;
        return cp_public_base_path() . '/' . ltrim($path, '/');
    }
}

if (!function_exists('cp_public_route')) {
    function cp_public_route(string $path, array $query = []): string
    {
        $url = cp_public_url($path);
        $query = array_filter($query, static fn($v) => $v !== null && $v !== '');
        return $query ? $url . '?' . http_build_query($query, '', '&', PHP_QUERY_RFC3986) : $url;
    }
}

if (!function_exists('cp_public_asset')) {
    function cp_public_asset(string $path): string { return cp_public_url($path); }
}

if (!function_exists('cp_public_absolute')) {
    function cp_public_absolute(string $path = ''): string
    {
        $https = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
            || ((int)($_SERVER['SERVER_PORT'] ?? 0) === 443)
            || strtolower((string)($_SERVER['HTTP_X_FORWARDED_PROTO'] ?? '')) === 'https';
        $origin = ($https ? 'https' : 'http') . '://' . trim((string)($_SERVER['HTTP_HOST'] ?? 'localhost'));
        return rtrim($origin, '/') . cp_public_url($path);
    }
}

if (!function_exists('cp_catalog_escape')) {
    function cp_catalog_escape(string $value): string
    {
        return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
    }
}

if (!function_exists('cp_catalog_image_url')) {
    function cp_catalog_image_url(?string $path): string
    {
        $path = trim((string)$path);
        if ($path === '') return '';
        if (preg_match('#^https?://#i', $path)) return $path;
        return '/' . ltrim($path, '/');
    }
}

if (!function_exists('cp_catalog_money')) {
    function cp_catalog_money($value): string
    {
        return is_numeric($value) ? '$' . number_format((float)$value, 2, '.', ',') . ' MXN' : '';
    }
}

if (!function_exists('cp_catalog_pricing_label')) {
    function cp_catalog_pricing_label(string $type): string
    {
        return [
            'fixed' => 'Precio definido',
            'variable' => 'Personalizable',
            'calculated' => 'Precio calculado',
            'project' => 'Proyecto cotizable',
        ][$type] ?? 'Cotización';
    }
}

if (!function_exists('cp_catalog_sort_sql')) {
    function cp_catalog_sort_sql(string $sort): string
    {
        return match ($sort) {
            'name_asc' => 'c.name ASC, p.name ASC, p.id DESC',
            'price_asc' => 'CASE WHEN p.sale_price IS NULL THEN 1 ELSE 0 END ASC, p.sale_price ASC, p.id DESC',
            'price_desc' => 'CASE WHEN p.sale_price IS NULL THEN 1 ELSE 0 END ASC, p.sale_price DESC, p.id DESC',
            'newest' => 'p.id DESC',
            default => "CASE WHEN p.pricing_type='fixed' AND p.sale_price IS NOT NULL THEN 0 ELSE 1 END ASC, p.id DESC",
        };
    }
}

if (!function_exists('cp_catalog_normalize_request')) {
    function cp_catalog_normalize_request(array $input): array
    {
        $categoryId = max(0, (int)($input['categoria'] ?? 0));
        $page = max(1, (int)($input['page'] ?? 1));
        $perPage = (int)($input['per_page'] ?? 12);
        if (!in_array($perPage, [8, 12, 16, 24], true)) $perPage = 12;

        $sort = trim((string)($input['orden'] ?? 'featured'));
        $allowedSorts = ['featured','newest','name_asc','price_asc','price_desc'];
        if (!in_array($sort, $allowedSorts, true)) $sort = 'featured';

        $q = trim((string)($input['q'] ?? ''));
        if (mb_strlen($q) > 80) $q = mb_substr($q, 0, 80);

        return [
            'categoria' => $categoryId,
            'q' => $q,
            'page' => $page,
            'per_page' => $perPage,
            'orden' => $sort,
        ];
    }
}

if (!function_exists('cp_catalog_get_categories')) {
    function cp_catalog_get_categories(PDO $pdo): array
    {
        $sql = "
            SELECT
                c.id,
                c.name,
                c.sort_order,
                COUNT(DISTINCT p.id) AS product_count,
                (
                    SELECT i.path
                    FROM cp_products p2
                    INNER JOIN cp_product_images i
                        ON i.product_id=p2.id AND i.enabled=1
                    WHERE p2.category_id=c.id
                      AND p2.enabled=1
                      AND p2.visible_web=1
                    ORDER BY p2.id DESC, i.sort_order ASC, i.id ASC
                    LIMIT 1
                ) AS image_path
            FROM cp_categories c
            LEFT JOIN cp_products p
                ON p.category_id=c.id
               AND p.enabled=1
               AND p.visible_web=1
            WHERE c.type='product' AND c.enabled=1
            GROUP BY c.id, c.name, c.sort_order
            ORDER BY c.sort_order ASC, c.name ASC
        ";
        return $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
    }
}

if (!function_exists('cp_catalog_get_products')) {
    function cp_catalog_get_products(PDO $pdo, array $filters): array
    {
        $where = [
            'p.enabled=1',
            'p.visible_web=1',
            'c.enabled=1',
            'c.type=\'product\'',
        ];
        $params = [];

        if ($filters['categoria'] > 0) {
            $where[] = 'p.category_id=?';
            $params[] = $filters['categoria'];
        }

        if ($filters['q'] !== '') {
            $where[] = '(p.name LIKE ? OR p.sku LIKE ? OR p.description LIKE ?)';
            $like = '%' . $filters['q'] . '%';
            array_push($params, $like, $like, $like);
        }

        $whereSql = implode(' AND ', $where);

        $countStmt = $pdo->prepare("SELECT COUNT(*) FROM cp_products p INNER JOIN cp_categories c ON c.id=p.category_id WHERE {$whereSql}");
        $countStmt->execute($params);
        $total = (int)$countStmt->fetchColumn();

        $pages = max(1, (int)ceil($total / $filters['per_page']));
        if ($filters['page'] > $pages) $filters['page'] = $pages;
        $offset = ($filters['page'] - 1) * $filters['per_page'];
        $limit = (int)$filters['per_page'];
        $offset = (int)$offset;

        $sql = "
            SELECT
                p.id,
                p.name,
                p.sku,
                p.description,
                p.sale_price,
                p.pricing_type,
                p.category_id,
                c.name AS category_name,
                (
                    SELECT COUNT(*)
                    FROM cp_product_images ic
                    WHERE ic.product_id=p.id AND ic.enabled=1
                ) AS image_count,
                (
                    SELECT i.path
                    FROM cp_product_images i
                    WHERE i.product_id=p.id AND i.enabled=1
                    ORDER BY i.sort_order ASC, i.id ASC
                    LIMIT 1
                ) AS image_path
            FROM cp_products p
            INNER JOIN cp_categories c ON c.id=p.category_id
            WHERE {$whereSql}
            ORDER BY " . cp_catalog_sort_sql($filters['orden']) . "
            LIMIT {$limit} OFFSET {$offset}
        ";

        $stmt = $pdo->prepare($sql);
        $stmt->execute($params);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach ($rows as &$row) {
            $row['id'] = (int)$row['id'];
            $row['category_id'] = (int)$row['category_id'];
            $row['image_count'] = (int)$row['image_count'];
            $row['sale_price'] = $row['sale_price'] !== null && is_numeric($row['sale_price']) ? (float)$row['sale_price'] : null;
            $row['pricing_label'] = cp_catalog_pricing_label((string)$row['pricing_type']);
            $row['image_url'] = cp_catalog_image_url($row['image_path'] ?? '');
            $row['url'] = cp_public_route('/producto.php', ['id' => $row['id']]);
        }
        unset($row);

        return [
            'items' => $rows,
            'pagination' => [
                'page' => $filters['page'],
                'per_page' => $filters['per_page'],
                'total' => $total,
                'pages' => $pages,
                'has_previous' => $filters['page'] > 1,
                'has_next' => $filters['page'] < $pages,
            ],
        ];
    }
}

if (!function_exists('cp_catalog_get_promotions')) {
    function cp_catalog_get_promotions(PDO $pdo, int $limit = 6): array
    {
        $limit = max(1, min(12, $limit));
        $sql = "
            SELECT
                pr.id,
                pr.title,
                pr.slug,
                pr.label,
                pr.description,
                pr.normal_price,
                pr.promo_price,
                pr.discount_percent,
                pr.start_date,
                pr.end_date,
                pr.image_path,
                (
                    SELECT pi.path
                    FROM cp_promotion_products pp2
                    INNER JOIN cp_product_images pi
                        ON pi.product_id=pp2.product_id AND pi.enabled=1
                    WHERE pp2.promotion_id=pr.id
                    ORDER BY pp2.sort_order ASC, pi.sort_order ASC, pi.id ASC
                    LIMIT 1
                ) AS product_image
            FROM cp_promotions pr
            WHERE pr.show_web=1
              AND pr.status <> 'draft'
              AND pr.start_date <= CURDATE()
              AND (pr.end_date IS NULL OR pr.end_date >= CURDATE())
            ORDER BY pr.id DESC
            LIMIT {$limit}
        ";

        $rows = $pdo->query($sql)->fetchAll(PDO::FETCH_ASSOC);
        foreach ($rows as &$row) {
            $row['id'] = (int)$row['id'];
            $row['normal_price'] = $row['normal_price'] !== null && is_numeric($row['normal_price']) ? (float)$row['normal_price'] : null;
            $row['promo_price'] = $row['promo_price'] !== null && is_numeric($row['promo_price']) ? (float)$row['promo_price'] : null;
            $row['discount_percent'] = $row['discount_percent'] !== null && is_numeric($row['discount_percent']) ? (float)$row['discount_percent'] : null;
            $row['image_url'] = cp_catalog_image_url($row['image_path'] ?: ($row['product_image'] ?? ''));
        }
        unset($row);
        return $rows;
    }
}

if (!function_exists('cp_catalog_payload')) {
    function cp_catalog_payload(PDO $pdo, array $input): array
    {
        $filters = cp_catalog_normalize_request($input);
        $categoryRows = cp_catalog_get_categories($pdo);
        $catalog = cp_catalog_get_products($pdo, $filters);
        $promotions = cp_catalog_get_promotions($pdo, 6);

        foreach ($categoryRows as &$category) {
            $category['id'] = (int)$category['id'];
            $category['product_count'] = (int)$category['product_count'];
            $category['image_url'] = cp_catalog_image_url($category['image_path'] ?? '');
        }
        unset($category);

        return [
            'success' => true,
            'meta' => [
                'source' => 'Colibrí Print México',
                'version' => '1.0',
                'generated_at' => gmdate('c'),
            ],
            'filters' => $filters,
            'categories' => $categoryRows,
            'products' => $catalog['items'],
            'pagination' => $catalog['pagination'],
            'promotions' => $promotions,
        ];
    }
}
