/* SISACT · Seguimiento Visual V2.1 · Mobile UX */
(function () {
  'use strict';

  function mobile() {
    return window.matchMedia('(max-width: 760px)').matches;
  }

  function activeStage() {
    return document.querySelector(
      '.progress-line.client-progress .stage.active, ' +
      '.progress-line.client-progress .stage.is-interrupted'
    );
  }

  function centerActiveStage(behavior) {
    if (!mobile()) return;

    const stage = activeStage();
    if (!stage) return;

    stage.setAttribute('aria-current', 'step');

    requestAnimationFrame(function () {
      try {
        stage.scrollIntoView({
          behavior: behavior || 'auto',
          block: 'nearest',
          inline: 'center'
        });
      } catch (e) {
        // Navegadores antiguos: no afectar el seguimiento si no soportan options.
        stage.scrollIntoView(false);
      }
    });
  }

  function improveCards() {
    document
      .querySelectorAll('.tracking-premium-card.is-current')
      .forEach(function (card) {
        card.setAttribute('aria-current', 'true');
      });

    document
      .querySelectorAll('.tracking-offer-v2 a, .tracking-offers-v2-main-cta')
      .forEach(function (link) {
        link.setAttribute('data-mobile-touch-target', 'true');
      });
  }

  let resizeTimer = null;

  function init() {
    improveCards();
    centerActiveStage('auto');

    window.addEventListener('resize', function () {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(function () {
        centerActiveStage('auto');
      }, 120);
    }, { passive: true });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init, { once: true });
  } else {
    init();
  }
})();
