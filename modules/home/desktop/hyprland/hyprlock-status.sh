#!/usr/bin/env bash

# --- TAILSCALE ---
TS_LABEL=""
if command -v tailscale &>/dev/null; then
  if tailscale status --peers=false &>/dev/null; then
    TS_LABEL="󰖂"
  fi
fi

# --- NETWORK (WLAN) ---
NET_LABEL=""
WLAN_IFACE=$(ls /sys/class/net | grep '^wl' | head -n 1)

if [ -n "$WLAN_IFACE" ]; then
  CURRENT_IFACE=$(ip route | grep '^default' | awk '{print $5; exit}')

  if [ "$CURRENT_IFACE" = "$WLAN_IFACE" ]; then
    SSID=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1=="yes"{print $2}')
    [ -z "$SSID" ] && SSID="$WLAN_IFACE"
    NET_LABEL="󰖩 ${SSID}"
  else
    NET_LABEL="󰖪 disconnected"
  fi
fi

# --- BATTERY ---
BAT_LABEL=""
BAT_PATH="/sys/class/power_supply/BAT0"
if [ -d "$BAT_PATH" ]; then
  BAT_PERCENT=$(cat "$BAT_PATH/capacity")
  BAT_STATUS=$(cat "$BAT_PATH/status")

  if [ "$BAT_STATUS" = "charging" ]; then
    BAT_ICON="󰂄"
  else
    BAT_ICONS=("󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰁹")
    ICON_INDEX=$((BAT_PERCENT / 11))
    BAT_ICON=${BAT_ICONS[ICON_INDEX]}
  fi
  BAT_LABEL="${BAT_ICON} ${BAT_PERCENT}%"
fi

# --- OUTPUT (JOINING) ---
SEPERATOR=""
OUTPUT=""
for item in "$TS_LABEL" "$NET_LABEL" "$BAT_LABEL"; do
  if [ -n "$item" ]; then
    if [ -z "$OUTPUT" ]; then
      OUTPUT="$item"
    else
      OUTPUT="$OUTPUT  ${SEPERATOR}  $item"
    fi
  fi
done

echo "$OUTPUT"
