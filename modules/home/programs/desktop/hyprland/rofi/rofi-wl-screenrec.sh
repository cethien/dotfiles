#!/usr/bin/env bash

SAVE_DIR="$HOME/Videos/Screencaptures"
mkdir -p "$SAVE_DIR"
DATE_TIME=$(date +%Y-%m-%d_%H%M%S)
FOCUSED_MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')
OUTPUT="$SAVE_DIR/${DATE_TIME}_${FOCUSED_MONITOR}.mkv"

RECORD_PID=$(pgrep -x wl-screenrec)
if [[ -n "$RECORD_PID" ]]; then
  pkill -INT -x wl-screenrec
  notify-send "🎥 stopped recording" "$OUTPUT"
  xdg-open "$SAVE_DIR"
  exit 0
fi

# NO_AUDIO=" No audio"
# DESKTOP_ONLY=" Desktop"
# MIC_ONLY=" Mic"
# MIC_DESKTOP=" Desktop + Mic"
# CHOICE=$(echo -e "$NO_AUDIO\n$DESKTOP_ONLY\n$MIC_ONLY\n$MIC_DESKTOP" |
#   rofi -dmenu -theme-str 'entry { enabled: false; }' -p "Record:")
#
# case "$CHOICE" in
# "$NO_AUDIO")
#   AUDIO=""
#   ;;
# "$MIC_ONLY")
#   AUDIO="--audio"
#   ;;
# "$DESKTOP_ONLY")
#   AUDIO="--audio --audio-device alsa_output.pci-0000_00_1f.3.hdmi-stereo.monitor"
#   ;;
# "$MIC_DESKTOP")
#   AUDIO="--audio --audio-device alsa_output.pci-0000_00_1f.3.hdmi-stereo.monitor --audio"
#   ;;
# *)
#   exit 0
#   ;;
# esac

wl-screenrec -f "$OUTPUT" -o "$FOCUSED_MONITOR" $AUDIO
