#!/bin/bash

# Función que se encarga de cambiar el fondo de pantalla de inicio de sesión (SDDM)
wallpaper_sddm() {
    local dir="/usr/local/etc/sddm"
    if [ -d "$dir" ]; then
        # Selecciona una imagen
        local image
        image=$(zenity --file-selection --title="Selecciona una imagen para el fondo de SDDM" --file-filter="Imágenes | *.png *.jpg *.jpeg")

        if [ -z "$image" ]; then
            notify-send "Fondo de SDDM" "No se ha seleccionado ninguna imagen"
            return 1
        fi

        MODE=$(gsettings get org.gnome.desktop.interface color-scheme)

    if [[ "$MODE" == "'prefer-dark'" ]]; then
        MATUGEN_MODE="dark"
    else
        MATUGEN_MODE="light"
    fi

        name_image="${image##*/}"  # Obtiene el nombre de la imagen

        rm -r "$dir"/*  # Elimina los archivos dentro del directorio de SDDM
        cp "$image" "$dir"  # Copia la imagen al directorio de SDDM

        ln -sf "$dir/$name_image" "$dir/sddm_background"  # Crea un enlace simbólico al fondo de pantalla de SDDM

        # Cambiar los colores de SDDM usando matugen
        matugen image "$image" -c "/home/$USER/.config/matugen/config-sddm.toml" -t scheme-tonal-spot -m "$MATUGEN_MODE"

        # Crear un enlace simbólico para los colores de SDDM
        ln -sf "$dir/Colors.qml" "$dir/sddm_config_colors"

        notify-send "Fondo de SDDM" "Fondo de inicio de sesión cambiado exitosamente"
    else
        zenity --error --title="Error de configuración" --text="Los archivos necesarios para la ejecución de esta tarea no están configurados correctamente."
    fi
}

# Llamar a la función de fondo de pantalla de SDDM
wallpaper_sddm
