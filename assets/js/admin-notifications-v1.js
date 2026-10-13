(() => {
'use strict';
const root=document.querySelector('[data-cp-notifications]');
if(!root)return;

const ENDPOINT='/admin/tracking_activity_feed.php';
const POLL_MS=20000;
const toggle=root.querySelector('[data-cp-notifications-toggle]');
const panel=root.querySelector('[data-cp-notifications-panel]');
const badge=root.querySelector('[data-cp-notifications-badge]');
const list=root.querySelector('[data-cp-notifications-list]');
const markAll=root.querySelector('[data-cp-notifications-mark-all]');
let csrf='',latestId=0,lastObservedId=null,busy=false,timer=null;

const esc=v=>String(v??'').replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;').replaceAll('"','&quot;').replaceAll("'","&#039;");
function when(iso){
  if(!iso)return'';
  const d=new Date(iso); if(Number.isNaN(d.getTime()))return'';
  const s=Math.max(0,Math.floor((Date.now()-d.getTime())/1000));
  if(s<45)return'ahora';
  const m=Math.floor(s/60); if(m<60)return`hace ${m} min`;
  const h=Math.floor(m/60); if(h<24)return`hace ${h} h`;
  const days=Math.floor(h/24); if(days<7)return`hace ${days} d`;
  return new Intl.DateTimeFormat('es-MX',{day:'2-digit',month:'short',hour:'2-digit',minute:'2-digit'}).format(d);
}
function copy(e){
  const c=e.customer_name||'Cliente';
  const o=e.order_number||`Orden #${e.order_id||''}`;
  const i=e.invoice_number?` ${e.invoice_number}`:'';
  switch(e.event_type){
    case'tracking_view':return{title:'Orden revisada',text:`${c} ha revisado la orden ${o}.`};
    case'cfdi_pdf_opened':return{title:'Factura PDF vista',text:`${c} ha consultado la factura${i} de ${o}.`};
    case'cfdi_xml_downloaded':return{title:'XML descargado',text:`${c} ha descargado el XML${i} de ${o}.`};
    case'payment_receipt_uploaded':return{title:'Comprobante recibido',text:`${c} envió un comprobante para ${o}.`};
    default:return{title:e.label||'Actividad del cliente',text:`${c} · ${o}`};
  }
}
function setBadge(unread){
  const n=Math.max(0,Number(unread||0));
  if(!badge)return;
  if(n<=0){badge.hidden=true;badge.textContent='0';toggle?.classList.remove('has-unread');return}
  badge.hidden=false;badge.textContent=n>99?'99+':String(n);toggle?.classList.add('has-unread');
}
function render(data){
  csrf=data.csrf||csrf; latestId=Number(data.latest_event_id||0);
  const unread=Math.max(0,Number(data.unread||0));
  const events=Array.isArray(data.events)?data.events:[];
  setBadge(unread);
  if(!list)return;
  if(!data.ready){list.innerHTML='<div class="cp-notification-empty">Tracking Activity todavía no está disponible.</div>';return}
  if(!events.length){list.innerHTML='<div class="cp-notification-empty">Aún no hay actividad de clientes.</div>';return}
  list.innerHTML=events.map((e,index)=>{
    const c=copy(e), isUnread=index<unread, id=Number(e.id||0), orderId=Number(e.order_id||0);
    const href=orderId>0?`/admin/orden.php?id=${encodeURIComponent(orderId)}`:'/admin/notificaciones.php';
    return `<a class="cp-notification-item${isUnread?' is-unread':''}" href="${href}" data-event-id="${id}">
      <span class="cp-notification-icon">${esc(e.icon||'•')}</span>
      <span class="cp-notification-content"><strong>${esc(c.title)}</strong><span>${esc(c.text)}</span><small>${esc(when(e.created_at_iso))}</small></span>
      ${isUnread?'<i aria-label="No leída"></i>':''}</a>`;
  }).join('');
  list.querySelectorAll('[data-event-id]').forEach(a=>a.addEventListener('click',()=>{const id=Number(a.dataset.eventId||0);if(id>0)markRead(id)}));
}
function toast(e){
  if(!e)return; const c=copy(e);
  const t=document.createElement('div'); t.className='cp-notification-toast';
  t.innerHTML=`<span>${esc(e.icon||'🔔')}</span><div><strong>${esc(c.title)}</strong><p>${esc(c.text)}</p></div>`;
  document.body.appendChild(t); requestAnimationFrame(()=>t.classList.add('is-visible'));
  setTimeout(()=>{t.classList.remove('is-visible');setTimeout(()=>t.remove(),250)},5200);
}
async function fetchFeed(showNew=true){
  if(busy)return; busy=true;
  try{
    const r=await fetch(`${ENDPOINT}?limit=10&_=${Date.now()}`,{credentials:'same-origin',cache:'no-store',headers:{Accept:'application/json'}});
    if(!r.ok)return;
    const data=await r.json(); if(!data?.ok)return;
    const newLatest=Number(data.latest_event_id||0), events=Array.isArray(data.events)?data.events:[];
    if(showNew&&lastObservedId!==null&&newLatest>lastObservedId){
      const newest=events.find(x=>Number(x.id||0)>lastObservedId); if(newest)toast(newest);
    }
    lastObservedId=newLatest; render(data);
  }catch(_){}
  finally{busy=false}
}
async function markRead(eventId){
  if(!csrf||eventId<=0)return;
  const body=new URLSearchParams(); body.set('_csrf',csrf); body.set('action','mark_read'); body.set('last_event_id',String(eventId));
  try{
    const r=await fetch(ENDPOINT,{method:'POST',credentials:'same-origin',cache:'no-store',headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8',Accept:'application/json'},body:body.toString()});
    if(!r.ok)return; const d=await r.json(); if(d?.ok)setBadge(d.unread||0);
  }catch(_){}
}
function open(){if(!panel||!toggle)return;panel.hidden=false;toggle.setAttribute('aria-expanded','true');root.classList.add('is-open');fetchFeed(false)}
function close(){if(!panel||!toggle)return;panel.hidden=true;toggle.setAttribute('aria-expanded','false');root.classList.remove('is-open')}
toggle?.addEventListener('click',e=>{e.preventDefault();e.stopPropagation();panel?.hidden?open():close()});
markAll?.addEventListener('click',async e=>{e.preventDefault();if(latestId>0){await markRead(latestId);await fetchFeed(false)}});
document.addEventListener('click',e=>{if(!root.contains(e.target))close()});
document.addEventListener('keydown',e=>{if(e.key==='Escape')close()});
fetchFeed(false);
timer=setInterval(()=>{if(document.visibilityState==='visible')fetchFeed(true)},POLL_MS);
document.addEventListener('visibilitychange',()=>{if(document.visibilityState==='visible')fetchFeed(true)});
window.addEventListener('beforeunload',()=>{if(timer)clearInterval(timer)},{once:true});
})();