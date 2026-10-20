<?php
declare(strict_types=1);

function pdf_text(string $text): string {
    $text = str_replace(["\r", "\n", "\t"], ' ', $text);
    $converted = iconv('UTF-8', 'Windows-1252//TRANSLIT//IGNORE', $text);
    if ($converted === false) $converted = $text;
    $converted = str_replace('\\', '\\\\', $converted);
    return str_replace(['(', ')'], ['\\(', '\\)'], $converted);
}

function pdf_wrap(string $text, int $maxChars): array {
    $text = preg_replace('/\s+/u', ' ', trim($text)) ?? trim($text);
    if ($text === '') return [''];
    return explode("\n", wordwrap($text, $maxChars, "\n", true));
}

function pdf_money(float $value): string {
    return '$' . number_format($value, 2, '.', ',');
}

final class SimplePdf {
    private array $pages = [];
    private string $stream = '';
    public float $y = 800;
    private int $pageNo = 0;
    private float $r = 0.04;
    private float $g = 0.10;
    private float $b = 0.17;

    public function __construct() { $this->newPage(); }

    public function setFill(float $r, float $g, float $b): void {
        $this->r = $r; $this->g = $g; $this->b = $b;
        $this->stream .= sprintf("%.3f %.3f %.3f rg\n", $r, $g, $b);
    }

    public function setStroke(float $r, float $g, float $b): void {
        $this->stream .= sprintf("%.3f %.3f %.3f RG\n", $r, $g, $b);
    }

    public function setLineWidth(float $w): void { $this->stream .= sprintf("%.2f w\n", $w); }

    public function newPage(): void {
        if ($this->pageNo > 0) $this->pages[$this->pageNo] = $this->stream;
        $this->pageNo++;
        $this->stream = '';
        $this->y = 792;
        $this->setFill(0.04, 0.10, 0.17);
        $this->setStroke(0.80, 0.84, 0.88);
        $this->setLineWidth(0.6);
        $this->line(44, 803, 551, 803);
    }

    public function need(float $h): void {
        if ($this->y - $h < 48) $this->newPage();
    }

    public function text(string $text, float $size = 10, bool $bold = false, float $x = 44, ?float $leading = null): void {
        $leading = $leading ?? ($size + 4);
        $this->need($leading);
        $this->textAt($text, $size, $x, $this->y, $bold);
        $this->y -= $leading;
    }

    public function textAt(string $text, float $size, float $x, float $y, bool $bold = false): void {
        $font = $bold ? '/F2' : '/F1';
        $this->stream .= "BT {$font} {$size} Tf {$x} {$y} Td (" . pdf_text($text) . ") Tj ET\n";
    }

    public function line(float $x1, float $y1, float $x2, float $y2): void {
        $this->stream .= "{$x1} {$y1} m {$x2} {$y2} l S\n";
    }

    public function rect(float $x, float $y, float $w, float $h): void {
        $this->stream .= "{$x} {$y} {$w} {$h} re S\n";
    }

    public function fillRect(float $x, float $y, float $w, float $h): void {
        $this->stream .= "{$x} {$y} {$w} {$h} re f\n";
    }

    public function getPages(): array {
        if ($this->pageNo > 0) $this->pages[$this->pageNo] = $this->stream;
        return $this->pages;
    }

    public function finish(): string {
        $pages = $this->getPages();
        $objects = [];
        $objects[] = '<< /Type /Catalog /Pages 2 0 R >>';
        $kids = [];
        $pageObjectBase = 3;
        $font1 = 3 + count($pages) * 2;
        $font2 = $font1 + 1;
        foreach ($pages as $i => $stream) {
            $pageObj = $pageObjectBase + (($i - 1) * 2);
            $contentObj = $pageObj + 1;
            $kids[] = $pageObj . ' 0 R';
            $objects[$pageObj - 1] = '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 ' . $font1 . ' 0 R /F2 ' . $font2 . ' 0 R >> >> /Contents ' . $contentObj . ' 0 R >>';
            $objects[$contentObj - 1] = "<< /Length " . strlen($stream) . " >>\nstream\n" . $stream . "endstream";
        }
        $objects[1] = '<< /Type /Pages /Kids [' . implode(' ', $kids) . '] /Count ' . count($pages) . ' >>';
        $objects[$font1 - 1] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>';
        $objects[$font2 - 1] = '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>';

        $pdf = "%PDF-1.4\n";
        $offsets = [0];
        foreach ($objects as $idx => $obj) {
            $objNum = $idx + 1;
            $offsets[$objNum] = strlen($pdf);
            $pdf .= $objNum . " 0 obj\n" . $obj . "\nendobj\n";
        }
        $xref = strlen($pdf);
        $pdf .= "xref\n0 " . (count($objects) + 1) . "\n0000000000 65535 f \n";
        for ($i = 1; $i <= count($objects); $i++) $pdf .= sprintf("%010d 00000 n \n", $offsets[$i]);
        $pdf .= "trailer\n<< /Size " . (count($objects) + 1) . " /Root 1 0 R >>\nstartxref\n{$xref}\n%%EOF";
        return $pdf;
    }
}

function generate_quote_pdf(array $quote, array $items, array $totals, array $company): string {
    $pdf = new SimplePdf();
    $brand = trim((string)($company['trade_name'] ?: $company['legal_name'] ?: 'Colibrí Print'));
    $legal = trim((string)($company['legal_name'] ?? ''));
    $cyan = [0.08, 0.72, 0.93];
    $navy = [0.04, 0.10, 0.17];
    $slate = [0.28, 0.34, 0.41];
    $light = [0.94, 0.96, 0.98];
    $border = [0.78, 0.82, 0.87];

    // Encabezado corporativo
    $pdf->setFill(...$navy);
    $pdf->fillRect(44, 748, 507, 56);
    $pdf->setFill(1, 1, 1);
    $pdf->textAt($brand, 20, 58, 780, true);
    $pdf->textAt($legal !== '' && $legal !== $brand ? $legal : 'Diseño · Impresión · Personalizados', 8.5, 58, 765, false);

    $contactLine = trim(implode(' · ', array_filter([
        (string)($company['phone'] ?? ''),
        (string)($company['email'] ?? ''),
        (string)($company['website'] ?? ''),
    ])));
    if ($contactLine !== '') $pdf->textAt($contactLine, 7.5, 58, 752, false);

    $pdf->setFill(...$cyan);
    $pdf->fillRect(430, 759, 121, 45);
    $pdf->setFill(1, 1, 1);
    $pdf->textAt('COTIZACIÓN', 8, 442, 786, true);
    $pdf->textAt((string)$quote['quote_number'], 13.5, 442, 770, true);

    $pdf->setStroke(...$border);
    $pdf->setLineWidth(0.6);
    $pdf->line(44, 738, 551, 738);

    // Metadatos de documento
    $pdf->setFill(...$slate);
    $issue = !empty($quote['issue_date']) ? date('d/m/Y', strtotime((string)$quote['issue_date'])) : '—';
    $valid = !empty($quote['valid_until']) ? date('d/m/Y', strtotime((string)$quote['valid_until'])) : 'Por confirmar';
    $pdf->textAt('FECHA DE EMISIÓN', 7.5, 58, 720, true);
    $pdf->textAt($issue, 10.5, 58, 705, true);
    $pdf->textAt('VIGENCIA', 7.5, 200, 720, true);
    $pdf->textAt($valid, 10.5, 200, 705, true);
    if (!empty($quote['client_reference'])) {
        $pdf->textAt('REFERENCIA', 7.5, 350, 720, true);
        $pdf->textAt((string)$quote['client_reference'], 9.5, 350, 705, true);
    }

    // Cliente
    $customerName = trim((string)($quote['customer_name'] ?? '')) ?: 'Cliente por confirmar';
    $pdf->setFill(...$light);
    $pdf->fillRect(44, 626, 507, 58);
    $pdf->setStroke(...$border);
    $pdf->rect(44, 626, 507, 58);
    $pdf->setFill(...$cyan);
    $pdf->textAt('DATOS DEL CLIENTE', 7.5, 58, 669, true);
    $pdf->setFill(...$navy);
    $pdf->textAt($customerName, 12, 58, 650, true);
    $customerMeta = trim(implode(' · ', array_filter([
        !empty($quote['customer_phone']) ? 'Tel. ' . $quote['customer_phone'] : '',
        !empty($quote['customer_email']) ? $quote['customer_email'] : '',
        !empty($quote['customer_tax_number']) ? 'RFC ' . $quote['customer_tax_number'] : '',
    ])));
    if ($customerMeta !== '') $pdf->textAt($customerMeta, 8, 58, 637, false);
    $customerAddress = trim((string)($quote['customer_address'] ?? ''));
    if ($customerAddress !== '') {
        $customerAddress .= !empty($quote['customer_city']) ? ', ' . $quote['customer_city'] : '';
        $pdf->textAt($customerAddress, 7.8, 300, 637, false);
    }

    // Referencias comerciales
    $refLines = array_values(array_filter([
        !empty($quote['payment_terms']) ? 'Condiciones de pago: ' . $quote['payment_terms'] : '',
        !empty($quote['delivery_time']) ? 'Tiempo de entrega: ' . $quote['delivery_time'] : '',
        !empty($quote['delivery_place']) ? 'Lugar de entrega: ' . $quote['delivery_place'] : '',
    ]));
    $cursor = 608;
    if ($refLines) {
        foreach ($refLines as $line) {
            $pdf->setFill(...$slate);
            $pdf->textAt($line, 7.7, 58, $cursor, false);
            $cursor -= 11;
        }
        $cursor -= 3;
    }

    // Detalle
    $pdf->setFill(...$navy);
    $pdf->fillRect(44, $cursor - 26, 507, 24);
    $pdf->setFill(1, 1, 1);
    $pdf->textAt('DETALLE DE LA PROPUESTA', 8.5, 58, $cursor - 18, true);
    $headerY = $cursor - 42;
    $pdf->setFill(...$slate);
    $pdf->textAt('DESCRIPCIÓN', 7.5, 58, $headerY, true);
    $pdf->textAt('CANT.', 7.5, 405, $headerY, true);
    $pdf->textAt('P. UNITARIO', 7.5, 455, $headerY, true);
    $pdf->textAt('IMPORTE', 7.5, 505, $headerY, true);
    $pdf->setStroke(...$border);
    $pdf->line(44, $headerY - 8, 551, $headerY - 8);
    $y = $headerY - 24;
    foreach ($items as $idx => $item) {
        $descLines = pdf_wrap((string)$item['description'], 58);
        $rowH = max(24, count($descLines) * 11 + 8);
        $pdf->need($rowH + 20);
        if ($idx % 2 === 0) {
            $pdf->setFill(0.975, 0.98, 0.99);
            $pdf->fillRect(44, $y - $rowH + 5, 507, $rowH);
        }
        $pdf->setFill(...$navy);
        $lineY = $y;
        foreach ($descLines as $line) {
            $pdf->textAt($line, 8, 58, $lineY, false);
            $lineY -= 11;
        }
        $pdf->textAt(number_format((float)$item['quantity'], 3, '.', ''), 8, 405, $y, false);
        $pdf->textAt(pdf_money((float)$item['unit_price']), 8, 455, $y, false);
        $pdf->textAt(pdf_money((float)$item['subtotal']), 8, 505, $y, false);
        $pdf->setStroke(...$border);
        $pdf->line(44, $y - $rowH + 5, 551, $y - $rowH + 5);
        $y -= $rowH;
    }

    // Totales
    $y -= 4;
    $pdf->setFill(...$navy);
    $pdf->fillRect(371, $y - 112, 180, 112);
    $pdf->setFill(1, 1, 1);
    $pdf->textAt('RESUMEN', 8.5, 384, $y - 18, true);
    $rows = [
        ['Subtotal', pdf_money((float)$totals['subtotal'])],
        ['Descuento', pdf_money((float)$totals['discount'])],
        ['Impuestos', pdf_money((float)$totals['tax'])],
    ];
    $ty = $y - 38;
    foreach ($rows as $r) {
        $pdf->textAt($r[0], 8, 384, $ty, false);
        $pdf->textAt($r[1], 8, 485, $ty, true);
        $ty -= 16;
    }
    $pdf->setFill(...$cyan);
    $pdf->fillRect(371, $y - 111, 180, 33);
    $pdf->setFill(1, 1, 1);
    $pdf->textAt('TOTAL', 10.5, 384, $y - 99, true);
    $pdf->textAt(pdf_money((float)$totals['total']), 13, 470, $y - 99, true);

    $contentY = min($y - 132, 500);

    // Notas y condiciones
    foreach ([
        ['NOTAS', (string)($quote['notes'] ?? '')],
        ['CONDICIONES COMERCIALES', (string)($quote['terms'] ?? '')],
    ] as $section) {
        $value = trim($section[1]);
        if ($value === '') continue;
        $lines = pdf_wrap($value, 90);
        $blockH = 18 + count($lines) * 10;
        if ($contentY - $blockH < 150) { $pdf->newPage(); $contentY = 770; }
        $pdf->setFill(...$cyan);
        $pdf->textAt($section[0], 8, 58, $contentY, true);
        $contentY -= 14;
        $pdf->setFill(...$slate);
        foreach ($lines as $line) { $pdf->textAt($line, 8, 58, $contentY, false); $contentY -= 10; }
        $contentY -= 8;
    }

    // Pago
    $paymentInfo = trim((string)($company['payment_info'] ?? ''));
    if ($paymentInfo !== '') {
        $paymentInfo = str_replace(["\\n", "\\r\\n"], ["\n", "\n"], $paymentInfo);
        $paymentLines = [];
        foreach (preg_split('/\R/u', $paymentInfo) ?: [] as $rawLine) {
            $rawLine = trim((string)$rawLine);
            if ($rawLine === '') continue;
            foreach (pdf_wrap($rawLine, 82) as $line) $paymentLines[] = $line;
        }
        $boxH = 28 + count($paymentLines) * 10;
        if ($contentY - $boxH < 72) { $pdf->newPage(); $contentY = 770; }
        $pdf->setFill(0.965, 0.975, 0.985);
        $pdf->fillRect(44, $contentY - $boxH, 507, $boxH);
        $pdf->setStroke(...$border);
        $pdf->rect(44, $contentY - $boxH, 507, $boxH);
        $pdf->setFill(...$navy);
        $pdf->textAt('INFORMACIÓN PARA PAGO', 8.5, 58, $contentY - 17, true);
        $py = $contentY - 33;
        $pdf->setFill(...$slate);
        foreach ($paymentLines as $line) { $pdf->textAt($line, 7.6, 58, $py, false); $py -= 10; }
        $contentY -= $boxH + 10;
    }

    // Pie
    $pdf->setStroke(...$border);
    $pdf->line(44, 55, 551, 55);
    $pdf->setFill(...$slate);
    $footer = trim((string)($company['quote_footer'] ?? ''));
    if ($footer !== '') $pdf->textAt($footer, 6.8, 44, 42, false);
    $pdf->textAt(trim($brand . ' · ' . ($company['website'] ?? '') . ' · ' . (string)$quote['quote_number']), 6.8, 44, 30, false);

    return $pdf->finish();
}
