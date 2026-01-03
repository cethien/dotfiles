#!/usr/bin/env bash

SEPARATOR="─"
# Function to get date and time
get_datetime() {
  TIME=$(date "+%H:%M")
  DATE=$(date "+%a, %d. %B %Y")
  echo "${DATE} ${SEPARATOR} ${TIME}"
}

# Function to get CPU and RAM usage
get_system_stats() {
  CPU="󰍛 CPU: $(awk 'NR==1 {usage=($2+$4)*100/($2+$4+$5); printf "%d%%", usage}' /proc/stat)"
  RAM="󰍛 RAM:  $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
  echo "${CPU} ${SEPARATOR} ${RAM}"
}

# Function to get battery status
get_battery_status() {
  if [ ! -d "/sys/class/power_supply/BAT0" ]; then
    return
  fi

  BAT_PERCENTAGE=$(cat /sys/class/power_supply/BAT0/capacity)
  BAT_STATUS=$(cat /sys/class/power_supply/BAT0/status)

  BAT_ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
  BAT_CHARGING_ICON="󰂄"

  ICON_INDEX=$((BAT_PERCENTAGE / 10))
  [ "$ICON_INDEX" -ge "${#BAT_ICONS[@]}" ] && ICON_INDEX=$((${#BAT_ICONS[@]} - 1))
  BAT_ICON=${BAT_ICONS[ICON_INDEX]}

  if [ "$BAT_STATUS" = "Charging" ]; then
    echo "${BAT_CHARGING_ICON} ${BAT_PERCENTAGE}% (Charging)"
  else
    echo "${BAT_ICON} ${BAT_PERCENTAGE}%"
  fi
}

# Function to get network status
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
main() {
  SECTIONS=()
  SECTIONS+=("$(get_datetime)")
  SECTIONS+=("$(get_system_stats)")

  BATTERY_LABEL="$(get_battery_status)"
  if [ -n "$BATTERY_LABEL" ]; then
    SECTIONS+=("$BATTERY_LABEL $SEPARATOR $(get_network_status)")
  else
    SECTIONS+=("$(get_network_status)")
  fi

  SPACE="                      "
  PANEL=$(printf "%s$SPACE" "${SECTIONS[@]}")
  PANEL="${PANEL%"$SPACE"}"

  notify-send -u low -h string:category:sysinfo -t 5000 "$PANEL"
}

main
