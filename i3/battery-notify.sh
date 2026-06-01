#!/bin/bash

BATTERY="/sys/class/power_supply/BAT0/capacity"
STATUS="/sys/class/power_supply/BAT0/status"

LEVEL=$(cat "$BATTERY")
STATE=$(cat "$STATUS")

if [ "$STATE" = "Discharging" ]; then
    if [ "$LEVEL" -le 15 ]; then
        notify-send -u critical "🔋 Batterie faible" "Niveau : $LEVEL%"
    elif [ "$LEVEL" -le 30 ]; then
        notify-send -u normal "⚠️ Batterie bientôt vide" "Niveau : $LEVEL%"
    fi
fi
