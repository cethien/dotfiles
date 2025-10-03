#!/usr/bin/env bash

DATE_TIME=$(date +%Y-%m-%d_%H%M%S)
FOCUSED_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')

REC_SAVE_DIR="$HOME/Videos/Screencaptures"
REC_OUTPUT="$REC_SAVE_DIR/${DATE_TIME}_${FOCUSED_MONITOR}.mkv"
REC_PID_FILE="/tmp/wl-screenrec.pid"
REC_FILENAME_FILE="/tmp/wl-screenrec.file"

start_screenrecord() {
  mkdir -p "$REC_SAVE_DIR"
  wl-screenrec -f "$REC_OUTPUT" -o "$FOCUSED_MONITOR" >/dev/null 2>&1 &
  sleep 0.1 # give it a moment to spawn child
  REC_PID=$(pgrep -f "$REC_OUTPUT")
  echo "$REC_PID" >"$REC_PID_FILE"
  echo "$REC_OUTPUT" >"$REC_FILENAME_FILE"
}

if [[ -f "$REC_PID_FILE" ]]; then
  pid=$(cat "$REC_PID_FILE")
  if kill -0 "$pid" 2>/dev/null; then
    kill -TERM "$pid" &&
      rm -f "$REC_PID_FILE" &&
      notify-send "🎥 stopped recording" "$REC_OUTPUT"
    xdg-open "$(cat "$REC_FILENAME_FILE")" &&
      rm -rf "$REC_FILENAME_FILE"
    exit 0
  else
    rm -f "$REC_PID_FILE" "$REC_FILENAME_FILE"
  fi
fi

OPT_SCREENRECORD="󰕧  start screenrecording (no audio)"

OPTIONS=$(
  printf "%s\n" \
    "$OPT_SCREENRECORD"
)

ACTION=$(echo -e "$OPTIONS" | rofi -dmenu -theme-str 'entry { enabled: false; }' -p "screenrecord:")
[ -z "$ACTION" ] && exit 0

case "$ACTION" in
"$OPT_SCREENRECORD") start_screenrecord ;;
esac
