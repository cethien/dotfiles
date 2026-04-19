#!/usr/bin/env bash
set -euo pipefail

ICON=" "
TITLE="tmux"

SESSIONS=$(tmux list-sessions -F "#S" 2>/dev/null)
if [ -z "$SESSIONS" ]; then
  notify-send "$ICON $TITLE" "no active sessions"
  exit 1
fi

ROFI_THEME="
entry{placeholder:'$TITLE';}
"
CHOICE=$(echo "$SESSIONS" | rofi -dmenu -p "$ICON" -theme-str "$ROFI_THEME")
[ -z "$CHOICE" ] && exit 0

if [ -n "$CHOICE" ]; then
  exec kitty --class "$CHOICE" -e tmux attach-session -t "$CHOICE"
fi
