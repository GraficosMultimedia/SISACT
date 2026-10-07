<?php
declare(strict_types=1);

function action_button(string $label, string $url, string $class = 'btn btn-sm btn-secondary', string $title = ''): string {
    $titleAttr = $title !== '' ? ' title="' . e($title) . '"' : '';
    return '<a class="' . e($class) . '" href="' . e($url) . '"' . $titleAttr . '>' . e($label) . '</a>';
}

function edit_button(string $url): string {
    return action_button('Editar', $url, 'btn btn-sm btn-edit', 'Editar registro');
}

function delete_button(string $url, string $message = '¿Seguro que deseas borrar este registro? Esta acción no se puede deshacer.'): string {
    return '<a class="btn btn-sm btn-delete" href="' . e($url) . '" data-confirm="' . e($message) . '" title="Borrar registro">Borrar</a>';
}

function cancel_button(string $url): string {
    return action_button('Cancelar', $url, 'btn btn-sm btn-cancel', 'Cancelar y volver');
}

function save_button(string $label = 'Guardar'): string {
    return '<button type="submit" class="btn btn-save">' . e($label) . '</button>';
}
