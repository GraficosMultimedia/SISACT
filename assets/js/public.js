document.addEventListener('DOMContentLoaded',()=>{
  const toggle=document.querySelector('.menu-toggle');
  const nav=document.querySelector('.main-nav');
  if(toggle&&nav){
    toggle.addEventListener('click',()=>nav.classList.toggle('is-open'));
    nav.querySelectorAll('a').forEach(a=>a.addEventListener('click',()=>nav.classList.remove('is-open')));
  }
  const items=document.querySelectorAll('.service-card,.portfolio-card,.media-card,.process-step');
  const io=new IntersectionObserver((entries)=>entries.forEach(e=>{if(e.isIntersecting){e.target.animate([{opacity:0,transform:'translateY(18px)'},{opacity:1,transform:'translateY(0)'}],{duration:520,easing:'cubic-bezier(.22,.61,.36,1)',fill:'forwards'});io.unobserve(e.target)}}),{threshold:.12});
  items.forEach(x=>io.observe(x));
});
