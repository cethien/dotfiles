#!/usr/bin/env bash

BAT_PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity)
BAT_ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
ICON_INDEX=$((BAT_PERCENTAGE / 10))
BAT_ICON=${BAT_ICONS[ICON_INDEX]}
if [ "$(cat /sys/class/power_supply/BAT0/status)" = "Charging" ]; then
  BAT_ICON="󰂄"
fi

IFACE=$(ip route | awk '/^default/ {print $5; exit}')
if [ -n "$IFACE" ]; then
  if [[ "$IFACE" == wl* ]]; then
    NET_ICON="󰖩" # Wi-Fi
  elif [[ "$IFACE" == en* ]]; then
    NET_ICON="󰈀" # Ethernet
  else
    NET_ICON="󰓢" # Generic (USB, VPN, etc.)
  fi
  NET_LABEL="${NET_ICON}"
else
  NET_LABEL="󰖪"
fi

echo "${BAT_ICON} ${BAT_PERCENTAGE}% • $NET_LABEL"
