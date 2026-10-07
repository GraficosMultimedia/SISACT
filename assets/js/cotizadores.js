
(function(){
'use strict';
const contexts={
 landing:{title:'Guía rápida de cotización',intro:'Configura tus costos internos y después elige el tipo de trabajo que vas a calcular.',steps:[
 ['1','Configura tarifas','Registra costos reales de materiales, impresión, máquina y mano de obra.'],
 ['2','Elige el trabajo','Bastidor + Lona calcula estructura e impresión. Corte CNC calcula material, máquina y preparación.'],
 ['3','Captura medidas','Usa las medidas reales del trabajo y revisa las unidades indicadas.'],
 ['4','Revisa el resultado','El sistema separa costo, utilidad y precio de venta. En esta fase todavía no se guarda una cotización comercial.']]},
 bastidor:{title:'Cómo llenar Bastidor + Lona',intro:'Los campos están divididos entre medidas de producción y tarifas internas.',steps:[
 ['1','Medidas','Ancho y alto en centímetros. Ejemplo: 200 × 100 cm.'],
 ['2','Travesaños','Indica cuántos refuerzos llevará la estructura.'],
 ['3','Mano de obra','Indica las horas estimadas para fabricación y armado.'],
 ['4','Tarifas','Revisa PTR, lona, impresión, mano de obra, desperdicio y margen.'],
 ['5','Calcular','Presiona Calcular costo y revisa el desglose antes de usar el precio.']]},
 cnc:{title:'Cómo llenar Corte CNC',intro:'El cálculo separa material, máquina, preparación y mano de obra.',steps:[
 ['1','Medidas','Ancho y alto de cada pieza, expresados en centímetros.'],
 ['2','Cantidad','Número de piezas iguales.'],
 ['3','Tiempos','Máquina y mano de obra son por pieza. El setup se considera una sola vez.'],
 ['4','Tarifas','Revisa material, consumo, máquina, mano de obra y margen.'],
 ['5','Calcular','Obtén costo total, precio total y precio unitario.']]},
 config:{title:'Configuración de tarifas',intro:'Estos valores alimentan automáticamente los cotizadores como tarifas internas.',steps:[
 ['1','Costos','Introduce el costo real que quieres utilizar para cada concepto.'],
 ['2','Desperdicio','Representa merma o consumo adicional.'],
 ['3','Margen','Es el porcentaje que representa la utilidad respecto al precio final de venta.'],
 ['4','Guardar','Guarda los valores para que aparezcan precargados en nuevos cálculos.']]}
};
const fieldTexts={
 width_cm:['Ancho','Medida horizontal final del trabajo, en centímetros.'],
 height_cm:['Alto','Medida vertical final del trabajo, en centímetros.'],
 crossbars:['Travesaños','Cantidad de refuerzos internos de la estructura.'],
 labor_hours:['Horas de mano de obra','Tiempo estimado de fabricación y armado.'],
 ptr_m:['PTR / metro','Costo interno por cada metro de PTR utilizado.'],
 canvas_m2:['Lona / m²','Costo interno de la lona por metro cuadrado.'],
 print_m2:['Impresión / m²','Costo interno de impresión por metro cuadrado.'],
 labor_hour:['Mano de obra / hora','Costo interno de una hora de trabajo.'],
 waste_pct:['Desperdicio','Porcentaje adicional aplicado al consumo de PTR, lona e impresión.'],
 margin_pct:['Margen sobre venta','Utilidad expresada como porcentaje del precio final de venta.'],
 quantity:['Cantidad','Número de piezas iguales que se fabricarán.'],
 machine_minutes:['Tiempo de máquina / pieza','Minutos de trabajo de CNC para una pieza.'],
 setup_minutes:['Preparación / setup','Tiempo de preparación inicial. Se considera una sola vez por cálculo.'],
 labor_minutes:['Mano de obra / pieza','Minutos de trabajo humano estimados para cada pieza.'],
 material_m2:['Material / m²','Costo interno del material por metro cuadrado.'],
 consumption_pct:['Consumo / desperdicio','Porcentaje adicional de material considerado por merma o consumo.'],
 machine_hour:['Máquina / hora','Costo interno por hora de operación de la CNC.']
};
function esc(v){return String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));}
function ensureStyle(){if(document.getElementById('qhelp-style'))return;let s=document.createElement('style');s.id='qhelp-style';s.textContent=`
.qhelp-backdrop{position:fixed;inset:0;z-index:99999;display:flex;align-items:center;justify-content:center;padding:18px;background:rgba(2,9,19,.78);backdrop-filter:blur(7px);opacity:0;visibility:hidden;transition:.18s}
.qhelp-backdrop.open{opacity:1;visibility:visible}.qhelp-box{width:min(620px,100%);max-height:88vh;overflow:auto;background:#0a1c31;border:1px solid #2b6087;border-radius:22px;box-shadow:0 30px 90px rgba(0,0,0,.55);padding:25px;color:#fff;transform:translateY(12px) scale(.98);transition:.2s}
.qhelp-backdrop.open .qhelp-box{transform:none}.qhelp-head{display:flex;gap:15px;justify-content:space-between}.qhelp-title{font-size:23px;font-weight:800}.qhelp-intro{color:#9eb5c9;line-height:1.55;margin-top:6px}.qhelp-close{width:38px;height:38px;border-radius:11px;border:1px solid #315d7c;background:#102b46;color:#fff;font-size:20px;cursor:pointer}
.qhelp-steps{display:grid;gap:9px;margin-top:18px}.qhelp-step{display:flex;gap:12px;padding:12px;border:1px solid rgba(62,125,165,.28);background:#09182a;border-radius:14px}.qhelp-num{width:29px;height:29px;flex:0 0 29px;border-radius:50%;display:grid;place-items:center;background:linear-gradient(145deg,#126fd1,#7a32d8);font-weight:800}.qhelp-step b{display:block;margin-bottom:3px}.qhelp-step span{display:block;color:#9eb5c9;font-size:13px;line-height:1.5}.qhelp-foot{display:flex;justify-content:flex-end;margin-top:18px}.qhelp-ok{border:0;border-radius:11px;padding:10px 17px;background:linear-gradient(90deg,#078eea,#8a36ed);color:#fff;font-weight:800;cursor:pointer}
`;document.head.appendChild(s)}
let modal=null;
function close(){if(!modal)return;let x=modal;modal=null;x.classList.remove('open');setTimeout(()=>x.remove(),190);document.body.style.overflow='';}
function open(data){ensureStyle();close();modal=document.createElement('div');modal.className='qhelp-backdrop';let box=document.createElement('div');box.className='qhelp-box';let steps=(data.steps||[]).map(x=>`<div class="qhelp-step"><div class="qhelp-num">${esc(x[0])}</div><div><b>${esc(x[1])}</b><span>${esc(x[2])}</span></div></div>`).join('');box.innerHTML=`<div class="qhelp-head"><div><div class="qhelp-title">${esc(data.title)}</div><div class="qhelp-intro">${esc(data.intro)}</div></div><button class="qhelp-close" type="button" aria-label="Cerrar">×</button></div><div class="qhelp-steps">${steps}</div><div class="qhelp-foot"><button class="qhelp-ok" type="button">Entendido</button></div>`;modal.appendChild(box);document.body.appendChild(modal);document.body.style.overflow='hidden';requestAnimationFrame(()=>modal.classList.add('open'));box.querySelector('.qhelp-close').focus();}
function bind(){ensureStyle();document.addEventListener('click',e=>{let b=e.target.closest('.js-help-open');let f=e.target.closest('.js-help-field');if(b){e.preventDefault();open(contexts[b.dataset.helpContext]||contexts.landing);return}if(f){e.preventDefault();let key=f.dataset.field||'';let t=fieldTexts[key]||['Ayuda del campo','Completa este campo con el dato correspondiente al trabajo.'];open({title:t[0],intro:t[1],steps:[['✓','Dato importante','Los valores de costos y tarifas son internos y no se muestran al cliente.']]});return}if(e.target.closest('.qhelp-close,.qhelp-ok')||e.target===modal)close();},true);document.addEventListener('keydown',e=>{if(e.key==='Escape'&&modal)close();});document.querySelectorAll('input[type=number]').forEach(i=>i.addEventListener('wheel',()=>i.blur(),{passive:true}));}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',bind,{once:true});else bind();
})();


/* ==========================================================
   Colibrí Print · Resultado de cálculo · Fase 4
   El cálculo se revisa en popup y queda preparado para Fase 5.
   ========================================================== */
(function(){
'use strict';
function money(v){return '$'+Number(v||0).toLocaleString('en-US',{minimumFractionDigits:2,maximumFractionDigits:2});}
function num(v,d=2){return Number(v||0).toLocaleString('es-MX',{minimumFractionDigits:d,maximumFractionDigits:d});}
function pct(v){return num(v)+'%';}
function ensureResultStyle(){
 if(document.getElementById('cp-result-style'))return;
 const s=document.createElement('style');s.id='cp-result-style';s.textContent=`
.cp-result-backdrop{position:fixed;inset:0;z-index:100000;display:flex;align-items:center;justify-content:center;padding:18px;background:rgba(2,8,18,.82);backdrop-filter:blur(9px);opacity:0;visibility:hidden;transition:.2s}.cp-result-backdrop.open{opacity:1;visibility:visible}.cp-result-box{width:min(820px,100%);max-height:92vh;overflow:auto;background:linear-gradient(180deg,#0b2037,#071426);border:1px solid #2b658c;border-radius:24px;box-shadow:0 35px 110px rgba(0,0,0,.62);color:#f4f8ff;transform:translateY(16px) scale(.98);transition:.22s}.cp-result-backdrop.open .cp-result-box{transform:none}.cp-result-top{padding:25px 27px 18px;border-bottom:1px solid rgba(92,163,207,.2);display:flex;align-items:flex-start;justify-content:space-between;gap:20px}.cp-result-kicker{font-size:11px;font-weight:900;letter-spacing:.14em;color:#20d9ff;text-transform:uppercase}.cp-result-title{font-size:27px;font-weight:900;margin-top:5px}.cp-result-sub{color:#94adc2;font-size:14px;margin-top:5px}.cp-result-close{width:40px;height:40px;border-radius:12px;border:1px solid #315d7c;background:#102b46;color:#fff;font-size:22px;cursor:pointer}.cp-result-body{padding:22px 27px}.cp-result-hero{display:grid;grid-template-columns:1fr auto;gap:18px;align-items:center;padding:20px;border-radius:18px;background:linear-gradient(135deg,rgba(18,126,216,.17),rgba(138,54,237,.15));border:1px solid rgba(58,142,196,.35)}.cp-result-hero span{display:block;color:#9fb7c9;font-size:13px}.cp-result-hero strong{display:block;font-size:38px;line-height:1.1;margin-top:5px}.cp-result-profit{text-align:right}.cp-result-profit b{font-size:18px}.cp-result-section{margin-top:20px}.cp-result-section h4{font-size:14px;text-transform:uppercase;letter-spacing:.08em;color:#20d9ff;margin:0 0 10px}.cp-result-table{width:100%;border-collapse:collapse;background:#08182a;border:1px solid rgba(75,132,169,.22);border-radius:15px;overflow:hidden}.cp-result-table th,.cp-result-table td{padding:11px 13px;border-bottom:1px solid rgba(75,132,169,.15);text-align:left;font-size:13px}.cp-result-table th{color:#8ea9be;font-weight:700}.cp-result-table td:last-child,.cp-result-table th:last-child{text-align:right}.cp-result-table tr:last-child td{border-bottom:0}.cp-result-total td{font-weight:900;font-size:15px}.cp-result-sale td{color:#28ddff;font-weight:900;font-size:16px}.cp-result-commercial{margin-top:18px;padding:14px 16px;border:1px solid rgba(45,221,255,.2);border-radius:14px;background:rgba(8,30,48,.8);color:#a9c0d0;font-size:13px;line-height:1.55}.cp-result-actions{padding:17px 27px;border-top:1px solid rgba(92,163,207,.2);display:flex;justify-content:flex-end;gap:10px;flex-wrap:wrap}.cp-result-actions button{border:0;border-radius:11px;padding:11px 17px;font-weight:800;cursor:pointer}.cp-result-secondary{background:#102b46;color:#fff;border:1px solid #315d7c!important}.cp-result-primary{background:linear-gradient(90deg,#079ce9,#8639ee);color:#fff}.cp-result-note{width:100%;font-size:12px;color:#7f9aaf;text-align:right;margin-top:2px}@media(max-width:650px){.cp-result-hero{grid-template-columns:1fr}.cp-result-profit{text-align:left}.cp-result-title{font-size:22px}.cp-result-body,.cp-result-top,.cp-result-actions{padding-left:18px;padding-right:18px}.cp-result-table{font-size:12px}}
`;
 document.head.appendChild(s);
}
function openResult(data){
 if(!data||!data.result)return;
 ensureResultStyle();
 const old=document.querySelector('.cp-result-backdrop');if(old)old.remove();
 const r=data.result; const type=data.type||'Cotización';
 const isCnc=type==='Corte CNC';
 let rows='';
 if(isCnc){
  rows=`<tr><td>Área por pieza</td><td>${num(r.area_piece)} m²</td></tr><tr><td>Material consumido</td><td>${num(r.material_area)} m²</td></tr><tr><td>Costo material</td><td>${money(r.material_cost)}</td></tr><tr><td>Tiempo total máquina</td><td>${num(r.machine_hours)} h</td></tr><tr><td>Costo máquina</td><td>${money(r.machine_cost)}</td></tr><tr><td>Tiempo total mano de obra</td><td>${num(r.labor_hours)} h</td></tr><tr><td>Costo mano de obra</td><td>${money(r.labor_cost)}</td></tr><tr><td>Cantidad</td><td>${num(r.quantity,0)}</td></tr>`;
 }else{
  rows=`<tr><td>Área</td><td>${num(r.area)} m²</td></tr><tr><td>PTR total</td><td>${num(r.ptr_meters)} m</td></tr><tr><td>Costo PTR</td><td>${money(r.ptr_cost)}</td></tr><tr><td>Costo lona</td><td>${money(r.canvas_cost)}</td></tr><tr><td>Costo impresión</td><td>${money(r.print_cost)}</td></tr><tr><td>Mano de obra</td><td>${money(r.labor_cost)}</td></tr>`;
 }
 const back=document.createElement('div');back.className='cp-result-backdrop';
 back.innerHTML=`<div class="cp-result-box" role="dialog" aria-modal="true" aria-labelledby="cpResultTitle"><div class="cp-result-top"><div><div class="cp-result-kicker">Fase 4 · Resultado</div><div id="cpResultTitle" class="cp-result-title">${type}</div><div class="cp-result-sub">Revisión interna antes de convertir el cálculo en una cotización comercial.</div></div><button class="cp-result-close" type="button" aria-label="Cerrar">×</button></div><div class="cp-result-body"><div class="cp-result-hero"><div><span>Precio de venta ${isCnc?'total':'estimado'}</span><strong>${money(r.sale)}</strong><span>Margen sobre venta: ${pct(r.margin_pct)}</span></div><div class="cp-result-profit"><span>Utilidad</span><b>${money(r.profit)}</b></div></div><div class="cp-result-section"><h4>Desglose interno</h4><table class="cp-result-table"><thead><tr><th>Concepto</th><th>Resultado</th></tr></thead><tbody>${rows}<tr class="cp-result-total"><td>Costo total de producción</td><td>${money(r.cost)}</td></tr><tr><td>Margen</td><td>${pct(r.margin_pct)}</td></tr><tr class="cp-result-sale"><td>Precio de venta</td><td>${money(r.sale)}</td></tr></tbody></table></div><div class="cp-result-commercial"><strong>🔒 Información interna.</strong> Los costos, desperdicio, mano de obra, máquina y utilidad no se mostrarán al cliente. Este resultado queda preparado temporalmente para ser utilizado por la Fase 5 al crear la cotización formal.</div></div><div class="cp-result-actions"><button type="button" class="cp-result-secondary cp-result-close-action">Volver al cálculo</button><button type="button" class="cp-result-primary cp-result-close-action">Usar este resultado</button><div class="cp-result-note">El botón “Usar este resultado” cierra el resumen y conserva el cálculo preparado para la siguiente fase.</div></div></div>`;
 document.body.appendChild(back);document.body.style.overflow='hidden';requestAnimationFrame(()=>back.classList.add('open'));
 const close=()=>{back.classList.remove('open');setTimeout(()=>back.remove(),200);document.body.style.overflow='';};
 back.addEventListener('click',e=>{if(e.target===back||e.target.closest('.cp-result-close,.cp-result-close-action'))close();});
 document.addEventListener('keydown',function esc(e){if(e.key==='Escape'){close();document.removeEventListener('keydown',esc);}});
}
function bindResult(){
 document.addEventListener('click',e=>{const b=e.target.closest('.js-open-result');if(b){e.preventDefault();openResult(window.CP_CALC_RESULT);}});
 if(window.CP_CALC_RESULT) setTimeout(()=>openResult(window.CP_CALC_RESULT),180);
}
if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',bindResult,{once:true});else bindResult();
})();
