SISACT · DESIGN SYSTEM
MÓDULO 4: PRODUCCIÓN WORKSPACE / KANBAN
Colibrí Print México

REVISIÓN PREVIA DEL REPOSITORIO
===============================
Se revisaron antes de crear este paquete:
- admin/produccion.php
- assets/css/produccion.css
- includes/produccion.php

ESTADO ACTUAL
=============
El Kanban usa siete etapas activas:
Pendiente, Diseño, Aprobación, Impresión, Producción, Calidad y Listo.

La lógica de etapas vive en includes/produccion.php y production_set_stage():
- actualiza cp_order_status;
- genera historial cuando corresponde;
- sincroniza el estado general de cp_orders;
- usa transacción.

ESTA LÓGICA NO SE MODIFICA.

HALLAZGO VISUAL
===============
En móvil, el CSS original reduce las columnas a 220-240 px y mantiene textos
de aproximadamente 10-12 px. Funciona, pero las tarjetas quedan demasiado
pequeñas para operación diaria.

QUÉ CAMBIA
==========
admin/produccion.php
- conserva toda la lógica actual;
- carga el Design System;
- muestra en cada tarjeta:
  * total;
  * responsable;
  * fecha de entrega;
  * indicador de vencida;
- añade resumen por etapas;
- añade la ayuda visual "Desliza entre etapas".

assets/css/sisact-design-system-v1.css
- base aprobada del Design System.

assets/css/produccion-workspace-professional-v1.css
- nueva capa visual específica.

NO SE MODIFICA
==============
- production_set_stage();
- production_orders();
- production_stages();
- cp_order_status;
- cp_order_history;
- cp_orders;
- transacciones;
- búsqueda;
- filtro por etapa;
- CSRF;
- log_activity();
- historial de finalizadas;
- detalle de producción;
- base de datos;
- conexiones.

MÓVIL
=====
- Kanban horizontal con scroll-snap.
- Cada etapa ocupa aproximadamente 86% de la pantalla, máximo 360px.
- Ya no usa columnas diminutas de 220px.
- Título de etapa 15px.
- Folio de orden 16px.
- Cliente 15px.
- Total 17px.
- Responsable 13px.
- Fecha 13px.
- Botón Abrir orden 50px.
- Inputs/selects 50px y 16px para evitar zoom automático.
- Resumen de etapas desplazable.
- Indicador de entrega vencida.
- Scrollbar horizontal oculto visualmente en móvil.

ESCRITORIO / TABLET
===================
- Se conserva el concepto Kanban.
- Tarjetas con mejor jerarquía.
- En tablet se activa Kanban horizontal de 300px por columna.
- Escritorio conserva las siete columnas.

CACHE
=====
admin/produccion.php carga:
  sisact-design-system-v1.css?v=1.0.1
  produccion-workspace-professional-v1.css?v=1.0.0

INSTALACIÓN
===========
1. Respaldar admin/produccion.php.
2. Copiar el ZIP respetando carpetas.
3. Reemplazar admin/produccion.php.
4. Copiar/actualizar ambos CSS.
5. Hacer Ctrl+F5 una vez.

PRUEBAS
=======
- 360px
- 390px
- 430px
- tablet
- escritorio
- buscar por orden
- buscar por cliente
- filtrar cada etapa
- orden con responsable
- orden sin responsable
- orden con fecha
- orden sin fecha
- orden vencida
- abrir detalle de producción
- historial finalizadas

REVERSIÓN
=========
Restaurar admin/produccion.php.
El CSS nuevo puede permanecer en el servidor sin afectar otros módulos porque
solo se carga desde esta pantalla.

SIGUIENTE MÓDULO RECOMENDADO
============================
Clientes Workspace / listado y ficha de cliente.
