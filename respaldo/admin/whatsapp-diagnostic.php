<?php
declare(strict_types=1);

// Standalone diagnostic page. If your existing admin has a global layout,
// you can include this page's contents there instead.
require_once __DIR__ . '/../api/whatsapp/lib/bootstrap.php';

start_admin_session();
?>
<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>WhatsApp Center · Diagnóstico</title>
    <link rel="stylesheet" href="assets/whatsapp-center.css">
</head>
<body>
<main class="wa-shell">
    <header class="wa-header">
        <div>
            <span class="eyebrow">COLIBRÍ PRINT · WHATSAPP CENTER</span>
            <h1>Centro de diagnóstico</h1>
            <p>Infraestructura, Whapi, WhatsApp Business, webhook y Status.</p>
        </div>
        <button id="refreshBtn" class="btn btn-primary">↻ Ejecutar diagnóstico</button>
    </header>

    <section class="grid" id="healthCards">
        <article class="card"><span class="muted">Sistema</span><strong id="systemState">—</strong></article>
        <article class="card"><span class="muted">Base de datos</span><strong id="dbState">—</strong></article>
        <article class="card"><span class="muted">Whapi</span><strong id="whapiState">—</strong></article>
        <article class="card"><span class="muted">Business</span><strong id="businessState">—</strong></article>
        <article class="card"><span class="muted">Webhook</span><strong id="webhookState">—</strong></article>
        <article class="card"><span class="muted">Mensajes locales</span><strong id="messageCount">—</strong></article>
    </section>

    <section class="panel">
        <div class="panel-head">
            <div>
                <span class="eyebrow">5A · HEALTH</span>
                <h2>Respuesta técnica</h2>
            </div>
            <span id="lastCheck" class="muted">—</span>
        </div>
        <pre id="healthOutput">Cargando…</pre>
    </section>

    <section class="two-col">
        <article class="panel">
            <div class="panel-head">
                <div>
                    <span class="eyebrow">5B · BUSINESS</span>
                    <h2>Perfil WhatsApp Business</h2>
                </div>
                <button id="businessBtn" class="btn">Consultar</button>
            </div>
            <pre id="businessOutput">Pulsa Consultar.</pre>
        </article>

        <article class="panel">
            <div class="panel-head">
                <div>
                    <span class="eyebrow">5D · STATUS</span>
                    <h2>Prueba controlada</h2>
                </div>
            </div>
            <textarea id="storyText" rows="4" placeholder="Texto para un Status de prueba..."></textarea>
            <div class="actions">
                <button id="storyBtn" class="btn btn-primary">Publicar Status</button>
                <button id="webhookBtn" class="btn">Probar Webhook</button>
            </div>
            <pre id="actionOutput">Las acciones de publicación requieren sesión administrativa.</pre>
        </article>
    </section>

    <section class="panel">
        <div class="panel-head">
            <div>
                <span class="eyebrow">5E · OPERACIÓN</span>
                <h2>Enviar mensaje de prueba</h2>
            </div>
        </div>
        <div class="form-row">
            <input id="toNumber" placeholder="521XXXXXXXXXX">
            <input id="messageText" placeholder="Mensaje de prueba">
            <button id="sendBtn" class="btn btn-primary">Enviar</button>
        </div>
        <pre id="sendOutput">—</pre>
    </section>
</main>
<script src="assets/whatsapp-center.js"></script>
</body>
</html>
