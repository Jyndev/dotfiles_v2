#!/bin/bash

PORT=8080
PID_FILE="/tmp/pyserver_toggle.pid"

# Verifica si ya hay una instancia en ejecución
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        kill "$PID"
        notify-send "PyShare " "Servidor detenido"
        rm "$PID_FILE"
        exit 0
    else
        # PID guardado no existe
        rm "$PID_FILE"
    fi
fi

# Selección de carpeta con Zenity
DIR=$(zenity --file-selection --directory --title="Selecciona una carpeta para compartir")

# Verifica si se canceló
if [ -z "$DIR" ]; then
    exit 1
fi

# Ejecutar el servidor en segundo plano
python3 ~/.config/scripts/server/pyshare.py "$DIR" &
PID=$!
echo $PID > "$PID_FILE"

# Mostrar IP en notificación
IP=$(ip route get 1 | awk '{print $7; exit}')
notify-send "PyShare " "#raw Servidor iniciado: http://$IP:$PORT \n Carpeta: $DIR"


