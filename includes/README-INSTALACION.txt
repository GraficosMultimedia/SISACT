SISACT · PDF ORDEN + SEGUIMIENTO · DESCUENTO / IVA V1
Colibrí Print México

OBJETIVO
========
Mostrar en los PDF profesionales el desglose comercial de la cotización
cuando corresponda:

Subtotal
Descuento (X%)
IVA (X%)
Total del servicio
Pagado
Saldo pendiente

REGLAS
======
- Si descuento = 0, no se muestra la fila Descuento.
- Si IVA = 0, no se muestra la fila IVA.
- Si existen ambos, aparecen ambos.
- 16.0000% se muestra como 16%.
- 7.5000% se muestra como 7.5%.

PROTECCIÓN IMPORTANTE
=====================
La orden NO almacena actualmente discount/tax de forma independiente.

Por eso el helper compara:
- cotización vinculada;
- cantidad de conceptos;
- descripción;
- cantidad;
- precio unitario;
- subtotal de cada concepto;
- total de la orden contra total de cotización.

SOLO si siguen alineados utiliza:
cp_quote_totals.subtotal
cp_quote_totals.discount
cp_quote_totals.tax
cp_quote_totals.total

Si una orden fue editada manualmente y ya no coincide con la cotización,
NO imprime porcentajes antiguos ni inventa IVA/descuento.

ARCHIVOS DEL PAQUETE
====================
NUEVO:
includes/order_commercial_breakdown.php

INSTALADOR TEMPORAL:
admin/aplicar_pdf_desglose_v1.php

NO HAY SQL
==========
No requiere migración.

POR QUÉ ESTE PAQUETE USA INSTALADOR
===================================
El instalador parchea los DOS generadores que ya existen en el servidor
sin sustituirlos completos. Esto conserva cualquier actualización reciente
que ya tengas en esos archivos.

El instalador exige login de SISACT, usa CSRF y crea respaldos antes de
escribir.

INSTALACIÓN
===========
1. Extraer el ZIP en la raíz de SISACT respetando carpetas.

2. Iniciar sesión como administrador.

3. Abrir:
   /admin/aplicar_pdf_desglose_v1.php

4. Pulsar:
   "Aplicar parche V1"

5. El instalador modifica:
   /orden_pdf.php
   /seguimiento_comprobante.php

6. Genera automáticamente:
   orden_pdf.php.bak_pdf_desglose_v1
   seguimiento_comprobante.php.bak_pdf_desglose_v1

7. Probar:
   - PDF profesional de Orden de servicio.
   - PDF profesional desde Seguimiento.

8. Cuando confirmes que funciona:
   ELIMINAR del servidor:
   admin/aplicar_pdf_desglose_v1.php

9. Conserva:
   includes/order_commercial_breakdown.php

PRUEBAS
=======
CASO A · descuento sin IVA
Debe mostrar:
Subtotal
Descuento (X%)
Total
Pagado
Saldo

CASO B · IVA sin descuento
Debe mostrar:
Subtotal
IVA (X%)
Total
Pagado
Saldo

CASO C · descuento + IVA
Debe mostrar:
Subtotal
Descuento (X%)
IVA (X%)
Total
Pagado
Saldo

CASO D · sin descuento ni IVA
El PDF conserva el resumen normal.

CASO E · orden editada manualmente después de la cotización
No debe mostrar un descuento/IVA de la cotización que ya no corresponda.

REVERSIÓN
=========
Antes de eliminar el instalador puedes pulsar:
"Revertir"

También puedes restaurar manualmente:
orden_pdf.php.bak_pdf_desglose_v1
seguimiento_comprobante.php.bak_pdf_desglose_v1

GITHUB
======
Después de aprobar la prueba en servidor, los archivos que debes reflejar
en GitHub son:

orden_pdf.php
seguimiento_comprobante.php
includes/order_commercial_breakdown.php

NO subas a GitHub:
admin/aplicar_pdf_desglose_v1.php
*.bak_pdf_desglose_v1

VALIDACIÓN
==========
El paquete fue construido para los marcadores exactos observados en el
main actual. Si alguno de esos bloques cambió, el instalador se detiene
sin modificar archivos en lugar de aplicar un parche parcial.
