(function(){
  'use strict';

  const doc = document;
  const root = doc.documentElement;
  const mq = function(query){
    return window.matchMedia ? window.matchMedia(query) : {matches:false};
  };
  const reducedMotion = mq('(prefers-reduced-motion: reduce)');
  const coarsePointer = mq('(hover: none), (pointer: coarse)');
  let scrollOffset = 84;

  root.classList.add('cp-motion-ready');

  function refreshScrollOffset(){
    const header = doc.querySelector('.site-header');
    const h = header ? Math.max(0, Math.ceil(header.getBoundingClientRect().height)) : 0;
    scrollOffset = Math.max(56, Math.min(130, h || 84));
    root.style.setProperty('--cp-scroll-offset', scrollOffset + 'px');
  }

  function closeMenu(btn, nav){
    if (!btn || !nav) return;
    btn.setAttribute('aria-expanded', 'false');
    nav.classList.remove('is-open');
    root.classList.remove('cp-menu-open');
  }

  function setupMenu(){
    const btn = doc.querySelector('.menu-toggle');
    const nav = doc.getElementById('main-menu');
    if (!btn || !nav) return;

    btn.addEventListener('click', function(){
      const open = btn.getAttribute('aria-expanded') === 'true';
      btn.setAttribute('aria-expanded', String(!open));
      nav.classList.toggle('is-open', !open);
      root.classList.toggle('cp-menu-open', !open);
    });

    nav.querySelectorAll('a').forEach(function(link){
      link.addEventListener('click', function(){
        closeMenu(btn, nav);
      });
    });

    doc.addEventListener('keydown', function(event){
      if (event.key === 'Escape') closeMenu(btn, nav);
    });

    window.addEventListener('resize', function(){
      if (window.innerWidth > 820) closeMenu(btn, nav);
      refreshScrollOffset();
    }, {passive:true});
  }

  function setupViewport(){
    const set = function(){
      root.dataset.cpViewport = window.innerWidth <= 820 ? 'mobile' : 'desktop';
      root.dataset.cpTouch = coarsePointer.matches ? 'yes' : 'no';
    };
    set();
    window.addEventListener('resize', set, {passive:true});
  }

  function setupSmoothAnchors(){
    doc.addEventListener('click', function(event){
      const link = event.target.closest && event.target.closest('a[href^="#"]');
      if (!link) return;

      const href = link.getAttribute('href') || '';
      if (href === '#' || href.length < 2) return;

      const target = doc.querySelector(href);
      if (!target) return;

      event.preventDefault();

      if (reducedMotion.matches){
        target.scrollIntoView();
        return;
      }

      const y = target.getBoundingClientRect().top + window.scrollY - scrollOffset + 2;
      window.scrollTo({top:Math.max(0,y), behavior:'smooth'});

      history.pushState(null, '', href);
    });
  }

  function setCascadeIndexes(){
    doc.querySelectorAll('[data-cp-cascade]').forEach(function(group){
      Array.from(group.children).forEach(function(child, index){
        child.style.setProperty('--cp-cascade-index', String(index));
      });
    });
  }

  function setupReveal(){
    const items = doc.querySelectorAll('.cp-scroll-reveal, .cp-section-reveal');
    if (!items.length) return;

    if (reducedMotion.matches || !('IntersectionObserver' in window)){
      items.forEach(function(el){ el.classList.add('is-visible'); });
      return;
    }

    const observer = new IntersectionObserver(function(entries, obs){
      entries.forEach(function(entry){
        if (!entry.isIntersecting) return;
        entry.target.classList.add('is-visible');

        const group = entry.target.closest('[data-cp-cascade]');
        if (group){
          Array.from(group.children).forEach(function(child, index){
            if (child === entry.target || child.contains(entry.target)){
              child.style.setProperty('--cp-reveal-delay', String(Math.min(index, 7) * 75) + 'ms');
            }
          });
        }

        obs.unobserve(entry.target);
      });
    },{
      root:null,
      rootMargin:'0px 0px -10% 0px',
      threshold:.08
    });

    items.forEach(function(el){ observer.observe(el); });
  }

  function setupScrollParallax(){
    if (reducedMotion.matches) return;

    const targets = doc.querySelectorAll('[data-cp-scroll-parallax]');
    if (!targets.length) return;

    let raf = 0;

    function render(){
      raf = 0;
      const viewport = window.innerHeight || 1;

      targets.forEach(function(el){
        const rect = el.getBoundingClientRect();
        if (rect.bottom < -80 || rect.top > viewport + 80) return;

        const strength = Number(el.dataset.cpScrollParallax || .05);
        const center = (rect.top + rect.height / 2) / viewport;
        const offset = (center - .5) * viewport * strength;

        el.style.setProperty('--cp-scroll-parallax', offset.toFixed(2) + 'px');
        el.style.transform = 'translate3d(0,' + offset.toFixed(2) + 'px,0)';
      });
    }

    function requestRender(){
      if (!raf) raf = requestAnimationFrame(render);
    }

    window.addEventListener('scroll', requestRender, {passive:true});
    window.addEventListener('resize', requestRender, {passive:true});
    requestRender();
  }

  function setupTouchFeedback(){
    const interactive = 'a,button,.cp-touch-feedback,.category-card,.shop-card,.service-card,.promo-card';
    doc.querySelectorAll(interactive).forEach(function(el){
      if (el.dataset.cpTouchBound === '1') return;
      el.dataset.cpTouchBound = '1';

      const press = function(){
        if (coarsePointer.matches && !reducedMotion.matches) {
          el.classList.add('is-pressed');
        }
      };
      const release = function(){
        el.classList.remove('is-pressed');
      };

      el.addEventListener('touchstart', press, {passive:true});
      el.addEventListener('touchend', release, {passive:true});
      el.addEventListener('touchcancel', release, {passive:true});
      el.addEventListener('blur', release, {passive:true});
    });
  }

  function setupTilt(){
    if (reducedMotion.matches || coarsePointer.matches) return;

    doc.querySelectorAll('[data-cp-tilt]').forEach(function(el){
      el.addEventListener('pointermove', function(event){
        const r = el.getBoundingClientRect();
        const px = (event.clientX - r.left) / r.width;
        const py = (event.clientY - r.top) / r.height;
        const x = (0.5 - py) * 5;
        const y = (px - 0.5) * 5;
        el.style.setProperty('--cp-tilt-x', x.toFixed(2) + 'deg');
        el.style.setProperty('--cp-tilt-y', y.toFixed(2) + 'deg');
      }, {passive:true});

      el.addEventListener('pointerleave', function(){
        el.style.setProperty('--cp-tilt-x', '0deg');
        el.style.setProperty('--cp-tilt-y', '0deg');
      }, {passive:true});
    });
  }

  function setupPointerParallax(){
    if (reducedMotion.matches || coarsePointer.matches) return;

    doc.querySelectorAll('[data-cp-parallax-scene]').forEach(function(scene){
      const targets = scene.querySelectorAll('[data-cp-parallax]');
      if (!targets.length) return;

      let raf = 0;
      let px = 0;
      let py = 0;

      const render = function(){
        raf = 0;
        targets.forEach(function(el){
          const strength = Number(el.dataset.cpParallax || 6);
          const x = px * strength;
          const y = py * strength;
          el.style.transform = 'translate3d(' + x.toFixed(2) + 'px,' + y.toFixed(2) + 'px,0)';
        });
      };

      scene.addEventListener('pointermove', function(event){
        const r = scene.getBoundingClientRect();
        px = ((event.clientX - r.left) / r.width - .5);
        py = ((event.clientY - r.top) / r.height - .5);
        if (!raf) raf = requestAnimationFrame(render);
      }, {passive:true});

      scene.addEventListener('pointerleave', function(){
        px = 0; py = 0;
        if (!raf) raf = requestAnimationFrame(render);
      }, {passive:true});
    });
  }

  function motionOrientationSupported(){
    return typeof window.DeviceOrientationEvent !== 'undefined';
  }

  function bindOrientation(targets){
    let raf = 0;
    let last = 0;
    let beta = 0;
    let gamma = 0;

    function render(){
      raf = 0;
      targets.forEach(function(el){
        const intensity = Math.max(1, Math.min(10, Number(el.dataset.cpGravityIntensity || 5)));
        const x = Math.max(-intensity, Math.min(intensity, gamma * intensity / 24));
        const y = Math.max(-intensity, Math.min(intensity, beta * intensity / 32));
        el.style.setProperty('--cp-gravity-x', x.toFixed(2) + 'px');
        el.style.setProperty('--cp-gravity-y', y.toFixed(2) + 'px');
        el.classList.add('is-motion-enabled');
      });
    }

    function onOrientation(event){
      const now = performance.now();
      if (now - last < 50) return;
      last = now;
      beta = Number(event.beta || 0);
      gamma = Number(event.gamma || 0);
      if (!raf) raf = requestAnimationFrame(render);
    }

    window.addEventListener('deviceorientation', onOrientation, {passive:true});
  }

  function setupMobileGravity(){
    const targets = doc.querySelectorAll('[data-cp-mobile-gravity]');
    if (!targets.length || reducedMotion.matches || window.innerWidth > 820) return;

    targets.forEach(function(el){
      el.dataset.cpGravityIntensity = el.dataset.cpGravityIntensity || '4';
    });

    if (!motionOrientationSupported()) return;

    const PermissionType = window.DeviceOrientationEvent;
    const needsPermission = typeof PermissionType.requestPermission === 'function';

    /*
      iOS/WebKit exige un permiso explícito. La fase 03 no lo solicita
      automáticamente: un control futuro de la UI puede llamar al evento
      data-cp-request-motion.
    */
    if (needsPermission){
      const trigger = doc.querySelector('[data-cp-request-motion]');
      if (!trigger) return;

      trigger.addEventListener('click', function(){
        PermissionType.requestPermission()
          .then(function(state){
            if (state === 'granted') bindOrientation(targets);
          })
          .catch(function(){});
      });
      return;
    }

    bindOrientation(targets);
  }


  function setupResizeObserver(){
    if (!('ResizeObserver' in window)) return;
    const header = doc.querySelector('.site-header');
    if (!header) return;

    const ro = new ResizeObserver(refreshScrollOffset);
    ro.observe(header);
  }

  refreshScrollOffset();
  setupMenu();
  setupViewport();
  setupSmoothAnchors();
  setCascadeIndexes();
  setupReveal();
  setupTouchFeedback();
  setupTilt();
  setupPointerParallax();
  setupScrollParallax();
  setupMobileGravity();
  setupResizeObserver();
})();
