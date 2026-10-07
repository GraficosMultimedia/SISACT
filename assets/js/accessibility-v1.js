document.addEventListener('keydown',e=>{if(e.key==='Escape')document.querySelectorAll('[aria-modal="true"],[data-cp-modal]').forEach(el=>el.setAttribute('hidden','hidden'));});
