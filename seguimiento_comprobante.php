<?php
declare(strict_types=1);
require_once __DIR__ . '/includes/seguimiento.php';
require_once __DIR__ . '/includes/company.php';
require_once __DIR__ . '/includes/cotizacion_pdf_renderer.php';

$token=trim((string)($_GET['t']??''));
if(!preg_match('/^[a-f0-9]{64}$/i',$token)){http_response_code(404);exit('Enlace no válido.');}
$order=tracking_order_by_token($token);
if(!$order){http_response_code(404);exit('El seguimiento ya no está disponible.');}
$orderId=(int)$order['id']; $items=tracking_order_items($orderId); $finance=tracking_payment_summary($orderId); $company=company_profile();
$brand=trim((string)($company['trade_name']?:$company['legal_name']?:'Colibrí Print')); $legal=trim((string)($company['legal_name']??''));
$contact=implode(' · ',array_filter([trim((string)($company['phone']??'')),trim((string)($company['email']??'')),trim((string)($company['website']??''))]));
$orderNumber=(string)$order['order_number']; $customer=trim((string)($order['customer_name']??''))?:'Cliente';
$total=(float)$finance['order_total']; $paid=(float)$finance['paid_total']; $balance=(float)$finance['balance'];
$current=tracking_internal_to_client_stage(tracking_current_stage($orderId)); $stages=tracking_client_stages(); $currentLabel=(string)($stages[$current]['label']??'En proceso');
$paymentInfo=trim((string)($company['payment_info']??''));

final class LetterPdf {
    private array $pages=[]; private string $stream=''; private int $pageNo=0; private float $r=.04,$g=.10,$b=.17;
    public function __construct(){ $this->newPage(); }
    public function fill(float $r,float $g,float $b):void{$this->r=$r;$this->g=$g;$this->b=$b;$this->stream.=sprintf("%.3f %.3f %.3f rg\n",$r,$g,$b);}
    public function stroke(float $r,float $g,float $b):void{$this->stream.=sprintf("%.3f %.3f %.3f RG\n",$r,$g,$b);}
    public function lw(float $w):void{$this->stream.=sprintf("%.2f w\n",$w);}
    public function newPage():void{if($this->pageNo>0)$this->pages[$this->pageNo]=$this->stream;$this->pageNo++;$this->stream='';$this->fill(.04,.10,.17);$this->stroke(.80,.84,.88);$this->lw(.6);}
    public function text(string $s,float $size,float $x,float $y,bool $bold=false):void{$font=$bold?'/F2':'/F1';$this->stream.="BT {$font} {$size} Tf {$x} {$y} Td (".pdf_text($s).") Tj ET\n";}
    public function line(float $x1,float $y1,float $x2,float $y2):void{$this->stream.="{$x1} {$y1} m {$x2} {$y2} l S\n";}
    public function rect(float $x,float $y,float $w,float $h):void{$this->stream.="{$x} {$y} {$w} {$h} re S\n";}
    public function fillRect(float $x,float $y,float $w,float $h):void{$this->stream.="{$x} {$y} {$w} {$h} re f\n";}
    public function finish():string{
        if($this->pageNo>0)$this->pages[$this->pageNo]=$this->stream;
        $objects=[ '<< /Type /Catalog /Pages 2 0 R >>' ]; $kids=[]; $base=3; $f1=3+count($this->pages)*2; $f2=$f1+1;
        foreach($this->pages as $i=>$stream){$po=$base+(($i-1)*2);$co=$po+1;$kids[]="$po 0 R";$objects[$po-1]='<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] /Resources << /Font << /F1 '.$f1.' 0 R /F2 '.$f2.' 0 R >> >> /Contents '.$co.' 0 R >>';$objects[$co-1]="<< /Length ".strlen($stream)." >>\nstream\n".$stream."endstream";}
        $objects[1]='<< /Type /Pages /Kids ['.implode(' ',$kids).'] /Count '.count($this->pages).' >>';$objects[$f1-1]='<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>';$objects[$f2-1]='<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>';
        $pdf="%PDF-1.4\n";$offs=[0];foreach($objects as $idx=>$obj){$n=$idx+1;$offs[$n]=strlen($pdf);$pdf.="$n 0 obj\n$obj\nendobj\n";}$xref=strlen($pdf);$pdf.="xref\n0 ".(count($objects)+1)."\n0000000000 65535 f \n";for($i=1;$i<=count($objects);$i++)$pdf.=sprintf("%010d 00000 n \n",$offs[$i]);$pdf.="trailer\n<< /Size ".(count($objects)+1)." /Root 1 0 R >>\nstartxref\n{$xref}\n%%EOF";return $pdf;
    }
}
$pdf=new LetterPdf();
$navy=[.035,.095,.20];$teal=[.06,.55,.48];$pink=[.91,.08,.24];$slate=[.32,.38,.46];$muted=[.50,.55,.62];$white=[1,1,1];$light=[.955,.97,.985];$greenBg=[.92,.975,.94];$redBg=[1,.945,.955];$blueBg=[.93,.965,1];$border=[.82,.85,.90];
$left=42;$right=570;$w=528;$money=static fn(float $n):string=>pdf_money($n);

function lp_header(LetterPdf $p,string $brand,string $legal,string $contact,string $orderNo,array $navy,array $pink,array $white,int $page):void{
    $p->fill(...$navy);$p->fillRect($GLOBALS['left'],735,$GLOBALS['w'],45);$p->fill(...$pink);$p->fillRect($GLOBALS['left'],735,6,45);$p->fill(...$white);$p->text($brand,17,58,763,true);if($legal!==''&&$legal!==$brand)$p->text($legal,7.5,58,750,false);if($contact!=='')$p->text($contact,6.7,58,739,false);$p->text('SEGUIMIENTO',10,420,763,true);$p->text($orderNo,8,420,750,false);
}
function lp_footer(LetterPdf $p,string $brand,string $orderNo,int $page,array $teal,array $muted,array $border):void{
    $p->stroke(...$border);$p->line(42,34,570,34);$p->fill(...$muted);$p->text($brand.' · '.$orderNo,6.5,42,23,false);$p->text('Página '.$page.' de 2',6.5,500,23,false);
}
lp_header($pdf,$brand,$legal,$contact,$orderNumber,$navy,$pink,$white,1);
$pdf->fill(...$slate);$pdf->text('ORDEN',7,58,710,true);$pdf->fill(...$navy);$pdf->text($orderNumber,11,58,694,true);$pdf->fill(...$slate);$pdf->text('CLIENTE',7,230,710,true);$pdf->fill(...$navy);$pdf->text($customer,10,230,694,true);$pdf->fill(...$slate);$pdf->text('FECHA',7,455,710,true);$pdf->fill(...$navy);$pdf->text(date('d/m/Y'),10,455,694,true);$pdf->stroke(...$border);$pdf->line(42,676,570,676);

$pdf->fill(...$navy);$pdf->text('SERVICIOS / PRODUCTOS',9,42,655,true);$pdf->fill(...$muted);$pdf->text('CANT.',7,450,655,true);$pdf->text('IMPORTE',7,510,655,true);$pdf->stroke(...$border);$pdf->line(42,643,570,643);$y=626;
foreach($items as $i=>$item){$desc=trim((string)($item['description']??''))?:'Servicio';$lines=pdf_wrap($desc,65);if(count($lines)>2){$lines=array_slice($lines,0,2);$lines[1]=rtrim($lines[1],'.').'...';}$rh=max(25,count($lines)*10+9);if($i%2===0){$pdf->fill(...$light);$pdf->fillRect(42,$y-$rh+6,528,$rh);} $pdf->fill(...$navy);$ly=$y;foreach($lines as $ln){$pdf->text($ln,8,58,$ly,false);$ly-=10;}$pdf->fill(...$slate);$pdf->text(number_format((float)$item['quantity'],2,'.',''),7.8,450,$y,false);$pdf->fill(...$navy);$pdf->text($money((float)$item['subtotal']),8.2,510,$y,true);$pdf->stroke(...$border);$pdf->line(42,$y-$rh+6,570,$y-$rh+6);$y-=$rh;}
$y-=12;$pdf->fill(...$navy);$pdf->text('ESTADO ACTUAL',9,42,$y,true);$y-=14;$pdf->fill(...$blueBg);$pdf->fillRect(42,$y-31,528,31);$pdf->fill(...$navy);$pdf->text($currentLabel,11,58,$y-14,true);if(!empty($order['due_date'])){$pdf->fill(...$slate);$pdf->text('Fecha compromiso: '.date('d/m/Y',strtotime((string)$order['due_date'])),7.8,350,$y-14,false);}$y-=47;
$pdf->fill(...$navy);$pdf->text('RESUMEN FINANCIERO',9,42,$y,true);$y-=14;$pdf->fill(...$slate);$pdf->text('TOTAL',7,58,$y,true);$pdf->text('PAGADO',7,240,$y,true);$pdf->text('SALDO',7,420,$y,true);$pdf->fill(...$navy);$pdf->text($money($total),12,58,$y-18,true);$pdf->text($money($paid),12,240,$y-18,true);$pdf->fill(...($balance>0?$pink:$teal));$pdf->text($money($balance),12,420,$y-18,true);
$y-=54;$pdf->fill(...($balance>0?$redBg:$greenBg));$pdf->fillRect(42,$y-25,528,25);$pdf->fill(...($balance>0?$pink:$teal));$pdf->text($balance>0?'SALDO PENDIENTE DE LIQUIDAR':'ORDEN LIQUIDADA',8,58,$y-16,true);
lp_footer($pdf,$brand,$orderNumber,1,$teal,$muted,$border);

$pdf->newPage();lp_header($pdf,$brand,$legal,$contact,$orderNumber,$navy,$teal,$white,2);
$pdf->fill(...$slate);$pdf->text('RESUMEN DE PAGO',8,42,704,true);$pdf->fill(...$navy);$pdf->text('Detalle financiero y condiciones del pedido',18,42,675,true);
$y=635;$pdf->fill(...$navy);$pdf->fillRect(42,$y-28,528,28);$pdf->fill(...$white);$pdf->text('CONCEPTO',7,58,$y-18,true);$pdf->text('IMPORTE',7,500,$y-18,true);$y-=45;
foreach([['Total del servicio',$money($total)],['Pagado',$money($paid)],['Saldo pendiente',$money($balance)]] as $j=>$r){if($j===2){$pdf->fill(...$redBg);$pdf->fillRect(42,$y-32,528,32);}$pdf->fill(...($j===2&&$balance>0?$pink:$navy));$pdf->text($r[0],9,58,$y-18,$j===2);$pdf->text($r[1],$j===2?16:10,480,$y-18,true);$pdf->stroke(...$border);$pdf->line(42,$y-33,570,$y-33);$y-=33;}
$y-=20;$pdf->fill(...$navy);$pdf->text('PAGO REGISTRADO',9,42,$y,true);$y-=14;$pdf->stroke(...$border);$pdf->line(42,$y,570,$y);$y-=20;
if(!empty($finance['first_payment'])){$fp=$finance['first_payment'];$date=!empty($fp['payment_date'])?date('d/m/Y',strtotime((string)$fp['payment_date'])):'—';$method=(string)($fp['method_label']??'Pago confirmado');$pdf->fill(...$greenBg);$pdf->fillRect(42,$y-36,528,36);$pdf->fill(...$teal);$pdf->text('CONFIRMADO',7,58,$y-15,true);$pdf->fill(...$navy);$pdf->text($money((float)$fp['amount']),11,180,$y-15,true);$pdf->fill(...$slate);$pdf->text($method,7.5,310,$y-15,false);$pdf->text($date,7.5,470,$y-15,false);$y-=52;}else{$pdf->fill(...$redBg);$pdf->fillRect(42,$y-32,528,32);$pdf->fill(...$pink);$pdf->text('SIN PAGO CONFIRMADO',8,58,$y-14,true);$y-=48;}
$pdf->fill(...$navy);$pdf->text('DATOS PARA PAGO',9,42,$y,true);$y-=14;$pdf->stroke(...$border);$pdf->line(42,$y,570,$y);$y-=18;
if($paymentInfo!==''){foreach(array_values(array_filter(array_map('trim',preg_split('/\R/u',$paymentInfo)))) as $line){foreach(pdf_wrap($line,78) as $ln){$pdf->fill(...$slate);$pdf->text($ln,7.5,58,$y,false);$y-=10;}}}else{$pdf->fill(...$muted);$pdf->text('Datos bancarios no configurados.',8,58,$y,false);$y-=12;}
$y-=10;$pdf->fill(...$navy);$pdf->text('ESTADO DEL PEDIDO',9,42,$y,true);$y-=15;$pdf->fill(...$blueBg);$pdf->fillRect(42,$y-32,528,32);$pdf->fill(...$navy);$pdf->text($currentLabel,10,58,$y-15,true);$y-=48;
$pdf->fill(...$muted);$pdf->text('Este documento es un comprobante informativo del seguimiento y estado del pedido.',7,42,55,false);
lp_footer($pdf,$brand,$orderNumber,2,$teal,$muted,$border);

$data=$pdf->finish();header('Content-Type: application/pdf');header('Content-Length: '.strlen($data));header('Content-Disposition: attachment; filename="Seguimiento-'.$orderNumber.'.pdf"');header('Cache-Control: private, no-store, no-cache, must-revalidate, max-age=0');echo $data;
