
document.addEventListener('DOMContentLoaded',function(){
  const sidebar=document.getElementById('adminSidebar');
  const overlay=document.getElementById('adminSidebarOverlay');
  const trigger=document.getElementById('adminMenuTrigger');
  const close=document.getElementById('adminSidebarClose');

  const isMobile=()=>window.matchMedia('(max-width:980px)').matches;

  function openSidebar(){
    if(!sidebar)return;
    sidebar.classList.add('is-open');
    overlay?.classList.add('is-visible');
    trigger?.setAttribute('aria-expanded','true');
    document.body.classList.add('admin-nav-open');
  }
  function closeSidebar(){
    if(!sidebar)return;
    sidebar.classList.remove('is-open');
    overlay?.classList.remove('is-visible');
    trigger?.setAttribute('aria-expanded','false');
    document.body.classList.remove('admin-nav-open');
  }

  trigger?.addEventListener('click',()=>sidebar?.classList.contains('is-open')?closeSidebar():openSidebar());
  close?.addEventListener('click',closeSidebar);
  overlay?.addEventListener('click',closeSidebar);
  document.addEventListener('keydown',e=>{if(e.key==='Escape')closeSidebar()});
  window.addEventListener('resize',()=>{if(!isMobile())closeSidebar()});

  // Marca la página activa sin cambiar rutas.
  const current=(location.pathname.replace(/\/+$/,'')||'/');
  sidebar?.querySelectorAll('nav a[href]').forEach(link=>{
    try{
      const target=(new URL(link.href,location.origin).pathname.replace(/\/+$/,'')||'/');
      if(target===current){
        link.classList.add('is-current');
        link.setAttribute('aria-current','page');
      }
      link.addEventListener('click',()=>{if(isMobile())closeSidebar()});
    }catch(_){}
  });

  // En la orden, el navegador debe ofrecer también "Archivos",
  // no solamente fotos/video. El servidor ya valida los formatos.
  document.querySelectorAll('input[type="file"]').forEach(input=>{
    if(input.name==='file'){
      input.setAttribute(
        'accept',
        '.jpg,.jpeg,.png,.webp,.gif,.bmp,.svg,.pdf,.doc,.docx,.odt,.rtf,.xls,.xlsx,.csv,.ods,.ppt,.pptx,.odp,.txt,.log,.md,.zip,.rar,.7z,.tar,.gz,.ai,.eps,.psd,.cdr,.dxf,.dwg,.stp,.step,.3mf,.obj,.stl'
      );
      input.setAttribute('aria-label','Seleccionar archivo de la orden');
    }
  });
});
