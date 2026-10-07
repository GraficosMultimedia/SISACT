
document.addEventListener('DOMContentLoaded',function(){
  const modal=document.getElementById('printCaptureModal');
  const dialog=modal?.querySelector('.capture-modal-dialog');
  const form=document.getElementById('meterForm');
  const grid=form?.querySelector('.meter-form-grid');
  if(!modal||!dialog||!form||!grid)return;

  dialog.classList.add('capture-wizard-dialog');

  const fields={
    date:form.querySelector('input[name="printed_at"]')?.closest('.field'),
    roll:form.querySelector('#roll_id')?.closest('.field'),
    job:form.querySelector('input[name="job_name"]')?.closest('.field'),
    length:form.querySelector('#job_length_mm')?.closest('.field'),
    meters:form.querySelector('#linear_m')?.closest('.field'),
    result:form.querySelector('#result_status')?.closest('.field'),
    rollConfirm:form.querySelector('.roll-selection-confirm'),
    preview:form.querySelector('.meter-preview'),
    note:form.querySelector('.capture-confirm-note'),
    submit:form.querySelector('.capture-submit')
  };

  if(!fields.job||!fields.roll||!fields.length||!fields.meters||!fields.result||!fields.rollConfirm||!fields.preview||!fields.submit)return;

  form.querySelectorAll('.capture-step-label').forEach(el=>el.remove());
  const card=form.closest('.capture-modal-card');
  const heading=card?.querySelector('.section-heading');
  if(heading)heading.style.display='none';

  const shell=document.createElement('div');
  shell.className='capture-wizard-shell';

  const header=document.createElement('div');
  header.className='capture-wizard-header';
  header.innerHTML=`
    <div>
      <div class="capture-wizard-kicker">PRONTEXP · CAPTURA INTERNA</div>
      <h3 class="capture-wizard-title">Registremos la impresión.</h3>
      <p class="capture-wizard-subtitle">Una decisión a la vez. El descuento ocurre únicamente al confirmar.</p>
    </div>
  `;
  const closeButton=document.createElement('button');
  closeButton.type='button';
  closeButton.className='capture-wizard-close';
  closeButton.setAttribute('aria-label','Cerrar captura');
  closeButton.textContent='×';
  closeButton.addEventListener('click',()=>document.getElementById('closePrintCapture')?.click());
  header.appendChild(closeButton);

  const progress=document.createElement('div');
  progress.className='capture-wizard-progress';
  progress.innerHTML=`
    <div class="capture-wizard-progress-track">
      <div class="capture-wizard-progress-fill" id="captureWizardProgressFill"></div>
      <div class="capture-wizard-progress-points">
        <div class="capture-wizard-point is-active"><span>1</span></div>
        <div class="capture-wizard-point"><span>2</span></div>
        <div class="capture-wizard-point"><span>3</span></div>
        <div class="capture-wizard-point"><span>✓</span></div>
      </div>
    </div>
  `;

  const body=document.createElement('div');
  body.className='capture-wizard-body';

  const step1=document.createElement('section');
  step1.className='capture-wizard-step is-active';
  step1.dataset.step='1';
  step1.innerHTML=`
    <div class="capture-step-kicker">01 · TRABAJO</div>
    <div class="capture-step-icon">🖨️</div>
    <h4 class="capture-step-title">¿Qué trabajo vas a registrar?</h4>
    <p class="capture-step-help">Escribe exactamente el nombre que aparece en Printexp. La fecha se conserva automáticamente.</p>
  `;
  step1.append(fields.job);
  if(fields.date)step1.append(fields.date);

  const step2=document.createElement('section');
  step2.className='capture-wizard-step';
  step2.dataset.step='2';
  step2.innerHTML=`
    <div class="capture-step-kicker">02 · CONSUMO</div>
    <div class="capture-step-icon">📏</div>
    <h4 class="capture-step-title">¿Cuánto material consumió?</h4>
    <p class="capture-step-help">Captura el largo que muestra Printexp. Los metros lineales se calculan automáticamente.</p>
  `;
  const fieldGrid=document.createElement('div');
  fieldGrid.className='capture-step-field-grid';
  fieldGrid.append(fields.length,fields.meters);
  step2.append(fieldGrid);
  const consumptionPreview=document.createElement('div');
  consumptionPreview.className='capture-consumption-preview';
  consumptionPreview.innerHTML=`
    <div class="capture-consumption-box"><span>Job Size</span><strong id="wizardJobSize">0.00 mm</strong></div>
    <div class="capture-consumption-box"><span>Consumo</span><strong id="wizardMeters">0.000 m</strong></div>
  `;
  step2.append(consumptionPreview);

  const step3=document.createElement('section');
  step3.className='capture-wizard-step';
  step3.dataset.step='3';
  step3.innerHTML=`
    <div class="capture-step-kicker">03 · ROLLO</div>
    <div class="capture-step-icon">🎞️</div>
    <h4 class="capture-step-title">¿En qué rollo se imprimió?</h4>
    <p class="capture-step-help">Selecciona el rollo físico antes de pasar a la confirmación.</p>
  `;
  step3.append(fields.roll);
  const rollCard=document.createElement('div');
  rollCard.className='capture-roll-card';
  rollCard.innerHTML=`
    <span class="roll-card-label">Rollo seleccionado</span>
    <span class="roll-card-title" id="wizardRollName">Selecciona un rollo</span>
    <div class="capture-roll-metrics">
      <div class="capture-roll-metric"><span>ID</span><strong id="wizardRollId">—</strong></div>
      <div class="capture-roll-metric"><span>Disponible</span><strong id="wizardRollAvailable">—</strong></div>
      <div class="capture-roll-metric"><span>Después</span><strong id="wizardRollAfter">—</strong></div>
    </div>
  `;
  step3.append(rollCard,fields.result);

  const step4=document.createElement('section');
  step4.className='capture-wizard-step';
  step4.dataset.step='4';
  step4.innerHTML=`
    <div class="capture-step-kicker">04 · CONFIRMACIÓN</div>
    <div class="capture-step-icon">✓</div>
    <h4 class="capture-step-title">¿Todo correcto?</h4>
    <p class="capture-step-help">Última revisión. El rollo no se descuenta hasta que confirmes.</p>
  `;
  const finalCard=document.createElement('div');
  finalCard.className='capture-final-card';
  finalCard.innerHTML=`
    <div class="final-check">✓</div>
    <h4>Revisa antes de descontar</h4>
    <p>Estos son los datos que se enviarán al registro.</p>
    <div class="capture-final-summary">
      <div class="capture-final-row"><span>Trabajo</span><strong id="finalJob">—</strong></div>
      <div class="capture-final-row"><span>Rollo</span><strong id="finalRoll">—</strong></div>
      <div class="capture-final-row"><span>Disponible</span><strong id="finalAvailable">—</strong></div>
      <div class="capture-final-row is-important"><span>Consumo</span><strong id="finalConsumption">0.000 m</strong></div>
      <div class="capture-final-row is-important"><span>Saldo después</span><strong id="finalAfter">—</strong></div>
    </div>
    <div class="capture-danger-note">⚠ Revisa especialmente el rollo. Este registro descontará los metros del inventario.</div>
  `;
  step4.append(finalCard,fields.rollConfirm,fields.preview,fields.note);

  body.append(step1,step2,step3,step4);

  const footer=document.createElement('div');
  footer.className='capture-wizard-footer';
  footer.innerHTML=`
    <div class="capture-wizard-footer-left">
      <button type="button" class="wizard-cancel">Cancelar</button>
      <button type="button" class="wizard-back" disabled>← Atrás</button>
    </div>
    <div class="capture-wizard-footer-right">
      <button type="button" class="wizard-next">Continuar →</button>
      <button type="button" class="wizard-submit" style="display:none">✓ Confirmar y descontar</button>
    </div>
  `;

  grid.hidden=true;
  form.insertBefore(shell,form.firstChild);
  shell.append(header,progress,body,footer);

  const steps=[...body.querySelectorAll('.capture-wizard-step')];
  const points=[...progress.querySelectorAll('.capture-wizard-point')];
  const fill=progress.querySelector('#captureWizardProgressFill');
  const back=footer.querySelector('.wizard-back');
  const next=footer.querySelector('.wizard-next');
  const submit=footer.querySelector('.wizard-submit');
  const cancel=footer.querySelector('.wizard-cancel');
  let currentStep=1;

  function num(v){
    const n=parseFloat(String(v||'').replace(',','.'));
    return Number.isFinite(n)?n:0;
  }
  function roll(){
    const opt=form.querySelector('#roll_id')?.selectedOptions?.[0];
    return {
      id:opt?.dataset?.rollId||form.querySelector('#roll_id')?.value||'',
      name:(opt?.dataset?.rollName||'').trim(),
      available:num(opt?.dataset?.remaining)
    };
  }
  function mirror(){
    const job=(form.querySelector('[name="job_name"]')?.value||'').trim();
    const mm=num(form.querySelector('#job_length_mm')?.value);
    const m=num(form.querySelector('#linear_m')?.value);
    const r=roll();
    const after=Math.max(0,r.available-m);

    document.getElementById('wizardJobSize').textContent=mm.toFixed(2)+' mm';
    document.getElementById('wizardMeters').textContent=m.toFixed(3)+' m';
    document.getElementById('wizardRollName').textContent=r.name||'Selecciona un rollo';
    document.getElementById('wizardRollId').textContent=r.name?'#'+r.id:'—';
    document.getElementById('wizardRollAvailable').textContent=r.name?r.available.toFixed(3)+' m':'—';
    document.getElementById('wizardRollAfter').textContent=r.name&&m>0?after.toFixed(3)+' m':'—';
    document.getElementById('finalJob').textContent=job||'—';
    document.getElementById('finalRoll').textContent=r.name?r.name+' · #'+r.id:'—';
    document.getElementById('finalAvailable').textContent=r.name?r.available.toFixed(3)+' m':'—';
    document.getElementById('finalConsumption').textContent=m.toFixed(3)+' m';
    document.getElementById('finalAfter').textContent=r.name&&m>0?after.toFixed(3)+' m':'—';
  }
  function showStep(n){
    currentStep=Math.max(1,Math.min(4,n));
    steps.forEach(s=>s.classList.toggle('is-active',Number(s.dataset.step)===currentStep));
    points.forEach((p,i)=>{
      const s=i+1;
      p.classList.toggle('is-active',s===currentStep);
      p.classList.toggle('is-done',s<currentStep);
    });
    fill.style.width=((currentStep-1)/3)*100+'%';
    back.disabled=currentStep===1;
    next.style.display=currentStep<4?'inline-flex':'none';
    submit.style.display=currentStep===4?'inline-flex':'none';
    mirror();
    requestAnimationFrame(()=>steps[currentStep-1].querySelector('input,select')?.focus());
  }
  function valid(){
    mirror();
    if(currentStep===1){
      const job=(form.querySelector('[name="job_name"]')?.value||'').trim();
      if(!job){alert('Escribe el nombre del trabajo de Printexp.');return false;}
    }
    if(currentStep===2){
      const mm=num(form.querySelector('#job_length_mm')?.value);
      const m=num(form.querySelector('#linear_m')?.value);
      if(mm<=0&&m<=0){alert('Captura el Job Size o los metros lineales.');return false;}
    }
    if(currentStep===3){
      const r=roll();
      const m=num(form.querySelector('#linear_m')?.value);
      if(!r.id){alert('Selecciona el rollo utilizado.');return false;}
      if(m<=0){alert('Captura primero los metros lineales.');return false;}
      if(m>r.available+0.0001){alert('El consumo supera el material disponible en el rollo seleccionado.');return false;}
    }
    return true;
  }

  [fields.job,fields.length,fields.meters,fields.roll,fields.result].forEach(f=>{
    f?.querySelectorAll('input,select').forEach(el=>el.addEventListener('input',mirror));
    f?.querySelectorAll('select').forEach(el=>el.addEventListener('change',mirror));
  });

  next.addEventListener('click',()=>{if(valid())showStep(currentStep+1);});
  back.addEventListener('click',()=>showStep(currentStep-1));
  cancel.addEventListener('click',()=>document.getElementById('closePrintCapture')?.click());

  submit.addEventListener('click',function(){
    if(!valid())return;
    const r=roll();
    const job=(form.querySelector('[name="job_name"]')?.value||'').trim();
    const m=num(form.querySelector('#linear_m')?.value);
    const msg=
      '⚠️ CONFIRMACIÓN FINAL\\n\\n'+
      'TRABAJO: '+job+'\\n'+
      'ROLLO: '+r.name+' (#'+r.id+')\\n'+
      'DISPONIBLE: '+r.available.toFixed(3)+' m\\n'+
      'CONSUMO: '+m.toFixed(3)+' m\\n'+
      'SALDO DESPUÉS: '+Math.max(0,r.available-m).toFixed(3)+' m\\n\\n'+
      '¿CONFIRMAS QUE ESTE ES EL ROLLO CORRECTO?';

    if(!window.confirm(msg))return;

    // Evita el doble confirm del listener anterior y envía directamente
    // al mismo endpoint/backend que ya utiliza el módulo.
    submit.disabled=true;
    HTMLFormElement.prototype.submit.call(form);
  });

  fields.submit.classList.add('capture-wizard-native-submit');

  document.getElementById('openPrintCapture')?.addEventListener('click',()=>{
    setTimeout(()=>showStep(1),0);
  });

  mirror();
});
