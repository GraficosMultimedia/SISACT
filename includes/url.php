<?php
declare(strict_types=1);

/**
 * Resolución centralizada de URL de Colibrí Print.
 *
 * Prioridad:
 *
 * 1. app.base_url configurado
 * 2. variable de entorno COLIBRI_BASE_URL
 * 3. detección automática desde la petición
 *
 * Compatible con:
 * - dominio raíz
 * - subcarpeta
 * - HTTPS
 * - Cloudflare
 * - LiteSpeed
 * - proxies/reverse proxies
 */

if (!function_exists('normalizeBaseUrl')) {

    function normalizeBaseUrl(string $url): string
    {
        $url = trim($url);

        if ($url === '') {
            return '';
        }

        return rtrim($url, '/');
    }
}


if (!function_exists('getForwardedValue')) {

    function getForwardedValue(string $key): string
    {
        $value = $_SERVER[$key] ?? '';

        if (!is_string($value)) {
            return '';
        }

        // Si viene una lista: "https,http"
        $value = explode(',', $value)[0];

        return trim($value);
    }
}


if (!function_exists('detectScheme')) {

    function detectScheme(): string
    {
        /*
         * Cloudflare / reverse proxy.
         */
        $forwardedProto = getForwardedValue('HTTP_X_FORWARDED_PROTO');

        if ($forwardedProto !== '') {
            $forwardedProto = strtolower($forwardedProto);

            if ($forwardedProto === 'https') {
                return 'https';
            }

            if ($forwardedProto === 'http') {
                return 'http';
            }
        }

        /*
         * Forwarded: proto=https
         */
        $forwarded = $_SERVER['HTTP_FORWARDED'] ?? '';

        if (is_string($forwarded) && $forwarded !== '') {

            if (preg_match('/proto=([^;,\s]+)/i', $forwarded, $match)) {

                $proto = strtolower(trim($match[1], '"'));

                if ($proto === 'https') {
                    return 'https';
                }

                if ($proto === 'http') {
                    return 'http';
                }
            }
        }

        /*
         * HTTPS estándar.
         */
        $https = $_SERVER['HTTPS'] ?? '';

        if (
            $https !== '' &&
            strtolower((string)$https) !== 'off' &&
            $https !== '0'
        ) {
            return 'https';
        }

        /*
         * Puerto HTTPS habitual.
         */
        $serverPort = (string)($_SERVER['SERVER_PORT'] ?? '');

        if ($serverPort === '443') {
            return 'https';
        }

        return 'http';
    }
}


if (!function_exists('detectHost')) {

    function detectHost(): string
    {
        /*
         * HTTP_HOST normalmente conserva el dominio original
         * incluso detrás de Cloudflare.
         */
        $host = $_SERVER['HTTP_HOST'] ?? '';

        if (!is_string($host)) {
            $host = '';
        }

        $host = trim($host);

        /*
         * Si no existe HTTP_HOST, intentamos SERVER_NAME.
         */
        if ($host === '') {
            $host = (string)($_SERVER['SERVER_NAME'] ?? '');
        }

        /*
         * Seguridad:
         * eliminamos cualquier puerto extraño y caracteres
         * que no correspondan a un hostname.
         */
        $host = preg_replace('/[^a-zA-Z0-9.\-:\[\]]/', '', $host);

        return trim((string)$host);
    }
}


if (!function_exists('detectBasePath')) {

    function detectBasePath(): string
    {
        /*
         * Si estamos en:
         *
         * /public_html/index.php
         *
         * normalmente no existe subcarpeta.
         *
         * Si estamos en:
         *
         * /public_html/colibri/index.php
         *
         * queremos:
         *
         * /colibri
         */

        $documentRoot = $_SERVER['DOCUMENT_ROOT'] ?? '';
        $documentRoot = is_string($documentRoot)
            ? realpath($documentRoot)
            : false;

        /*
         * Este archivo está:
         *
         * /includes/url.php
         *
         * Por eso el proyecto está un nivel arriba.
         */
        $projectRoot = realpath(__DIR__ . '/..');

        if (
            $documentRoot === false ||
            $projectRoot === false
        ) {
            return '';
        }

        $documentRoot = rtrim(
            str_replace('\\', '/', $documentRoot),
            '/'
        );

        $projectRoot = rtrim(
            str_replace('\\', '/', $projectRoot),
            '/'
        );

        /*
         * El proyecto está dentro del document root.
         */
        if (
            $projectRoot === $documentRoot ||
            str_starts_with(
                $projectRoot . '/',
                $documentRoot . '/'
            )
        ) {

            $relative = substr(
                $projectRoot,
                strlen($documentRoot)
            );

            $relative = trim(
                str_replace('\\', '/', $relative),
                '/'
            );

            if ($relative !== '') {
                return '/' . $relative;
            }
        }

        return '';
    }
}


if (!function_exists('resolveBaseUrl')) {

    function resolveBaseUrl(?array $config = null): string
    {
        $config ??= [];

        /*
         * 1. Configuración explícita.
         */
        $configured = $config['app']['base_url'] ?? '';

        if (is_string($configured)) {
            $configured = normalizeBaseUrl($configured);

            if ($configured !== '') {
                return $configured;
            }
        }

        /*
         * 2. Variable de entorno.
         *
         * Útil en producción sin modificar código.
         */
        $environment = getenv('COLIBRI_BASE_URL');

        if (
            $environment !== false &&
            trim($environment) !== ''
        ) {
            return normalizeBaseUrl($environment);
        }

        /*
         * 3. Detección automática.
         */
        $scheme = detectScheme();
        $host   = detectHost();

        if ($host === '') {
            return '';
        }

        $basePath = detectBasePath();

        return $scheme . '://' . $host . $basePath;
    }
}


if (!function_exists('url')) {

    function url(
        string $path = '',
        ?array $config = null
    ): string {

        $base = resolveBaseUrl($config);

        $path = trim($path);

        if ($path === '') {
            return $base;
        }

        return $base . '/' . ltrim($path, '/');
    }
}


if (!function_exists('assetUrl')) {

    function assetUrl(
        string $path,
        ?array $config = null
    ): string {

        return url($path, $config);
    }
}