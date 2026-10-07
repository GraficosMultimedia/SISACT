(function(){
  'use strict';
  const modal=document.getElementById('promoModal');
  if(!modal) return;
  const image=document.getElementById('promoModalImage');
  const label=document.getElementById('promoModalLabel');
  const discount=document.getElementById('promoModalDiscount');
  const title=document.getElementById('promoModalTitle');
  const description=document.getElementById('promoModalDescription');
  const price=document.getElementById('promoModalPrice');
  const normal=document.getElementById('promoModalNormal');
  const deadline=document.getElementById('promoModalDeadline');
  const form=document.getElementById('promoBuyForm');
  const panel=modal.querySelector('.promo-modal-panel');
  const waButton=document.getElementById('promoWhatsappBtn');
  let current=null;
  const phone=(document.body.dataset.companyPhone||'').replace(/\D+/g,'');
  const money=v=>v==null||v===''?'':new Intl.NumberFormat('es-MX',{style:'currency',currency:'MXN'}).format(Number(v));
  const daysLeft=end=>{if(!end)return '';const d=Math.max(0,Math.floor((new Date(end+'T23:59:59')-new Date())/86400000));return d===0?'Último día':'Válida hasta '+new Date(end+'T00:00:00').toLocaleDateString('es-MX')+' · quedan '+d+' días';};
  function openPromo(data){
    current=data;
    image.src=data.image||''; image.alt=data.title||'Promoción'; image.style.display=data.image?'block':'none';
    label.textContent=data.label||'OFERTA';
    discount.textContent=data.discount?'-'+data.discount+'%':'';
    title.textContent=data.title||'Promoción';
    description.textContent=data.description||'Personaliza esta promoción con Colibrí Print.';
    price.textContent=data.price!=null?money(data.price):'Consultar';
    normal.textContent=data.normal?money(data.normal):'';
    deadline.textContent=data.expired?'Esta promoción ha finalizado. Puedes verla como referencia, pero ya no acepta pedidos.':daysLeft(data.end_date);
    form.reset();
    panel.classList.toggle('is-expired', !!data.expired);
    if(data.expired){
      label.textContent='FINALIZADA';
      discount.textContent=data.discount?'-'+data.discount+'%':'';
      const callout=document.getElementById('promoExpiredCallout');
      if(callout) callout.textContent='Esta promoción ya no está disponible para compra. Mantente al pendiente de nuestras próximas promociones.';
    }
    modal.classList.add('is-open'); modal.setAttribute('aria-hidden','false'); document.body.classList.add('promo-modal-open');
  }
  function closePromo(){modal.classList.remove('is-open');modal.setAttribute('aria-hidden','true');document.body.classList.remove('promo-modal-open');current=null;}
  document.querySelectorAll('.promo-card-v2').forEach(card=>card.addEventListener('click',()=>{try{openPromo(JSON.parse(card.dataset.promo));}catch(e){}}));
  modal.querySelectorAll('[data-promo-close]').forEach(el=>el.addEventListener('click',closePromo));
  document.addEventListener('keydown',e=>{if(e.key==='Escape'&&modal.classList.contains('is-open'))closePromo();});
  function buildMessage(){
    const fd=new FormData(form), qty=Math.max(1,Number(fd.get('quantity')||1));
    return [
      'Hola Colibrí Print, quiero realizar un pedido de promoción.',
      'Promoción: '+(current?.title||''),
      current?.product_name?'Producto: '+current.product_name:'',
      current?.price!=null?'Precio unitario: '+money(current.price):'',
      'Cantidad: '+qty,
      'Total estimado: '+(current?.price!=null?money(Number(current.price)*qty):'Por confirmar'),
      'Personalización: '+(fd.get('customization')||'No indicada'),
      'Notas: '+(fd.get('notes')||'Sin notas'),
      'Método de pago: '+(fd.get('payment')||'Por confirmar'),
      'Quedo atento a la confirmación de disponibilidad y entrega.'
    ].filter(Boolean).join('\n');
  }
  function sendWhatsApp(){
    if(!current||!phone){return;}
    window.open('https://wa.me/'+phone+'?text='+encodeURIComponent(buildMessage()),'_blank','noopener');
  }
  if(waButton) waButton.addEventListener('click',sendWhatsApp);
  form.addEventListener('submit',function(e){e.preventDefault();sendWhatsApp();});
})();
