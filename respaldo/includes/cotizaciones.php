<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';

function quote_statuses(): array {
    return [
        'draft' => 'Borrador',
        'sent' => 'Enviada',
        'approved' => 'Aprobada',
        'rejected' => 'Rechazada',
        'expired' => 'Vencida',
        'cancelled' => 'Cancelada',
    ];
}

function quote_status_label(string $status): string {
    $statuses = quote_statuses();
    return $statuses[$status] ?? 'Desconocido';
}

function quote_money(float $value): string {
    return '$' . number_format($value, 2, '.', ',');
}

function quote_source_label(?string $source): string {
    if ($source === 'bastidor_lona') return 'Bastidor + Lona';
    if ($source === 'corte_cnc') return 'Corte CNC';
    return 'Manual';
}

function next_quote_number(): string {
    $prefix = 'CP-' . date('Y') . '-';
    $stmt = db()->prepare('SELECT quote_number FROM cp_quotes WHERE quote_number LIKE ? ORDER BY id DESC LIMIT 1');
    $stmt->execute([$prefix . '%']);
    $last = $stmt->fetchColumn();
    $seq = 1;
    if (is_string($last) && preg_match('/-(\d+)$/', $last, $m)) {
        $seq = ((int)$m[1]) + 1;
    }
    return $prefix . str_pad((string)$seq, 5, '0', STR_PAD_LEFT);
}

function quote_get(int $id): ?array {
    $stmt = db()->prepare(
        'SELECT q.*, c.name AS customer_name, c.email AS customer_email, c.phone AS customer_phone,
                c.address AS customer_address, c.city AS customer_city, c.state AS customer_state,
                c.zip_code AS customer_zip_code, c.tax_number AS customer_tax_number, c.country AS customer_country
         FROM cp_quotes q
         LEFT JOIN cp_customers c ON c.id=q.customer_id
         WHERE q.id=? LIMIT 1'
    );
    $stmt->execute([$id]);
    $row = $stmt->fetch();
    return $row ?: null;
}

function quote_items(int $quoteId): array {
    $stmt = db()->prepare('SELECT * FROM cp_quote_items WHERE quote_id=? ORDER BY sort_order,id');
    $stmt->execute([$quoteId]);
    return $stmt->fetchAll();
}

function quote_costs(int $quoteId): array {
    $stmt = db()->prepare('SELECT * FROM cp_quote_costs WHERE quote_id=? ORDER BY id');
    $stmt->execute([$quoteId]);
    return $stmt->fetchAll();
}

function quote_totals(int $quoteId): array {
    $stmt = db()->prepare('SELECT * FROM cp_quote_totals WHERE quote_id=? LIMIT 1');
    $stmt->execute([$quoteId]);
    return $stmt->fetch() ?: [
        'subtotal'=>0, 'discount'=>0, 'tax'=>0, 'total'=>0,
        'internal_cost'=>0, 'profit'=>0, 'margin_pct'=>0,
    ];
}

function quote_source_cost_rows(string $source, array $result): array {
    if ($source === 'bastidor_lona') {
        return [
            ['PTR', (float)($result['ptr_cost'] ?? 0)],
            ['Lona', (float)($result['canvas_cost'] ?? 0)],
            ['Impresión', (float)($result['print_cost'] ?? 0)],
            ['Mano de obra', (float)($result['labor_cost'] ?? 0)],
        ];
    }
    if ($source === 'corte_cnc') {
        return [
            ['Material', (float)($result['material_cost'] ?? 0)],
            ['Máquina', (float)($result['machine_cost'] ?? 0)],
            ['Mano de obra', (float)($result['labor_cost'] ?? 0)],
        ];
    }
    return [];
}

function quote_pending_normalize(?array $pending): ?array {
    if (!$pending || empty($pending['source'])) return null;
    return [
        'source' => (string)$pending['source'],
        'title' => (string)($pending['title'] ?? quote_source_label((string)$pending['source'])),
        'input' => is_array($pending['input'] ?? null) ? $pending['input'] : [],
        'result' => is_array($pending['result'] ?? null) ? $pending['result'] : [],
        'created_at' => (string)($pending['created_at'] ?? date('c')),
    ];
}

function quote_source_from_saved(array $quote): array {
    $data = [];
    if (!empty($quote['source_data'])) {
        $decoded = json_decode((string)$quote['source_data'], true);
        if (is_array($decoded)) $data = $decoded;
    }
    return [
        'source' => (string)($quote['source_calculator'] ?? ($data['source'] ?? '')),
        'title' => (string)($data['title'] ?? quote_source_label((string)($quote['source_calculator'] ?? ''))),
        'input' => is_array($data['input'] ?? null) ? $data['input'] : [],
        'result' => is_array($data['result'] ?? null) ? $data['result'] : [],
    ];
}

function quote_calculate_totals(float $quantity, float $unitPrice, float $discount, float $taxPct): array {
    $quantity = max(0.001, $quantity);
    $unitPrice = max(0, $unitPrice);
    $subtotal = round($quantity * $unitPrice, 2);
    $discount = min(max(0, $discount), $subtotal);
    $taxPct = max(0, min(100, $taxPct));
    $taxBase = max(0, $subtotal - $discount);
    $tax = round($taxBase * ($taxPct / 100), 2);
    $total = round($taxBase + $tax, 2);
    return compact('subtotal', 'discount', 'taxPct', 'tax', 'total');
}
