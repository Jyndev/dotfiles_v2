#!/bin/bash
# Funcion que se encarga de cambiar los colores de la interfaz
change_colors() {
    local image
    image=$(select_file "Selecciona una imagen" "Imágenes" "*.png *.jpg *.jpeg")

    if [ "$image" == '' ]
    then
        notify "No se ha seleccionado ninguna imagen"
        return 1
    fi

    # Se detienen los procesos de swww-daemon, waybar y swaync para evitar errores
    pkill waybar

    change_color "$image" # Cambia los colores de la interfaz con la imagen seleccionada

    # Se inician los procesos de swww-daemon, waybar y swaync
    waybar &
    eww reload

    # si el metodo de fondo de pantalla es wallpaper, se inicia el proceso de swww-daemon
    if [ $METODO_FONDO == "wallpaper" ]
    then
        swww-daemon &
    fi

    notify "Colores actualizados exitosamente"
}