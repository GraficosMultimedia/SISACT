(function(){
  'use strict';

  function money(value){
    return new Intl.NumberFormat('es-MX',{style:'currency',currency:'MXN'}).format(value);
  }

  function setup(){
    var root = document.querySelector('[data-cp-product-options]');
    if (!root) return;

    var basePrice = Number(root.getAttribute('data-base-price') || 0);
    var fixedPrice = root.getAttribute('data-fixed') === '1';
    var summary = document.querySelector('[data-cp-config-price]');
    var waButton = document.querySelector('[data-cp-config-wa]');
    var productName = root.getAttribute('data-product-name') || 'producto';
    var waBase = root.getAttribute('data-wa-base') || '';

    function selectedValues(){
      var parts = [];

      root.querySelectorAll('input[data-price-delta]:checked').forEach(function(input){
        parts.push({
          label:input.getAttribute('data-label') || input.value,
          delta:Number(input.getAttribute('data-price-delta') || 0)
        });
      });

      root.querySelectorAll('select[data-price-source]').forEach(function(select){
        var option = select.options[select.selectedIndex];
        if (!option || !option.value) return;
        parts.push({
          label:option.getAttribute('data-label') || option.textContent,
          delta:Number(option.getAttribute('data-price-delta') || 0)
        });
      });

      root.querySelectorAll('input[data-cp-free-field],textarea[data-cp-free-field]').forEach(function(input){
        var value = input.type === 'checkbox' ? (input.checked ? 'Sí' : '') : (input.value || '').trim();
        if (value) {
          parts.push({
            label:(input.getAttribute('data-label') || input.name) + ': ' + value,
            delta:0
          });
        }
      });

      root.querySelectorAll('input[data-cp-file-field]').forEach(function(input){
        if (input.files && input.files[0]) {
          parts.push({
            label:(input.getAttribute('data-label') || 'Archivo') + ': ' + input.files[0].name,
            delta:0
          });
        }
      });

      return parts;
    }

    function isValid(){
      var valid = true;

      root.querySelectorAll('select[required],textarea[required],input[required]').forEach(function(field){
        if (!field.checkValidity()) valid = false;
      });

      root.querySelectorAll('.prod-option-choices[data-required="1"]').forEach(function(group){
        if (!group.querySelector('input[type="radio"]:checked')) valid = false;
      });

      return valid;
    }

    function render(){
      var values = selectedValues();
      var delta = values.reduce(function(total,item){ return total + item.delta; },0);
      var total = basePrice + delta;

      if (summary) {
        summary.textContent = fixedPrice ? money(total) : 'Lista para cotizar';
      }

      if (waButton && waBase) {
        var detail = values.length
          ? '\\nConfiguración:\\n- ' + values.map(function(v){return v.label;}).join('\\n- ')
          : '';
        var priceLine = fixedPrice ? '\\nPrecio estimado: ' + money(total) : '';
        var text = 'Hola Colibrí Print México, quiero solicitar información sobre: ' + productName + '.' + detail + priceLine;
        waButton.href = waBase + '?text=' + encodeURIComponent(text);
      }
    }

    root.addEventListener('change', render);
    root.addEventListener('input', render);

    if (waButton) {
      waButton.addEventListener('click', function(event){
        if (!isValid()) {
          event.preventDefault();
          var invalid = root.querySelector(':invalid');
          if (invalid && typeof invalid.focus === 'function') invalid.focus();
          window.alert('Completa las opciones obligatorias antes de solicitar la configuración.');
        }
      });
    }

    render();
  }

  document.addEventListener('DOMContentLoaded', setup);
})();
