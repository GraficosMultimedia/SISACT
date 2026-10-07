
document.addEventListener('DOMContentLoaded',()=>{
 const endpoint='/api/admin_quote_notifications.php';
 let lastId=Number(localStorage.getItem('cpq_last_notification_id')||0)||0;
 let busy=false;
 const shell=document.createElement('div'); shell.className='cpq-admin-notifications'; document.body.appendChild(shell);
 const csrf=()=>document.querySelector('input[name="_csrf"]')?.value||'';
 const esc=s=>String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));
 function add(item){
  const el=document.createElement('article'); el.className='cpq-admin-toast';
  el.innerHTML=`<div class="cpq-toast-icon">!</div><div class="cpq-toast-body"><span class="cpq-toast-kicker">NUEVA SOLICITUD WEB</span><strong>${esc(item.title)}</strong><p>${esc(item.message)}</p><div class="cpq-toast-actions"><a href="/admin/cotizaciones_web.php#cpq-${item.request_id}">Abrir expediente →</a><button type="button">Marcar leída</button></div></div><button class="cpq-toast-close" type="button">×</button>`;
  el.querySelector('.cpq-toast-close').onclick=()=>remove(el);
  el.querySelector('.cpq-toast-actions button').onclick=async()=>{
   const p=new URLSearchParams({_csrf:csrf(),id:String(item.id)});
   try{await fetch(endpoint+'?action=mark_read',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:p.toString(),credentials:'same-origin'});}catch(_){}
   remove(el);
  };
  shell.prepend(el);requestAnimationFrame(()=>el.classList.add('is-visible'));setTimeout(()=>{if(el.isConnected)remove(el)},15000);
 }
 function remove(el){el.classList.remove('is-visible');setTimeout(()=>el.remove(),180)}
 async function poll(){
   if(busy)return;busy=true;
   try{
    const r=await fetch(endpoint+'?action=poll&after='+lastId+'&t='+Date.now(),{credentials:'same-origin',cache:'no-store'});
    const d=await r.json();
    if(d.ok){
      for(const item of (d.notifications||[])){if(Number(item.id)>lastId){add(item);lastId=Number(item.id)}}
      lastId=Math.max(lastId,Number(d.latest_id||0));localStorage.setItem('cpq_last_notification_id',String(lastId));
    }
   }catch(_){}
   busy=false;
 }
 poll();setInterval(poll,15000);
});
