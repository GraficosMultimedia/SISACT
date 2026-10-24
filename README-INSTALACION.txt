SISACT · Seguimiento Visual Motion V2.2
=======================================

OBJETIVO
- Refinar seguimiento.php para acercarlo al mockup dark-premium aprobado.
- Mejorar iconografía mediante SVG propios.
- Añadir microanimaciones agradables y accesibles.
- Optimizar móvil.
- En móvil horizontal, mostrar un guard de orientación con iconos que "caen" y pedir volver a vertical.

NO MODIFICA
- Base de datos.
- Tokens.
- Pagos / Mercado Pago.
- CFDI.
- Cancelaciones.
- Kanban ni sus estados.
- Cálculos comerciales.

ARCHIVOS
/seguimiento.php
/assets/css/seguimiento-visual-motion-v2-2.css
/assets/js/seguimiento-visual-motion-v2-2.js
/admin/aplicar_tracking_visual_motion_v2_2.php

INSTALACION RECOMENDADA
1. Extraer el ZIP en la raíz de SISACT conservando carpetas.
2. Abrir /admin/aplicar_tracking_visual_motion_v2_2.php
3. Pulsar "Instalar V2.2".
4. Abrir una orden real y hacer Ctrl+F5.
5. Probar escritorio, móvil vertical y móvil horizontal.

INSTALACION MANUAL
Si prefieres no usar instalador, reemplaza /seguimiento.php por el incluido y sube los dos assets CSS/JS.

REVERSION
El instalador crea /seguimiento.php.bak_tracking_visual_v2_2 antes de tocar el archivo.
Usa "Revertir V2.2" para recuperar el estado previo.

NOTA DE ORIENTACION
El bloqueo se aplica únicamente a dispositivos táctiles/coarse pointer en landscape con viewport bajo (típicamente teléfonos). No usa DeviceOrientation ni solicita permisos de sensores.

ACCESIBILIDAD
prefers-reduced-motion desactiva las animaciones prolongadas y reduce el efecto de gravedad.
