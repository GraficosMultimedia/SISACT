(() => {
  const menuBtn=document.getElementById('menuBtn'), nav=document.getElementById('mainNav');
  if(menuBtn) menuBtn.addEventListener('click',()=>nav.classList.toggle('open'));

  const modal=document.getElementById('promoModal');
  const close=()=>{modal.classList.remove('open');modal.setAttribute('aria-hidden','true')};
  document.getElementById('closeModal').addEventListener('click',close);
  document.getElementById('cancelModal').addEventListener('click',close);
  modal.addEventListener('click',e=>{if(e.target===modal)close()});
  document.addEventListener('keydown',e=>{if(e.key==='Escape')close()});

  document.querySelectorAll('[data-promo]').forEach(card=>{
    card.addEventListener('click',()=>{
      document.getElementById('promoTitle').textContent=card.dataset.title;
      document.getElementById('modalPrice').textContent=card.dataset.price;
      document.getElementById('modalEnd').textContent=card.dataset.end;
      document.getElementById('modalDescription').textContent=card.dataset.description;
      const img=document.getElementById('modalImage');
      img.src=card.dataset.image; img.alt=card.dataset.title;
      modal.classList.add('open');modal.setAttribute('aria-hidden','false');
      document.getElementById('buyerName').focus();
    });
  });

  document.getElementById('promoForm').addEventListener('submit',e=>{
    e.preventDefault();
    const title=document.getElementById('promoTitle').textContent;
    const price=document.getElementById('modalPrice').textContent;
    const end=document.getElementById('modalEnd').textContent;
    const name=document.getElementById('buyerName').value.trim();
    const phone=document.getElementById('buyerPhone').value.trim();
    const qty=document.getElementById('buyerQty').value;
    const payment=document.querySelector('input[name="payment"]:checked')?.value || '';
    const note=document.getElementById('buyerNote').value.trim();
    const target="<?= h($phone) ?>".replace(/\D+/g,'');
    const waTarget=target && !target.startsWith('52') ? '52'+target : target;
    if(!waTarget){alert('El teléfono de atención de WhatsApp no está configurado.');return;}
    const msg=[
      'Hola Colibrí Print, quiero realizar un pedido de promoción.',
      '',
      'Promoción: '+title,
      'Precio unitario: '+price,
      'Cantidad: '+qty,
      'Vigencia mostrada: '+end,
      'Nombre: '+name,
      'Mi WhatsApp: '+phone,
      'Pago: '+payment,
      note ? 'Notas: '+note : ''
    ].filter(Boolean).join('\n');
    window.open('https://wa.me/'+waTarget+'?text='+encodeURIComponent(msg),'_blank','noopener');
    close();
  });
})();
