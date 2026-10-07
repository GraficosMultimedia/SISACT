<?php
// Ejemplo seguro. NO coloques secretos en el repositorio público.
return [
    'client_key' => getenv('sbawjd2mfh91nif35r') ?: '',
    'client_secret' => getenv('K25rRkxBdQwTd77eQhoQ4XppgNiionF8') ?: '',
    'redirect_uri' => getenv('https://colibriprint.com.mx/tiktok-callback/') ?: '',
];
