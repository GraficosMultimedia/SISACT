/* ============================================================
   SISACT · Seguimiento Visual Motion V2.2
   Iconografía SVG + motion orchestration + portrait guard.
   ============================================================ */
(function () {
  'use strict';

  const SVG = {
    pending:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M7 4h10v4H7z"/><path d="M6 8h12v12H6z"/><path d="M9 12h6M9 16h4"/></svg>',
    design:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M12 3a9 9 0 1 0 0 18h1.3a2.2 2.2 0 0 0 0-4.4h-.8a1.6 1.6 0 0 1 0-3.2H15A6 6 0 0 0 21 7.4C21 4.9 17.2 3 12 3Z"/><circle cx="7.5" cy="9" r="1"/><circle cx="10" cy="6.5" r="1"/><circle cx="14" cy="6" r="1"/><circle cx="17" cy="8" r="1"/></svg>',
    approval:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M6 3h9l3 3v15H6z"/><path d="M14 3v4h4"/><path d="m9 14 2 2 4-5"/></svg>',
    printing:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M7 8V3h10v5"/><path d="M6 18H4V9h16v9h-2"/><path d="M7 14h10v7H7z"/><path d="M17 11h.01"/></svg>',
    production:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M14 5a5 5 0 0 0-6.5 6.5L3 16l5 5 4.5-4.5A5 5 0 0 0 19 10l-3 3-3-3z"/></svg>',
    quality:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><circle cx="11" cy="11" r="6"/><path d="m16 16 4 4"/><path d="m8.5 11 1.6 1.6 3.4-3.7"/></svg>',
    ready:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M4 8 12 4l8 4-8 4z"/><path d="M4 8v8l8 4 8-4V8"/><path d="M12 12v8"/></svg>',
    delivered:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M3 6h11v10H3z"/><path d="M14 9h4l3 3v4h-7z"/><circle cx="7" cy="18" r="2"/><circle cx="18" cy="18" r="2"/></svg>',
    money:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M4 6h16v12H4z"/><circle cx="12" cy="12" r="3"/><path d="M7 9H6v1M17 15h1v-1"/></svg>',
    clock:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>',
    chart:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M4 19V9M10 19V5M16 19v-7M22 19H2"/></svg>',
    target:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><circle cx="12" cy="12" r="8"/><circle cx="12" cy="12" r="4"/><path d="M12 2v3M22 12h-3"/></svg>',
    laser:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M12 2v5M5 5l3 3M19 5l-3 3M3 12h5M21 12h-5"/><path d="m8 21 4-9 4 9z"/></svg>',
    print:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M5 4h14v5H5z"/><path d="M4 9h16v8H4z"/><path d="M7 14h10v6H7z"/></svg>',
    quote:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><path d="M4 5h16v12H9l-5 4z"/><path d="M8 9h8M8 13h5"/></svg>',
    phone:'<svg viewBox="0 0 24 24" class="cp22-icon-svg" aria-hidden="true"><rect x="7" y="2" width="10" height="20" rx="2"/><path d="M10 5h4M11 19h2"/></svg>'
  };

  function norm(value){
    return String(value || '').normalize('NFD').replace(/[\u0300-\u036f]/g,'').toLowerCase().trim();
  }

  function stageKey(label){
    const t = norm(label);
    if (t.includes('pendiente')) return 'pending';
    if (t.includes('diseno')) return 'design';
    if (t.includes('aprob')) return 'approval';
    if (t.includes('impres')) return 'printing';
    if (t.includes('produ')) return 'production';
    if (t.includes('calidad')) return 'quality';
    if (t.includes('listo')) return 'ready';
    if (t.includes('entreg')) return 'delivered';
    return 'pending';
  }

  function replaceStageIcons(){
    document.querySelectorAll('.progress-line.client-progress .stage').forEach(function(stage){
      const label = stage.querySelector('span');
      const dot = stage.querySelector('.stage-dot');
      if (!label || !dot || stage.classList.contains('done')) return;
      dot.innerHTML = SVG[stageKey(label.textContent)] || SVG.pending;
      dot.setAttribute('aria-hidden','true');
    });

    const current = document.querySelector('.tracking-premium-current-main strong');
    const currentIcon = document.querySelector('.tracking-premium-current-icon');
    if (current && currentIcon) currentIcon.innerHTML = SVG[stageKey(current.textContent)];

    document.querySelectorAll('.tracking-premium-card').forEach(function(card){
      const title = card.querySelector('h4,strong');
      const icon = card.querySelector('.tracking-premium-card-icon');
      if (title && icon) icon.innerHTML = SVG[stageKey(title.textContent)];
    });
  }

  function improveMetrics(){
    const icons = ['money','clock','chart','target'];
    document.querySelectorAll('.tracking-premium-metric').forEach(function(card,idx){
      if (card.querySelector('.cp22-metric-icon')) return;
      const icon = document.createElement('span');
      icon.className='cp22-metric-icon';
      icon.setAttribute('aria-hidden','true');
      icon.innerHTML=SVG[icons[idx] || 'chart'];
      card.insertBefore(icon, card.firstChild);
    });
  }

  function improveOfferIcons(){
    document.querySelectorAll('.tracking-offer-v2').forEach(function(card){
      const title = norm((card.querySelector('h3') || {}).textContent);
      const icon = card.querySelector('.tracking-offer-v2-icon');
      if (!icon) return;
      let key='quote';
      if (title.includes('gran formato') || title.includes('impres')) key='print';
      else if (title.includes('grabado') || title.includes('laser')) key='laser';
      else if (title.includes('cnc') || title.includes('fabric')) key='production';
      else if (title.includes('whatsapp') || title.includes('cotiz')) key='quote';
      icon.innerHTML=SVG[key];
    });
  }

  function sequenceStory(){
    document.querySelectorAll('.tracking-premium-card').forEach(function(card,idx){
      card.style.setProperty('--cp22-index',String(idx));
    });
  }

  function createPortraitGuard(){
    if (document.querySelector('.cp22-portrait-guard')) return;
    const guard=document.createElement('aside');
    guard.className='cp22-portrait-guard';
    guard.setAttribute('role','status');
    guard.setAttribute('aria-live','polite');
    guard.innerHTML =
      '<div class="cp22-gravity-field" aria-hidden="true">' +
        [
          ['printing','8vw','-.2s','2.4s','150deg'],['design','22vw','.35s','2.9s','-170deg'],['approval','36vw','.8s','2.6s','210deg'],
          ['production','54vw','.1s','3.1s','-200deg'],['quality','68vw','.6s','2.55s','180deg'],['ready','82vw','1.0s','2.8s','-150deg']
        ].map(function(x){return '<span class="cp22-gravity-icon" style="--x:'+x[1]+';--delay:'+x[2]+';--dur:'+x[3]+';--rot:'+x[4]+'">'+SVG[x[0]]+'</span>';}).join('') +
      '</div>'+
      '<div class="cp22-portrait-guard-inner">'+
        '<div class="cp22-phone-turn" aria-hidden="true">'+SVG.phone+'</div>'+
        '<h2>Gira tu celular</h2>'+
        '<p>Para disfrutar el seguimiento de tu pedido, mantén tu pantalla en <strong>posición vertical</strong>. Los iconos volverán a su lugar cuando gires el teléfono.</p>'+
      '</div>';
    document.body.appendChild(guard);
  }

  function updateOrientation(){
    const coarse = window.matchMedia('(pointer: coarse)').matches;
    const landscape = window.matchMedia('(orientation: landscape)').matches;
    const shortViewport = window.innerHeight <= 600;
    document.body.classList.toggle('cp22-landscape-lock', coarse && landscape && shortViewport);
  }

  function init(){
    document.body.classList.add('cp22-motion-ready');
    replaceStageIcons();
    improveMetrics();
    improveOfferIcons();
    sequenceStory();
    createPortraitGuard();
    updateOrientation();

    let timer;
    window.addEventListener('resize',function(){
      clearTimeout(timer);
      timer=setTimeout(updateOrientation,80);
    },{passive:true});
    window.addEventListener('orientationchange',function(){setTimeout(updateOrientation,120);},{passive:true});
  }

  if(document.readyState==='loading') document.addEventListener('DOMContentLoaded',init,{once:true});
  else init();
})();
