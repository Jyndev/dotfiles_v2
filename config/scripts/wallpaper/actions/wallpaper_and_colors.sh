#!/bin/bash
# Función para cambiar el fondo de pantalla y los colores
change_wallpaper_color() {
    # Si el argumento es video, se detiene el proceso de mpvpaper
    if [ $METODO_FONDO == "video" ]
    then
        pkill mpvpaper &
        swww-daemon &
    fi

    local image
    image=$(select_file "Selecciona una imagen" "Imágenes" "*.png *.jpg *.jpeg *.gif")

    if [ "$image" == '' ]
    then
        notify "No se ha seleccionado ninguna imagen"
        return 1
    fi

    # En este caso en concreto, no hay nescesidad de copiar la imagen a la cache
    # ya que el comando swww se encarga de hacerlo
    wallpaper "$image" # Cambia el fondo de pantalla
    sleep 3 # Espera 3 segundos para que la transición se complete

    pkill waybar
    

    #change_color "$image" # Cambia los colores de la interfaz

    waybar & # Inicia waybar

    
    eww reload

    # Se crea un archivo de configuración con el método de fondo de pantalla
    echo "METHOD=wallpaper" > $ARCHIVO_CONFIGURACION

    notify "Se ha cambiado el fondo de pantalla y los colores"
}