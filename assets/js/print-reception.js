(function(){
'use strict';
const root=document.querySelector('[data-print-app]');
if(!root) return;
const form=document.getElementById('print-request-form');
const input=document.getElementById('print_files');
const drop=root.querySelector('[data-drop]');
const fileList=root.querySelector('[data-files]');
const optionsBox=root.querySelector('[data-file-options]');
const emptyOptions=root.querySelector('[data-empty-options]');
const totalEl=root.querySelector('[data-total]');
const fileCountEl=root.querySelector('[data-file-count]');
const pageCountEl=root.querySelector('[data-page-count]');
const sheetCountEl=root.querySelector('[data-sheet-count]');
const summaryList=root.querySelector('[data-summary-list]');
const summaryEmpty=root.querySelector('[data-summary-empty]');
const uploadCount=root.querySelector('[data-upload-count]');
const submit=root.querySelector('[data-submit]');
const submitNote=root.querySelector('[data-submit-note]');
const catalog=window.CP_PRINT_CATALOG||{sizes:[],materials:[],finishes:[]};
const defaults=window.CP_PRINT_DEFAULTS||{};
let filesMeta=[];
let timer=null;
let lastPricing=null;

const money=v=>new Intl.NumberFormat('es-MX',{style:'currency',currency:'MXN'}).format(Number(v||0));
const esc=s=>String(s??'').replace(/[&<>"']/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[m]));

function countPdfPages(file){
  return new Promise(resolve=>{
    const reader=new FileReader();
    reader.onload=()=>{
      try{
        const bytes=new Uint8Array(reader.result);
        const text=new TextDecoder('latin1').decode(bytes);
        const pages=text.match(/\/Type\s*\/Page\b/gi);
        if(pages&&pages.length) return resolve(pages.length);
        const counts=text.match(/\/Count\s+(\d+)/gi);
        if(counts){
          let max=0;
          counts.forEach(v=>max=Math.max(max,parseInt(v.replace(/\D/g,''),10)||0));
          if(max>0) return resolve(max);
        }
      }catch(e){}
      resolve(1);
    };
    reader.onerror=()=>resolve(1);
    reader.readAsArrayBuffer(file);
  });
}

function optionHtml(name,list,placeholder,selected){
  let h='<select class="cp-select" data-opt="'+name+'">';
  if(placeholder) h+='<option value="">'+esc(placeholder)+'</option>';
  list.forEach(x=>{
    const val=String(x.id);
    const sel=String(selected??'')===val?' selected':'';
    let label=String(x.name||'');
    if(name==='size_id'&&x.width_mm) label+=' · '+x.width_mm+' × '+x.height_mm+' mm';
    h+='<option value="'+esc(val)+'"'+sel+'>'+esc(label)+'</option>';
  });
  return h+'</select>';
}

function selectedFinish(){
  if(defaults.finish_id) return defaults.finish_id;
  const f=catalog.finishes.find(x=>String(x.name||'').trim().toLowerCase()==='sin acabado');
  return f?.id||catalog.finishes[0]?.id||'';
}

function renderFileRows(){
  fileList.innerHTML='';
  filesMeta.forEach((meta,i)=>{
    const f=meta.file;
    const row=document.createElement('div');
    row.className='cp-file-row';
    row.innerHTML='<div class="cp-file-icon">PDF</div><div class="cp-file-name-wrap"><strong class="cp-file-name">'+esc(f.name)+'</strong><span class="cp-small">'+Math.max(1,Math.round(f.size/1024))+' KB</span></div><span class="cp-page-pill" data-page-pill="'+i+'">'+(meta.pageCount===1?'1 página':meta.pageCount+' páginas')+'</span><button class="cp-remove-file" type="button" data-remove="'+i+'" aria-label="Quitar archivo">×</button>';
    fileList.appendChild(row);
  });
  fileList.querySelectorAll('[data-remove]').forEach(btn=>btn.addEventListener('click',()=>removeFile(Number(btn.dataset.remove))));
  if(uploadCount) uploadCount.textContent=filesMeta.length+' '+(filesMeta.length===1?'archivo':'archivos');
}

function renderOptions(){
  optionsBox.innerHTML='';
  if(emptyOptions) emptyOptions.classList.toggle('cp-hidden',filesMeta.length>0);
  filesMeta.forEach((meta,i)=>{
    const f=meta.file;
    const card=document.createElement('article');
    card.className='cp-file-card';
    card.dataset.index=i;
    card.innerHTML='<div class="cp-file-card-head">'+
      '<div class="cp-file-title"><div class="cp-file-icon big">PDF</div><div class="cp-file-title-text"><strong>'+esc(f.name)+'</strong><span>'+meta.pageCount+' '+(meta.pageCount===1?'página detectada':'páginas detectadas')+' · '+(f.type||'archivo')+'</span></div></div>'+
      '<div class="cp-card-price" data-card-total>Calculando…</div></div>'+
      '<div class="cp-file-config-grid">'+
      '<div class="cp-field"><label>Tamaño</label>'+optionHtml('size_id',catalog.sizes,'Selecciona un tamaño',defaults.size_id||catalog.sizes[0]?.id)+'</div>'+
      '<div class="cp-field"><label>Material</label>'+optionHtml('material_id',catalog.materials,'Selecciona un material',defaults.material_id||catalog.materials[0]?.id)+'</div>'+
      '<div class="cp-field"><label>Acabado</label>'+optionHtml('finish_id',catalog.finishes,'Selecciona un acabado',selectedFinish())+'</div>'+
      '<div class="cp-field"><label>Color</label><select class="cp-select" data-opt="color_mode"><option value="color" '+((defaults.color_mode||'color')==='color'?'selected':'')+'>Color</option><option value="bw" '+((defaults.color_mode||'color')==='bw'?'selected':'')+'>Blanco y negro</option></select></div>'+
      '<div class="cp-field"><label>Caras</label><select class="cp-select" data-opt="print_sides"><option value="single">Una cara</option><option value="double">Doble cara</option></select></div>'+
      '<div class="cp-field"><label>Copias</label><div class="cp-quantity"><button type="button" data-minus>−</button><input class="cp-input" data-opt="copies" type="number" min="1" step="1" value="1"><button type="button" data-plus>+</button></div></div>'+ 
      '</div>'+ 
      '<div class="cp-file-bottom"><div class="cp-file-calculation" data-card-math>Consultando tarifa…</div><div class="cp-field cp-note-field"><input class="cp-input" data-opt="notes" placeholder="Nota para este archivo (opcional)"></div></div>';
    card.querySelectorAll('[data-opt]').forEach(el=>{el.addEventListener('change',schedulePrice);el.addEventListener('input',schedulePrice);});
    card.querySelector('[data-minus]').addEventListener('click',()=>adjustCopies(card,-1));
    card.querySelector('[data-plus]').addEventListener('click',()=>adjustCopies(card,1));
    optionsBox.appendChild(card);
  });
}

function adjustCopies(card,delta){
  const input=card.querySelector('[data-opt="copies"]');
  const n=Math.max(1,(parseInt(input.value||'1',10)||1)+delta);
  input.value=n;
  schedulePrice();
}

function getOptions(){
  return filesMeta.map((meta,i)=>{
    const card=optionsBox.querySelector('.cp-file-card[data-index="'+i+'"]');
    const get=n=>card?.querySelector('[data-opt="'+n+'"]')?.value??'';
    return {page_count:meta.pageCount,size_id:get('size_id'),material_id:get('material_id'),finish_id:get('finish_id'),color_mode:get('color_mode')||'color',print_sides:get('print_sides')||'single',copies:Math.max(1,parseInt(get('copies')||'1',10)),notes:get('notes')||''};
  });
}

function updateSubmitState(j){
  const ok=filesMeta.length>0 && !!j.ok;
  if(submit) submit.disabled=!ok;
  if(submitNote){
    if(!filesMeta.length) submitNote.textContent='Agrega al menos un archivo para continuar.';
    else if(ok) submitNote.textContent='Todo listo. El precio está calculado.';
    else submitNote.textContent='Hay archivos sin tarifa. Ajusta sus opciones antes de enviar.';
  }
}

function updateSummary(j){
  if(totalEl) totalEl.textContent=money(j.total);
  if(fileCountEl) fileCountEl.textContent=filesMeta.length;
  if(pageCountEl) pageCountEl.textContent=j.pages||0;
  if(sheetCountEl) sheetCountEl.textContent=j.sheets||0;
  if(summaryEmpty) summaryEmpty.classList.toggle('cp-hidden',(j.items||[]).length>0);
  if(summaryList){
    summaryList.innerHTML='';
    (j.items||[]).forEach(item=>{
      const meta=filesMeta[item.index]; if(!meta) return;
      const div=document.createElement('div');
      div.className='cp-summary-row';
      div.innerHTML='<div><span>'+esc(meta.file.name)+'</span><small>'+meta.pageCount+' pág. · '+(getOptions()[item.index]?.copies||1)+' copia(s)</small></div><strong>'+(item.ok?money(item.subtotal):'Pendiente')+'</strong>';
      summaryList.appendChild(div);
    });
  }
  (j.items||[]).forEach(item=>{
    const card=optionsBox.querySelector('.cp-file-card[data-index="'+item.index+'"]'); if(!card) return;
    const total=card.querySelector('[data-card-total]');
    const math=card.querySelector('[data-card-math]');
    if(item.ok){
      total.textContent=money(item.subtotal);
      total.classList.remove('bad');
      math.className='cp-file-calculation ok';
      const unit=item.pricing_mode==='sheet'?'hojas':item.pricing_mode==='piece'||item.pricing_mode==='unit'?'unidades':'páginas';
      math.innerHTML='<b>'+item.billable_units+' '+unit+'</b> × '+money(item.unit_price)+' = <strong>'+money(item.subtotal)+'</strong>';
    }else{
      total.textContent='Sin tarifa'; total.classList.add('bad');
      math.className='cp-file-calculation bad';
      math.innerHTML='<b>Revisa esta combinación</b><span>'+esc(item.message||'No existe una tarifa configurada para estas opciones.')+'</span>';
    }
  });
  updateSubmitState(j);
}

async function price(){
  if(!filesMeta.length){
    const j={ok:false,total:0,pages:0,sheets:0,items:[]}; lastPricing=j; updateSummary(j); return;
  }
  const fd=new FormData(); fd.set('ajax','price');
  getOptions().forEach((o,i)=>Object.entries(o).forEach(([k,v])=>fd.set('file_options['+i+']['+k+']',v)));
  try{
    const r=await fetch(window.location.href,{method:'POST',body:fd,headers:{'X-Requested-With':'XMLHttpRequest','Accept':'application/json'}});
    if(!r.ok) throw new Error('HTTP '+r.status);
    const j=await r.json(); lastPricing=j; updateSummary(j);
  }catch(e){
    const j={ok:false,total:0,pages:0,sheets:0,items:filesMeta.map((_,i)=>({index:i,ok:false,message:'No se pudo consultar el precio. Intenta nuevamente.'}))};
    lastPricing=j; updateSummary(j);
  }
}
function schedulePrice(){clearTimeout(timer);timer=setTimeout(price,160);}

function removeFile(index){
  const current=Array.from(input.files||[]);
  current.splice(index,1);
  const dt=new DataTransfer(); current.forEach(f=>dt.items.add(f)); input.files=dt.files;
  readFiles();
}

async function readFiles(){
  const selected=Array.from(input.files||[]);
  filesMeta=[];
  if(!selected.length){renderFileRows();renderOptions();updateSummary({ok:false,total:0,pages:0,sheets:0,items:[]});return;}
  for(const file of selected){
    const ext=(file.name.split('.').pop()||'').toLowerCase();
    const pages=ext==='pdf'?await countPdfPages(file):1;
    filesMeta.push({file,pageCount:Math.max(1,pages)});
  }
  renderFileRows(); renderOptions(); price();
}

if(input) input.addEventListener('change',readFiles);
if(drop){
  drop.addEventListener('dragover',e=>{e.preventDefault();drop.classList.add('is-over');});
  drop.addEventListener('dragleave',()=>drop.classList.remove('is-over'));
  drop.addEventListener('drop',e=>{e.preventDefault();drop.classList.remove('is-over');if(!e.dataTransfer.files.length)return;const dt=new DataTransfer();Array.from(e.dataTransfer.files).forEach(f=>dt.items.add(f));input.files=dt.files;readFiles();});
}
if(form){
  form.addEventListener('submit',e=>{
    const opts=getOptions();
    if(!filesMeta.length || !lastPricing?.ok){e.preventDefault();document.querySelector('[data-file-options]')?.scrollIntoView({behavior:'smooth',block:'center'});return;}
    if(opts.some(x=>!x.size_id||!x.material_id||!x.finish_id)){e.preventDefault();alert('Completa tamaño, material y acabado para cada archivo.');}
  });
}

readFiles();
})();
