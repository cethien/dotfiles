#!/usr/bin/env bash

SEPARATOR="─"
get_datetime() {
  TIME=$(date "+%H:%M")
  DATE=$(date "+%a, %d. %B %Y")
  echo "󰥔 ${TIME}  ${SEPARATOR}  󰃭 ${DATE}"
}

get_system_stats() {
  CPU="󰍛 CPU: $(awk 'NR==1 {usage=($2+$4)*100/($2+$4+$5); printf "%d%%", usage}' /proc/stat)"
  RAM="󰍛 RAM:  $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
  echo "${CPU}  ${SEPARATOR}  ${RAM}"
}

BAT_PATH="/sys/class/power_supply/BAT0"
[ -d "$BAT_PATH" ] && HAS_BATTERY=1
get_battery_status() {
  BAT_PERCENTAGE=$(cat $BAT_PATH/capacity)
  BAT_STATUS=$(cat $BAT_PATH/status)

  BAT_ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
  BAT_CHARGING_ICON="󰂄"

  ICON_INDEX=$((BAT_PERCENTAGE / 10))
  [ "$ICON_INDEX" -ge "${#BAT_ICONS[@]}" ] && ICON_INDEX=$((${#BAT_ICONS[@]} - 1))
  BAT_ICON=${BAT_ICONS[ICON_INDEX]}

  if [ "$BAT_STATUS" = "charging" ]; then
    echo "${BAT_CHARGING_ICON} ${BAT_PERCENTAGE}% (charging)"
  else
    echo "${BAT_ICON} ${BAT_PERCENTAGE}%"
  fi
}

get_network_status() {
  IFACE=$(ip route | awk '/^default/ {print $5; exit}')

  if [ -z "$IFACE" ]; then
    echo "󰖪 Disconnected"
    return
  fi

  if [[ "$IFACE" == wl* ]]; then
    SSID=""
    SIGNAL=0
    if command -v nmcli &>/dev/null; then
      read SSID SIGNAL <<<$(nmcli -t -f active,ssid,signal dev wifi | awk -F: '$1=="yes"{print $2, $3}')
    fi

    ICON="󰤯" # Weak signal
    if [ "$SIGNAL" -ge 76 ]; then
      ICON="󰤥" # Excellent
    elif [ "$SIGNAL" -ge 51 ]; then
      ICON="󰤢" # Good
    elif [ "$SIGNAL" -ge 26 ]; then
      ICON="󰤟" # Fair
    fi

    if [ -n "$SSID" ]; then
      echo "${ICON} $SSID"
    else
      echo "󰖩 $IFACE" # Wifi icon and interface name
    fi
  elif [[ "$IFACE" == en* ]]; then
    echo "󰈀 $IFACE" # Ethernet
  else
    echo "󰓢 $IFACE" # Generic
  fi
}

# Main script logic
SECTIONS=()
SECTIONS+=("$(get_datetime)")

if [ -n "$HAS_BATTERY" ]; then
  SECTIONS+=("$(get_battery_status)")
fi
SECTIONS+=("$(get_system_stats)")
SECTIONS+=("$(get_network_status)")

SPACE="\n"
PANEL=$(printf "%s$SPACE" "${SECTIONS[@]}")
PANEL="${PANEL%"$SPACE"}"

notify-send -u low -t 5000 "$PANEL"
