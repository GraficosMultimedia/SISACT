SISACT · DESIGN SYSTEM
PRIMER MÓDULO: DETALLE DE COTIZACIÓN
Colibrí Print México

OBJETIVO
========
Corregir y profesionalizar la experiencia visual de admin/cotizacion.php,
especialmente en teléfonos, sin modificar funciones, consultas, base de datos,
conexiones, estados, PDF, WhatsApp ni órdenes.

REVISIÓN PREVIA
===============
Antes de crear este paquete se revisó el repositorio actual de SISACT.

Se detectó una diferencia de versión importante:
- GitHub ya contiene cambios recientes del editor móvil y Guardar + WhatsApp
  en cotizacion_nueva.php.
- La ficha admin/cotizacion.php visible en GitHub todavía corresponde a una
  versión anterior.
- La captura del servidor corresponde a la ficha V1.1 que ya incluye:
  * acción contextual;
  * historial reciente;
  * barra inferior móvil;
  * WhatsApp;
  * PDF;
  * rentabilidad.

Para evitar una regresión, este paquete usa como base la misma cotizacion.php
de la V1.1 instalada en el servidor y solamente añade referencias a hojas CSS.

ARCHIVOS
========
admin/cotizacion.php
  Base funcional V1.1 ya utilizada en servidor.
  ÚNICO CAMBIO: se cargan dos hojas CSS nuevas del Design System.

assets/css/cotizaciones-workspace-v1.css
  Dependencia actual del Workspace, incluida sin cambios para que el paquete
  sea autocontenido.

assets/js/cotizaciones-workspace-v1.js
  Dependencia actual del Workspace, incluida sin cambios.

assets/css/sisact-design-system-v1.css
  Nuevo.
  Tokens base del Design System SISACT: colores, escalas, radios, espacios,
  tipografía, superficies, tamaños táctiles y utilidades futuras.

assets/css/cotizacion-detail-professional-v1.css
  Nuevo.
  Capa específica para la ficha de cotización.

CAMBIOS VISUALES EN MÓVIL
=========================
- Textos normales se elevan a tamaños legibles.
- Jerarquía fuerte para folio, cliente, total y vigencia.
- Status badge con proporción correcta.
- Encabezado de empresa reorganizado.
- Datos del cliente dejan de verse comprimidos.
- Fecha y vigencia se muestran como bloques claros.
- Referencia, pago, entrega y lugar se organizan en tarjetas.
- Conceptos dejan de parecer una tabla de escritorio comprimida.
- Cantidad, precio e importe usan filas táctiles legibles.
- Subtotal/descuento/impuestos tienen separación adecuada.
- Total pasa a jerarquía principal.
- Condiciones comerciales e información de pago usan texto de lectura real.
- Select de estado: 52px.
- Guardar estado: 52px.
- Rentabilidad: filas de 52px con números claros.
- Historial reciente: texto y fechas legibles.
- Barra fija inferior: 52px por control + safe-area.
- WhatsApp y menú ⋯ tienen áreas táctiles reales.
- Menú móvil se abre encima de la barra y no debajo de ella.
- Se protege contra overflow horizontal.

ESCRITORIO
==========
También se refinan:
- espaciado;
- tamaños;
- cabecera;
- documento;
- panel lateral;
- timeline;
- acciones.

NO SE MODIFICA
==============
- lógica PHP;
- funciones;
- SQL;
- tablas;
- sesiones;
- CSRF;
- estados;
- cp_activity_log;
- cálculo de rentabilidad;
- creación de orden;
- WhatsApp;
- PDF;
- archivos del cliente;
- configuración de empresa;
- impresión.

INSTALACIÓN
===========
1. Respaldar:
   admin/cotizacion.php
   assets/css/cotizaciones-workspace-v1.css
   assets/js/cotizaciones-workspace-v1.js

2. Copiar la estructura del ZIP en la raíz SISACT.

3. Reemplazar admin/cotizacion.php.

4. Puede reemplazarse cotizaciones-workspace-v1.css y
   cotizaciones-workspace-v1.js; son copias de la versión actual del
   Workspace y se incluyen para mantener consistencia.

5. Copiar los dos CSS nuevos.

6. Hacer Ctrl+F5.

PRUEBAS RECOMENDADAS
====================
- 360px de ancho.
- 390px.
- 430px.
- tablet.
- 1366px.
- 1920px.
- cotización borrador.
- cotización enviada.
- cotización aprobada.
- cotización vinculada con orden.
- cotización con archivo del cliente.
- cotización con varias líneas.
- condiciones comerciales extensas.
- información de pago extensa.
- menú móvil ⋯.
- WhatsApp.
- PDF.
- cambio de estado.
- impresión del navegador.

REVERSIÓN
=========
Restaurar admin/cotizacion.php.
Los dos CSS nuevos pueden permanecer en el servidor sin afectar otra pantalla.

SIGUIENTE PASO
==============
Una vez aprobada esta ficha, los mismos tokens del Design System se aplicarán
al siguiente módulo sin introducir cambios globales de golpe.
