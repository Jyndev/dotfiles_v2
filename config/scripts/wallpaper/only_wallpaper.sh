#!/bin/bash

# Archivo donde se guarda el tipo de fondo de pantalla y su URL
ARCHIVO_CONFIGURACION=~/.config/scripts/wallpaper/vars.txt

# Función para leer las variables del archivo de configuración
leer_variables() {
    # Protege la variable con comillas en caso de que haya espacios
    source "$ARCHIVO_CONFIGURACION"
    echo "$METHOD"
}

# Obtiene el método de fondo de pantalla que se está utilizando
METODO_FONDO=$(leer_variables)

# Función para cambiar el fondo de pantalla con `swww` y la transición personalizada
wallpaper() {
    if [[ "$1" =~ \.(png|jpg|jpeg|gif)$ ]]; then
        if [ "$METODO_FONDO" == "video" ]; then
            pkill mpvpaper # Detener el proceso de video
            swww-daemon &   # Iniciar el daemon de swww
        fi
        # Si es una imagen o GIF, usar swww para cambiar el fondo con transición
        swww img "$1" --transition-type "outer" --transition-pos "0.854,0.977" --transition-step 90
        # Guarda los datos en el archivo de configuración
        echo "METHOD=wallpaper" > "$ARCHIVO_CONFIGURACION"
        echo "WALLPAPER_URL=$archivo" >> "$ARCHIVO_CONFIGURACION"
        eww open bg-panel

    elif [[ "$1" =~ \.mp4$ ]]; then
     if [ "$METODO_FONDO" == "wallpaper" ]; then
            pkill swww-daemon # Detener el daemon de swww
        fi
        # Si es un video, usar mpvpaper para establecer el fondo de pantalla
        name_video="${1##*/}" # Obtiene el nombre del video
        rm -r ~/.cache/liveWallpaper/* # Elimina los archivos dentro de la cache
        cp "$1" ~/.cache/liveWallpaper/wallpaper.mp4 # Copia el video a la cache
        ffmpeg -y -i "$1" -ss 00:00:01 -vframes 1 "$HOME/.cache/liveWallpaper/wall-video.jpg" # Genera una imagen del video

        # Establece la imagen generada como fondo con transición
        swww img "$HOME/.cache/liveWallpaper/wall-video.jpg" --transition-type "outer" --transition-pos "0.854,0.977" --transition-step 90
        nohup mpvpaper -o "--loop-file=inf" '*' ~/.cache/liveWallpaper/wallpaper.mp4 > /dev/null 2>&1 & disown
        eww open bg-panel
        echo "METHOD=video" > "$ARCHIVO_CONFIGURACION"
        echo "WALLPAPER_URL=$archivo" >> "$ARCHIVO_CONFIGURACION"
    else
        echo "Tipo de archivo no válido para fondo de pantalla."
        return 1
    fi
}

# Función para seleccionar un archivo con zenity
select_file() {
    zenity --file-selection --title="Selecciona una imagen, GIF o video" --file-filter="Imágenes y Videos | *.png *.jpg *.jpeg *.gif *.mp4"
}

# Función para cambiar el fondo de pantalla
change_wallpaper() {
    # Selección de archivo (imagen o video)
    local archivo
    archivo=$(select_file)

    if [ -z "$archivo" ]; then
        notify-send "Fondos de pantalla" "No se ha seleccionado ningún archivo"
        return 1
    fi

    # Cambiar el fondo de pantalla con el archivo seleccionado
    wallpaper "$archivo"

    # Se envía la notificación
    notify-send "Fondos de pantalla" "Se ha cambiado el fondo de pantalla"
}

# Llamar a la función para cambiar el fondo de pantalla
change_wallpaper
