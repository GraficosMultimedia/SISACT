<?php
declare(strict_types=1);
require_once __DIR__ . '/../config/runtime.php';

function setting_get(string $key, string $default = ''): string {
    try {
        $stmt = db()->prepare('SELECT setting_value FROM cp_settings WHERE setting_key=? LIMIT 1');
        $stmt->execute([$key]);
        $value = $stmt->fetchColumn();
        return $value === false || $value === null ? $default : (string)$value;
    } catch (Throwable $e) {
        return $default;
    }
}

function setting_set(string $key, ?string $value): void {
    $stmt = db()->prepare('INSERT INTO cp_settings(setting_key,setting_value,created_at,updated_at) VALUES(?,?,NOW(),NOW()) ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value),updated_at=NOW()');
    $stmt->execute([$key, $value]);
}

function company_profile(): array {
    $defaults = [
        'name' => 'Colibrí Print México',
        'slogan' => 'Ideas que se hacen realidad',
        'description' => 'Soluciones de impresión, publicidad y personalización para personas, negocios y empresas.',
        'legal_name' => 'Colibrí Print México',
        'trade_name' => 'Colibrí Print',
        'rfc' => '',
        'tax_regime' => '',
        'phone' => '',
        'whatsapp' => '',
        'email' => '',
        'website' => 'https://colibriprint.com.mx',
        'address' => '',
        'neighborhood' => '',
        'city' => 'Parral',
        'state' => 'Chihuahua',
        'postal_code' => '',
        'country' => 'México',
        'maps_url' => '',
        'logo_path' => '',
        'favicon_path' => '',
        'logo_pdf_path' => '',
        'color_primary' => '#ec0b63',
        'color_secondary' => '#0b2239',
        'color_accent' => '#16b7a4',
        'facebook' => '',
        'instagram' => '',
        'tiktok' => '',
        'youtube' => '',
        'seo_title' => 'Colibrí Print México | Impresión, publicidad y personalización',
        'seo_description' => 'Soluciones de impresión, publicidad y personalización desde Parral, Chihuahua para todo México.',
        'seo_keywords' => '',
        'seo_schema' => '',
        'quote_footer' => 'Este documento es una cotización comercial y no sustituye un comprobante fiscal digital (CFDI).',
        'commercial_terms' => '',
        'payment_info' => '',
        'payment_methods' => '',
    ];
    foreach ($defaults as $key => $default) {
        $defaults[$key] = setting_get('company.' . $key, $default);
    }
    return $defaults;
}
