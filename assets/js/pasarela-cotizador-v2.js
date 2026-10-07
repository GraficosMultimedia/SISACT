
(() => {
  'use strict';

  const SERVICES = {
    playeras:{name:'Playeras personalizadas',icon:'👕',desc:'DTF, bordado, vinil o sublimación',fields:[
      {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 25',required:true},
      {name:'garment',label:'Tipo de prenda',type:'select',options:['Playera cuello redondo','Playera polo','Sudadera','Otra']},
      {name:'technique',label:'Técnica',type:'select',options:['DTF','Bordado','Sublimación','Vinil textil','No lo sé todavía']},
      {name:'color',label:'Color de prenda',type:'text',placeholder:'Ej. Negro, blanco...'}]},
    bordado:{name:'Bordado',icon:'🧵',desc:'Prendas, gorras y artículos',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 20',required:true},
      {name:'item',label:'¿Qué vamos a bordar?',type:'text',placeholder:'Playeras, gorras, chamarras...'},
      {name:'positions',label:'Número de posiciones',type:'select',options:['1','2','3 o más']},
      {name:'size',label:'Tamaño aproximado del bordado',type:'select',options:['Pequeño','Mediano','Grande','No lo sé']}]},
    sublimacion:{name:'Sublimación',icon:'🎨',desc:'Textiles y artículos personalizados',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 12',required:true},
      {name:'product',label:'Producto',type:'select',options:['Taza','Playera','Termo','Llavero','Rompecabezas','Otro']},
      {name:'colors',label:'¿Cuántos diseños diferentes?',type:'number',min:1,placeholder:'Ej. 2'},
      {name:'size',label:'Medida o tamaño',type:'text',placeholder:'Ej. 22 × 9 cm'}]},
    dtf:{name:'DTF',icon:'✨',desc:'Impresión para personalización textil',fields:[
      {name:'quantity',label:'Cantidad de aplicaciones',type:'number',min:1,placeholder:'Ej. 25',required:true},
      {name:'size',label:'Tamaño aproximado',type:'select',options:['Logo pequeño','A4','A3','Medio metro','Metro','Varios metros']},
      {name:'designs',label:'¿Cuántos diseños diferentes?',type:'number',min:1,placeholder:'Ej. 3'},
      {name:'application',label:'¿Necesitas aplicación en prenda?',type:'select',options:['Sí','No','Todavía no lo sé']}]},
    impresion:{name:'Impresión',icon:'🖨️',desc:'Papelería, publicidad y piezas impresas',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 100',required:true},
      {name:'product',label:'¿Qué producto necesitas?',type:'text',placeholder:'Tarjetas, volantes, trípticos, menús...'},
      {name:'size',label:'Medidas',type:'text',placeholder:'Ej. Carta, media carta, 90 × 60 cm...'},
      {name:'material',label:'Material',type:'text',placeholder:'Couché, opalina, sintético...'},
      {name:'finish',label:'Acabado',type:'select',options:['Sin acabado','Laminado','Barniz','Corte','Doblez','No lo sé']}]},
    gran_formato:{name:'Gran formato',icon:'🖼️',desc:'Lonas, vinil, banners y publicidad',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 1',required:true},
      {name:'product',label:'Producto',type:'select',options:['Lona','Vinil de impresión','Vinil de corte','Banner','Pendón','Otro']},
      {name:'width',label:'Ancho (cm)',type:'number',min:1,placeholder:'Ej. 200'},
      {name:'height',label:'Alto (cm)',type:'number',min:1,placeholder:'Ej. 100'},
      {name:'finish',label:'Acabado',type:'select',options:['Ojillos','Dobladillo','Instalación','Sin acabado','No lo sé']}]},
    etiquetas:{name:'Etiquetas y stickers',icon:'🏷️',desc:'Etiquetas adhesivas y señalización',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 500',required:true},
      {name:'size',label:'Medida',type:'text',placeholder:'Ej. 5 × 5 cm'},
      {name:'material',label:'Material',type:'select',options:['Papel','Vinil','Transparente','Otro']},
      {name:'finish',label:'Acabado',type:'select',options:['Mate','Brillante','Troquelado','Rectangular','No lo sé']},
      {name:'roll',label:'Presentación',type:'select',options:['Por pieza','En rollo','No lo sé']}]},
    sellos:{name:'Sellos personalizados',icon:'◼',desc:'Autoentintables y de madera',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 1',required:true},
      {name:'type',label:'Tipo de sello',type:'select',options:['Autoentintable','Madera','Otro']},
      {name:'size',label:'Tamaño aproximado',type:'text',placeholder:'Ej. 38 × 14 mm'},
      {name:'text',label:'Texto que llevará',type:'text',placeholder:'Nombre, RFC, teléfono...'}]},
    laser:{name:'Grabado láser',icon:'⌁',desc:'Madera, acrílico, termos y reconocimientos',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 10',required:true},
      {name:'material',label:'Material / artículo',type:'text',placeholder:'Madera, acrílico, termo...'},
      {name:'size',label:'Medidas aproximadas',type:'text',placeholder:'Ej. 10 × 10 cm'},
      {name:'detail',label:'¿Qué se grabará?',type:'text',placeholder:'Logo, nombre, frase, diseño...'}]},
    cnc:{name:'Corte CNC',icon:'✂',desc:'MDF, melamina, madera, acrílico y más',fields:[
      {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 4',required:true},
      {name:'material',label:'Material',type:'text',placeholder:'MDF, melamina, madera, acrílico...'},
      {name:'thickness',label:'Espesor',type:'text',placeholder:'Ej. 15 mm'},
      {name:'size',label:'Medidas de placa',type:'text',placeholder:'Ej. 122 × 244 cm'},
      {name:'cut_type',label:'Tipo de trabajo',type:'select',options:['Corte recto','Corte con forma','Perforado','Grabado CNC','No lo sé']}]},
    corporea:{name:'Letras corpóreas',icon:'🔠',desc:'3D para fachadas, interiores y señalización',fields:[
      {name:'quantity',label:'Cantidad de letras / piezas',type:'number',min:1,placeholder:'Ej. 8',required:true},
      {name:'material',label:'Material',type:'select',options:['PVC','Acrílico','Aluminio','Madera','Otro']},
      {name:'height',label:'Altura aproximada',type:'text',placeholder:'Ej. 30 cm'},
      {name:'installation',label:'¿Requieres instalación?',type:'select',options:['Sí','No','No lo sé']}]},
    diseno:{name:'Diseño gráfico',icon:'✎',desc:'Logotipos, publicidad, identidad y piezas digitales',fields:[
      {name:'quantity',label:'Cantidad de piezas / diseños',type:'number',min:1,placeholder:'Ej. 1',required:true},
      {name:'type',label:'Tipo de diseño',type:'select',options:['Logotipo','Identidad corporativa','Flyer','Etiqueta','Menú','Redes sociales','Catálogo','Invitación','Otro']},
      {name:'format',label:'Entrega final',type:'select',options:['Digital','Impresión','Digital + impresión']},
      {name:'reference',label:'¿Tienes referencias?',type:'text',placeholder:'Describe el estilo, colores o referencias...'}]},
    comestible:{name:'Impresión comestible',icon:'🍰',desc:'Oblea de azúcar y papel de arroz/papa',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 20',required:true},
      {name:'material',label:'Tipo de oblea',type:'select',options:['Azúcar sabor vainilla','Arroz / papa sabor neutro','No lo sé']},
      {name:'size',label:'Medidas',type:'text',placeholder:'Ej. 20 × 20 cm'},
      {name:'event',label:'¿Para qué evento o producto?',type:'text',placeholder:'Pastel, cupcakes, evento...'}]},
    promo:{name:'Artículos promocionales',icon:'🎁',desc:'Tazas, termos, vasos, botellas, souvenirs y más',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 30',required:true},
      {name:'product',label:'Producto',type:'text',placeholder:'Taza, termo, botella, vaso, cojín...'},
      {name:'personalization',label:'Personalización',type:'text',placeholder:'Logo, nombre, frase, foto...'},
      {name:'occasion',label:'Uso / evento',type:'text',placeholder:'Empresa, boda, regalo, evento...'}]},
    vinil:{name:'Vinil de corte',icon:'✦',desc:'Cristales, muros, vehículos y rotulación',fields:[
      {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 2',required:true},
      {name:'surface',label:'¿Dónde se instalará?',type:'select',options:['Cristal','Muro','Vehículo','Otro']},
      {name:'size',label:'Medidas',type:'text',placeholder:'Ej. 100 × 50 cm'},
      {name:'color',label:'Color de vinil',type:'text',placeholder:'Ej. Negro, blanco, rojo...'}]},
    invitaciones:{name:'Invitaciones especiales',icon:'💌',desc:'Bodas, XV años y eventos',fields:[
      {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 100',required:true},
      {name:'event',label:'Tipo de evento',type:'select',options:['Boda','XV años','Cumpleaños','Bautizo','Corporativo','Otro']},
      {name:'size',label:'Formato / tamaño',type:'text',placeholder:'Ej. 15 × 21 cm'},
      {name:'finish',label:'Acabado',type:'select',options:['Simple','Premium','Con sobre','Con acabados especiales','No lo sé']}]},
    otro:{name:'Otro proyecto',icon:'＋',desc:'Algo diferente que quieres fabricar o imprimir',fields:[
      {name:'quantity',label:'Cantidad aproximada',type:'number',min:1,placeholder:'Ej. 1'},
      {name:'project',label:'¿Qué necesitas?',type:'text',placeholder:'Descríbelo en una frase...'},
      {name:'size',label:'Medidas aproximadas',type:'text',placeholder:'Si aplica'},
      {name:'material',label:'Material',type:'text',placeholder:'Si lo conoces'}]}
  };

  const STEP_TITLES=['Servicio','Detalles','Archivos','Entrega','Revisión'];
  const modal=document.querySelector('#cpqModal');
  if(!modal)return;
  const form=document.querySelector('#cpqForm');
  const serviceGrid=document.querySelector('#cpqServiceGrid');
  const dynamicFields=document.querySelector('#cpqDynamicFields');
  const review=document.querySelector('#cpqReview');
  const footer=document.querySelector('#cpqFooter');
  const result=document.querySelector('#cpqResult');
  const submitState=document.querySelector('#cpqSubmitState');
  const nextButton=document.querySelector('#cpqNext');
  const backButton=document.querySelector('#cpqBack');

  let step=1,selected='',submitting=false;

  const $=(s,r=document)=>r.querySelector(s);
  const $$=(s,r=document)=>[...r.querySelectorAll(s)];
  const esc=v=>String(v??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));

  function renderServices(){
    serviceGrid.innerHTML=Object.entries(SERVICES).map(([key,s])=>`
      <button type="button" class="cpq-service ${selected===key?'is-selected':''}" data-service-key="${esc(key)}">
        <span class="cpq-service-icon">${s.icon}</span>
        <span class="cpq-service-name">${esc(s.name)}</span>
        <small>${esc(s.desc)}</small>
        <i>→</i>
      </button>`).join('');
    $$('.cpq-service',serviceGrid).forEach(btn=>btn.addEventListener('click',()=>selectService(btn.dataset.serviceKey)));
  }

  function selectService(key){
    if(!SERVICES[key])return;
    selected=key;
    renderServices();
    const er=$('#cpqServiceError'); if(er)er.textContent='';
    renderDynamic();
  }

  function renderDynamic(){
    const s=SERVICES[selected];
    if(!s){dynamicFields.innerHTML='<div class="cpq-empty">Selecciona un servicio para continuar.</div>';return;}
    $('#cpqDetailsTitle').textContent=s.name;
    dynamicFields.innerHTML=s.fields.map(f=>{
      if(f.type==='select')return `<label class="cpq-field"><span>${esc(f.label)}${f.required?' *':''}</span><select name="${esc(f.name)}" ${f.required?'required':''}>${f.options.map(o=>`<option value="${esc(o)}">${esc(o)}</option>`).join('')}</select></label>`;
      return `<label class="cpq-field"><span>${esc(f.label)}${f.required?' *':''}</span><input name="${esc(f.name)}" type="${esc(f.type)}" ${f.min?`min="${esc(f.min)}"`:''} placeholder="${esc(f.placeholder||'')}" ${f.required?'required':''}></label>`;
    }).join('');
  }

  function openModal(target=1){
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden','false');
    document.body.classList.add('cpq-lock');
    goTo(target);
  }
  function closeModal(){
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden','true');
    document.body.classList.remove('cpq-lock');
  }

  function collect(){
    const data={service:selected,service_name:SERVICES[selected]?.name||''};
    $$('input,select,textarea',form).forEach(el=>{
      if(el.name && el.name!=='website' && el.type!=='file')data[el.name]=(el.value??'').trim();
    });
    const file=$('input[name="attachment"]',form);
    data.attachment=file?.files?.[0]||null;
    return data;
  }

  function validateCurrent(){
    if(step===1){
      if(!selected){
        const er=$('#cpqServiceError');if(er)er.textContent='Selecciona el servicio que más se acerque a tu proyecto.';
        return false;
      }
      return true;
    }
    if(step===2){
      for(const el of $$('[required]',dynamicFields)){
        if(!String(el.value||'').trim()){el.focus();alert('Completa el campo requerido.');return false;}
      }
      return true;
    }
    if(step===4){
      const name=$('[name="name"]',form)?.value.trim()||'';
      const phone=$('[name="phone"]',form)?.value.trim()||'';
      const email=$('[name="email"]',form)?.value.trim()||'';
      if(!name||!phone){alert('Completa tu nombre y WhatsApp para continuar.');return false;}
      if(email&&!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)){alert('Revisa el correo electrónico.');return false;}
      return true;
    }
    return true;
  }

  function renderReview(){
    const d=collect(),s=SERVICES[selected];
    const detailRows=(s?.fields||[]).map(f=>{
      const value=d[f.name];
      return value?`<div class="cpq-review-row"><span>${esc(f.label)}</span><strong>${esc(value)}</strong></div>`:'';
    }).join('');
    review.innerHTML=`
      <div class="cpq-review-card cpq-review-main"><div class="cpq-review-icon">${s?.icon||'✦'}</div><div><span>SERVICIO</span><strong>${esc(s?.name||'Por seleccionar')}</strong></div></div>
      <div class="cpq-review-grid">
        <div class="cpq-review-card"><span>DETALLES</span>${detailRows||'<p>Sin detalles adicionales.</p>'}</div>
        <div class="cpq-review-card"><span>PRODUCCIÓN Y ENTREGA</span>
          <div class="cpq-review-row"><span>Diseño</span><strong>${esc(d.design_status||'No indicado')}</strong></div>
          <div class="cpq-review-row"><span>Aplicación / instalación</span><strong>${esc(d.application||'No indicado')}</strong></div>
          <div class="cpq-review-row"><span>Entrega</span><strong>${esc(d.delivery_method||'Por confirmar')}</strong></div>
          <div class="cpq-review-row"><span>Fecha solicitada</span><strong>${esc(d.desired_date||'Por confirmar')}</strong></div>
        </div>
      </div>
      <div class="cpq-review-card cpq-review-contact"><span>CONTACTO</span>
        <div class="cpq-review-row"><span>Nombre</span><strong>${esc(d.name||'Falta')}</strong></div>
        <div class="cpq-review-row"><span>WhatsApp</span><strong>${esc(d.phone||'Falta')}</strong></div>
        ${d.email?`<div class="cpq-review-row"><span>Correo</span><strong>${esc(d.email)}</strong></div>`:''}
        ${d.notes?`<div class="cpq-review-note-row"><span>Notas</span><p>${esc(d.notes)}</p></div>`:''}
        ${d.attachment?`<div class="cpq-review-row"><span>Archivo</span><strong>${esc(d.attachment.name)}</strong></div>`:''}
      </div>`;
  }

  function updateProgress(){
    $$('.cpq-progress span').forEach((bar,i)=>{
      bar.classList.toggle('is-current',i===step-1);
      bar.classList.toggle('is-done',i<step-1);
    });
    $('#cpqStepTitle').textContent=STEP_TITLES[step-1]||'Revisión';
    $('#cpqStepNumber').textContent=String(step);
    $('#cpqFooterLabel').textContent=`Paso ${step} de 5`;
    backButton.style.visibility=step===1?'hidden':'visible';
    nextButton.textContent=step===5?'Enviar solicitud →':'Continuar →';
  }

  function scrollDialogTop(){
    const dialog=$('.cpq-dialog');
    if(!dialog)return;
    try{dialog.scrollTo({top:0,behavior:'smooth'})}catch(_){dialog.scrollTop=0}
  }

  function goTo(target){
    step=Math.max(1,Math.min(5,Number(target)||1));
    $$('.cpq-step').forEach(panel=>panel.classList.toggle('is-visible',Number(panel.dataset.cpqStepview)===step));
    result.classList.remove('is-visible');
    footer.style.display='flex';
    if(step===5)renderReview();
    updateProgress();
    scrollDialogTop();
  }

  async function submit(){
    if(submitting||!validateCurrent())return;
    const data=collect();
    const fd=new FormData(form);
    fd.set('service',selected);
    fd.set('service_name',SERVICES[selected]?.name||'');
    if(data.attachment)fd.set('attachment',data.attachment);

    submitting=true;
    nextButton.disabled=true;
    backButton.disabled=true;
    submitState.classList.remove('is-error');
    submitState.textContent='Enviando tu solicitud…';

    const controller=new AbortController();
    const timer=setTimeout(()=>controller.abort(),15000);

    try{
      const response=await fetch(new URL('api/pasarela-cotizador.php',window.location.href).href,{
        method:'POST',
        body:fd,
        headers:{'X-Requested-With':'XMLHttpRequest','Accept':'application/json'},
        credentials:'same-origin',
        cache:'no-store',
        signal:controller.signal
      });

      const text=await response.text();
      let payload=null;
      try{payload=JSON.parse(text)}catch(_){}

      if(!payload){
        throw new Error(`El servidor respondió HTTP ${response.status} sin JSON. Revisa la respuesta del endpoint.`);
      }
      if(!response.ok||!payload.ok){
        throw new Error(payload.message||`No se pudo registrar la solicitud. HTTP ${response.status}.`);
      }

      $('#cpqRequestId').textContent=payload.reference||`CPQ-${String(payload.id||'').padStart(6,'0')}`;
      $('#cpqResultText').textContent=payload.message||'Tu solicitud quedó registrada correctamente.';
      const wa=$('#cpqResultWhatsApp');
      if(wa)wa.href=payload.whatsapp_url||'#';

      $$('.cpq-step').forEach(panel=>panel.classList.remove('is-visible'));
      result.classList.add('is-visible');
      footer.style.display='none';
      submitState.textContent='';
    }catch(error){
      let message=error?.message||'No se pudo registrar la solicitud.';
      if(error?.name==='AbortError')message='El servidor tardó más de 15 segundos en responder. La solicitud NO se puede confirmar todavía. Intenta nuevamente.';
      submitState.textContent=message;
      submitState.classList.add('is-error');
      nextButton.disabled=false;
      backButton.disabled=false;
    }finally{
      clearTimeout(timer);
      submitting=false;
    }
  }

  function reset(){
    form.reset();
    selected='';
    result.classList.remove('is-visible');
    footer.style.display='flex';
    submitState.textContent='';
    submitState.classList.remove('is-error');
    renderServices();
    renderDynamic();
    goTo(1);
  }

  $$('[data-cpq-open]').forEach(btn=>btn.addEventListener('click',()=>openModal(btn.dataset.cpqStep||1)));
  $$('[data-cpq-close]').forEach(btn=>btn.addEventListener('click',closeModal));
  nextButton.addEventListener('click',event=>{
    event.preventDefault();
    if(step<5){if(validateCurrent())goTo(step+1)}
    else submit();
  });
  backButton.addEventListener('click',event=>{
    event.preventDefault();
    if(step>1)goTo(step-1);
  });
  $('#cpqNewRequest')?.addEventListener('click',reset);
  document.addEventListener('keydown',event=>{
    if(event.key==='Escape'&&modal.classList.contains('is-open'))closeModal();
  });

  renderServices();
  renderDynamic();
  updateProgress();
})();
