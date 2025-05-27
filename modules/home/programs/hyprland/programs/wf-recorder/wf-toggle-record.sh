#!/bin/env bash

RECORD_PID=$(pgrep -x "wf-recorder")
SAVE_DIR="$HOME/Videos/Screencaptures"
DATE_TIME=$(date +%Y-%m-%d_%H%M%S)
FOCUSED_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
OUTPUT="$SAVE_DIR/${DATE_TIME}_${FOCUSED_MONITOR}.mkv"

if [[ -n "$RECORD_PID" ]]; then
  pkill -INT -x wf-recorder
  notify-send "🎥 Stopped recording" "$OUTPUT"
  exit 0
fi

mkdir -p "$SAVE_DIR"
wf-recorder --audio --output "$FOCUSED_MONITOR" --bframes max_b_frames -f "$OUTPUT"
