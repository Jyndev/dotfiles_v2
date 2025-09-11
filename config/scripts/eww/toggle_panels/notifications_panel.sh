#!/bin/bash

STATE_FILE="/tmp/notifications_panel_state"
OTHER_STATE_FILE="/tmp/notif_estado"
estado="close"

# Leer estado actual
[[ -f "$STATE_FILE" ]] && estado=$(<"$STATE_FILE")

if [[ "$1" == "--toggle" ]]; then
    if [[ "$estado" == "open" ]]; then
        # Cerrar este panel
        eww update show_panel_notifications=false
        echo "close" > "$STATE_FILE"
    else
        # Cerrar el otro panel si está abierto
        if [[ -f "$OTHER_STATE_FILE" ]] && [[ $(<"$OTHER_STATE_FILE") == "open" ]]; then
            eww update show_control_center=false
            echo "close" > "$OTHER_STATE_FILE"
        fi

        # Abrir este panel
        eww update show_panel_notifications=true
        echo "open" > "$STATE_FILE"
    fi
fi
