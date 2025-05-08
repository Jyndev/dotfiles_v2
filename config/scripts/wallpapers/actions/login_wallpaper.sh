#!/bin/bash
# Funcion que se encarga de cambiar el fondo de pantalla de inicio de sesion
wallpaper_sddm() {
    local dir="/usr/local/etc/sddm"
    if [ -d "$dir" ] # Validar que todo este configurado exitosamente
    then
        # Selecciona una imagen
        local image
        image=$(select_file "Selecciona una imagen" "Imágenes" "*.png *.jpg *.jpeg")

        if [ "$image" == '' ]
        then
            notify "No se ha seleccionado ninguna imagen"
            return 1
        fi

        name_image="${image##*/}" # Obtien el nombre de la imagen

        rm -r "$dir"/* # Elimina los archivos dentro de la cache
        cp $image "$dir" # Copia la imagen a la cache

        ln -sf "$dir/$name_image" "$dir/sddm_background"  # Crea un enlace simbolico
        notify "Fondo de inicio de sesion cambiado exitosamente"
    else
        zenity --error --title="Error de configuracion" --text="Los archivos nesesarios para la ejecucion de esta tarea no estan configurados correctamente"
    fi
}