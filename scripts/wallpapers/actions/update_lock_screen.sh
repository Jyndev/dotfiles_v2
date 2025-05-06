#!/bin/bash
# Funcion que se encarga de cambiar el fondo de pantalla de hyprlock
change_locked() {
    # Valida que la configuracion este correcta
    if [ -d ~/.cache/hyprlock ]
    then
        # Selecciona una imagen
        local image
        image=$(select_file "Selecciona una imagen" "Imágenes" "*.png *.jpg *.jpeg")

        if [ "$image" == '' ]
        then
            notify "No se ha seleccionado ninguna imagen"
            return 1
        fi

        # Obtien el nombre de la imagen
        local name_image
        name_image="${image##*/}"

        rm -r ~/.cache/hyprlock/* # Elimina los archivos dentro de la cache
        cp $image ~/.cache/hyprlock/ # Copia la imagen a la cache

        echo "\$wallpaper = $HOME/.cache/hyprlock/$name_image" > ~/.cache/hyprlock/wallpaper.conf
        notify "El fondo de pantalla de bloqueo se ha cambiado exitosamente <span color='green'></span>"
    else
        zenity --error --title="Error de configuracion" --text="Los archivos nesesarios para la ejecucion de esta tarea no estan configurados correctamente"
    fi
}