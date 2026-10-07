<?php
declare(strict_types=1);

/*
|--------------------------------------------------------------------------
| COLIBRÍ PRINT
|--------------------------------------------------------------------------
| Configuración central del sistema de impresión.
|--------------------------------------------------------------------------
*/

/*
|--------------------------------------------------------------------------
| Aplicación
|--------------------------------------------------------------------------
*/

const CP_APP_NAME = 'Colibrí Print México';
const CP_APP_SHORT_NAME = 'Colibrí Print';
const CP_BASE_URL = '';
const CP_TIMEZONE = 'America/Chihuahua';


/*
|--------------------------------------------------------------------------
| Base de datos principal
|--------------------------------------------------------------------------
*/

const CP_DB_HOST = 'localhost';
const CP_DB_NAME = 'colibrip_abcsistema';
const CP_DB_USER = 'colibrip_siscar';
const CP_DB_PASS = 'DpNH?av%K^%tjw5l';
const CP_DB_CHARSET = 'utf8mb4';


/*
|--------------------------------------------------------------------------
| Akaunting
|--------------------------------------------------------------------------
*/

const CP_AKAUNTING_DB_HOST = 'localhost';
const CP_AKAUNTING_DB_NAME = 'colibrip_akau488';
const CP_AKAUNTING_DB_USER = 'colibrip_siscar';
const CP_AKAUNTING_DB_PASS = 'DpNH?av%K^%tjw5l';
const CP_AKAUNTING_DB_CHARSET = 'utf8mb4';
const CP_AKAUNTING_DB_PREFIX = 'ak4s_';


/*
|--------------------------------------------------------------------------
| Sesión
|--------------------------------------------------------------------------
*/

const CP_SESSION_NAME = 'colibri_admin';


/*
|--------------------------------------------------------------------------
| Archivos
|--------------------------------------------------------------------------
*/

const CP_UPLOAD_DIR = __DIR__ . '/../uploads/print_requests';
const CP_TMP_DIR = __DIR__ . '/../uploads/tmp';

const CP_MAX_FILE_BYTES = 25 * 1024 * 1024;


/*
|--------------------------------------------------------------------------
| Conexión PDO principal
|--------------------------------------------------------------------------
*/

function cp_db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $dsn =
        'mysql:host=' . CP_DB_HOST .
        ';dbname=' . CP_DB_NAME .
        ';charset=' . CP_DB_CHARSET;

    $pdo = new PDO(
        $dsn,
        CP_DB_USER,
        CP_DB_PASS,
        [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ]
    );

    return $pdo;
}


/*
|--------------------------------------------------------------------------
| Crear directorios necesarios
|--------------------------------------------------------------------------
*/

function cp_ensure_dirs(): void
{
    foreach (
        [
            CP_UPLOAD_DIR,
            CP_TMP_DIR,
        ] as $dir
    ) {
        if (!is_dir($dir)) {
            mkdir($dir, 0775, true);
        }
    }
}

cp_ensure_dirs();


/*
|--------------------------------------------------------------------------
| Configuración compatible con el sistema anterior
|--------------------------------------------------------------------------
|
| Algunos módulos pueden seguir utilizando:
|
| $config['app']
| $config['db']
| $config['akaunting']
| $config['security']
|
| Por eso conservamos esta estructura.
|--------------------------------------------------------------------------
*/

return [
    'app' => [
        'name'       => CP_APP_NAME,
        'short_name' => CP_APP_SHORT_NAME,
        'base_url'   => CP_BASE_URL,
        'timezone'   => CP_TIMEZONE,
    ],

    'db' => [
        'host'    => CP_DB_HOST,
        'name'    => CP_DB_NAME,
        'user'    => CP_DB_USER,
        'pass'    => CP_DB_PASS,
        'charset' => CP_DB_CHARSET,
    ],

    'akaunting' => [
        'host'    => CP_AKAUNTING_DB_HOST,
        'name'    => CP_AKAUNTING_DB_NAME,
        'user'    => CP_AKAUNTING_DB_USER,
        'pass'    => CP_AKAUNTING_DB_PASS,
        'charset' => CP_AKAUNTING_DB_CHARSET,
        'prefix'  => CP_AKAUNTING_DB_PREFIX,
    ],

    'security' => [
        'session_name' => CP_SESSION_NAME,
    ],

    'uploads' => [
        'print_requests' => CP_UPLOAD_DIR,
        'tmp'             => CP_TMP_DIR,
        'max_file_bytes'  => CP_MAX_FILE_BYTES,
    ],
];