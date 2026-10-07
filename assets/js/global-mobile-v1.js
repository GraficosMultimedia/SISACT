document.addEventListener('DOMContentLoaded',function(){
  const sidebar=document.getElementById('globalSidebar');
  const overlay=document.getElementById('globalSidebarOverlay');
  const toggle=document.getElementById('globalSidebarToggle');
  const close=document.getElementById('globalSidebarClose');
  const body=document.body;

  function openSidebar(){
    if(!sidebar)return;
    sidebar.classList.add('is-open');
    toggle?.setAttribute('aria-expanded','true');
    overlay?.classList.add('is-visible');
    body.classList.add('global-sidebar-open');
  }

  function closeSidebar(){
    if(!sidebar)return;
    sidebar.classList.remove('is-open');
    toggle?.setAttribute('aria-expanded','false');
    overlay?.classList.remove('is-visible');
    body.classList.remove('global-sidebar-open');
  }

  toggle?.addEventListener('click',function(){
    sidebar?.classList.contains('is-open') ? closeSidebar() : openSidebar();
  });
  close?.addEventListener('click',closeSidebar);
  overlay?.addEventListener('click',closeSidebar);

  document.addEventListener('keydown',function(e){
    if(e.key==='Escape') closeSidebar();
  });

  sidebar?.querySelectorAll('a[href]').forEach(function(a){
    a.addEventListener('click',function(){
      if(window.matchMedia('(max-width:980px)').matches) closeSidebar();
    });
  });

  // Active module based on current path.
  const path=window.location.pathname.replace(/\/+$/,'')||'/';
  sidebar?.querySelectorAll('.nav-group-items a[href]').forEach(function(a){
    try{
      const url=new URL(a.href,window.location.origin);
      const target=url.pathname.replace(/\/+$/,'')||'/';
      if(target===path){
        a.classList.add('is-current');
        const group=a.closest('.nav-group');
        const btn=group?.querySelector('.nav-group-toggle');
        if(btn)btn.setAttribute('aria-expanded','true');
      }
    }catch(_){}
  });

  // Remember only collapsed groups. This does not store or touch business data.
  sidebar?.querySelectorAll('.nav-group').forEach(function(group){
    const name=group.dataset.navGroup;
    const btn=group.querySelector('.nav-group-toggle');
    if(!btn||!name)return;
    btn.addEventListener('click',function(){
      const next=btn.getAttribute('aria-expanded')!=='true';
      btn.setAttribute('aria-expanded',String(next));
      try{localStorage.setItem('cp-nav-'+name,next?'open':'closed')}catch(_){}
    });
    try{
      const saved=localStorage.getItem('cp-nav-'+name);
      if(saved==='closed' && !group.querySelector('.is-current')) btn.setAttribute('aria-expanded','false');
    }catch(_){}
  });
});
