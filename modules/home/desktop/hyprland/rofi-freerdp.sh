#!/usr/bin/env bash
set -euo pipefail

RDP_DIR="$HOME/.rdp"

SESSIONS=$(
  find "$RDP_DIR" -maxdepth 1 -type f,l -name "*.rdp" -printf "%f\n" 2>/dev/null |
    sed 's/\.rdp$//' | sort -V
)
if [ -z "$SESSIONS" ]; then
  notify-send "RDP" "no sessions configured"
  exit 1
fi

CHOICE=$(echo "$SESSIONS" | rofi -dmenu -i -p "󰢹  RDP > ")
[ -z "$CHOICE" ] && exit 0

PROFILE="$RDP_DIR/$CHOICE.rdp"

RDP_HOST=$(awk -F':' '/^full address:s:/ {print $NF}' "$PROFILE" | tr -d '\r\n')

PASS=""
if [ -n "$RDP_HOST" ] && command -v secret-tool >/dev/null; then
  PASS=$(secret-tool lookup URL "$RDP_HOST" 2>/dev/null || echo "")
fi

ARGS=("$PROFILE" "/cert:ignore")
[ -n "$PASS" ] && ARGS+=("/p:$PASS")

if [ -n "${WAYLAND_DISPLAY:-}" ]; then
  exec sdl-freerdp "${ARGS[@]}"
else
  exec xfreerdp "${ARGS[@]}"
fi
