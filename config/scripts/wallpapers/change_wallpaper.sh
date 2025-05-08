#!/bin/bash
ARCHIVO_CONFIGURACION=~/.config/scripts/wallpapers/configs/wallpaper_method.txt

TITULO_APP="HyprDev"
ICONO_APP="󰅭"

source ~/.config/scripts/wallpapers/functions/menu_dialog.sh
source ~/.config/scripts/wallpapers/functions/selection_dialog.sh
source ~/.config/scripts/wallpapers/functions/notifications.sh
source ~/.config/scripts/wallpapers/functions/apply_wallpaper.sh
source ~/.config/scripts/wallpapers/functions/change_color.sh

source ~/.config/scripts/wallpapers/actions/wallpaper_and_colors.sh
source ~/.config/scripts/wallpapers/actions/update_colors.sh
source ~/.config/scripts/wallpapers/actions/only_wallpaper.sh
source ~/.config/scripts/wallpapers/actions/update_lock_screen.sh
source ~/.config/scripts/wallpapers/actions/login_wallpaper.sh
source ~/.config/scripts/wallpapers/actions/update_video.sh


# Funcion para leer las variables del archivo de configuracion
# Que contiene el tipo de fondo de pantalla que se esta utilizando
leer_variables() {
    source $ARCHIVO_CONFIGURACION
    echo $METHOD
}

# Obtiene el metodo de fondo de pantalla que se esta utilizando
METODO_FONDO=$(leer_variables)

# Bucle principal para mantener la interacción hasta que el usuario decida salir
while true; do
    # Llama a la función show_dialog y almacena la opción seleccionada en la variable 'selected_item'
    selected_item=$(show_dialog)

    # Si el usuario cierra el cuadro de diálogo o presiona cancelar, salimos del script
    [ $? -ne 0 ] && { exit 0; }

    # Detecta el modo de GNOME
    MODE=$(gsettings get org.gnome.desktop.interface color-scheme)
    if [[ "$MODE" == "'prefer-dark'" ]]; then
    MATUGEN_MODE="dark"
    else
    MATUGEN_MODE="light"
    fi


    # Maneja la opción seleccionada mediante un bloque case
    case "$selected_item" in
        "Fondo de bloqueo")
            change_locked
            ;;
        "Fondo Inicio de Sesion")
            wallpaper_sddm
            ;;
        "Fondo de pantalla") 
            change_wallpaper_color # Llama a la función para cambiar fondo y colores (a implementar)
            ;;
        "Solo fondo de pantalla")
            change_wallpaper  # Llama a la función para cambiar solo el fondo (a implementar)
            ;;
        "Video de fondo")
            change_video
            ;;
        "Colores de interfaz") 
            change_colors  # Llama a la función para cambiar solo los colores (a implementar)
            ;;
        *) 
            echo "Selección no válida."  # Maneja cualquier caso no esperado
            ;;
    esac

    # Pregunta al usuario si desea realizar otra acción
    if zenity --question --title="󰣇" --text="¿Quieres hacer algo mas?" --ok-label="Sí" --cancel-label="No"; then
        continue  # Si el usuario elige "Sí", reinicia el bucle
    else
        break  # Si el usuario elige "No", sale del bucle
    fi
done 