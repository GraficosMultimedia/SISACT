
document.addEventListener('DOMContentLoaded',function(){
  const header=document.getElementById('adminGlobalHeader');
  const trigger=document.getElementById('adminMenuTrigger');
  const panel=document.getElementById('adminMobilePanel');

  function isMobile(){return window.matchMedia('(max-width:920px)').matches}

  function closeMobile(){
    if(!panel)return;
    panel.hidden=true;
    trigger?.setAttribute('aria-expanded','false');
  }

  trigger?.addEventListener('click',function(){
    const open=panel.hidden;
    panel.hidden=!open;
    trigger.setAttribute('aria-expanded',String(open));
    if(open){
      const first=panel.querySelector('.is-current, a, summary');
      first?.scrollIntoView({block:'nearest'});
    }
  });

  document.addEventListener('keydown',function(e){
    if(e.key==='Escape')closeMobile();
  });

  window.addEventListener('resize',function(){
    if(!isMobile())closeMobile();
  });

  // Marcar módulo activo sin alterar ninguna ruta.
  const current=(location.pathname.replace(/\/+$/,'')||'/');
  const allLinks=header?.querySelectorAll('a[href]')||[];

  allLinks.forEach(function(link){
    try{
      const target=(new URL(link.href,location.origin).pathname.replace(/\/+$/,'')||'/');
      if(target===current){
        link.classList.add('is-current');
        link.setAttribute('aria-current','page');
        const desktopMenu=link.closest('.admin-nav-menu');
        desktopMenu?.classList.add('has-current');
      }
      link.addEventListener('click',function(){
        if(isMobile())closeMobile();
      });
    }catch(_){}
  });

  // En la orden, Android/iOS ofrecerá también documentos en "Archivos".
  document.querySelectorAll('input[type="file"]').forEach(function(input){
    if(input.name==='file'){
      input.setAttribute(
        'accept',
        '.jpg,.jpeg,.png,.webp,.gif,.bmp,.svg,.pdf,.doc,.docx,.odt,.rtf,.xls,.xlsx,.csv,.ods,.ppt,.pptx,.odp,.txt,.log,.md,.zip,.rar,.7z,.tar,.gz,.ai,.eps,.psd,.cdr,.dxf,.dwg,.stp,.step,.3mf,.obj,.stl'
      );
      input.setAttribute('aria-label','Seleccionar archivo de la orden');
    }
  });
});
