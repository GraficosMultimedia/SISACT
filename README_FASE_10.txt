COLIBRI PRINT - FASE 10
Gestión visual de cotizaciones

CAMBIOS
1. admin/cotizaciones.php
   - Nuevo panel de filtros.
   - Filtros rápidos: Todas, Aprobadas, En espera, Borradores, Rechazadas, Vencidas y Canceladas.
   - Búsqueda por folio, cliente o notas.
   - Selector de vista Lista / Cuadros.
   - Vista de cuadrícula con tarjetas de cotización.
   - Las cotizaciones aprobadas muestran una indicación de que están disponibles para crear orden.
   - Se conserva edición, visualización y eliminación.

2. assets/css/cotizaciones.css
   - Estilos para filtros rápidos, selector de vista y tarjetas.
   - Diseño responsive para escritorio, tablet y móvil.

3. admin/orden_nueva.php
   - Se conserva el comportamiento de Fase 9: al crear una orden se muestran automáticamente únicamente las cotizaciones aprobadas que todavía no tienen una orden activa.

IMPORTANTE
- Este paquete parte del ZIP completo de Fase 9 corregida para evitar parches parciales.
- No requiere una migración SQL nueva.
