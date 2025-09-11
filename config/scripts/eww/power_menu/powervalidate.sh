#!/bin/bash

# Si no se pasa ningún argumento, solo cerrar el menú
if [[ -z "$1" ]]; then
    eww close powermenu powercorner-left powercorner-right
    exit 0
fi

ACTION="$1"

# Función de confirmación con retorno de código de salida correcto
confirm() {
    zenity --question --title="¿Estás seguro?" --text="$1"
    return $?
}

# Ejecutar acción según el argumento
case "$ACTION" in
    "poweroff")
        if confirm "¿Apagar el sistema?"; then
            systemctl poweroff
        fi
        ;;
    "reboot")
        if confirm "¿Reiniciar el sistema?"; then
            systemctl reboot
        fi
        ;;
    "lock")
        ~/.config/eww/scripts/powermenu.sh &  # Cierra el menú
        sleep 1
        hyprlock
        ;;
    "suspend")
        if confirm "¿Suspender el sistema?"; then
            gtklock &
            ~/.config/eww/scripts/powermenu.sh &  # Cierra el menú
            sleep 0.2
            systemctl suspend
        fi
        ;;
    "logout")
        if confirm "¿Cerrar sesión?"; then
            hyprctl dispatch exit 0
        fi
        ;;
    "cancel")
        ~/.config/eww/scripts/powermenu.sh &  # Cierra el menú
        ;;
    *)
        zenity --error --text="Acción no reconocida: $ACTION"
        ;;
esac
