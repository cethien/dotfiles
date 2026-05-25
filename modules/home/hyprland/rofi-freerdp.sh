#!/usr/bin/env bash
set -euo pipefail

ICON="󰢹 "
TITLE="rdp"

RDP_DIR="$HOME/.rdp"

SESSIONS=$(
  find "$RDP_DIR" -maxdepth 1 -type f,l -name "*.rdp" -printf "%f\n" 2>/dev/null |
    sed 's/\.rdp$//' | sort -V
)
if [ -z "$SESSIONS" ]; then
  notify-send "$ICON $TITLE" "no sessions configured"
  exit 1
fi
ROFI_THEME="
entry{placeholder:'$TITLE';}
"
CHOICE=$(echo "$SESSIONS" | rofi -dmenu -p "$ICON" -theme-str "$ROFI_THEME")
[ -z "$CHOICE" ] && exit 0

PROFILE="$RDP_DIR/$CHOICE.rdp"

RDP_HOST=$(awk -F':' '/^full address:s:/ {print $NF}' "$PROFILE" | tr -d '\r\n')

PASS=""
if [ -n "$RDP_HOST" ] && command -v secret-tool >/dev/null; then
  PASS=$(secret-tool lookup URL "$RDP_HOST" 2>/dev/null || echo "")
fi

ARGS=("$PROFILE"
  "-wallpaper"
  "-themes"
  "-fonts"
  "/bpp:16"
  "/network:lan"
  "+auto-reconnect"

  "+clipboard"
  "/printer"
  "+workarea"
  "+dynamic-resolution"

  "/cert:ignore"
)
[ -n "$PASS" ] && ARGS+=("/p:$PASS")

if [ -n "${WAYLAND_DISPLAY:-}" ]; then
  exec sdl-freerdp "${ARGS[@]}"
else
  exec xfreerdp "${ARGS[@]}"
fi
