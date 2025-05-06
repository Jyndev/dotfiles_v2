#!/bin/bash
# Función para mostrar el cuadro de diálogo con la lista de opciones
show_dialog() {
     # Usamos Zenity para crear una lista con opciones en formato de selección única (radiolist)
    zenity --list \
        --radiolist \
        --height=400 \
        --width=700 \
        --title="¡Hola!, $USER" \
        --text="Selecciona una de las opciones disponibles:" \
        --column="" \
        --column="Nombre" \
        --column="Descripción" \
        FALSE "Fondo Inicio de Sesion" "Cambia el fondo de pantalla de inicio de sesion" \
        TRUE "Fondo de pantalla" "Cambia el fondo de pantalla junto a los colores" \
        FALSE "Video de fondo" "Cambia el fondo de pantalla a un video" \
        FALSE "Solo fondo de pantalla" "Cambia solo el fondo de pantalla conservando los colores" \
        FALSE "Colores de interfaz" "Cambia el esquema de colores subiendo una imagen"
}