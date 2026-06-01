#!/bin/bash

STATE_FILE="/tmp/polybar_weather_state"
CACHE_FILE="/tmp/polybar_weather_cache"
REFRESH_INTERVAL=3600  # 30 min

WEATHER_CMD="$HOME/.config/polybar/weather/weather.sh"

refresh_cache() {
  local out
  out="$("$WEATHER_CMD" 2>/dev/null)"
  # Si la commande renvoie quelque chose, on met à jour le cache
  if [ -n "$out" ]; then
    printf "%s\n" "$out" > "$CACHE_FILE"
  fi
}

# 1) (Ré)générer le cache si :
#    - il n'existe pas (ex: /tmp vidé)
#    - il a > 30 min
if [ ! -f "$CACHE_FILE" ] || [ "$1" = "touch" ]; then
  refresh_cache
else
  now=$(date +%s)
  mtime=$(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)
  age=$(( now - mtime ))
  if [ "$age" -ge "$REFRESH_INTERVAL" ]; then
    refresh_cache
  fi
fi

# 2) Lire la sortie (ville + météo) depuis le cache
OUTPUT="$(cat "$CACHE_FILE" 2>/dev/null)"
CITY=$(echo "$OUTPUT"   | sed -n '1p')
WEATHER=$(echo "$OUTPUT"| sed -n '2p')

# 3) État pour le toggle
if [ ! -f "$STATE_FILE" ]; then
  echo "weather" > "$STATE_FILE"
fi
STATE=$(cat "$STATE_FILE" 2>/dev/null)

# 4) Gestion du toggle
if [ "$1" = "toggle" ]; then
  if [ "$STATE" = "weather" ]; then
    echo "city" > "$STATE_FILE"
    echo "$CITY"
  else
    echo "weather" > "$STATE_FILE"
    echo "$WEATHER"
  fi
else
  # Affichage normal selon l’état
  if [ "$STATE" = "weather" ]; then
    echo "$WEATHER"
  else
    echo "$CITY"
  fi
fi
