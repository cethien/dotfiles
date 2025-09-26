#!/usr/bin/env bash

BAT_PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity)
BAT_ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
BAT_CHARGING_ICON="󰂄"
ICON_INDEX=$((BAT_PERCENTAGE / 10))
BAT_ICON=${BAT_ICONS[ICON_INDEX]}
BAT_LABEL="${BAT_ICON} ${BAT_PERCENTAGE}%"
if [ "$(cat /sys/class/power_supply/BAT0/status)" = "Charging" ]; then
  BAT_LABEL="${BAT_CHARGING_ICON} ${BAT_PERCENTAGE}% (Charging)"
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
  NET_LABEL="${NET_ICON} ${IFACE}"
else
  NET_LABEL="󰖪 Disconnected"
fi

CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage) "%"}')
RAM=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

notify-send -u low -t 5000 "󰃰 System" "\
$(date '+%a, %d. %B %Y • %H:%M')
󰍛 CPU: ${CPU} • 󰍛 RAM: ${RAM}
${NET_LABEL}
${BAT_LABEL}"
