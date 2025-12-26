#!/bin/bash

# Archivo donde se guarda el tipo de fondo de pantalla y su URL
ARCHIVO_CONFIGURACION=~/.config/scripts/wallpaper/vars.txt

# Función para cambiar solo los colores usando `matugen`
change_color() {
    # Detectar el modo de color en GNOME (puedes ajustar esta parte para tu entorno)
    MODE=$(gsettings get org.gnome.desktop.interface color-scheme)

    if [[ "$MODE" == "'prefer-dark'" ]]; then
        MATUGEN_MODE="dark"
    else
        MATUGEN_MODE="light"
    fi

    # Cambiar los colores usando `matugen` con el archivo de configuración que me proporcionaste
    matugen image "$1" -c "/home/$USER/.config/matugen/config-not-wallpaper.toml" -t scheme-tonal-spot -m "$MATUGEN_MODE"
    
    # Si usas `kitty`, enviar la señal para aplicar los cambios de color
    kill -SIGUSR1 $(pidof kitty)
}

# Función para actualizar solo la URL del fondo de pantalla en el archivo de configuración
update_wallpaper_url() {
    local archivo_url="$1"

    # Usamos sed para reemplazar solo la URL del fondo de pantalla en el archivo de configuración
    sed -i "s|^WALLPAPER_URL=.*|WALLPAPER_URL=$archivo_url|" "$ARCHIVO_CONFIGURACION"
}

# Función para reiniciar elementos como waybar y eww (si es necesario)
reset_elements() {
    pkill waybar
    eww reload
    waybar &
}

# Solicitar al usuario seleccionar un archivo de imagen o video
archivo=$(zenity --file-selection --title="Selecciona una imagen  para el fondo de pantalla" --file-filter="Imágenes | *.png *.jpg *.jpeg")

# Si no se seleccionó ningún archivo, salimos
if [ -z "$archivo" ]; then
    notify-send "Fondo de pantalla" "No se ha seleccionado ningún archivo."
    exit 1
fi

# Actualizar solo la URL del fondo de pantalla en el archivo de configuración
update_wallpaper_url "$archivo"

# Cambiar los colores con `matugen`
change_color "$archivo"

# Reiniciar elementos si es necesario
reset_elements

# Notificación de éxito
notify-send "Fondo de pantalla" "La URL del fondo de pantalla ha sido actualizada y los colores cambiados."
