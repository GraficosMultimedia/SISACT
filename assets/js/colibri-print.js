(() => {
  'use strict';
  const state={files:[],catalogs:window.CP_CATALOGS||{sizes:[],materials:[],finishes:[],prices:{}}};
  const $=(s,r=document)=>r.querySelector(s), $$=(s,r=document)=>[...r.querySelectorAll(s)];
  const money=n=>'$'+Number(n||0).toLocaleString('es-MX',{minimumFractionDigits:2,maximumFractionDigits:2});
  const esc=s=>String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));
  function priceInfo(i){const k=[i.size_id,i.material_id,i.finish_id,i.color_mode].join(':');const p=state.catalogs.prices[k];if(p&&p.pricing_mode)i.pricing_mode=p.pricing_mode;return p||null}
  const priceFor=i=>{const p=priceInfo(i);return p?Number(p.unit_price):0};
  const optionList=(l,s)=>l.map(x=>`<option value="${x.id}" ${Number(x.id)===Number(s)?'selected':''}>${esc(x.name)}</option>`).join('');
  const findBy=(l,id)=>l.find(x=>Number(x.id)===Number(id));
  function pageStateLabel(f){
    if(Number(f.pages)>0)return `<span class="cp-pages-manual">✎ ${f.pages} ${f.pages===1?'página':'páginas'} · captura manual</span>`;
    return `<span class="cp-pages-warning">⚠ Indica las páginas del archivo</span>`;
  }
  function renderConfig(){
    const host=$('#cp-config-list');if(!host)return;
    if(!state.files.length){host.innerHTML='<div class="cp-empty">Selecciona uno o varios archivos arriba para comenzar.</div>';renderSummary();return;}
    host.innerHTML=state.files.map((f,i)=>{
      const unit=priceFor(f),baseQty=f.pricing_mode==='per_sheet'?Math.ceil((f.pages||0)/2):(f.pages||0),subtotal=unit*baseQty*f.copies,ext=f.extension.toUpperCase();
      return `<article class="cp-config-item" data-index="${i}">
        <div class="cp-config-top"><div class="cp-thumb">${ext}</div><div><strong title="${esc(f.name)}">${esc(f.name)}</strong>${pageStateLabel(f)}<div class="cp-manual-note">El número de páginas lo indicas tú. No se analiza el archivo.</div></div><button type="button" class="cp-btn cp-btn-danger" data-remove="${i}">Quitar</button></div>
        <div class="cp-manual-pages"><div class="cp-field"><label>¿Cuántas páginas tiene este archivo?</label><input type="number" min="1" max="100000" value="${Number(f.pages)||''}" placeholder="Ej. 5" data-manual-pages-input></div><button type="button" class="cp-btn cp-btn-primary" data-apply-pages="${i}">Aplicar cantidad</button></div>
        <div class="cp-config-grid"><div class="cp-field"><label>Tamaño</label><select data-field="size_id">${optionList(state.catalogs.sizes,f.size_id)}</select></div><div class="cp-field"><label>Material</label><select data-field="material_id">${optionList(state.catalogs.materials,f.material_id)}</select></div><div class="cp-field"><label>Acabado</label><select data-field="finish_id">${optionList(state.catalogs.finishes,f.finish_id)}</select></div><div class="cp-field"><label>Color</label><select data-field="color_mode"><option value="color" ${f.color_mode==='color'?'selected':''}>Color</option><option value="bw" ${f.color_mode==='bw'?'selected':''}>Blanco y negro</option></select></div><div class="cp-field"><label>Cantidad</label><div class="cp-qty"><button type="button" data-qty="-1">−</button><input type="number" min="1" value="${f.copies}" data-field="copies"><button type="button" data-qty="1">+</button></div></div></div>
        <div class="cp-config-footer"><div class="cp-stat"><span>Páginas del archivo</span><strong>${f.pages||'—'}</strong></div><div class="cp-stat"><span>Hojas físicas · una cara</span><strong>${(f.pages||0)*f.copies}</strong></div>${unit>0&&f.pages>0?`<div class="cp-price-box"><strong>${money(subtotal)}</strong><small>${money(unit)} / ${f.pricing_mode==='per_sheet'?'hoja':'página'} × ${baseQty} × ${f.copies}</small></div>`:`<div class="cp-price-box cp-price-missing"><strong>${f.pages>0?'Sin tarifa':'Esperando páginas'}</strong><small>${f.pages>0?'Configura esta combinación en Precios':'Indica manualmente la cantidad de páginas'}</small></div>`}</div>
      </article>`;
    }).join('');renderSummary();
  }
  function renderSummary(){
    const total=state.files.reduce((sum,f)=>sum+priceFor(f)*(f.pricing_mode==='per_sheet'?Math.ceil((f.pages||0)/2):(f.pages||0))*f.copies,0);
    const pages=state.files.reduce((n,f)=>n+(Number(f.pages)||0),0);
    const sheets=state.files.reduce((n,f)=>n+(Number(f.pages)||0)*f.copies,0);
    $('#cp-total').textContent=money(total);if($('#cp-total-bottom'))$('#cp-total-bottom').textContent=money(total);
    $$('#cp-files-count,[data-files-count]').forEach(e=>e.textContent=state.files.length);$('#cp-pages-count').textContent=pages;$('#cp-sheets-count').textContent=sheets;
    const detail=$('#cp-summary-detail');
    if(detail)detail.innerHTML=state.files.length?state.files.map(f=>{
      const size=findBy(state.catalogs.sizes,f.size_id),mat=findBy(state.catalogs.materials,f.material_id),unit=priceFor(f),qty=f.pricing_mode==='per_sheet'?Math.ceil((f.pages||0)/2):(f.pages||0),sub=unit*qty*f.copies;
      const page=f.pages?`${f.pages} pág. · captura manual`:'Páginas pendientes';
      return `<div class="cp-detail-row"><div class="cp-thumb">${esc(f.extension.toUpperCase())}</div><div class="cp-detail-main"><strong>${esc(f.name)}</strong><small>${page}</small><small>${esc(size?.name||'')} · ${esc(mat?.name||'')} · ${f.color_mode==='color'?'Color':'B/N'} · ${f.copies} copia(s)</small></div><div class="cp-detail-price">${unit>0&&f.pages>0?money(sub):'—'}</div></div>`;
    }).join(''):'<div class="cp-empty">Tu resumen aparecerá aquí al cargar archivos.</div>';
    const incomplete=state.files.some(f=>!Number(f.pages)),missing=state.files.some(f=>priceFor(f)<=0);
    ['#cp-submit','#cp-submit-2'].forEach(sel=>{const button=$(sel);if(button)button.disabled=!state.files.length||incomplete||missing});
    const w=$('#cp-price-warning');
    if(w){const no=state.files.filter(f=>priceFor(f)<=0),wait=state.files.filter(f=>!Number(f.pages));w.hidden=!no.length&&!wait.length;
      w.textContent=wait.length?`✎ Indica manualmente las páginas de ${wait.length} archivo(s). No se analizarán los documentos.`:no.length?`⚠ No hay tarifa configurada para ${no.map(f=>`"${f.name}"`).join(', ')}. Puedes configurarla en Precios.`:'';
    }
  }
  async function uploadFiles(list){
    const files=[...list];if(!files.length)return;
    const form=new FormData();files.forEach(f=>form.append('files[]',f));form.append('csrf',$('#cp-csrf').value);form.append('mode','upload');
    $('#cp-upload-status').textContent='Subiendo archivos…';
    try{
      const res=await fetch('api/analyze_files.php',{method:'POST',body:form}),data=await res.json();
      if(!res.ok||!data.ok)throw new Error(data.message||'No fue posible recibir los archivos.');
      $('#cp-upload-token').value=data.token;
      data.files.forEach(f=>{f.pages=0;f.page_source='manual';f.analysis_status='manual';state.files.push(f)});
      $('#cp-upload-status').textContent='Archivos recibidos. Indica manualmente las páginas de cada archivo.';
      renderUploadList();renderConfig();
    }catch(err){$('#cp-upload-status').textContent=err.message;alert(err.message)}
    finally{const input=$('#cp-files');if(input)input.value=''}
  }
  function renderUploadList(){
    const host=$('#cp-upload-list');if(!host)return;
    host.innerHTML=state.files.map((f,i)=>{
      const status=Number(f.pages)>0?`${f.pages} pág. manual`:'Indica páginas';
      return `<div class="cp-file-row">
        <div class="cp-file-type">${esc(f.extension.toUpperCase())}</div>
        <div class="cp-file-meta"><strong>${esc(f.name)}</strong><small>${status} · ${Math.round(f.size/1024)} KB</small></div>
        <span class="cp-badge">${esc(status)}</span>
        <button type="button" class="cp-btn cp-btn-primary" data-edit-manual="${i}">Indicar páginas</button>
        <button type="button" class="cp-btn cp-btn-danger" data-remove="${i}">Quitar</button>
      </div>`;
    }).join('');
  }
  function applyManualPages(i){const card=document.querySelector(`[data-index="${i}"]`),input=card?.querySelector('[data-manual-pages-input]'),pages=Math.min(100000,Math.floor(Number(input?.value||0)));if(!pages||pages<1)return alert('Indica cuántas páginas tiene el archivo.');state.files[i].pages=pages;state.files[i].sheets=pages;state.files[i].page_source='manual';state.files[i].analysis_status='manual';$('#cp-upload-status').textContent=`${state.files[i].name}: ${pages} páginas capturadas manualmente.`;renderUploadList();renderConfig()}
  document.addEventListener('change',e=>{const field=e.target.closest('[data-field]'),card=e.target.closest('[data-index]');if(!field||!card)return;const i=Number(card.dataset.index);let v=field.value;if(field.dataset.field==='copies')v=Math.max(1,Number(v||1));state.files[i][field.dataset.field]=v;renderConfig()});
  document.addEventListener('click',e=>{
    const rem=e.target.closest('[data-remove]');
    if(rem){const i=Number(rem.dataset.remove);state.files.splice(i,1);renderUploadList();renderConfig();return}
    const app=e.target.closest('[data-apply-pages]');
    if(app){applyManualPages(Number(app.dataset.applyPages));return}
    const edit=e.target.closest('[data-edit-manual]');
    if(edit){const i=Number(edit.dataset.editManual),f=state.files[i];if(f){renderConfig();setTimeout(()=>{const card=document.querySelector(`[data-index="${i}"]`);card?.querySelector('[data-manual-pages-input]')?.focus()},0)}return}
    const qty=e.target.closest('[data-qty]');
    if(qty){const card=qty.closest('[data-index]'),i=Number(card.dataset.index);state.files[i].copies=Math.max(1,Number(state.files[i].copies||1)+Number(qty.dataset.qty));renderConfig()}
  });
  const input=$('#cp-files');if(input)input.addEventListener('change',e=>uploadFiles(e.target.files));const drop=$('#cp-dropzone');if(drop){['dragenter','dragover'].forEach(t=>drop.addEventListener(t,e=>{e.preventDefault();drop.classList.add('is-drag')}));['dragleave','drop'].forEach(t=>drop.addEventListener(t,e=>{e.preventDefault();drop.classList.remove('is-drag')}));drop.addEventListener('drop',e=>uploadFiles(e.dataTransfer.files))}
  const form=$('#cp-request-form');if(form)form.addEventListener('submit',e=>{
    const payload=state.files.map(f=>({token_name:f.token_name,original_name:f.name,pages:Number(f.pages),page_source:'manual',size_id:Number(f.size_id),material_id:Number(f.material_id),finish_id:Number(f.finish_id),color_mode:f.color_mode,copies:Number(f.copies),pricing_mode:f.pricing_mode}));
    $('#cp-items-json').value=JSON.stringify(payload);
    if(!state.files.length){e.preventDefault();alert('Agrega al menos un archivo.');return}
    if(state.files.some(f=>!Number(f.pages))){e.preventDefault();alert('Indica manualmente cuántas páginas tiene cada archivo.');return}
    if(state.files.some(f=>priceFor(f)<=0)){e.preventDefault();alert('Hay archivos sin tarifa configurada. Revisa su configuración.')}
  });
  renderUploadList();renderConfig();
})();