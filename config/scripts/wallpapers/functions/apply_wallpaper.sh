#!/bin/bash

# Función para cambiar el fondo de pantalla con `swww y matugen`
wallpaper() {
    matugen image "$1" -m "$MATUGEN_MODE" -t scheme-tonal-spot
    kill -SIGUSR1 $(pidof kitty)
}
