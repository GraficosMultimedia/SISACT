(function(){
  const button=document.querySelector('.menu-toggle');
  const menu=document.getElementById('catalogMenu');
  if(!button||!menu) return;
  button.addEventListener('click',function(){
    const open=menu.classList.toggle('is-open');
    button.setAttribute('aria-expanded',open?'true':'false');
  });
  menu.querySelectorAll('a').forEach(function(a){a.addEventListener('click',function(){menu.classList.remove('is-open');button.setAttribute('aria-expanded','false');});});
})();
