# Autorizaciones de clientes v5

Corrección: las solicitudes CPQ que todavía no tienen cotización formal ahora aparecen en **Pendientes**. Antes el `INNER JOIN` con `cp_quotes` las ocultaba y el contador quedaba en 0.

Flujo:
1. Operación → Autorizaciones → Pendientes.
2. Ver solicitud o **Convertir en cotización**.
3. Una vez creada la cotización, vuelve a Autorizaciones.
4. Ahora aparecerá el botón **✓ Autorizar** para la cotización en estado borrador/enviada.

No modifica la base de datos.
Reemplaza únicamente `admin/autorizaciones.php` respecto al parche v4. `includes/header.php` permanece igual al v4.
