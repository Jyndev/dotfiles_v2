#!/bin/bash

# Función para obtener volumen o "muted"
get_volume() {
  if pactl get-sink-mute @DEFAULT_SINK@ | grep -q "yes"; then
    echo "muted"
  else
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%'
  fi
}

# Mostrar el volumen actual al iniciar
get_volume

# Escuchar cambios en sinks
pactl subscribe | grep --line-buffered "on sink" | while read -r _; do
  get_volume
done
