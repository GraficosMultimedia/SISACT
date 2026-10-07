final class CorporateOrderPdf
{
    private array $pages=[];
    private string $stream='';
    private int $pageNo=0;
    private float $r=0,$g=0,$b=0;
    private array $images=[];
    private array $imageNames=[];

    public function __construct(){ $this->newPage(); }
    public function newPage(): void{
        if($this->pageNo>0) $this->pages[$this->pageNo]=$this->stream;
        $this->pageNo++;
        $this->stream='';
        $this->setFill(1,1,1);
        $this->fillRect(0,0,595,842);
        $this->setStroke(.88,.90,.93);
        $this->setLineWidth(.6);
    }
    public function pageNo(): int { return $this->pageNo; }
    public function setFill(float $r,float $g,float $b):void{$this->r=$r;$this->g=$g;$this->b=$b;$this->stream.=sprintf("%.3f %.3f %.3f rg\n",$r,$g,$b);}
    public function setStroke(float $r,float $g,float $b):void{$this->stream.=sprintf("%.3f %.3f %.3f RG\n",$r,$g,$b);}
    public function setLineWidth(float $w):void{$this->stream.=sprintf("%.2f w\n",$w);}
    public function line(float $x1,float $y1,float $x2,float $y2):void{$this->stream.="{$x1} {$y1} m {$x2} {$y2} l S\n";}
    public function rect(float $x,float $y,float $w,float $h):void{$this->stream.="{$x} {$y} {$w} {$h} re S\n";}
    public function fillRect(float $x,float $y,float $w,float $h):void{$this->stream.="{$x} {$y} {$w} {$h} re f\n";}
    private function esc(string $s):string{
        $s=str_replace(["\r","\n","\t"],' ',$s);
        $c=iconv('UTF-8','Windows-1252//TRANSLIT//IGNORE',$s); if($c===false)$c=$s;
        $c=str_replace('\\','\\\\',$c);
        return str_replace(['(',')'],['\\(','\\)'],$c);
    }
    public function text(string $s,float $size,float $x,float $y,bool $bold=false):void{
        $font=$bold?'/F2':'/F1';
        $this->stream.="BT {$font} {$size} Tf {$x} {$y} Td (".$this->esc($s).") Tj ET\n";
    }
    private function approxWidth(string $s,float $size):float{
        $ascii=function_exists('iconv') ? @iconv('UTF-8','Windows-1252//TRANSLIT//IGNORE',$s) : false;
        $len=$ascii!==false ? strlen($ascii) : strlen($s);
        return $len*$size*.49;
    }
    public function textRight(string $s,float $size,float $right,float $y,bool $bold=false):void{$this->text($s,$size,$right-$this->approxWidth($s,$size),$y,$bold);}
    public function textCenter(string $s,float $size,float $cx,float $y,bool $bold=false):void{$this->text($s,$size,$cx-$this->approxWidth($s,$size)/2,$y,$bold);}
    public function addJpeg(string $path,float $x,float $y,float $w,float $h):void{
        if(!is_file($path)) return;
        $info=@getimagesize($path);
        if(!$info || (($info['mime']??'')!=='image/jpeg')) return;
        $name='/Im'.(count($this->images)+1);
        $this->images[]=['name'=>$name,'path'=>$path,'width'=>(int)$info[0],'height'=>(int)$info[1],'data'=>file_get_contents($path)];
        $this->stream.="q {$w} 0 0 {$h} {$x} {$y} cm {$name} Do Q\n";
    }
    public function finishPage():void{$this->pages[$this->pageNo]=$this->stream;}
    public function finish():string{
        $this->finishPage();
        $pages=$this->pages;
        $objects=[];
        $objects[1]='<< /Type /Catalog /Pages 2 0 R >>';
        $kids=[];
        $pageObjs=[];
        $contentObjs=[];
        $next=3;
        foreach($pages as $i=>$stream){$pageObjs[$i]=$next++;$contentObjs[$i]=$next++;}
        $imageObjs=[];$imgIndex=0;
        foreach($this->images as $img){$imgIndex++;$imageObjs[$img['name']]=$next++;}
        $font1=$next++;$font2=$next++;
        foreach($pages as $i=>$stream){
            $xobjects=''; foreach($imageObjs as $name=>$obj){$xobjects.=$name.' '.$obj.' 0 R ';}
            $res='<< /Font << /F1 '.$font1.' 0 R /F2 '.$font2.' 0 R >>';
            if($xobjects!=='')$res.=' /XObject << '.$xobjects.'>>';
            $res.=' >>';
            $objects[$pageObjs[$i]]='<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources '.$res.' /Contents '.$contentObjs[$i].' 0 R >>';
            $objects[$contentObjs[$i]]='<< /Length '.strlen($stream).' >>' . "\nstream\n" . $stream . "\nendstream";
            $kids[]=$pageObjs[$i].' 0 R';
        }
        $objects[2]='<< /Type /Pages /Kids ['.implode(' ',$kids).'] /Count '.count($pages).' >>';
        foreach($this->images as $img){$obj=$imageObjs[$img['name']];$objects[$obj]='<< /Type /XObject /Subtype /Image /Width '.$img['width'].' /Height '.$img['height'].' /ColorSpace /DeviceRGB /BitsPerComponent 8 /Filter /DCTDecode /Length '.strlen($img['data'])." >>\nstream\n".$img['data']."\nendstream";}
        $objects[$font1]='<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>';
        $objects[$font2]='<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>';
        ksort($objects,SORT_NUMERIC);
        $pdf="%PDF-1.4\n";$offsets=[0];
        foreach($objects as $num=>$obj){$offsets[$num]=strlen($pdf);$pdf.=$num." 0 obj\n".$obj."\nendobj\n";}
        $xref=strlen($pdf);$max=max(array_keys($objects));
        $pdf.="xref\n0 ".($max+1)."\n0000000000 65535 f \n";
        for($i=1;$i<=$max;$i++)$pdf.=sprintf("%010d 00000 n \n",$offsets[$i]??0);
        $pdf.="trailer\n<< /Size ".($max+1)." /Root 1 0 R >>\nstartxref\n{$xref}\n%%EOF";
        return $pdf;
    }
}

function cwrap(string $text,int $max=90):array{ $text=preg_replace('/\s+/u',' ',trim($text))??trim($text); return $text===''?['']:explode("\n",wordwrap($text,$max,"\n",true)); }
function cmoney(float $v):string{return '$'.number_format($v,2,'.',',');}
function cdate(?string $v,string $fmt='d/m/Y'):string{if(!$v)return 'No registrado';$t=strtotime($v);return $t?date($fmt,$t):'No registrado';}
function cstatus(string $s):array{
  $map=['pending'=>['Pendiente',[.65,.46,.08]],'in_progress'=>['En proceso',[.08,.55,.84]],'completed'=>['Completada',[.05,.60,.42]],'delivered'=>['Entregada',[.05,.60,.42]],'cancelled'=>['Cancelada',[.82,.20,.26]]];
  return $map[$s]??['En proceso',[.08,.55,.84]];
}

function generate_order_pdf(array $order,array $customer,array $quote,array $items,array $finance,array $payments,array $history,array $company, string $logoPath='', int $photoCount=0):string{
  $pdf=new CorporateOrderPdf();
  $navy=[.035,.075,.115];$red=[1,.06,.30];$yellow=[1,.70,.06];$cyan=[.08,.60,.92];$green=[.05,.70,.47];$slate=[.34,.39,.45];$light=[.955,.97,.98];$border=[.82,.85,.89];$soft=[.985,.99,.995];
  $brand=trim((string)($company['trade_name']?:$company['legal_name']?:'Colibrí Print México'));
  $legal=trim((string)($company['legal_name']??''));
  $social=[];
  $social['Facebook']=trim((string)($company['facebook']??''))?:'https://www.facebook.com/ColibriPrintMexico';
  $social['Instagram']=trim((string)($company['instagram']??''))?:'https://www.instagram.com/colibriprintmexico/';
  $social['TikTok']=trim((string)($company['tiktok']??''))?:'https://www.tiktok.com/@colibriprintmexico';
  if(trim((string)($company['youtube']??''))!=='')$social['YouTube']=(string)$company['youtube'];

  $addr=implode(' · ',array_values(array_filter([
    (string)($company['address']??''),(string)($company['neighborhood']??''),
    (string)($company['city']??''),(string)($company['state']??''),
    (string)($company['postal_code']??''),(string)($company['country']??'México')
  ])));
  $status=cstatus((string)$order['status']);

  $header=function()use(&$pdf,$brand,$legal,$company,$logoPath,$navy,$red,$yellow,$slate,$border,$order):void{
    $pdf->setFill(...$navy);$pdf->fillRect(0,776,595,66);
    if($logoPath!=='')$pdf->addJpeg($logoPath,38,791,142,40);
    $pdf->setFill(1,1,1);$pdf->text($brand,10,205,815,true);
    $sub=$legal!==''&&$legal!==$brand?$legal:'SOLUCIONES GRÁFICAS · IMPRESIÓN · PERSONALIZACIÓN';$pdf->text($sub,7.3,205,801,false);
    $contact=trim(implode(' · ',array_filter([(string)($company['phone']??''),(string)($company['email']??''),(string)($company['website']??'')])));
    if($contact!=='')$pdf->text($contact,6.6,205,787,false);
    $pdf->setFill(...$red);$pdf->fillRect(414,792,143,34);$pdf->setFill(1,1,1);$pdf->text('ORDEN DE SERVICIO',7.6,424,814,true);$pdf->text((string)$order['order_number'],13.2,424,799,true);
    $pdf->setFill(...$yellow);$pdf->fillRect(0,776,595,3);
  };
  $footer=function(int $pageNo)use(&$pdf,$company,$social,$brand,$slate,$border):void{
    $pdf->setStroke(...$border);$pdf->line(38,42,557,42);
    $pdf->setFill(...$slate);
    $left=$brand.' · '.$company['city'].' · '.$company['state'];$pdf->text($left,6.5,38,29,false);
    $socialLine=implode('  ·  ',array_map(fn($k)=>$k.': '.preg_replace('#^https?://#i','',$social[$k]),array_keys($social)));
    $pdf->text($socialLine,6,38,19,false);
    $pdf->textRight('PÁGINA '.$pageNo,6.5,557,29,true);
  };

  // PAGE 1
  $header();$y=748;
  $pdf->setFill(...$slate);$pdf->text('CONTROL DOCUMENTAL',7.2,38,$y,true);
  $pdf->setFill(...$navy);$pdf->text((string)$order['order_number'],13,38,$y-20,true);
  $pdf->setFill(...$slate);$pdf->text('Cotización de origen: '.(string)($order['quote_number']??''),7.2,38,$y-36,false);
  $pdf->setFill(...$status[1]);$pdf->fillRect(450,$y-32,107,26);$pdf->setFill(1,1,1);$pdf->textCenter(strtoupper($status[0]),8,503.5,$y-22,true);

  $y=670;
  // Emisor + cliente
  $boxTop=$y;$boxH=104;
  $pdf->setFill(...$light);$pdf->fillRect(38,$boxTop-$boxH,250,$boxH);$pdf->fillRect(305,$boxTop-$boxH,252,$boxH);
  $pdf->setStroke(...$border);$pdf->rect(38,$boxTop-$boxH,250,$boxH);$pdf->rect(305,$boxTop-$boxH,252,$boxH);
  $pdf->setFill(...$red);$pdf->text('EMISOR · DATOS FISCALES',7.6,50,$boxTop-18,true);
  $companyFields=[
    'Razón social: '.($legal!==''?$legal:'No configurada'),
    'Nombre comercial: '.($brand!==''?$brand:'No configurado'),
    'RFC: '.(($company['rfc']??'')!==''?(string)$company['rfc']:'Pendiente de configuración'),
    'Régimen fiscal: '.(($company['tax_regime']??'')!==''?(string)$company['tax_regime']:'No configurado'),
    'Domicilio: '.($addr!==''?$addr:'No configurado'),
  ];$yy=$boxTop-34;$pdf->setFill(...$navy);foreach($companyFields as $line){foreach(cwrap($line,50) as $w){$pdf->text($w,7.1,50,$yy,false);$yy-=10;}}
  $pdf->setFill(...$cyan);$pdf->text('CLIENTE · DATOS DE FACTURACIÓN',7.6,317,$boxTop-18,true);
  $custFields=[
    'Nombre: '.(($customer['name']??$order['customer_name']??'')?:'Sin cliente'),
    'RFC: '.(($customer['tax_number']??'')?:'No registrado'),
    'Teléfono: '.(($customer['phone']??$order['customer_phone']??'')?:'No registrado'),
    'Correo: '.(($customer['email']??$order['customer_email']??'')?:'No registrado'),
    'Domicilio: '.trim(implode(', ',array_filter([(string)($customer['address']??$order['customer_address']??''),(string)($customer['city']??$order['customer_city']??''),(string)($customer['state']??$order['customer_state']??''),(string)($customer['zip_code']??'')]))),
  ];$yy=$boxTop-34;$pdf->setFill(...$navy);foreach($custFields as $line){foreach(cwrap($line,50) as $w){$pdf->text($w,7.1,317,$yy,false);$yy-=10;}}

  // dates
  $y=548;$pdf->setFill(...$soft);$pdf->fillRect(38,$y-53,519,53);$pdf->setStroke(...$border);$pdf->rect(38,$y-53,519,53);
  $dateCols=[['FECHA DE ORDEN',cdate((string)$order['order_date'])],['FECHA COMPROMISO',cdate($order['due_date']??null)],['FECHA COTIZACIÓN',cdate($quote['issue_date']??$order['quote_issue_date']??null)],['ÚLTIMA ACTUALIZACIÓN',cdate($order['updated_at']??null,'d/m/Y H:i')]];
  $colX=[50,180,310,440];for($i=0;$i<4;$i++){[$lab,$val]=$dateCols[$i];$pdf->setFill(...$slate);$pdf->text($lab,6.8,$colX[$i],$y-16,true);$pdf->setFill(...$navy);$pdf->text($val,9,$colX[$i],$y-34,true);}

  // service detail table
  $y=472;$pdf->setFill(...$navy);$pdf->fillRect(38,$y-27,519,27);$pdf->setFill(1,1,1);$pdf->text('DETALLE DEL SERVICIO SOLICITADO',8.4,50,$y-18,true);
  $hy=$y-43;$pdf->setFill(...$slate);$pdf->text('DESCRIPCIÓN',7.2,50,$hy,true);$pdf->text('CANT.',7.2,382,$hy,true);$pdf->text('P. UNIT.',7.2,430,$hy,true);$pdf->text('IMPORTE',7.2,500,$hy,true);$pdf->setStroke(...$border);$pdf->line(38,$hy-8,557,$hy-8);$y=$hy-24;
  foreach($items as $idx=>$item){$lines=cwrap((string)$item['description'],56);$rowH=max(25,count($lines)*10+10);if($y-$rowH<190){$footer($pdf->pageNo());$pdf->newPage();$header();$y=742;}
    if($idx%2===0){$pdf->setFill(...$soft);$pdf->fillRect(38,$y-$rowH+5,519,$rowH);}
    $pdf->setFill(...$navy);$ly=$y;foreach($lines as $ln){$pdf->text($ln,7.4,50,$ly,false);$ly-=10;}
    $pdf->text(number_format((float)$item['quantity'],3,'.',''),7.2,382,$y,false);
    $pdf->text(cmoney((float)$item['unit_price']),7.2,430,$y,false);
    $pdf->text(cmoney((float)$item['subtotal']),7.2,500,$y,false);
    $pdf->setStroke(...$border);$pdf->line(38,$y-$rowH+5,557,$y-$rowH+5);$y-=$rowH;
  }

  // totals/payment summary
  $y-=8;$pdf->setFill(...$light);$pdf->fillRect(319,$y-120,238,120);$pdf->setStroke(...$border);$pdf->rect(319,$y-120,238,120);
  $pdf->setFill(...$red);$pdf->text('RESUMEN FINANCIERO',7.8,335,$y-18,true);
  $rows=[['Total del servicio',(float)$finance['order_total'],$navy],['Pagado / anticipo',(float)$finance['paid_total'],$green],['Saldo pendiente',(float)$finance['balance'],$yellow]];$ty=$y-43;foreach($rows as $r){$pdf->setFill(...$slate);$pdf->text($r[0],8,335,$ty,false);$pdf->setFill(...$r[2]);$pdf->textRight(cmoney($r[1]),11,540,$ty,true);$ty-=23;}
  $pdf->setFill(...$slate);$first=$finance['first_payment']??null;if($first){$pdf->text('Primer pago: '.cdate((string)$first['payment_date']),7.1,50,$y-24,false);$pdf->text('Método: '.(string)$first['method_label'],7.1,50,$y-36,false);if(!empty($first['reference']))$pdf->text('Referencia: '.(string)$first['reference'],7.1,50,$y-48,false);}else{$pdf->text('No hay anticipo confirmado registrado.',7.1,50,$y-24,false);}
  $footer($pdf->pageNo());

  // PAGE 2
  $pdf->newPage();$header();$y=748;
  $pdf->setFill(...$red);$pdf->text('CONTROL OPERATIVO Y ARCHIVO HISTÓRICO',9,38,$y,true);
  $pdf->setFill(...$navy);$pdf->text('Expediente de la orden '.$order['order_number'],19,38,$y-24,true);
  $y=686;
  // status / operational
  $boxes=[
    ['ESTADO COMERCIAL',strtoupper($status[0]),$status[1]],
    ['RESPONSABLE',trim((string)($order['responsible_name']??''))?:'Sin asignar',$cyan],
    ['ETAPA PRODUCCIÓN',trim((string)($order['production_stage']??''))?:'Pendiente',$green],
    ['EVIDENCIA FOTOGRÁFICA',($photoCount).' archivo(s)',$yellow],
  ];$bx=38;foreach($boxes as $b){$pdf->setFill(...$soft);$pdf->fillRect($bx,$y-68,119,68);$pdf->setStroke(...$border);$pdf->rect($bx,$y-68,119,68);$pdf->setFill(...$slate);$pdf->text($b[0],6.4,$bx+10,$y-17,true);$pdf->setFill(...$b[2]);foreach(cwrap($b[1],19) as $j=>$ln)$pdf->text($ln,9,$bx+10,$y-38-($j*11),true);$bx+=129;}
  $y-=92;

  // conditions
  $pdf->setFill(...$navy);$pdf->fillRect(38,$y-25,519,25);$pdf->setFill(1,1,1);$pdf->text('ENTREGA Y PAGO',8.2,50,$y-17,true);$y-=40;
  $cond=[
    'Condiciones de pago'=>trim((string)($quote['payment_terms']??$order['payment_terms']??'')),
    'Tiempo de entrega'=>trim((string)($quote['delivery_time']??$order['delivery_time']??'')),
    'Lugar de entrega'=>trim((string)($quote['delivery_place']??$order['delivery_place']??'')),
    'Términos'=>trim((string)($quote['terms']??'')),
  ];
  foreach($cond as $lab=>$val){if($val==='')continue;$pdf->setFill(...$slate);$pdf->text($lab.':',7.4,50,$y,true);$xx=145;foreach(cwrap($val,72) as $ln){$pdf->setFill(...$navy);$pdf->text($ln,7.8,$xx,$y,false);$y-=11;} $y-=6;}

  // payments history
  $y-=3;$pdf->setFill(...$navy);$pdf->fillRect(38,$y-25,519,25);$pdf->setFill(1,1,1);$pdf->text('REGISTRO DE PAGOS',8.2,50,$y-17,true);$y-=40;
  if(!$payments){$pdf->setFill(...$slate);$pdf->text('No hay pagos registrados.',8,50,$y,false);$y-=18;}else{
    $pdf->setFill(...$slate);$pdf->text('FECHA',7,50,$y,true);$pdf->text('MÉTODO',7,140,$y,true);$pdf->text('REFERENCIA',7,260,$y,true);$pdf->text('ESTADO',7,420,$y,true);$pdf->text('IMPORTE',7,500,$y,true);$y-=12;$pdf->setStroke(...$border);$pdf->line(38,$y,557,$y);$y-=14;
    foreach($payments as $idx=>$p){if($y<245){$footer($pdf->pageNo());$pdf->newPage();$header();$y=742;$pdf->setFill(...$red);$pdf->text('REGISTRO DE PAGOS · CONTINUACIÓN',8,38,$y,true);$y-=24;}
      if($idx%2===0){$pdf->setFill(...$soft);$pdf->fillRect(38,$y-17,519,22);} $pdf->setFill(...$navy);
      $pdf->text(cdate((string)$p['payment_date']),7.2,50,$y,false);$pdf->text((string)($p['method']??''),7.2,140,$y,false);$pdf->text(csubstr((string)($p['reference']??''),25),7.2,260,$y,false);$pdf->text((string)($p['status']??''),7.2,420,$y,false);$pdf->textRight(cmoney((float)$p['amount']),7.2,548,$y,false);$y-=22;
    }
  }

  // notes
  $y-=4;$blockStart=$y;$pdf->setFill(...$light);$pdf->fillRect(38,$y-110,519,110);$pdf->setStroke(...$border);$pdf->rect(38,$y-110,519,110);$pdf->setFill(...$red);$pdf->text('NOTAS DEL SERVICIO',8,50,$y-18,true);$ny=$y-36;$noteText=trim((string)($order['notes']??''));if($noteText==='')$noteText='Sin notas operativas.';foreach(cwrap($noteText,88) as $ln){$pdf->setFill(...$navy);$pdf->text($ln,7.4,50,$ny,false);$ny-=10;if($ny<$y-95)break;}
  $y-=130;
  $pdf->setFill(...$light);$pdf->fillRect(38,$y-110,519,110);$pdf->setStroke(...$border);$pdf->rect(38,$y-110,519,110);$pdf->setFill(...$yellow);$pdf->text('NOTAS INTERNAS · SOLO ARCHIVO',8,50,$y-18,true);$ny=$y-36;$internalText=trim((string)($order['internal_notes']??$quote['internal_notes']??''));if($internalText==='')$internalText='Sin notas internas.';foreach(cwrap($internalText,88) as $ln){$pdf->setFill(...$navy);$pdf->text($ln,7.4,50,$ny,false);$ny-=10;if($ny<$y-95)break;}
  $footer($pdf->pageNo());

  // PAGE 3 archive metadata + history + socials
  $pdf->newPage();$header();$y=748;$pdf->setFill(...$red);$pdf->text('FICHA MAESTRA DE ARCHIVO',9,38,$y,true);$y-=30;
  $pdf->setFill(...$navy);$pdf->text('Control histórico del expediente',18,38,$y,true);$y-=42;
  $meta=[
    ['ID orden',(string)$order['id'],38],['ID cotización',(string)$order['quote_id'],170],['ID cliente',(string)($order['customer_id']??'N/D'),302],['Folio de archivo','ARCH-'.(string)$order['order_number'],434],
    ['Creado',cdate((string)($order['created_at']??''),'d/m/Y H:i'),38],['Actualizado',cdate((string)($order['updated_at']??''),'d/m/Y H:i'),170],['Pagos',(string)((int)($finance['payment_count']??count($payments))),302],['Fotos',(string)$photoCount,434],
  ];foreach($meta as $m){$pdf->setFill(...$soft);$pdf->fillRect($m[2],$y-48,119,48);$pdf->setStroke(...$border);$pdf->rect($m[2],$y-48,119,48);$pdf->setFill(...$slate);$pdf->text($m[0],6.5,$m[2]+10,$y-16,true);$pdf->setFill(...$navy);$pdf->text($m[1],8,$m[2]+10,$y-34,true);}
  $y-=75;

  $pdf->setFill(...$navy);$pdf->fillRect(38,$y-25,519,25);$pdf->setFill(1,1,1);$pdf->text('HISTORIAL DEL SERVICIO',8.2,50,$y-17,true);$y-=39;
  $hist=array_reverse($history);
  if(!$hist){$pdf->setFill(...$slate);$pdf->text('Sin movimientos registrados.',8,50,$y,false);$y-=18;}else{
    foreach($hist as $h){if($y<200){$footer($pdf->pageNo());$pdf->newPage();$header();$y=742;$pdf->setFill(...$red);$pdf->text('HISTORIAL DEL SERVICIO · CONTINUACIÓN',8,38,$y,true);$y-=26;}
      $label=(string)($h['new_status']??'');$pdf->setFill(...$red);$pdf->text(strtoupper($label),7.5,50,$y,true);$pdf->setFill(...$slate);$pdf->text(cdate((string)($h['created_at']??''),'d/m/Y H:i'),7.2,170,$y,false);$pdf->setFill(...$navy);$note=trim((string)($h['note']??''));$xx=290;foreach(cwrap($note!==''?$note:'Actualización de estado.',38) as $ln){$pdf->text($ln,7.1,$xx,$y,false);$y-=10;} $pdf->setStroke(...$border);$pdf->line(38,$y-4,557,$y-4);$y-=14;
    }
  }
  $y-=3;$pdf->setFill(...$navy);$pdf->fillRect(38,$y-25,519,25);$pdf->setFill(1,1,1);$pdf->text('PRESENCIA DIGITAL Y CONTACTO',8.2,50,$y-17,true);$y-=40;
  $pdf->setFill(...$slate);$pdf->text('Sitio web',7.5,50,$y,true);$pdf->setFill(...$navy);$pdf->text((string)($company['website']?:'https://colibriprint.com.mx'),7.8,145,$y,false);$y-=15;
  foreach($social as $k=>$v){$pdf->setFill(...$slate);$pdf->text($k,7.5,50,$y,true);$pdf->setFill(...$navy);$pdf->text(preg_replace('#^https?://#i','',(string)$v),7.5,145,$y,false);$y-=13;}
  $y-=6;$pdf->setFill(...$light);$pdf->fillRect(38,$y-86,519,86);$pdf->setStroke(...$border);$pdf->rect(38,$y-86,519,86);$pdf->setFill(...$red);$pdf->text('LEYENDA DOCUMENTAL',7.7,50,$y-17,true);
  $legend='Documento interno de control y archivo histórico. Resume la orden de servicio, los datos del cliente y emisor, conceptos, pagos confirmados, condiciones y movimientos registrados en el sistema. No sustituye un CFDI ni modifica los comprobantes fiscales emitidos por separado.';
  $yy=$y-35;$pdf->setFill(...$navy);foreach(cwrap($legend,92) as $ln){$pdf->text($ln,7.1,50,$yy,false);$yy-=10;}
  $footer($pdf->pageNo());

  return $pdf->finish();
}
function csubstr(string $s,int $n):string{
    $s=preg_replace('/\s+/u',' ',trim($s))??trim($s);
    if($n<=0)return '';
    $ascii=function_exists('iconv') ? @iconv('UTF-8','Windows-1252//TRANSLIT//IGNORE',$s) : false;
    $len=$ascii!==false ? strlen($ascii) : strlen($s);
    if($len<=$n)return $s;
    $cut=@substr($ascii!==false ? $ascii : $s,0,max(1,$n-3));
    return $cut.'...';
}
