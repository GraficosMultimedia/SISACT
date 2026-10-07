(function(){
  'use strict';

  function setupGallery(){
    var main = document.getElementById('prod-main-image');
    if (!main) return;
    document.querySelectorAll('[data-cp-product-thumb]').forEach(function(button){
      button.addEventListener('click', function(){
        var src = button.getAttribute('data-src');
        if (!src) return;
        main.src = src;
        document.querySelectorAll('[data-cp-product-thumb]').forEach(function(item){
          item.classList.remove('active');
        });
        button.classList.add('active');
      });
    });
  }

  document.addEventListener('DOMContentLoaded', setupGallery);
})();
