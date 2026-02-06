#!/usr/bin/env bash

# --- config ---
SPOTIFYCTL="playerctl -p spotify_player"
SEPARATOR="-----"

# --- helfer ---
is_daemon_running() { pgrep -x "spotify_player" >/dev/null; }
sink_muted() { wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED; }
source_muted() { wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED; }

# --- aktionen ---
run_action() {
  case "$1" in
  "play_pause") $SPOTIFYCTL play-pause ;;
  "next") $SPOTIFYCTL next ;;
  "prev") $SPOTIFYCTL previous ;;
  "daemon")
    spotify_player -d >/dev/null 2>&1 &
    disown
    notify-send "󰓇 spotify" "starting daemon"
    ;;
  "mixer") kitty --class wiremix -e wiremix ;;
  "afk_on")
    wpctl set-mute @DEFAULT_SINK@ 1
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
    notify-send "󰒲 afk" "mic & speaker muted"
    ;;
  "afk_off")
    wpctl set-mute @DEFAULT_SINK@ 0
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
    notify-send "󰒲 back" "everything unmuted"
    ;;
  "toggle_sink")
    if sink_muted; then
      wpctl set-mute @DEFAULT_SINK@ 0
      notify-send "󰓄 speaker" "unmuted"
    else
      wpctl set-mute @DEFAULT_SINK@ 1
      notify-send "󰓃 speaker" "muted"
    fi
    ;;
  "toggle_src")
    if source_muted; then
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0
      notify-send "󰍬 mic" "unmuted"
    else
      wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1
      notify-send "󰍭 mic" "muted"
    fi
    ;;
  *) exit 0 ;;
  esac
}

# --- menü-struktur ---
OPTIONS=()
ACTIONS=()

# 1-3: spotify (keys: 1, 2, 3)
if is_daemon_running; then
  METADATA=$($SPOTIFYCTL metadata -f "{{artist}} - {{title}}" 2>/dev/null | tr '[:upper:]' '[:lower:]')
  HEADER=" ${METADATA:-spotify playing}"

  OPTIONS+=("[1] 󰐊/󰏤 play/pause")
  ACTIONS+=("play_pause")
  OPTIONS+=("[2] 󰒭 next")
  ACTIONS+=("next")
  OPTIONS+=("[3] 󰒮 previous")
  ACTIONS+=("prev")
else
  HEADER="󰓇 daemon offline"
  OPTIONS+=("[1] 󰓇 start daemon")
  ACTIONS+=("daemon")
  OPTIONS+=("---")
  ACTIONS+=("none")
  OPTIONS+=("---")
  ACTIONS+=("none")
fi

# trenner (nimmt platz 4 ein, kein keybind)
OPTIONS+=("$SEPARATOR")
ACTIONS+=("none")

# m, a, s, d: audio block
OPTIONS+=("[m] 󰕾 open mixer")
ACTIONS+=("mixer")

if sink_muted && source_muted; then
  OPTIONS+=("[a] 󰒲 back (unmute all)")
  ACTIONS+=("afk_off")
else
  OPTIONS+=("[a] 󰒲 afk (mute all)")
  ACTIONS+=("afk_on")
fi

if sink_muted; then
  OPTIONS+=("[s] 󰓄 unmute speaker")
  ACTIONS+=("toggle_sink")
else
  OPTIONS+=("[s] 󰓃 mute speaker")
  ACTIONS+=("toggle_sink")
fi

if source_muted; then
  OPTIONS+=("[S] 󰍭 unmute mic")
  ACTIONS+=("toggle_src")
else
  OPTIONS+=("[S] 󰍬 mute mic")
  ACTIONS+=("toggle_src")
fi

# --- rofi ui ---
IDX=$(printf '%s\n' "${OPTIONS[@]}" | rofi -dmenu -p "$HEADER" -format 'i' \
  -kb-select-1 "1" \
  -kb-select-2 "2" \
  -kb-select-3 "3" \
  -kb-select-5 "m" \
  -kb-select-6 "a" \
  -kb-select-7 "s" \
  -kb-select-8 "S" \
  -theme-str 'entry { enabled: false; }')

if [[ -n "$IDX" ]]; then
  run_action "${ACTIONS[$IDX]}"
fi
