
document.addEventListener('DOMContentLoaded',function(){
  const sidebar=document.getElementById('adminSidebar');
  const overlay=document.getElementById('adminSidebarOverlay');
  const trigger=document.getElementById('adminMenuTrigger');
  const close=document.getElementById('adminSidebarClose');

  function isMobile(){return window.matchMedia('(max-width:980px)').matches}

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

  trigger?.addEventListener('click',function(){
    sidebar?.classList.contains('is-open')?closeSidebar():openSidebar();
  });
  close?.addEventListener('click',closeSidebar);
  overlay?.addEventListener('click',closeSidebar);

  document.addEventListener('keydown',function(e){
    if(e.key==='Escape')closeSidebar();
  });

  const current=(location.pathname.replace(/\/+$/,'')||'/');

  sidebar?.querySelectorAll('.admin-main-nav a[href]').forEach(function(link){
    try{
      const target=(new URL(link.href,location.origin).pathname.replace(/\/+$/,'')||'/');
      if(target===current){
        link.classList.add('is-current');
        link.setAttribute('aria-current','page');
      }
      link.addEventListener('click',function(){
        if(isMobile())closeSidebar();
      });
    }catch(_){}
  });

  window.addEventListener('resize',function(){
    if(!isMobile())closeSidebar();
  });
});
