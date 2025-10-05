#!/usr/bin/env bash

SEPARATOR="─"
SPACE="                          "
SECTIONS=()

TIME="$(date "+%H:%M")"
DATE="$(date "+%a, %d. %B %Y")"
SECTIONS+=(
  "${DATE} ${SEPARATOR} ${TIME}"
)

CPU="󰍛 CPU: $(awk 'NR==1 {usage=($2+$4)*100/($2+$4+$5); printf "%d%%", usage}' /proc/stat)"
RAM="󰍛 RAM:  $(free -h | awk '/Mem:/ {print $3 "/" $2}')"

BAT_PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity)
BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)

BAT_ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
BAT_CHARGING_ICON="󰂄"

ICON_INDEX=$((BAT_PERCENTAGE / 10))
[ "$ICON_INDEX" -ge "${#BAT_ICONS[@]}" ] && ICON_INDEX=$((${#BAT_ICONS[@]} - 1))
BAT_ICON=${BAT_ICONS[ICON_INDEX]}

BAT_LABEL=$([ "$BAT_STATUS" = "Charging" ] && echo "${BAT_CHARGING_ICON} ${BAT_PERCENTAGE}% (Charging)" || echo "${BAT_ICON} ${BAT_PERCENTAGE}%")

SECTIONS+=("$BAT_LABEL $SEPARATOR $CPU $SEPARATOR $RAM")

NET_LABEL="󰖪 Disconnected"
IFACE=$(ip route | awk '/^default/ {print $5; exit}')

if [ -n "$IFACE" ]; then
  if [[ "$IFACE" == wl* ]]; then
    SSID=""
    SIGNAL=0
    if command -v nmcli &>/dev/null; then
      read SSID SIGNAL <<<$(nmcli -t -f active,ssid,signal dev wifi | awk -F: '$1=="yes"{print $2, $3}')
    fi

    ICON="󰤯"
    if [ "$SIGNAL" -ge 76 ]; then
      ICON="󰤥"
    elif [ "$SIGNAL" -ge 51 ]; then
      ICON="󰤢"
    elif [ "$SIGNAL" -ge 26 ]; then
      ICON="󰤟"
    fi

    if [ -n "$SSID" ]; then
      NET_LABEL="${ICON} $SSID"
    else
      NET_LABEL="󰖩 $IFACE"
    fi
  elif [[ "$IFACE" == en* ]]; then
    NET_LABEL="󰈀 $IFACE" # Ethernet
  else
    NET_LABEL="󰓢 $IFACE" # Generic
  fi
fi

SECTIONS+=("${NET_LABEL}")

PANEL=$(printf "%s$SPACE" "${SECTIONS[@]}")
PANEL="${PANEL%$SPACE}"

notify-send -u low -h string:category:sysinfo -t 5000 "$PANEL"
