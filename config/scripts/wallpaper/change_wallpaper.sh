#!/bin/bash

# Archivo donde se guarda el tipo de fondo de pantalla y su URL
ARCHIVO_CONFIGURACION="~/.config/scripts/wallpaper/vars.txt"

# Función para leer las variables del archivo de configuración
leer_variables() {
    # Protege la variable con comillas en caso de que haya espacios
    source "$ARCHIVO_CONFIGURACION"
    echo "$METHOD"
}

# Obtiene el método de fondo de pantalla que se está utilizando
METODO_FONDO=$(leer_variables)

# Función para cambiar el fondo de pantalla con `swww` y `matugen`
wallpaper() {
    matugen image "$1" -m "$MATUGEN_MODE" -t scheme-tonal-spot
    kill -SIGUSR1 "$(pidof kitty)"
}

# Función para cambiar el color con `matugen`
change_color() {
    matugen image "$1" -c "/home/$USER/.config/matugen/config-not-wallpaper.toml" -t scheme-tonal-spot -m "$MATUGEN_MODE"
    kill -SIGUSR1 "$(pidof kitty)"
}

# Función para mostrar notificaciones
notify() {
    notify-send "Fondos de pantalla" "$1"
}

# Función para reiniciar elementos como waybar y eww
reset_elements() {
    pkill waybar
    eww reload
    waybar &
}

# Función para cambiar el fondo de pantalla y los colores
change_wallpaper_color() {
    # Selección de archivo (imagen o video)
    local archivo
    archivo=$(select_file "Selecciona una imagen o video" "Imágenes y Videos" "*.png *.jpg *.jpeg *.gif *.mp4")

    if [ -z "$archivo" ]; then
        notify "No se ha seleccionado ningún archivo"
        return 1
    fi

    # Detectar el modo de color en GNOME
    MODE=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ "$MODE" == "'prefer-dark'" ]]; then
        MATUGEN_MODE="dark"
    else
        MATUGEN_MODE="light"
    fi

    # Detectar si el archivo es una imagen o un video
    if [[ "$archivo" =~ \.(png|jpg|jpeg|gif)$ ]]; then  # Es una imagen, usar el método de imagen
        if [ "$METODO_FONDO" == "video" ]; then
            pkill mpvpaper # Detener el proceso de video
            swww-daemon &   # Iniciar el daemon de swww
        fi
        wallpaper "$archivo" # Cambia el fondo de pantalla

        # Guarda los datos en el archivo de configuración
        echo "METHOD=wallpaper" > "$ARCHIVO_CONFIGURACION"
        echo "WALLPAPER_URL=$archivo" >> "$ARCHIVO_CONFIGURACION"

        # Reinicia para aplicar los colores
        reset_elements

        # Se envía la notificación
        notify "Se ha cambiado el fondo de pantalla a una imagen"

    elif [[ "$archivo" =~ \.mp4$ ]]; then  # Es un video, usar el método de video
        if [ "$METODO_FONDO" == "wallpaper" ]; then
            pkill swww-daemon # Detener el daemon de swww
        fi

        name_video="${archivo##*/}" # Obtiene el nombre del video
        rm -r ~/.cache/liveWallpaper/* # Elimina los archivos dentro de la cache
        cp "$archivo" ~/.cache/liveWallpaper/wallpaper.mp4 # Copia el video a la cache

        # Genera una imagen de vista previa del video
        ffmpeg -y -i "$archivo" -ss 00:00:01 -vframes 1 "$HOME/.cache/liveWallpaper/wall-video.jpg"

        change_color "$HOME/.cache/liveWallpaper/wall-video.jpg"
        nohup mpvpaper -o "--loop-file=inf" '*' ~/.cache/liveWallpaper/wallpaper.mp4 > /dev/null 2>&1 & disown
        

        echo "METHOD=video" > "$ARCHIVO_CONFIGURACION"
        echo "WALLPAPER_URL=$archivo" >> "$ARCHIVO_CONFIGURACION"

        eww open bg-panel 

        notify "Se ha cambiado a un fondo de pantalla con video"
        reset_elements
    else
        notify "El archivo seleccionado no es válido"
        return 1
    fi
}

# Función select_file para seleccionar archivos con zenity
select_file() {
    zenity --file-selection --title="$1" --file-filter="$2 | $3"
}

# Llamar a la función de cambio de fondo
change_wallpaper_color
