#!/bin/bash

STATE_FILE="/tmp/notif_estado"
estado="open"

# Si existe el archivo, léelo
if [[ -f "$STATE_FILE" ]]; then
    estado=$(<"$STATE_FILE")
fi

# Si pasamos --toggle, cambiamos el estado
if [[ "$1" == "--toggle" ]]; then
    if [[ "$estado" == "open" ]]; then
        eww close control_center
        # Aquí iría tu comando para desactivar notificaciones
        echo "close" > "$STATE_FILE"
    else
        # Aquí iría tu comando para activar notificaciones
        eww open control_center
        echo "open" > "$STATE_FILE"
    fi
fi