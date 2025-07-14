#!/bin/bash

playerctl --follow metadata --format '{{position}} {{mpris:length}} {{playerName}}' | while read -r position length player; do
    # Convierte posición de nanosegundos a segundos
    position_sec=$(echo "($position + 500000) / 1000000" | bc)

    # Convierte a formato MM:SS
    mins=$((position_sec / 60))
    secs=$((position_sec % 60))
    positionStr=$(printf "%02d:%02d" $mins $secs)

    # Genera JSON en una sola línea
    jq -c -n \
      --arg position $position_sec \
      --arg positionStr "$positionStr" \
      --arg player "$player" \
      '{current: {position: $position, positionStr: $positionStr}}'
done
