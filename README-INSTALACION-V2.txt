SISACT — LOGIN PROFESIONAL COLIBRÍ PRINT MÉXICO
VERSIÓN 2

Este paquete está preparado para probarse manualmente en el servidor.
NO realiza ningún cambio en GitHub.

ARCHIVOS
========

admin/index.php
  Reemplaza el login actual.

assets/css/login-colibri.css
  Hoja de estilos V2.

assets/js/login-colibri.js
  Mostrar/ocultar contraseña, Recordarme y estado "Ingresando…".

assets/img/colibri-print-logo-dark.png
  Variante del logotipo optimizada específicamente para fondos oscuros.
  El ave y los colores de marca se conservan; la tipografía azul marino
  se adapta a claro para mejorar legibilidad en el login.

assets/img/colibri-print-logo-original.png
  Copia del logotipo original proporcionado por Colibrí Print México.

CAMBIOS PRINCIPALES DE V2
=========================

1. El logotipo ahora tiene contraste correcto sobre fondo azul oscuro.
2. Los campos de correo y contraseña son oscuros, como en el mockup aprobado.
3. Se corrigió el color blanco que Chrome/Edge aplican a campos autocompletados.
4. El fondo decorativo queda concentrado en bordes y esquinas.
5. La tarjeta de login es más ancha, profunda y con glow azul/magenta más sutil.
6. Mejora de contraste en textos secundarios e iconos.
7. Checkbox "Recordarme" más visible y coherente con la identidad.
8. Mejor equilibrio entre logo, título, funciones y formulario.
9. Responsive revisado para escritorio, tablet y móvil.

INSTALACIÓN
===========

1. Haz respaldo del archivo actual:
   admin/index.php

2. Copia el contenido de este ZIP a la raíz de SISACT respetando las carpetas.

3. Permite reemplazar:
   admin/index.php
   assets/css/login-colibri.css
   assets/js/login-colibri.js

4. Los archivos de assets/img pueden copiarse como nuevos.

5. Abre:
   /admin/

6. Si el navegador conserva CSS antiguo, usa Ctrl+F5.

PRUEBAS RECOMENDADAS
====================

- Login correcto.
- Contraseña incorrecta.
- Campo de correo autocompletado por Chrome/Edge.
- Mostrar/ocultar contraseña.
- Recordarme.
- Vista a 1920x1080.
- Vista a 1366x768.
- Vista móvil.

SEGURIDAD / LÓGICA
==================

No se modifica la lógica de:
- CSRF
- password_verify()
- usuarios habilitados
- roles
- session_regenerate_id()
- last_login_at
- log_activity()
- redirección al dashboard

"Recordarme" conserva únicamente el correo electrónico en el navegador.
No guarda la contraseña y no prolonga la sesión.

REVERSIÓN
=========

Si hubiera cualquier inconveniente, restaura el respaldo anterior de
admin/index.php. Los assets nuevos no afectan otras pantallas si no son
referenciados por el login.
