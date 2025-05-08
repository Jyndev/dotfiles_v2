#!/bin/bash

# ======= CONFIGURACIÓN =======
max_intervalo=3600   # Máximo de segundos para esperar entre ejecuciones
max_duracion=1200    # Máximo de segundos que puede estar abierto el widget
nombre_widget="activate-linux"  # Nombre del widget de EWW
# ==============================

while true; do
    # Generar duración aleatoria entre 1 y max_duracion
    duracion=$(( (RANDOM % max_duracion) + 1 ))

    echo "Mostrando widget '$nombre_widget' (durante $duracion segundos)"

    # Mostrar el widget
    eww open "$nombre_widget" &
    pid=$!

    # Esperar la duración aleatoria
    sleep "$duracion"

    # Cerrar el widget
    echo "Cerrando widget '$nombre_widget'"
    eww close "$nombre_widget"

    # Asegurarse de matar el proceso abierto si sigue vivo
    if kill -0 "$pid" 2>/dev/null; then
        kill "$pid"
    fi

    # Generar un intervalo de espera aleatorio
    intervalo=$(( (RANDOM % max_intervalo) + 1 ))
    echo "Esperando $intervalo segundos antes de volver a mostrar..."
    sleep "$intervalo"
done
