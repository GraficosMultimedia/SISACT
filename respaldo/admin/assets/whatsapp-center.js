const $ = (id) => document.getElementById(id);

function pretty(data){ return JSON.stringify(data, null, 2); }

function state(ok, text = null){
    return `<span class="${ok ? 'state-ok' : 'state-bad'}">${text || (ok ? '● OK' : '● ERROR')}</span>`;
}

async function getJson(url, options = {}){
    const res = await fetch(url, {
        cache: 'no-store',
        credentials: 'same-origin',
        ...options,
        headers: {
            'Accept':'application/json',
            ...(options.headers || {})
        }
    });
    const data = await res.json().catch(() => ({ok:false,error:'Respuesta no JSON'}));
    return {res,data};
}

async function loadHealth(){
    $('healthOutput').textContent = 'Consultando…';

    const {data} = await getJson('../api/whatsapp/health.php');
    $('healthOutput').textContent = pretty(data);

    $('systemState').innerHTML = state(data.ok, data.ok ? '● HEALTHY' : '● DEGRADED');
    $('dbState').innerHTML = state(data.database?.connected, data.database?.connected ? '● CONECTADA' : '● ERROR');
    $('whapiState').innerHTML = state(data.whapi?.reachable, data.whapi?.reachable ? '● CONECTADO' : '● ERROR');
    $('messageCount').textContent = data.database?.whatsapp?.counts?.messages ?? '—';

    $('lastCheck').textContent = data.checked_at ? new Date(data.checked_at).toLocaleString() : '—';

    const wh = data.whapi?.health;
    if (wh && typeof wh === 'object') {
        $('webhookState').innerHTML = '● REVISAR';
    }
}

async function loadBusiness(){
    $('businessOutput').textContent = 'Consultando…';
    const {data} = await getJson('../api/whatsapp/business.php');
    $('businessOutput').textContent = pretty(data);
    $('businessState').innerHTML = state(data.ok, data.ok ? '● DISPONIBLE' : '● ERROR');
}

async function sendMessage(){
    const to = $('toNumber').value.trim();
    const body = $('messageText').value.trim();

    if(!to || !body){
        $('sendOutput').textContent = 'Completa número y mensaje.';
        return;
    }

    $('sendOutput').textContent = 'Enviando…';

    const {data} = await getJson('../api/whatsapp/send.php', {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({to,body})
    });

    $('sendOutput').textContent = pretty(data);
}

async function publishStory(){
    const body = $('storyText').value.trim();

    if(!body){
        $('actionOutput').textContent = 'Escribe el texto del Status.';
        return;
    }

    if(!confirm('Esto PUBLICARÁ un Status real en WhatsApp. ¿Continuar?')){
        return;
    }

    $('actionOutput').textContent = 'Publicando…';

    const {data} = await getJson('../api/whatsapp/stories.php', {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({body})
    });

    $('actionOutput').textContent = pretty(data);
}

async function testWebhook(){
    $('actionOutput').textContent = 'Probando webhook…';

    const {data} = await getJson('../api/whatsapp/webhook_test.php', {
        method:'POST',
        headers:{'Content-Type':'application/json'},
        body:JSON.stringify({type:'messages',mode:'body'})
    });

    $('actionOutput').textContent = pretty(data);
}

$('refreshBtn').addEventListener('click', loadHealth);
$('businessBtn').addEventListener('click', loadBusiness);
$('sendBtn').addEventListener('click', sendMessage);
$('storyBtn').addEventListener('click', publishStory);
$('webhookBtn').addEventListener('click', testWebhook);

loadHealth();
loadBusiness();
