#!/usr/bin/env bash
set -e

ICON="󰨜 "
TITLE="screen record"

# Pfade & Config
REC_SAVE_DIR="$HOME/Videos/"

TEMP_DIR="${TMDIR:-/tmp/}"
REC_PID_FILE="${TEMP_DIR}gsr.pid"
REC_FILENAME_FILE="${TEMP_DIR}gsr.file"
REC_LOG_FILE="${TEMP_DIR}gsr.log"

# --- HELPER: START FUNCTION ---
REC_OUTPUT_BASE="$REC_SAVE_DIR/$(date +%Y%m%d_%H%M%S)_screenrecord"
start_record() {
  local target_type=$1
  local audio_mode=$2
  local target_args=()
  local audio_args=()

  if [[ "$target_type" == "window" ]]; then
    local win_data=$(hyprctl activewindow -j)
    local address=$(echo "$win_data" | jq -r '.address')
    local title=$(echo "$win_data" | jq -r '.title' | tr ' ' '_')
    target_args+=("-w" "portal")
    REC_OUTPUT="${REC_OUTPUT_BASE}_${title}.mkv"
  else
    local monitor=$(hyprctl activeworkspace -j | jq -r '.monitor')
    target_args+=("-w" "$monitor")
    REC_OUTPUT="${REC_OUTPUT_BASE}_${monitor}.mkv"
  fi

  # 2. Audio Logic
  case "$audio_mode" in
  "desktop") audio_args+=("-a" "default_output") ;;
  "mic") audio_args+=("-a" "default_output|default_input") ;;
  esac

  mkdir -p "$REC_SAVE_DIR"

  gpu-screen-recorder \
    "${target_args[@]}" "${audio_args[@]}" \
    -f 60 -o "$REC_OUTPUT" \
    2>"$REC_LOG_FILE" >/dev/null &

  local pid=$!
  sleep 1.5

  if kill -0 "$pid" 2>/dev/null; then
    echo "$pid" >"$REC_PID_FILE"
    echo "$REC_OUTPUT" >"$REC_FILENAME_FILE"
  else
    notify-send -u critical "❌ GSR Error" "Failed to start. Opening log..."
    xdg-open "$REC_LOG_FILE"
    exit 1
  fi
}

# --- 1. KILL LOGIK ---
if [[ -f "$REC_PID_FILE" ]]; then
  PID=$(cat "$REC_PID_FILE")
  FILE=$(cat "$REC_FILENAME_FILE")

  if kill -0 "$PID" 2>/dev/null; then
    kill -SIGINT "$PID"
    notify-send "󰨜  stopped recording" "$FILE"
    rm -f "$REC_PID_FILE" "$REC_FILENAME_FILE" "$REC_LOG_FILE"
    sleep 0.8
    xdg-open "$FILE"
    exit 0
  else
    rm -f "$REC_PID_FILE" "$REC_FILENAME_FILE" "$REC_LOG_FILE"
  fi
fi

# --- 2. ROFI MENU ---
OPT1="󰺷  window"
OPT2="󰊗  window + mic"
OPT3="󰍹  desktop"
OPT4="󱩛  desktop + mic"
OPT5="󰽠  desktop (no audio)"

OPTIONS="$OPT1\n$OPT2\n$OPT3\n$OPT4\n$OPT5"

ROFI_THEME="
entry{placeholder:'$TITLE';}
"
ACTION=$(echo -e "$OPTIONS" | rofi -dmenu -p "$ICON" -theme-str "$ROFI_THEME")

case "$ACTION" in
"$OPT1") start_record "window" "desktop" ;;
"$OPT2") start_record "window" "mic" ;;
"$OPT3") start_record "desktop" "desktop" ;;
"$OPT4") start_record "desktop" "mic" ;;
"$OPT5") start_record "desktop" "" ;;
*) exit 0 ;;
esac
