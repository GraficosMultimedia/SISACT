SISACT · COTIZACIÓN PÚBLICA · OFERTAS V2

OBJETIVO
========
Mejorar la pantalla de cotización no vigente para que:
- use la identidad visual del home de Colibrí Print;
- se vea más viva y comercial;
- recupere la intención de compra;
- muestre productos/servicios actuales que el cliente puede aprovechar.

REEMPLAZA
=========
/cotizacion_pdf_publica.php

NO REQUIERE
===========
- SQL
- instalador
- cambios en otras rutas

FUNCIONALIDAD NUEVA
===================
1. Hero oscuro con colores del home:
   - azul marino
   - rosa/fucsia
   - cyan
   - acentos dorados

2. CTA principales:
   - Solicitar nueva cotización
   - Ver productos y servicios
   - Ir al sitio principal

3. Extra plus comercial:
   - tarjetas de productos/ofertas actuales
   - bloque “¿Qué sigue?”
   - bloque de contacto rápido

4. Sección editable:
   La función qpv2_products() contiene las tarjetas de servicios
   destacadas y puede modificarse fácilmente más adelante.

FUNCIONALIDAD CONSERVADA
========================
Si el token es válido:
- sigue actualizando last_access_at
- sigue usando quote_items()
- sigue usando quote_totals()
- sigue generando el PDF inline
- no altera la lógica de cotizaciones válidas

GITHUB
======
Después de aprobar, subir:
- cotizacion_pdf_publica.php
