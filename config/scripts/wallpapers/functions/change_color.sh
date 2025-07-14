#!/bin/bash
# Función para cambiar el color del fondo usando `wal`
change_color() {
    matugen image "$1" -c "/home/$USER/.config/matugen/config-not-wallpaper.toml" -t scheme-tonal-spot -m "$MATUGEN_MODE"
    kill -SIGUSR1 $(pidof kitty)
}