#!/bin/bash

while true; do
    # Obtener posición (en microsegundos) y duración (en microsegundos) del reproductor actual
    metadata=$(playerctl metadata -f "{{position}} {{mpris:length}} {{playerName}}" 2>/dev/null)
    if [[ -z "$metadata" ]]; then
        # No hay reproductor activo
        echo '{"": {"position": "", "positionStr": ""}}'
        sleep 1
        continue
    fi

    read -r position_micro length_micro player <<< "$metadata"

    # Validar que no estén vacíos y sean números
    if ! [[ "$position_micro" =~ ^[0-9]+$ ]] || ! [[ "$length_micro" =~ ^[0-9]+$ ]]; then
        echo '{"": {"position": "", "positionStr": ""}}'
        sleep 1
        continue
    fi

    # Convertir microsegundos a segundos (redondeando)
    position_sec=$(( (position_micro + 500000) / 1000000 ))
    length_sec=$(( (length_micro + 500000) / 1000000 ))

    # Función para convertir segundos a formato mm:ss
    function seconds_to_mmss() {
        local total_sec=$1
        local min=$((total_sec / 60))
        local sec=$((total_sec % 60))
        printf "%d:%02d" "$min" "$sec"
    }

    positionStr=$(seconds_to_mmss $position_sec)
    lengthStr=$(seconds_to_mmss $length_sec)

    # Construir JSON con jq
    JSON_STRING=$( jq -cn \
    --arg player "$player" \
    --argjson position "$position_sec" \
    --arg length "$lengthStr" \
    --arg positionStr "$positionStr" \
    '{($player): {position: $position, positionStr: $positionStr, length: $length}}' )

    echo "$JSON_STRING"

    sleep 1
done
