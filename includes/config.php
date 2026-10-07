<?php
declare(strict_types=1);

return [

    'app' => [
        'name' => 'Colibrí Print México',
        'short_name' => 'Colibrí Print',

        /*
         * VACÍO = detección automática.
         *
         * Si algún día necesitas forzar una URL concreta:
         *
         * 'base_url' => 'https://ejemplo.com',
         *
         * Pero normalmente debe permanecer vacío.
         */
        'base_url' => '',

        'timezone' => 'America/Chihuahua',
    ],

    'db' => [
        'host' => 'localhost',
        'name' => 'colibrip_abcsistema',
        'user' => 'colibrip_siscar',
        'pass' => 'DpNH?av%K^%tjw5l',
        'charset' => 'utf8mb4',
    ],

    'akaunting' => [
        'host' => 'localhost',
        'name' => 'colibrip_akau488',
        'user' => 'colibrip_siscar',
        'pass' => 'DpNH?av%K^%tjw5l',
        'charset' => 'utf8mb4',
        'prefix' => 'ak4s_',
    ],

    'security' => [
        'session_name' => 'colibri_admin',
    ],

    'whapi' => [
        'base_url' => 'https://gate.whapi.cloud',
        'token' => 'KTsQK0v6rR6rR37T7ZBKWeSxh7ruqOSX',
        'channel_id' => 'DEADPL-UAWN5',
        'timeout' => 15,
    ],

];