#!/bin/bash

get_mode() {
    MODE=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ "$MODE" == "'prefer-dark'" ]]; then
    echo true
    else
    echo false
    fi
}

toggle_mode() {
    MODE=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ "$MODE" == "'prefer-dark'" ]]; then
        notify-send "cambio en modo de color" "Se ha cambiado a modo claro, cambiará automáticamente al cambiar el fondo"
        gsettings set org.gnome.desktop.interface color-scheme "'prefer-light'"
    else
        notify-send "cambio en modo de color" "Se ha cambiado a modo oscuro, cambiará automáticamente al cambiar el fondo"
        gsettings set org.gnome.desktop.interface color-scheme "'prefer-dark'"
    fi
}

if [[ $1 == 'getmode' ]]; then get_mode; fi
if [[ $1 == 'togglemode' ]]; then toggle_mode; fi