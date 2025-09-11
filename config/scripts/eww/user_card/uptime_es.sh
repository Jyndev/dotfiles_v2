#!/bin/bash

# Obtener el tiempo de encendido (en inglés)
uptime_raw=$(uptime -p)

# Quitar la palabra "up"
uptime_clean=${uptime_raw#"up "}

# Traducciones básicas al español
translated=$(echo "$uptime_clean" | sed \
  -e 's/minute/minuto/g' \
  -e 's/minutes/minutos/g' \
  -e 's/hour/hora/g' \
  -e 's/hours/horas/g' \
  -e 's/day/día/g' \
  -e 's/days/días/g' \
  -e 's/,/,/g')

# Agregar prefijo si quieres
echo "Encendido $translated"
