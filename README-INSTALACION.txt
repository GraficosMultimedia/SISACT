SISACT · ARCHIVOS FALTANTES PARA GITHUB · V1
Colibrí Print México

OBJETIVO
========
Este ZIP reúne únicamente los archivos que faltaban o estaban pendientes de
sincronización en el repositorio principal de SISACT, conservando exactamente
sus carpetas y rutas.

ESTRUCTURA DEL ZIP
==================
/
├── seguimiento_comprobante.php
├── includes/
│   ├── order_pdf_professional_2pages.php
│   └── expense_cfdi.php
└── database/
    └── sql/
        └── 022_expense_cfdi_documents.sql

RUTAS DESTINO EN SISACT / GITHUB
================================
1. seguimiento_comprobante.php
   Ruta:
   /seguimiento_comprobante.php

   Función:
   - Endpoint público del PDF de seguimiento por token.
   - Valida el token público.
   - Resuelve la orden.
   - Utiliza el renderer profesional compartido de dos páginas.

2. includes/order_pdf_professional_2pages.php
   Ruta:
   /includes/order_pdf_professional_2pages.php

   Función:
   - Renderer profesional compartido entre:
     /admin/orden_pdf_2paginas.php
     /seguimiento_comprobante.php
   - Muestra Subtotal, Descuento (%), IVA (%) y Total cuando corresponda.

3. includes/expense_cfdi.php
   Ruta:
   /includes/expense_cfdi.php

   Función:
   - Lógica de importación y gestión de CFDI XML para Egresos.
   - Es dependencia directa de /admin/egresos.php.

4. database/sql/022_expense_cfdi_documents.sql
   Ruta:
   /database/sql/022_expense_cfdi_documents.sql

   Función:
   - Migración para la tabla documental de CFDI de egresos.
   - Debe ejecutarse en la base de datos del servidor si aún no existe la tabla.

INSTALACIÓN / SUBIDA A GITHUB
=============================
Extraer el ZIP en la raíz del proyecto SISACT conservando carpetas.

Después, en GitHub, deben aparecer exactamente estas rutas:

seguimiento_comprobante.php
includes/order_pdf_professional_2pages.php
includes/expense_cfdi.php
database/sql/022_expense_cfdi_documents.sql

IMPORTANTE
==========
- No incluye instaladores temporales.
- No incluye archivos .bak.
- No reemplaza seguimiento.php, porque la versión V2 ya fue confirmada como
  instalada y funcionando.
- No reemplaza admin/orden_pdf_2paginas.php, porque el controlador ya está
  presente y referencia el renderer compartido.
- La migración 022 solo debe ejecutarse una vez y únicamente si la tabla aún
  no existe.

VALIDACIÓN
==========
Los archivos PHP incluidos se validan con php -l antes de empaquetar.
El ZIP se verifica después de crearse.
