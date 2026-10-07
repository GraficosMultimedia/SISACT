
document.addEventListener('DOMContentLoaded',function(){
  const endpoint='/api/admin_quote_notifications.php';
  let lastId=parseInt(localStorage.getItem('cpq_last_notification_id')||'0',10)||0;
  let busy=false;
  let toastTimer=null;

  function esc(s){return String(s??'').replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c]));}
  function ensureShell(){
    let shell=document.getElementById('cpqAdminNotificationShell');
    if(shell)return shell;
    shell=document.createElement('div');
    shell.id='cpqAdminNotificationShell';
    shell.innerHTML=`
      <div class="cpq-admin-notifications" aria-live="polite">
        <div class="cpq-notification-list"></div>
      </div>`;
    document.body.appendChild(shell);
    return shell;
  }
  function show(item){
    const shell=ensureShell(), list=shell.querySelector('.cpq-notification-list');
    const el=document.createElement('article');
    el.className='cpq-admin-toast';
    el.innerHTML=`
      <div class="cpq-toast-icon">!</div>
      <div class="cpq-toast-body">
        <span class="cpq-toast-kicker">NUEVA SOLICITUD WEB</span>
        <strong>${esc(item.title)}</strong>
        <p>${esc(item.message)}</p>
        <div class="cpq-toast-actions">
          <a href="/admin/cotizaciones_web.php#cpq-${encodeURIComponent(item.request_id)}">Abrir expediente →</a>
          <button type="button" data-notification-id="${item.id}">Marcar leída</button>
        </div>
      </div>
      <button class="cpq-toast-close" type="button" aria-label="Cerrar">×</button>
    `;
    el.querySelector('.cpq-toast-close').addEventListener('click',()=>remove(el));
    el.querySelector('[data-notification-id]').addEventListener('click',async()=>{
      const data=new URLSearchParams();
      data.set('id',item.id);
      data.set('_csrf',document.querySelector('input[name="_csrf"]')?.value||'');
      try{await fetch(endpoint+'?action=mark_read',{method:'POST',headers:{'Content-Type':'application/x-www-form-urlencoded'},body:data.toString(),credentials:'same-origin'});}catch(_){}
      remove(el);
    });
    list.prepend(el);
    requestAnimationFrame(()=>el.classList.add('is-visible'));
    clearTimeout(toastTimer);
    toastTimer=setTimeout(()=>{
      if(el.isConnected)remove(el);
    },12000);
  }
  function remove(el){
    el.classList.remove('is-visible');
    setTimeout(()=>el.remove(),220);
  }

  async function poll(){
    if(busy)return;
    busy=true;
    try{
      const res=await fetch(endpoint+'?action=poll&after='+lastId+'&limit=10&t='+Date.now(),{credentials:'same-origin',cache:'no-store'});
      const data=await res.json();
      if(data.ok){
        const items=Array.isArray(data.notifications)?data.notifications:[];
        items.forEach(item=>{
          if(Number(item.id)>lastId){
            show(item);
            lastId=Number(item.id);
          }
        });
        if(Number(data.latest_id)>lastId)lastId=Number(data.latest_id);
        localStorage.setItem('cpq_last_notification_id',String(lastId));
      }
    }catch(_){}
    busy=false;
  }

  poll();
  setInterval(poll,15000);
});
