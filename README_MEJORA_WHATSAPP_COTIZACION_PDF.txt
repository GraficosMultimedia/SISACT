COLIBRÍ PRINT MÉXICO
MEJORA WHATSAPP + PDF PÚBLICO SEGURO DE COTIZACIÓN

Objetivo
Al pulsar “WhatsApp + PDF” desde una cotización, el sistema:
1) abre WhatsApp Web directamente con el mensaje preparado;
2) agrega un enlace público seguro al PDF de la cotización;
3) abre una vista previa del mismo PDF en otra pestaña para el operador;
4) evita el selector “Share on WhatsApp” del navegador;
5) no intenta adjuntar automáticamente un archivo a WhatsApp Web.

INSTALACIÓN

A. Ejecutar una sola vez:
database/migrations/014_whatsapp_quote_pdf_publico.sql

B. Reemplazar únicamente:
/admin/cotizacion.php
/admin/cotizacion_pdf.php
/includes/whatsapp.php

C. Crear/subir:
/cotizacion_pdf_publica.php
/includes/cotizacion_pdf_renderer.php

La migración crea cp_quote_public_tokens para generar enlaces de PDF de alta entropía, revocables y sin exponer la sesión administrativa.

PRUEBA
1. Abrir una cotización que tenga teléfono.
2. Pulsar “WhatsApp + PDF”.
3. WhatsApp Web debe abrirse directamente con el mensaje.
4. El mensaje debe incluir “📄 Ver cotización en PDF:” y una URL colibriprint.com.mx/cotizacion_pdf_publica.php?t=...
5. La otra pestaña debe mostrar el PDF.
6. Copiar la URL del PDF en una ventana incógnita. Debe abrir el PDF sin iniciar sesión.
7. La URL /admin/cotizacion_pdf.php?id=... continúa protegida para administración.

NOTA
El PDF se entrega al cliente mediante enlace seguro porque una página web normal no puede adjuntar silenciosamente el archivo dentro de una conversación de WhatsApp Web ya abierta.
