(function(){
  const toggle=document.querySelector('.menu-toggle');
  const menu=document.getElementById('mainMenu');
  if(toggle&&menu){
    toggle.addEventListener('click',()=>{
      const open=menu.classList.toggle('is-open');
      toggle.setAttribute('aria-expanded',open?'true':'false');
      toggle.querySelector('i').textContent=open?'✕':'☰';
    });
    menu.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>{
      menu.classList.remove('is-open');toggle.setAttribute('aria-expanded','false');toggle.querySelector('i').textContent='☰';
    }));
  }
  const observer=new IntersectionObserver(entries=>entries.forEach(e=>{if(e.isIntersecting){e.target.classList.add('show');observer.unobserve(e.target)}}),{threshold:.12});
  document.querySelectorAll('.reveal').forEach(el=>observer.observe(el));
})();
