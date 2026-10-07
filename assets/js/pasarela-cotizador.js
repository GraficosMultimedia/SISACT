(() => {
  'use strict';

  const SERVICES = {
    playeras: {
      name: 'Playeras personalizadas',
      icon: '👕',
      desc: 'DTF, bordado, vinil o sublimación',
      fields: [
        {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 25',required:true},
        {name:'garment',label:'Tipo de prenda',type:'select',options:['Playera cuello redondo','Playera polo','Sudadera','Otra']},
        {name:'technique',label:'Técnica',type:'select',options:['DTF','Bordado','Sublimación','Vinil textil','No lo sé todavía']},
        {name:'color',label:'Color de prenda',type:'text',placeholder:'Ej. Negro, blanco...'}
      ]
    },
    bordado: {
      name:'Bordado',
      icon:'🧵',
      desc:'Prendas, gorras y artículos',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 20',required:true},
        {name:'item',label:'¿Qué vamos a bordar?',type:'text',placeholder:'Playeras, gorras, chamarras...'},
        {name:'positions',label:'Número de posiciones',type:'select',options:['1','2','3 o más']},
        {name:'size',label:'Tamaño aproximado del bordado',type:'select',options:['Pequeño','Mediano','Grande','No lo sé']}
      ]
    },
    sublimacion: {
      name:'Sublimación',
      icon:'🎨',
      desc:'Textiles y artículos personalizados',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 12',required:true},
        {name:'product',label:'Producto',type:'select',options:['Taza','Playera','Termo','Llavero','Rompecabezas','Otro']},
        {name:'colors',label:'¿Cuántos diseños diferentes?',type:'number',min:1,placeholder:'Ej. 2'},
        {name:'size',label:'Medida o tamaño',type:'text',placeholder:'Ej. 22 × 9 cm'}
      ]
    },
    dtf: {
      name:'DTF',
      icon:'✨',
      desc:'Impresión para personalización textil',
      fields:[
        {name:'quantity',label:'Cantidad de aplicaciones',type:'number',min:1,placeholder:'Ej. 25',required:true},
        {name:'size',label:'Tamaño aproximado',type:'select',options:['Logo pequeño','A4','A3','Medio metro','Metro','Varios metros']},
        {name:'designs',label:'¿Cuántos diseños diferentes?',type:'number',min:1,placeholder:'Ej. 3'},
        {name:'application',label:'¿Necesitas aplicación en prenda?',type:'select',options:['Sí','No','Todavía no lo sé']}
      ]
    },
    impresion: {
      name:'Impresión',
      icon:'🖨️',
      desc:'Papelería, publicidad y piezas impresas',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 100',required:true},
        {name:'product',label:'¿Qué producto necesitas?',type:'text',placeholder:'Tarjetas, volantes, trípticos, menús...'},
        {name:'size',label:'Medidas',type:'text',placeholder:'Ej. Carta, media carta, 90 × 60 cm...'},
        {name:'material',label:'Material',type:'text',placeholder:'Couché, opalina, sintético...'},
        {name:'finish',label:'Acabado',type:'select',options:['Sin acabado','Laminado','Barniz','Corte','Doblez','No lo sé']}
      ]
    },
    gran_formato: {
      name:'Gran formato',
      icon:'🖼️',
      desc:'Lonas, vinil, banners y publicidad',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 1',required:true},
        {name:'product',label:'Producto',type:'select',options:['Lona','Vinil de impresión','Vinil de corte','Banner','Pendón','Otro']},
        {name:'width',label:'Ancho (cm)',type:'number',min:1,placeholder:'Ej. 200'},
        {name:'height',label:'Alto (cm)',type:'number',min:1,placeholder:'Ej. 100'},
        {name:'finish',label:'Acabado',type:'select',options:['Ojillos','Dobladillo','Instalación','Sin acabado','No lo sé']}
      ]
    },
    etiquetas: {
      name:'Etiquetas y stickers',
      icon:'🏷️',
      desc:'Etiquetas adhesivas y señalización',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 500',required:true},
        {name:'size',label:'Medida',type:'text',placeholder:'Ej. 5 × 5 cm'},
        {name:'material',label:'Material',type:'select',options:['Papel','Vinil','Transparente','Otro']},
        {name:'finish',label:'Acabado',type:'select',options:['Mate','Brillante','Troquelado','Rectangular','No lo sé']},
        {name:'roll',label:'Presentación',type:'select',options:['Por pieza','En rollo','No lo sé']}
      ]
    },
    sellos: {
      name:'Sellos personalizados',
      icon:'◼',
      desc:'Autoentintables y de madera',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 1',required:true},
        {name:'type',label:'Tipo de sello',type:'select',options:['Autoentintable','Madera','Otro']},
        {name:'size',label:'Tamaño aproximado',type:'text',placeholder:'Ej. 38 × 14 mm'},
        {name:'text',label:'Texto que llevará',type:'text',placeholder:'Nombre, RFC, teléfono...'}
      ]
    },
    laser: {
      name:'Grabado láser',
      icon:'⌁',
      desc:'Madera, acrílico, termos y reconocimientos',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 10',required:true},
        {name:'material',label:'Material / artículo',type:'text',placeholder:'Madera, acrílico, termo...'},
        {name:'size',label:'Medidas aproximadas',type:'text',placeholder:'Ej. 10 × 10 cm'},
        {name:'detail',label:'¿Qué se grabará?',type:'text',placeholder:'Logo, nombre, frase, diseño...'}
      ]
    },
    cnc: {
      name:'Corte CNC',
      icon:'✂',
      desc:'MDF, melamina, madera, acrílico y más',
      fields:[
        {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 4',required:true},
        {name:'material',label:'Material',type:'text',placeholder:'MDF, melamina, madera, acrílico...'},
        {name:'thickness',label:'Espesor',type:'text',placeholder:'Ej. 15 mm'},
        {name:'size',label:'Medidas de placa',type:'text',placeholder:'Ej. 122 × 244 cm'},
        {name:'cut_type',label:'Tipo de trabajo',type:'select',options:['Corte recto','Corte con forma','Perforado','Grabado CNC','No lo sé']}
      ]
    },
    corporea: {
      name:'Letras corpóreas',
      icon:'🔠',
      desc:'3D para fachadas, interiores y señalización',
      fields:[
        {name:'quantity',label:'Cantidad de letras / piezas',type:'number',min:1,placeholder:'Ej. 8',required:true},
        {name:'material',label:'Material',type:'select',options:['PVC','Acrílico','Aluminio','Madera','Otro']},
        {name:'height',label:'Altura aproximada',type:'text',placeholder:'Ej. 30 cm'},
        {name:'installation',label:'¿Requieres instalación?',type:'select',options:['Sí','No','No lo sé']}
      ]
    },
    diseno: {
      name:'Diseño gráfico',
      icon:'✎',
      desc:'Logotipos, publicidad, identidad y piezas digitales',
      fields:[
        {name:'quantity',label:'Cantidad de piezas / diseños',type:'number',min:1,placeholder:'Ej. 1',required:true},
        {name:'type',label:'Tipo de diseño',type:'select',options:['Logotipo','Identidad corporativa','Flyer','Etiqueta','Menú','Redes sociales','Catálogo','Invitación','Otro']},
        {name:'format',label:'Entrega final',type:'select',options:['Digital','Impresión','Digital + impresión']},
        {name:'reference',label:'¿Tienes referencias?',type:'text',placeholder:'Describe el estilo, colores o referencias...'}
      ]
    },
    comestible: {
      name:'Impresión comestible',
      icon:'🍰',
      desc:'Oblea de azúcar y papel de arroz/papa',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 20',required:true},
        {name:'material',label:'Tipo de oblea',type:'select',options:['Azúcar sabor vainilla','Arroz / papa sabor neutro','No lo sé']},
        {name:'size',label:'Medidas',type:'text',placeholder:'Ej. 20 × 20 cm'},
        {name:'event',label:'¿Para qué evento o producto?',type:'text',placeholder:'Pastel, cupcakes, evento...'}
      ]
    },
    promo: {
      name:'Artículos promocionales',
      icon:'🎁',
      desc:'Tazas, termos, vasos, botellas, souvenirs y más',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 30',required:true},
        {name:'product',label:'Producto',type:'text',placeholder:'Taza, termo, botella, vaso, cojín...'},
        {name:'personalization',label:'Personalización',type:'text',placeholder:'Logo, nombre, frase, foto...'},
        {name:'occasion',label:'Uso / evento',type:'text',placeholder:'Empresa, boda, regalo, evento...'}
      ]
    },
    vinil: {
      name:'Vinil de corte',
      icon:'✦',
      desc:'Cristales, muros, vehículos y rotulación',
      fields:[
        {name:'quantity',label:'Cantidad de piezas',type:'number',min:1,placeholder:'Ej. 2',required:true},
        {name:'surface',label:'¿Dónde se instalará?',type:'select',options:['Cristal','Muro','Vehículo','Otro']},
        {name:'size',label:'Medidas',type:'text',placeholder:'Ej. 100 × 50 cm'},
        {name:'color',label:'Color de vinil',type:'text',placeholder:'Ej. Negro, blanco, rojo...'}
      ]
    },
    invitaciones: {
      name:'Invitaciones especiales',
      icon:'💌',
      desc:'Bodas, XV años y eventos',
      fields:[
        {name:'quantity',label:'Cantidad',type:'number',min:1,placeholder:'Ej. 100',required:true},
        {name:'event',label:'Tipo de evento',type:'select',options:['Boda','XV años','Cumpleaños','Bautizo','Corporativo','Otro']},
        {name:'size',label:'Formato / tamaño',type:'text',placeholder:'Ej. 15 × 21 cm'},
        {name:'finish',label:'Acabado',type:'select',options:['Simple','Premium','Con sobre','Con acabados especiales','No lo sé']}
      ]
    },
    otro: {
      name:'Otro proyecto',
      icon:'＋',
      desc:'Algo diferente que quieres fabricar o imprimir',
      fields:[
        {name:'quantity',label:'Cantidad aproximada',type:'number',min:1,placeholder:'Ej. 1'},
        {name:'project',label:'¿Qué necesitas?',type:'text',placeholder:'Descríbelo en una frase...'},
        {name:'size',label:'Medidas aproximadas',type:'text',placeholder:'Si aplica'},
        {name:'material',label:'Material',type:'text',placeholder:'Si lo conoces'}
      ]
    }
  };

  const STEP_TITLES = ['Servicio','Detalles','Archivos','Entrega','Revisión'];
  const modal = document.querySelector('#cpqModal');
  if (!modal) return;

  const form = document.querySelector('#cpqForm');
  const serviceGrid = document.querySelector('#cpqServiceGrid');
  const dynamicFields = document.querySelector('#cpqDynamicFields');
  const review = document.querySelector('#cpqReview');
  const footer = document.querySelector('#cpqFooter');
  const result = document.querySelector('#cpqResult');
  const resultText = document.querySelector('#cpqResultText');
  const requestIdEl = document.querySelector('#cpqRequestId');
  const resultWa = document.querySelector('#cpqResultWhatsApp');
  const submitState = document.querySelector('#cpqSubmitState');

  let step = 1;
  let selected = '';
  let lastRequest = null;

  const $ = (selector, root=document) => root.querySelector(selector);
  const $$ = (selector, root=document) => [...root.querySelectorAll(selector)];

  const esc = (value='') => String(value)
    .replace(/&/g,'&amp;')
    .replace(/</g,'&lt;')
    .replace(/>/g,'&gt;')
    .replace(/"/g,'&quot;')
    .replace(/'/g,'&#039;');

  function openModal(target=1) {
    modal.classList.add('is-open');
    modal.setAttribute('aria-hidden','false');
    document.body.classList.add('cpq-lock');
    goTo(Math.max(1, Math.min(5, Number(target) || 1)));
  }

  function closeModal() {
    modal.classList.remove('is-open');
    modal.setAttribute('aria-hidden','true');
    document.body.classList.remove('cpq-lock');
  }

  function renderServices() {
    serviceGrid.innerHTML = Object.entries(SERVICES).map(([key, service]) => `
      <button type="button" class="cpq-service ${selected === key ? 'is-selected' : ''}" data-cpq-service="${esc(key)}">
        <span class="cpq-service-icon">${service.icon}</span>
        <span class="cpq-service-name">${esc(service.name)}</span>
        <small>${esc(service.desc)}</small>
        <i>→</i>
      </button>
    `).join('');

    $$('.cpq-service').forEach(btn => {
      btn.addEventListener('click', () => selectService(btn.dataset.cpqService));
    });
  }

  function selectService(key) {
    if (!SERVICES[key]) return;
    selected = key;
    renderServices();
    $('#cpqServiceError').textContent = '';
    renderDynamicFields();
  }

  function renderDynamicFields() {
    const service = SERVICES[selected];
    if (!service) {
      dynamicFields.innerHTML = '<div class="cpq-empty">Selecciona un servicio para continuar.</div>';
      return;
    }

    $('#cpqDetailsTitle').textContent = service.name;

    dynamicFields.innerHTML = service.fields.map(field => {
      const label = esc(field.label);
      const name = esc(field.name);
      const required = field.required ? 'required' : '';
      if (field.type === 'select') {
        return `
          <label class="cpq-field">
            <span>${label}${field.required ? ' *' : ''}</span>
            <select name="${name}" ${required}>
              ${(field.options || []).map(option => `<option value="${esc(option)}">${esc(option)}</option>`).join('')}
            </select>
          </label>
        `;
      }

      return `
        <label class="cpq-field">
          <span>${label}${field.required ? ' *' : ''}</span>
          <input name="${name}" type="${esc(field.type)}" ${field.min ? `min="${esc(field.min)}"` : ''} placeholder="${esc(field.placeholder || '')}" ${required}>
        </label>
      `;
    }).join('');
  }

  function collect() {
    const data = {};
    $$('input,select,textarea', form).forEach(el => {
      if (el.name && el.type !== 'file' && el.name !== 'website') data[el.name] = el.value.trim();
    });
    data.service = selected;
    data.service_name = SERVICES[selected]?.name || '';
    const file = $('input[name="attachment"]', form);
    data.attachment = file?.files?.[0] || null;
    return data;
  }

  function detailRows(data) {
    const service = SERVICES[selected];
    const excluded = new Set(['design_status','application','notes','delivery_method','desired_date','name','phone','email']);
    return Object.entries(data)
      .filter(([key, value]) => value !== '' && value !== null && !excluded.has(key) && !key.startsWith('_'))
      .map(([key, value]) => {
        const field = service?.fields?.find(f => f.name === key);
        return `<div class="cpq-review-row"><span>${esc(field?.label || key)}</span><strong>${esc(value)}</strong></div>`;
      }).join('');
  }

  function renderReview() {
    const data = collect();
    const service = SERVICES[selected];

    review.innerHTML = `
      <div class="cpq-review-card cpq-review-main">
        <div class="cpq-review-icon">${service?.icon || '✦'}</div>
        <div>
          <span>SERVICIO</span>
          <strong>${esc(service?.name || 'Por seleccionar')}</strong>
        </div>
      </div>

      <div class="cpq-review-grid">
        <div class="cpq-review-card">
          <span>DETALLES</span>
          ${detailRows(data) || '<p>Sin detalles adicionales.</p>'}
        </div>

        <div class="cpq-review-card">
          <span>PRODUCCIÓN</span>
          <div class="cpq-review-row"><span>Diseño</span><strong>${esc(data.design_status || 'No indicado')}</strong></div>
          <div class="cpq-review-row"><span>Aplicación / instalación</span><strong>${esc(data.application || 'No indicado')}</strong></div>
          <div class="cpq-review-row"><span>Entrega</span><strong>${esc(data.delivery_method || 'Por confirmar')}</strong></div>
          <div class="cpq-review-row"><span>Fecha solicitada</span><strong>${esc(data.desired_date || 'Por confirmar')}</strong></div>
        </div>
      </div>

      <div class="cpq-review-card cpq-review-contact">
        <span>CONTACTO</span>
        <div class="cpq-review-row"><span>Nombre</span><strong>${esc(data.name || 'Falta')}</strong></div>
        <div class="cpq-review-row"><span>WhatsApp</span><strong>${esc(data.phone || 'Falta')}</strong></div>
        ${data.email ? `<div class="cpq-review-row"><span>Correo</span><strong>${esc(data.email)}</strong></div>` : ''}
        ${data.notes ? `<div class="cpq-review-note-row"><span>Notas</span><p>${esc(data.notes)}</p></div>` : ''}
        ${data.attachment ? `<div class="cpq-review-row"><span>Archivo</span><strong>${esc(data.attachment.name)}</strong></div>` : ''}
      </div>
    `;
  }

  function validateStep() {
    if (step === 1) {
      if (!selected) {
        $('#cpqServiceError').textContent = 'Selecciona el servicio que más se acerque a tu proyecto.';
        return false;
      }
      return true;
    }

    if (step === 2) {
      const service = SERVICES[selected];
      for (const field of (service?.fields || [])) {
        if (!field.required) continue;
        const el = $(`[name="${field.name}"]`, dynamicFields);
        if (!el || !el.value.trim()) {
          el?.focus();
          alert(`Completa: ${field.label}`);
          return false;
        }
      }
      return true;
    }

    if (step === 4) {
      const name = $('[name="name"]', form)?.value.trim();
      const phone = $('[name="phone"]', form)?.value.trim();
      const email = $('[name="email"]', form)?.value.trim();

      if (!name || !phone) {
        alert('Completa tu nombre y WhatsApp para continuar.');
        return false;
      }
      if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        alert('Revisa el correo electrónico.');
        return false;
      }
      return true;
    }

    if (step === 5) {
      const data = collect();
      if (!selected || !data.name || !data.phone) {
        alert('Faltan datos obligatorios.');
        return false;
      }
      return true;
    }

    return true;
  }

  function updateProgress() {
    $$('.cpq-progress span').forEach((bar, index) => {
      bar.classList.toggle('is-current', index === step - 1);
      bar.classList.toggle('is-done', index < step - 1);
    });
    $('#cpqStepTitle').textContent = STEP_TITLES[step - 1];
    $('#cpqStepNumber').textContent = step;
    $('#cpqFooterLabel').textContent = `Paso ${step} de 5`;
    $('#cpqBack').style.visibility = step === 1 ? 'hidden' : 'visible';
    $('#cpqNext').textContent = step === 5 ? 'Enviar solicitud →' : 'Continuar →';
  }

  function goTo(nextStep) {
    step = nextStep;
    $$('.cpq-step').forEach(panel => {
      panel.classList.toggle('is-visible', Number(panel.dataset.cpqStepview) === step);
    });

    updateProgress();
    footer.style.display = result.classList.contains('is-visible') ? 'none' : 'flex';

    if (step === 5) renderReview();

    $('.cpq-dialog').scrollTo({top:0, behavior:'smooth'});
  }

  async function submitRequest() {
    if (!validateStep()) return;

    const data = collect();
    const fd = new FormData(form);
    fd.set('service', selected);
    fd.set('service_name', SERVICES[selected]?.name || '');

    submitState.textContent = 'Guardando tu solicitud...';
    $('#cpqNext').disabled = true;
    $('#cpqBack').disabled = true;

    try {
      const response = await fetch('/api/pasarela-cotizador.php', {
        method: 'POST',
        body: fd,
        headers: {'X-Requested-With':'XMLHttpRequest'}
      });

      const payload = await response.json();
      if (!response.ok || !payload.ok) {
        throw new Error(payload.message || 'No se pudo registrar la solicitud.');
      }

      lastRequest = payload;
      requestIdEl.textContent = payload.reference || `CPQ-${String(payload.id).padStart(6,'0')}`;
      resultText.textContent = payload.message || 'Tu solicitud quedó registrada correctamente.';
      resultWa.href = payload.whatsapp_url || '#';

      $$('.cpq-step').forEach(panel => panel.classList.remove('is-visible'));
      result.classList.add('is-visible');
      footer.style.display = 'none';
      submitState.textContent = '';
    } catch (error) {
      submitState.textContent = error.message || 'No se pudo registrar la solicitud.';
      submitState.classList.add('is-error');
      $('#cpqNext').disabled = false;
      $('#cpqBack').disabled = false;
      return;
    }

    $('#cpqNext').disabled = false;
    $('#cpqBack').disabled = false;
  }

  function resetForm() {
    form.reset();
    selected = '';
    lastRequest = null;
    result.classList.remove('is-visible');
    footer.style.display = 'flex';
    submitState.textContent = '';
    submitState.classList.remove('is-error');
    renderServices();
    renderDynamicFields();
    goTo(1);
  }

  $$('[data-cpq-open]').forEach(button => {
    button.addEventListener('click', () => openModal(Number(button.dataset.cpqStep || 1)));
  });

  $$('[data-cpq-close]').forEach(button => {
    button.addEventListener('click', closeModal);
  });

  $('#cpqNext').addEventListener('click', () => {
    if (step < 5) {
      if (!validateStep()) return;
      goTo(step + 1);
    } else {
      submitRequest();
    }
  });

  $('#cpqBack').addEventListener('click', () => {
    if (step > 1) goTo(step - 1);
  });

  $('#cpqNewRequest').addEventListener('click', resetForm);

  document.addEventListener('keydown', event => {
    if (event.key === 'Escape' && modal.classList.contains('is-open')) closeModal();
  });

  renderServices();
  renderDynamicFields();
  updateProgress();
})();
