#!/bin/bash
# Funcion que se encarga de cambiar solo el fondo de pantalla
change_wallpaper() {
    # Si el argumento es video, se detiene el proceso de mpvpaper
    if [ $METODO_FONDO == "video" ]
    then
        pkill mpvpaper &
    fi

    # Selecciona una imagen
    local image
    image=$(select_file "Selecciona una imagen" "Imágenes" "*.png *.jpg *.jpeg")

    # Si no se selecciona ninguna imagen, se notifica al usuario
    if [ "$image" == '' ]
    then
        notify "No se ha seleccionado ninguna imagen"
        return 1
    fi

    swww img --transition-type outer --transition-pos 0.854,0.977 --transition-step 90 "$image"

    notify "Se ha cambiado solo el fondo de pantalla"

    # Se guarda el método de fondo de pantalla en un archivo de configuración
    echo "METHOD=wallpaper" > $ARCHIVO_CONFIGURACION
}