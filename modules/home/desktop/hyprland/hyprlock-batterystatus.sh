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
    if command -v nmcli &>/dev/null; then
      SSID=$(nmcli -t -f active,ssid dev wifi | awk -F: '$1=="yes"{print $2}')
    fi

    if [ -n "$SSID" ]; then
      NET_ICON="󰖩" # Wi-Fi
      NET_LABEL="${NET_ICON} ${SSID}"
    else
      NET_ICON="󰖩"
      NET_LABEL="${NET_ICON} ${IFACE}"
    fi
  elif [[ "$IFACE" == en* ]]; then
    NET_ICON="󰈀" # Ethernet
    NET_LABEL="${NET_ICON} Ethernet"
  else
    NET_ICON="󰓢" # Generic (USB, VPN, etc.)
    NET_LABEL="${NET_ICON} ${IFACE}"
  fi
else
  NET_LABEL="󰖪 disconnected"
fi

echo "${BAT_ICON} ${BAT_PERCENTAGE}% • $NET_LABEL"
