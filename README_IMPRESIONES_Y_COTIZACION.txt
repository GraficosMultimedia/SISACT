BLOQUE: Control de impresiones Printexp + rediseño del PDF de cotización

1) BASE DE DATOS
Ejecutar una sola vez:
 database/migrations/016_control_impresiones_printexp.sql
Base: colibrip_abcsistema

2) ARCHIVOS
Reemplazar/agregar respetando rutas:
 admin/impresiones.php
 includes/impresiones.php
 includes/cotizacion_pdf_renderer.php
 includes/header.php
 assets/css/impresiones.css
 database/migrations/016_control_impresiones_printexp.sql

3) CONTROL DE IMPRESIONES
El módulo registra por trabajo los datos que Printexp muestra al finalizar:
- Job DPI (X/Y)
- Print Program %
- Print Capa: m²/h y m/h
- Print Mode
- Print Time
- Print Copy
- Job Size (ancho y largo en mm)
- Print Length (m)
- Equipo/impresora
- Material/lona
- Orden de servicio y, opcionalmente, cotización
- Resultado y motivo de merma
- Observaciones

CRITERIO DE MEDICIÓN:
- Metros lineales = Print Length.
- m² brutos = (ancho del job en mm / 1000) × Print Length.
- m² útiles = m² brutos − merma.
- Una impresión buena normalmente tiene merma 0.
- Test, cancelación con impresión, atrapamiento/daño y reimpresión pueden contabilizarse como merma.
- Una cancelación sin impresión debe registrarse con 0 m² brutos y 0 m² de merma.

EJEMPLO DEL TRABAJO DE PRONTEXP MOSTRADO:
Job size 1536.31 mm × 3810.00 mm y Print Length 3.81 m producen aproximadamente 5.855 m² brutos.

4) CONTROL ADMINISTRATIVO
El módulo incluye filtros por fecha, resultado, material y equipo, resumen acumulado de metros y m², historial de trabajos y exportación CSV.

5) PRONTEXP
No se automatiza una importación directa desde Printexp porque todavía no se recibió un archivo/CSV de exportación ni una interfaz de integración. La captura manual reproduce los campos visibles del trabajo. Cuando exista un CSV real de Printexp se puede crear un importador sin modificar los registros históricos.

6) PDF DE COTIZACIÓN
Se rediseñó el renderer actual para una presentación más corporativa:
- encabezado con marca y folio destacado;
- fecha, vigencia y referencia;
- bloque de cliente;
- condiciones comerciales;
- tabla de conceptos con encabezado y filas alternadas;
- resumen de importes con total destacado;
- notas y condiciones;
- información para pago en bloque independiente;
- pie documental y leyenda de cotización comercial/no CFDI.

El PDF fue generado y validado localmente como documento de una página A4 con texto visible y lectura correcta.
