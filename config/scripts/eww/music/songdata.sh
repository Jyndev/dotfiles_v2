#!/usr/bin/env bash

capitalize () {
  toshow="$1"
  maxlen="$2"

  sufix=""

  if test $(echo "$toshow" | wc -c) -ge $maxlen ; then
    sufix=" ..."
  fi

  echo "${toshow:0:$maxlen}$sufix"
}

withSafe () {
  local txt="$1"
  local safe="$2"
  if [[ $txt == "" ]]; then
    echo "$safe"
  else
    echo "$txt"
  fi
}

ms_to_hms () {
  local input="$1"

  # Si es solo números → asumimos microsegundos
  if [[ "$input" =~ ^[0-9]+$ ]]; then
    local total_sec=$((input / 1000000))
    local h=$((total_sec / 3600))
    local m=$(((total_sec % 3600) / 60))
    local s=$((total_sec % 60))
    printf "%02d:%02d:%02d\n" $h $m $s

  # Si es mm:ss → convertir a hh:mm:ss
  elif [[ "$input" =~ ^[0-9]+:[0-9]{2}$ ]]; then
    local m=${input%:*}
    local s=${input#*:}
    printf "00:%02d:%02d\n" $m $s

  else
    echo "00:00:00"
  fi
}

format_duration () {
  local input="$1"

  # Si es solo dígitos → microsegundos
  if [[ "$input" =~ ^[0-9]+$ ]]; then
    local total_sec=$((input / 1000000))
    local h=$((total_sec / 3600))
    local m=$(((total_sec % 3600) / 60))
    local s=$((total_sec % 60))

    if (( h > 0 )); then
      printf "%d:%02d:%02d\n" "$h" "$m" "$s"
    else
      printf "%02d:%02d\n" "$m" "$s"
    fi

  # Si ya viene en formato hh:mm:ss o mm:ss
  elif [[ "$input" =~ ^[0-9]+:[0-9]{2}(:[0-9]{2})?$ ]]; then
    # Normalizar: si tiene horas → dejar igual, si no → mm:ss
    IFS=: read -r a b c <<< "$input"
    if [[ -n "$c" ]]; then
      # hh:mm:ss
      echo "$a:$b:$c"
    else
      # mm:ss
      printf "%02d:%02d\n" "$a" "$b"
    fi
  else
    echo "00:00"
  fi
}



case "$1" in
  title)
    capitalize "$(playerctl metadata --format "{{title}}" 2>/dev/null || echo "Not playing")" 30
    ;;
  artist)
    withSafe "$(capitalize "$(playerctl metadata --format "{{artist}}" 2>/dev/null || echo "No artist")" 18)" "No artist detected"
    ;;
  status)
    playerctl status 2>/dev/null || echo "Paused"
    ;;
duration)
  dur=$(playerctl metadata --format "{{duration(mpris:length)}}" 2>/dev/null)
  if [[ -n "$dur" ]]; then
    format_duration "$dur"
  else
    echo "00:00"
  fi
  ;;

  player)
    raw=$(playerctl -l 2>/dev/null | head -n1 || echo "unknown")

    case "$raw" in
      chromium.*) echo "Chromium" ;;
      firefox.*) echo "Firefox" ;;
      brave.*) echo "Brave" ;;
      mpv) echo "MPV" ;;
      spotify) echo "Spotify" ;;
      vlc) echo "VLC" ;;
      *) echo "$raw" ;;
    esac
    ;;
  *)
    echo "Uso: $0 {title|artist|status|duration|player}"
    ;;
esac
