#!/bin/bash
ARCHIVO=~/.config/scripts/wallpapers/configs/wallpaper_method.txt
notificaciones() {
    notify-send "Carga inicial 󰘦" "$1"
}
verificar_archivo() {
    if [ ! -f $ARCHIVO ];
    then
        touch $ARCHIVO
        notificaciones "No hay configuraciones de fondo de pantalla almacenadas"
        source ~/.config/scripts/wallpapers/change_wallpaper.sh
    fi
}
leer_variables() {
    source $ARCHIVO
    echo $METHOD
}
verificar_archivo
metodo_fondo=$(leer_variables)
if [ $metodo_fondo == "wallpaper" ];
then
    source ~/.config/scripts/wallpapers/launchers/launch_swww.sh
    notificaciones "Normal $USER"
elif [ $metodo_fondo == "video" ];
then
    notificaciones "Video $USER"
    source ~/.config/scripts/wallpapers/launchers/launch_mpvpaper.sh
fi
notificaciones "Bienvenido a ArchLinux $USER"