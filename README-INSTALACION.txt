SISACT · DESIGN SYSTEM
MÓDULO 3: ÓRDENES WORKSPACE
Colibrí Print México

REVISIÓN DEL REPOSITORIO
========================
Se revisó antes de crear el paquete:
- admin/ordenes.php actual en GitHub;
- assets/css/ordenes.css actual;
- assets/css/sisact-design-system-v1.css actual.

Hallazgo principal:
La tabla actual tiene min-width:1050px y el CSS móvil todavía conserva
min-width:900px. Por eso en teléfono se comporta como tabla de escritorio
comprimida/desplazable.

Este paquete corrige ese problema sin cambiar el funcionamiento.

ARCHIVOS
========
admin/ordenes.php
  Basado en la lógica actual de GitHub.

assets/css/sisact-design-system-v1.css
  Design System ya aprobado.

assets/css/ordenes-workspace-professional-v1.css
  Nueva capa visual específica del listado de órdenes.

FUNCIONES QUE SE CONSERVAN
==========================
- require_auth();
- búsqueda por orden/cotización/cliente/teléfono;
- filtro por estado;
- fecha desde/hasta;
- límite de 200 registros;
- conteos por estado;
- cancelación de orden;
- transacción de cancelación;
- historial cp_order_history;
- log_activity();
- CSRF;
- enlace a orden;
- enlace a cotización;
- enlace a seguimiento;
- acceso a Producción;
- Nueva orden.

ÚNICO DATO VISUAL NUEVO
=======================
Una orden activa con due_date anterior a hoy recibe la marca visual
"Entrega vencida". No se cambia su estado, no se escribe en BD y no se ejecuta
ninguna acción automática.

DESKTOP
=======
- Cabecera profesional.
- KPIs compactos.
- Filtros más ordenados.
- Tabla con mejor densidad y jerarquía.
- Estado, total y acciones más claros.

MÓVIL
=====
La tabla deja de conservar ancho de escritorio.
Cada <tr> se presenta como tarjeta sin duplicar registros ni consultas.

Cada tarjeta muestra:
- Orden.
- Cliente y teléfono.
- Cotización.
- Fecha.
- Entrega.
- Responsable.
- Estado.
- Total.
- Ver orden.
- Seguimiento.
- Cancelar cuando corresponde.

Controles:
- inputs/selects de 50px;
- fuente de formulario 16px para evitar zoom automático;
- botones de 48-50px;
- sin scroll horizontal de la tabla.

CACHE
=====
admin/ordenes.php carga:
sisact-design-system-v1.css?v=1.0.1
ordenes-workspace-professional-v1.css?v=1.0.0

INSTALACIÓN
===========
1. Respaldar admin/ordenes.php.
2. Copiar los archivos respetando la estructura.
3. Reemplazar admin/ordenes.php.
4. Copiar/actualizar ambos CSS.
5. Ctrl+F5 una vez.

PRUEBAS
=======
- escritorio;
- 360px;
- 390px;
- 430px;
- búsqueda;
- filtros;
- fechas;
- orden pendiente;
- en proceso;
- completada;
- entregada;
- cancelada;
- orden con entrega vencida;
- Ver orden;
- Seguimiento;
- Cancelar.

REVERSIÓN
=========
Restaurar admin/ordenes.php.
ordenes-workspace-professional-v1.css puede permanecer sin efecto porque solo
se carga en esta pantalla.
