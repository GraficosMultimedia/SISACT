(() => {
  const form=document.getElementById('quoteForm');
  const container=document.getElementById('quoteItems');
  const addTop=document.getElementById('addItem');
  const addBottom=document.getElementById('addItemBottom');
  const discountEl=document.getElementById('quoteDiscount');
  const taxEl=document.getElementById('quoteTaxPct');
  const money=n=>'$'+Number(n||0).toLocaleString('en-US',{minimumFractionDigits:2,maximumFractionDigits:2});

  function update(){
    let subtotal=0;
    container?.querySelectorAll('[data-row]').forEach(row=>{
      const qty=Number(row.querySelector('.js-qty')?.value||0);
      const price=Number(row.querySelector('.js-price')?.value||0);
      const amount=Math.max(0,qty)*Math.max(0,price);
      subtotal+=amount;
      const out=row.querySelector('.js-amount');if(out)out.textContent=money(amount);
    });
    const discountPct=Math.max(0,Math.min(100,Number(discountEl?.value||0)));
    const discount=Math.round((subtotal*discountPct/100)*100)/100;
    const taxPct=Math.max(0,Math.min(100,Number(taxEl?.value||0)));
    const net=Math.max(0,subtotal-discount);
    const tax=Math.round((net*taxPct/100)*100)/100;
    const total=Math.round((net+tax)*100)/100;
    const set=(id,val)=>{const el=document.getElementById(id);if(el)el.textContent=money(val)};
    set('liveSubtotal',subtotal);
    const discountOut=document.getElementById('liveDiscount');if(discountOut)discountOut.textContent=discountPct.toFixed(2)+'%';
    set('liveTax',tax);set('liveTotal',total);
    const hint=document.getElementById('liveTaxHint');if(hint)hint.textContent=taxPct.toFixed(2)+'%';
  }

  function addRow(){
    if(!container)return;
    const row=document.createElement('div');row.className='quote-item-row';row.dataset.row='1';
    row.innerHTML=`<div class="field"><label class="mobile-label">Descripción</label><input name="description[]" required><input type="hidden" name="calculator_source[]" value=""></div><div class="field"><label class="mobile-label">Cantidad</label><input class="js-qty" type="number" name="quantity[]" min="0.001" step="0.001" value="1" required></div><div class="field"><label class="mobile-label">Precio unitario</label><input class="js-price" type="number" name="unit_price[]" min="0" step="0.01" value="0" required></div><div class="item-amount"><span class="mobile-label">Importe</span><strong class="js-amount">$0.00</strong></div><button type="button" class="item-remove" data-remove aria-label="Eliminar concepto">×</button>`;
    container.appendChild(row);bindRow(row);row.querySelector('input[name="description[]"]')?.focus();
  }
  function bindRow(row){
    row.querySelectorAll('input').forEach(i=>i.addEventListener('input',update));
    row.querySelector('[data-remove]')?.addEventListener('click',()=>{const rows=container.querySelectorAll('[data-row]');if(rows.length<=1)return;row.remove();update();});
  }
  container?.querySelectorAll('[data-row]').forEach(bindRow);
  addTop?.addEventListener('click',addRow);addBottom?.addEventListener('click',addRow);discountEl?.addEventListener('input',update);taxEl?.addEventListener('input',update);

  const template=document.getElementById('conditionTemplate');
  document.getElementById('applyCondition')?.addEventListener('click',()=>{
    const o=template?.selectedOptions?.[0];if(!o||!o.value)return;
    const fill=(id,val)=>{const el=document.getElementById(id);if(el)el.value=val||''};
    fill('paymentTerms',o.dataset.payment);fill('deliveryTime',o.dataset.delivery);fill('deliveryPlace',o.dataset.place);
    const terms=form?.querySelector('textarea[name="terms"]');if(terms)terms.value=o.dataset.terms||'';
  });

  const search=document.getElementById('customerSearch');
  const results=document.getElementById('customerResults');
  const hidden=document.getElementById('customerId');
  const selected=document.getElementById('selectedCustomer');
  let timer;
  let searchRequestId=0;
  let searchController=null;
  async function searchCustomers(){
    const q=(search?.value||'').trim();
    const requestId=++searchRequestId;
    if(searchController) searchController.abort();
    if(q.length<2){if(results){results.innerHTML='';results.hidden=true;}return;}

    searchController=new AbortController();
    const controller=searchController;
    if(results){results.innerHTML='<div class="customer-search-empty">Buscando...</div>';results.hidden=false;}

    try{
      const url='/admin/cotizacion_nueva.php?customer_search=1&q='+encodeURIComponent(q)+'&_ts='+Date.now();
      const r=await fetch(url,{
        headers:{'Accept':'application/json','X-Requested-With':'XMLHttpRequest'},
        cache:'no-store',
        signal:controller.signal
      });
      if(!r.ok)throw new Error('HTTP '+r.status);
      const data=await r.json();

      // Evita que una respuesta vieja (por ejemplo, la búsqueda de "a")
      // reemplace la búsqueda más reciente (por ejemplo, "Karina").
      const current=(search?.value||'').trim();
      if(requestId!==searchRequestId || current!==q)return;
      if(!results)return;

      results.innerHTML='';
      data.forEach(c=>{
        const b=document.createElement('button');
        b.type='button';b.className='customer-result';
        b.innerHTML='<strong>'+escapeHtml(c.name||'')+'</strong><span>'+escapeHtml([c.phone,c.email].filter(Boolean).join(' · '))+(c.source_type==='akaunting'?' · Akaunting':' · Local')+'</span>';
        if(c.selectable===false || !Number(c.id||0)){
          b.disabled=true;b.title='Sin réplica local disponible';
        } else {
          b.addEventListener('click',()=>selectCustomer(c));
        }
        results.appendChild(b);
      });
      results.hidden=data.length===0;
      if(data.length===0){results.innerHTML='<div class="customer-search-empty">No se encontró el cliente.</div>';results.hidden=false;}
    }catch(e){
      if(e?.name==='AbortError')return;
      if(requestId!==searchRequestId)return;
      if(results){results.innerHTML='<div class="customer-search-error">No se pudo consultar la base de clientes.</div>';results.hidden=false;}
    }
  }
  function selectCustomer(c){
    if(hidden)hidden.value=c.id||'';
    if(search)search.value=c.name||'';
    if(results)results.hidden=true;
    if(selected){
      selected.hidden=false;
      selected.innerHTML='<strong>'+escapeHtml(c.name||'')+'</strong><span>'+escapeHtml([c.email,c.phone].filter(Boolean).join(' · '))+'</span><button type="button" class="customer-clear" id="customerClear">Cambiar</button>';
      selected.querySelector('#customerClear')?.addEventListener('click',clearCustomer);
    }
  }
  function clearCustomer(){if(hidden)hidden.value='';if(search){search.value='';search.focus()}if(selected)selected.hidden=true}
  function escapeHtml(s){return String(s).replace(/[&<>'"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[c]))}
  search?.addEventListener('input',()=>{clearTimeout(timer);timer=setTimeout(searchCustomers,180)});
  search?.addEventListener('change',searchCustomers);
  search?.addEventListener('paste',()=>setTimeout(searchCustomers,0));
  document.getElementById('customerClear')?.addEventListener('click',clearCustomer);
  update();
})();
