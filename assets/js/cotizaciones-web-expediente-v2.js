
document.addEventListener('DOMContentLoaded',()=>{
 const drawer=document.getElementById('cpq2Drawer');
 const body=document.getElementById('cpq2DrawerBody');
 const title=document.getElementById('cpq2DrawerTitle');
 const sub=document.getElementById('cpq2DrawerSubtitle');
 const wa=document.getElementById('cpq2DrawerWa');
 if(!drawer||!body)return;

 const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));
 const moneySize=n=>{
   n=Number(n)||0;
   return n<1024*1024 ? `${Math.round(n/1024)} KB` : `${(n/1048576).toFixed(2)} MB`;
 };
 function rows(obj){
   if(!obj||typeof obj!=='object'||!Object.keys(obj).length)return '<p class="cpq2-muted">Sin datos adicionales.</p>';
   return Object.entries(obj).map(([k,v])=>`<div class="cpq2-exp-row"><span>${esc(k.replaceAll('_',' '))}</span><strong>${esc(v)}</strong></div>`).join('');
 }
 function open(id){
   const src=document.getElementById('cpq-data-'+id);
   if(!src)return;
   let d;
   try{d=JSON.parse(src.textContent)}catch(_){return;}
   title.textContent=`${d.reference} · ${d.customer_name}`;
   sub.textContent=`${d.service} · ${d.created_at} · ${d.status}`;
   wa.href=d.phone ? `https://wa.me/${String(d.phone).replace(/\D+/g,'')}?text=${encodeURIComponent('Hola '+d.customer_name+', somos Colibrí Print. Damos seguimiento a tu solicitud '+d.reference+'.')}` : '#';

   const files=d.files||[];
   const filesHtml=files.length ? files.map(f=>`
      <a class="cpq2-exp-file" href="/admin/cotizacion_archivo.php?id=${f.id}" target="_blank" rel="noopener">
        <i>${esc(String(f.ext||'FILE').toUpperCase())}</i>
        <div><strong>${esc(f.name)}</strong><small>${moneySize(f.size)} · Abrir archivo ↗</small></div>
      </a>`).join('') : '<p class="cpq2-muted">El cliente no adjuntó archivos.</p>';

   body.innerHTML=`
     <section class="cpq2-exp-hero"><span class="eyebrow">CLIENTE</span><h4>${esc(d.customer_name)}</h4><div>${d.phone?`<span>☎ ${esc(d.phone)}</span>`:''}${d.email?`<span>✉ ${esc(d.email)}</span>`:''}</div></section>
     <section class="cpq2-exp-block"><span class="eyebrow">SERVICIO</span><h4>${esc(d.service)}</h4><div class="cpq2-exp-grid"><div><span>Cantidad</span><strong>${esc(d.quantity)}</strong></div><div><span>Fecha solicitada</span><strong>${esc(d.desired_date)}</strong></div></div></section>
     <section class="cpq2-exp-block"><span class="eyebrow">ESPECIFICACIONES</span>${rows(d.details)}</section>
     <section class="cpq2-exp-block"><span class="eyebrow">PRODUCCIÓN</span>${rows(d.production)}</section>
     <section class="cpq2-exp-block"><span class="eyebrow">ENTREGA</span>${rows(d.delivery)}</section>
     <section class="cpq2-exp-block"><span class="eyebrow">ARCHIVOS DEL CLIENTE · ${files.length}</span><div class="cpq2-exp-files">${filesHtml}</div></section>
     <details class="cpq2-raw"><summary>Ver respaldo técnico de la solicitud</summary><pre>${esc(d.raw)}</pre></details>
   `;
   drawer.classList.add('is-open');drawer.setAttribute('aria-hidden','false');document.body.classList.add('cpq2-drawer-open');
 }
 function close(){drawer.classList.remove('is-open');drawer.setAttribute('aria-hidden','true');document.body.classList.remove('cpq2-drawer-open');}
 document.querySelectorAll('[data-open-expedient]').forEach(b=>b.addEventListener('click',()=>open(b.dataset.openExpedient)));
 drawer.addEventListener('click',e=>{if(e.target.matches('[data-close-expedient]'))close();});
 document.addEventListener('keydown',e=>{if(e.key==='Escape'&&drawer.classList.contains('is-open'))close();});
});
