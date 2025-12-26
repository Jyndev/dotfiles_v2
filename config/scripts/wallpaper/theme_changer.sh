#!/bin/bash

# Archivo donde se guarda el tipo de fondo de pantalla y su URL
ARCHIVO_CONFIGURACION=~/.config/scripts/wallpaper/vars.txt

# Función para cambiar solo los colores usando `matugen`
change_color() {
    local image="$1"
    local mode="$2"
    
    # Cambiar los colores usando `matugen` con el archivo de configuración que me proporcionaste
    matugen image "$image" -c "/home/$USER/.config/matugen/config-not-wallpaper.toml" -t scheme-tonal-spot -m "$mode"
    
    # Si usas `kitty`, enviar la señal para aplicar los cambios de color
    kill -SIGUSR1 $(pidof kitty)
    
    # Notificación al usuario
    notify-send "Colores de interfaz" "Modo $mode activado."
}

# Función para obtener la URL del fondo de pantalla desde el archivo de configuración
get_wallpaper_url() {
    source "$ARCHIVO_CONFIGURACION"
    echo "$WALLPAPER_URL"
}

# Función para reiniciar procesos como waybar y eww
reset_elements() {
    pkill waybar
    waybar &
    eww reload

    # Esperar un poco para asegurarse de que los procesos se hayan reiniciado correctamente
    sleep 2
}

# Obtener la URL del fondo de pantalla
wallpaper_url=$(get_wallpaper_url)

# Verificar si se tiene una URL válida del fondo de pantalla
if [ -z "$wallpaper_url" ]; then
    notify-send "Error" "No se ha encontrado una URL de fondo de pantalla válida en el archivo de configuración."
    exit 1
fi

# Detectar el modo actual (oscuro o claro)
current_mode=$(gsettings get org.gnome.desktop.interface color-scheme)

if [[ "$current_mode" == "'prefer-dark'" ]]; then
    # Si está en modo oscuro, cambiar a modo claro
    new_mode="light"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
    # Si está en modo claro, cambiar a modo oscuro
    new_mode="dark"
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# Cambiar los colores con `matugen` según el nuevo modo
change_color "$wallpaper_url" "$new_mode"

# Reiniciar los procesos de waybar y eww
reset_elements

# Notificación final
notify-send "Fondo de pantalla" "El modo de color ha sido cambiado a $new_mode y los procesos de la interfaz han sido reiniciados."
