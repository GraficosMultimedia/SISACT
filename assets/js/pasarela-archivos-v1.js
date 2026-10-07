
document.addEventListener('DOMContentLoaded',()=>{
 const form=document.getElementById('cpqForm');
 if(!form)return;
 const old=form.querySelector('input[name="attachment"]');
 if(!old)return;

 const label=old.closest('.cpq-field');
 if(!label)return;

 const zone=document.createElement('div');
 zone.className='cpq-files-v1';
 zone.innerHTML=`
   <div class="cpq-files-v1-icon">📎</div>
   <div class="cpq-files-v1-copy">
     <strong>Sube los archivos de tu proyecto</strong>
     <span>PDF, Word, Excel, PowerPoint, imágenes, ZIP/RAR, AI, EPS, PSD, CDR, DXF, DWG, STL y más.</span>
     <small>Hasta 5 archivos · 10 MB por archivo · 50 MB en total</small>
   </div>
   <button type="button" class="cpq-files-v1-button">Elegir archivos</button>
 `;
 const input=document.createElement('input');
 input.type='file';
 input.name='attachments[]';
 input.multiple=true;
 input.accept='.jpg,.jpeg,.png,.webp,.gif,.bmp,.svg,.pdf,.doc,.docx,.odt,.rtf,.xls,.xlsx,.ods,.csv,.ppt,.pptx,.odp,.txt,.md,.zip,.rar,.7z,.ai,.eps,.psd,.cdr,.dxf,.dwg,.stp,.step,.3mf,.obj,.stl';
 input.className='cpq-files-v1-input';
 input.setAttribute('aria-label','Seleccionar archivos del proyecto');

 const list=document.createElement('div');
 list.className='cpq-files-v1-list';

 old.type='hidden';
 old.removeAttribute('accept');

 zone.appendChild(input);
 label.replaceWith(zone);
 const notes=form.querySelector('textarea[name="notes"]');
 if(notes){notes.parentElement.parentElement.insertBefore(list,notes.parentElement);}
 else zone.after(list);

 function formatSize(n){
   return n<1048576 ? `${Math.max(1,Math.round(n/1024))} KB` : `${(n/1048576).toFixed(2)} MB`;
 }
 function render(){
   list.innerHTML='';
   const files=[...input.files];
   const total=files.reduce((a,f)=>a+f.size,0);
   const tooMany=files.length>5;
   const tooBig=files.some(f=>f.size>10*1024*1024)||total>50*1024*1024;
   if(!files.length){
     list.innerHTML='<div class="cpq-files-v1-empty">Todavía no has agregado archivos.</div>';
     zone.classList.remove('has-files','is-error');
     return;
   }
   zone.classList.add('has-files');
   if(tooMany||tooBig)zone.classList.add('is-error'); else zone.classList.remove('is-error');
   list.innerHTML=files.map(f=>{
     const ext=(f.name.split('.').pop()||'FILE').toUpperCase();
     return `<div class="cpq-file-chip"><i>${ext}</i><span>${escFile(f.name)}</span><small>${formatSize(f.size)}</small></div>`;
   }).join('');
   list.insertAdjacentHTML('beforeend',`<div class="cpq-files-v1-total">${files.length}/5 archivos · ${formatSize(total)} de 50 MB</div>`);
 }
 function escFile(s){return String(s).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));}
 zone.addEventListener('click',()=>input.click());
 zone.addEventListener('dragover',e=>{e.preventDefault();zone.classList.add('is-drag');});
 zone.addEventListener('dragleave',()=>zone.classList.remove('is-drag'));
 zone.addEventListener('drop',e=>{
   e.preventDefault();zone.classList.remove('is-drag');
   if(e.dataTransfer?.files?.length)input.files=e.dataTransfer.files;
   render();
 });
 input.addEventListener('change',render);

 // Add files to the review page without replacing the core cotizador.
 const review=document.getElementById('cpqReview');
 if(review){
   const obs=new MutationObserver(()=>{
     const files=[...input.files];
     const oldRow=review.querySelector('.cpq-files-v1-review');
     oldRow?.remove();
     if(!files.length)return;
     review.insertAdjacentHTML('beforeend',`
       <div class="cpq-review-card cpq-files-v1-review">
         <span>ARCHIVOS DEL PROYECTO</span>
         ${files.map(f=>`<div class="cpq-review-row"><span>${escFile(f.name)}</span><strong>${formatSize(f.size)}</strong></div>`).join('')}
       </div>
     `);
   });
   obs.observe(review,{childList:true,subtree:true});
 }

 render();
});
