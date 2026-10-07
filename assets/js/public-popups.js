(function(){
  'use strict';

  const doc = document;
  const root = doc.documentElement;
  const reduced = window.matchMedia ? window.matchMedia('(prefers-reduced-motion: reduce)') : {matches:false};
  let popupRoot = null;
  let popup = null;
  let titleEl = null;
  let kickerEl = null;
  let textEl = null;
  let detailEl = null;
  let actionsEl = null;
  let closeEl = null;
  let progressEl = null;
  let lastFocus = null;
  let autoCloseTimer = null;
  let touchStartY = null;

  function esc(value){
    return String(value == null ? '' : value)
      .replace(/&/g,'&amp;')
      .replace(/</g,'&lt;')
      .replace(/>/g,'&gt;')
      .replace(/"/g,'&quot;')
      .replace(/'/g,'&#039;');
  }

  function ensureRoot(){
    if (popupRoot) return;

    popupRoot = doc.createElement('div');
    popupRoot.className = 'cp-popup-root';
    popupRoot.setAttribute('aria-hidden','true');
    popupRoot.innerHTML = '' +
      '<div class="cp-popup-backdrop" data-cp-popup-close></div>' +
      '<section class="cp-popup" role="dialog" aria-modal="true" aria-labelledby="cp-popup-title" aria-describedby="cp-popup-text" tabindex="-1">' +
        '<button class="cp-popup-close" type="button" aria-label="Cerrar" data-cp-popup-close>×</button>' +
        '<div class="cp-popup-content">' +
          '<div class="cp-popup-kicker" id="cp-popup-kicker">COLIBRÍ PRINT</div>' +
          '<h2 class="cp-popup-title" id="cp-popup-title">Información</h2>' +
          '<p class="cp-popup-text" id="cp-popup-text"></p>' +
          '<div class="cp-popup-detail" id="cp-popup-detail"></div>' +
          '<div class="cp-popup-actions" id="cp-popup-actions"></div>' +
          '<div class="cp-popup-progress" id="cp-popup-progress" hidden><span></span></div>' +
        '</div>' +
      '</section>';

    doc.body.appendChild(popupRoot);
    popup = popupRoot.querySelector('.cp-popup');
    titleEl = doc.getElementById('cp-popup-title');
    kickerEl = doc.getElementById('cp-popup-kicker');
    textEl = doc.getElementById('cp-popup-text');
    detailEl = doc.getElementById('cp-popup-detail');
    actionsEl = doc.getElementById('cp-popup-actions');
    closeEl = popupRoot.querySelector('.cp-popup-close');
    progressEl = doc.getElementById('cp-popup-progress');

    popupRoot.addEventListener('click', function(event){
      if (event.target.closest('[data-cp-popup-close]')) close();
    });

    popup.addEventListener('touchstart', function(event){
      if (window.innerWidth > 820 || !event.touches.length) return;
      touchStartY = event.touches[0].clientY;
    }, {passive:true});

    popup.addEventListener('touchend', function(event){
      if (window.innerWidth > 820 || touchStartY == null || !event.changedTouches.length) return;
      const delta = event.changedTouches[0].clientY - touchStartY;
      touchStartY = null;
      if (delta > 90) close();
    }, {passive:true});
  }

  function clearAutoClose(){
    if (autoCloseTimer){
      window.clearTimeout(autoCloseTimer);
      autoCloseTimer = null;
    }
  }

  function normalizeAction(action, index){
    const label = esc(action.label || action.text || 'Cerrar');
    const href = action.href ? esc(action.href) : '';
    const type = action.type === 'mango' ? 'cp-popup-action-mango' : (action.type === 'ghost' ? 'cp-popup-action-ghost' : 'cp-popup-action-primary');

    if (href){
      const target = action.target ? ' target="' + esc(action.target) + '" rel="noopener"' : '';
      return '<a class="cp-popup-action ' + type + '" href="' + href + '"' + target + ' data-cp-popup-action-index="' + index + '">' + label + '</a>';
    }
    return '<button class="cp-popup-action ' + type + '" type="button" data-cp-popup-close data-cp-popup-action-index="' + index + '">' + label + '</button>';
  }

  function renderDetails(details){
    if (!Array.isArray(details) || !details.length){
      detailEl.innerHTML = '';
      return;
    }
    detailEl.innerHTML = details.map(function(item){
      return '<div class="cp-popup-detail-row"><div><strong>' + esc(item.label || '') + '</strong><span>' + esc(item.value || '') + '</span></div></div>';
    }).join('');
  }

  function parseTarget(target){
    const actions = [];
    const actionLabel = target.dataset.cpPopupAction || '';
    const actionHref = target.dataset.cpPopupHref || '';
    if (actionLabel) actions.push({label:actionLabel, href:actionHref, type:target.dataset.cpPopupActionType || 'primary', target:target.dataset.cpPopupTarget || ''});
    return {
      kicker:target.dataset.cpPopupKicker || 'COLIBRÍ PRINT',
      title:target.dataset.cpPopupTitle || target.getAttribute('aria-label') || 'Información',
      text:target.dataset.cpPopupText || '',
      theme:target.dataset.cpPopupTheme || '',
      actions:actions,
      duration:Number(target.dataset.cpPopupDuration || 0),
      autoClose:target.dataset.cpPopupAutoclose === 'true'
    };
  }

  function open(config){
    ensureRoot();
    clearAutoClose();

    lastFocus = doc.activeElement;
    const data = config || {};

    popup.className = 'cp-popup' + (data.theme ? ' is-' + esc(data.theme) : '');
    kickerEl.textContent = data.kicker || 'COLIBRÍ PRINT';
    titleEl.textContent = data.title || 'Información';
    textEl.textContent = data.text || '';
    renderDetails(data.details || []);
    actionsEl.innerHTML = (Array.isArray(data.actions) ? data.actions : []).map(normalizeAction).join('');

    const duration = Math.max(1, Number(data.duration || 6));
    if (data.autoClose){
      popupRoot.classList.add('is-auto-close');
      popupRoot.style.setProperty('--cp-popup-duration', duration + 's');
      progressEl.hidden = false;
      progressEl.querySelector('span').style.animationDuration = duration + 's';
      autoCloseTimer = window.setTimeout(close, duration * 1000);
    } else {
      popupRoot.classList.remove('is-auto-close');
      progressEl.hidden = true;
      progressEl.querySelector('span').style.animationDuration = '';
    }

    popupRoot.classList.add('is-open');
    popupRoot.setAttribute('aria-hidden','false');
    doc.body.classList.add('cp-popup-lock');

    window.requestAnimationFrame(function(){
      closeEl.focus();
    });
  }

  function close(){
    if (!popupRoot || !popupRoot.classList.contains('is-open')) return;
    clearAutoClose();
    popupRoot.classList.remove('is-open','is-auto-close');
    popupRoot.setAttribute('aria-hidden','true');
    doc.body.classList.remove('cp-popup-lock');

    if (lastFocus && typeof lastFocus.focus === 'function'){
      window.setTimeout(function(){ lastFocus.focus(); }, reduced.matches ? 0 : 180);
    }
  }

  function focusTrap(event){
    if (!popupRoot || !popupRoot.classList.contains('is-open') || event.key !== 'Tab') return;
    const focusables = popup.querySelectorAll('a[href],button:not([disabled]),input:not([disabled]),select:not([disabled]),textarea:not([disabled]),[tabindex]:not([tabindex="-1"])');
    if (!focusables.length) return;

    const first = focusables[0];
    const last = focusables[focusables.length - 1];
    if (event.shiftKey && doc.activeElement === first){
      event.preventDefault(); last.focus();
    } else if (!event.shiftKey && doc.activeElement === last){
      event.preventDefault(); first.focus();
    }
  }

  function setupTriggers(){
    doc.addEventListener('click', function(event){
      const target = event.target.closest && event.target.closest('[data-cp-popup]');
      if (!target) return;

      const href = target.getAttribute('href') || '';
      if (href && href.charAt(0) !== '#') return;

      event.preventDefault();
      open(parseTarget(target));
    });

    doc.addEventListener('keydown', function(event){
      if (event.key === 'Escape') close();
      focusTrap(event);
    });
  }

  function setupWelcome(){
    const enabled = doc.body.dataset.cpWelcomePopup === 'true';
    if (!enabled) return;
    if (reduced.matches) return;

    try{
      if (sessionStorage.getItem('cp_welcome_seen') === '1') return;
    }catch(_){ }

    window.setTimeout(function(){
      open({
        kicker:'BIENVENIDO',
        title:'¿Qué quieres crear hoy?',
        text:'Explora productos, descubre nuestros servicios o cuéntanos una idea especial. Colibrí Print te ayuda a encontrar el camino más rápido.',
        theme:'purple',
        details:[
          {label:'Catálogo',value:'Productos y personalización.'},
          {label:'Servicios',value:'Diseño, impresión, grabado y fabricación.'},
          {label:'Cotización',value:'Para proyectos a medida.'}
        ],
        actions:[
          {label:'Ver catálogo',href:doc.body.dataset.cpCatalogUrl || '#',type:'mango'},
          {label:'Necesito ayuda',type:'ghost'}
        ]
      });
      try{ sessionStorage.setItem('cp_welcome_seen','1'); }catch(_){ }
    }, 1200);
  }

  function setupFab(){
    const fab = doc.querySelector('[data-cp-popup-help]');
    if (!fab) return;
    fab.addEventListener('click', function(){
      open({
        kicker:'AYUDA RÁPIDA',
        title:'¿Qué estás buscando?',
        text:'Elige una ruta y te llevamos al siguiente paso.',
        theme:'purple',
        actions:[
          {label:'Ver catálogo',href:doc.body.dataset.cpCatalogUrl || '#',type:'mango'},
          {label:'Cotizar mi proyecto',href:doc.body.dataset.cpQuoteUrl || '#',type:'primary'},
          {label:'Cerrar',type:'ghost'}
        ]
      });
    });
  }

  window.ColibriPopup = {open:open, close:close};

  function init(){
    setupTriggers();
    setupFab();
    setupWelcome();
  }

  if (doc.readyState === 'loading') doc.addEventListener('DOMContentLoaded', init, {once:true});
  else init();
})();
