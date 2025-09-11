#!/usr/bin/env bash

get_cpu_temperature() {
  temp=$(sensors 2>/dev/null | awk '/Package id 0/ {gsub(/\+|°C/,"",$4); print int($4); exit}')
  if [[ -z "$temp" ]]; then
    temp=$(sensors 2>/dev/null | awk '/Tctl/ {gsub(/\+|°C/,"",$2); print int($2); exit}')
  fi
  if [[ -z "$temp" && -r /sys/class/thermal/thermal_zone0/temp ]]; then
    temp=$(( $(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null) / 1000 ))
  fi
  echo "${temp:-N/A}"
}

temp=$(get_cpu_temperature)

# Verificar temperatura y mostrar advertencia con Zenity si es >= 80°C
if [[ "$temp" =~ ^[0-9]+$ && $temp -ge 59 ]]; then
  zenity --warning --title="¡Alerta de temperatura!" \
    --text="La temperatura del CPU ha alcanzado ${temp}°C. ¡Revisa la refrigeración!" &
fi
echo "${temp}"
