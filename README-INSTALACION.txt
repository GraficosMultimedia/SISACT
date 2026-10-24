SISACT · SEGUIMIENTO VISUAL + OFERTAS V2.1
PULIDO FINO + OPTIMIZACIÓN MÓVIL
===============================================

OBJETIVO
--------
Aplicar el diseño V2.1 aprobado sobre la V2 Premium actualmente estable,
sin modificar lógica de SISACT.

ESTA ES UNA CAPA INCREMENTAL
----------------------------
V2.1 requiere que V2 Premium ya esté instalada.

No reemplaza:
- tracking_experience_v2.php
- seguimiento-visual-ofertas-v2.css
- lógica de seguimiento

Agrega overrides y UX móvil encima de V2.

CAMBIOS VISUALES
----------------
1. Kanban
   - mayor contraste de textos;
   - etapa actual más visible;
   - estados completados más legibles.

2. Hero premium
   - ring de progreso ligeramente más pequeño;
   - mejor balance entre texto y porcentaje;
   - chips más limpios;
   - gradientes más sutiles.

3. Estado actual
   - barra/acento lateral;
   - mayor jerarquía visual;
   - próximo paso más claro.

4. KPIs
   - tarjetas compactas;
   - sombras más suaves;
   - mejor lectura de títulos y valores.

5. Historia de producción
   - tarjetas con mayor contraste;
   - estado actual con badge "EN CURSO";
   - footer corregido para móvil;
   - hover refinado en escritorio.

6. Ofertas
   - tarjetas más premium;
   - CTAs mayores;
   - mejor encabezado comercial.

MÓVIL
-----
La V2.1 NO se limita a reducir la versión de escritorio.

Incluye:

- tracking-page con padding reducido;
- encabezado de empresa compacto;
- Kanban horizontal táctil;
- scroll-snap;
- centrado automático de etapa actual;
- hero compacto en dos columnas;
- ring de 70–82 px;
- chips en grid;
- estado actual + próximo paso en una sola tarjeta;
- KPIs 2×2;
- historial en una columna;
- tarjetas sin alturas fijas problemáticas;
- ofertas en carrusel horizontal táctil;
- CTAs de 44–46 px;
- soporte prefers-reduced-motion.

ARCHIVOS NUEVOS
---------------
assets/css/seguimiento-visual-ofertas-v2-1.css
assets/js/seguimiento-visual-ofertas-v2-1.js
admin/aplicar_tracking_visual_ofertas_v2_1.php

ARCHIVO MODIFICADO POR INSTALADOR
---------------------------------
seguimiento.php

NO HAY CAMBIOS DE BASE DE DATOS
-------------------------------
No agrega tablas.
No agrega columnas.
No modifica registros.

NO TOCA
-------
- Kanban / cp_order_status
- cancelaciones
- pagos
- Mercado Pago
- comprobantes
- CFDI
- archivos
- cotizaciones
- totales
- token público

INSTALACIÓN
-----------
1. Mantener V2 Premium instalada.

2. Extraer el ZIP en la raíz SISACT.

3. Abrir:
   /admin/aplicar_tracking_visual_ofertas_v2_1.php

4. Pulsar:
   Instalar V2.1

5. Abrir un seguimiento real y hacer Ctrl + F5.

PRUEBA DESKTOP
--------------
Verificar:
- las 8 etapas del Kanban;
- ring de avance;
- estado actual;
- 4 KPIs;
- historia de producción;
- ofertas y CTAs.

PRUEBA MÓVIL
------------
Probar en 360 px, 390 px y 430 px de ancho.

Verificar:
- no existe scroll horizontal global;
- el Kanban sí puede deslizarse horizontalmente;
- la etapa actual aparece centrada automáticamente;
- los KPIs aparecen 2×2;
- tarjetas de historial usan una sola columna;
- las ofertas se deslizan como carrusel;
- los botones son cómodos para tocar;
- ningún texto queda cortado.

REVERTIR
--------
El instalador crea:

seguimiento.php.bak_tracking_visual_v2_1

Revertir V2.1 restaura exactamente la V2 Premium que estaba instalada
antes de aplicar este paquete.

GITHUB DESPUÉS DE VALIDAR
-------------------------
Subir:
- seguimiento.php
- assets/css/seguimiento-visual-ofertas-v2-1.css
- assets/js/seguimiento-visual-ofertas-v2-1.js

Mantener también los archivos V2 existentes:
- includes/tracking_experience_v2.php
- assets/css/seguimiento-visual-ofertas-v2.css

NO subir:
- admin/aplicar_tracking_visual_ofertas_v2_1.php
- *.bak_tracking_visual_v2_1

VALIDACIÓN
----------
PHP:
php -l

JavaScript:
node --check

ZIP:
prueba de integridad
