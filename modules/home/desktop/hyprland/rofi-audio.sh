#!/usr/bin/env bash

SEPARATOR="-----"

# ===== OPTIONS =====
OPT_DAEMON_START="  start daemon"
OPT_SPOTIFY_PLAY="  play"
OPT_SPOTIFY_PAUSE="  pause"
OPT_SPOTIFY_NEXT="  next"
OPT_SPOTIFY_PREV="  previous"

OPT_SPEAKER_MUTE="󰓃  mute speaker"
OPT_SPEAKER_UNMUTE="󰓄  unmute speaker"
OPT_MIC_MUTE="󰍬  mute microphone"
OPT_MIC_UNMUTE="󰍭  unmute microphone"

OPT_MIXER="󰕾  open mixer"

SPOTIFYCTL="playerctl -p spotify_player"

# ===== HELPERS =====
is_daemon_running() {
  pgrep -x "spotify_player" >/dev/null
}

sink_muted() {
  wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED
}

source_muted() {
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED
}

# ===== LOGIC =====
OPTIONS=()

if is_daemon_running; then
  # Spotify Controls
  STATUS_MSG=$($SPOTIFYCTL status 2>/dev/null)
  if [[ "$STATUS_MSG" == "Playing" ]]; then
    OPTIONS+=("$OPT_SPOTIFY_PAUSE")
  else
    OPTIONS+=("$OPT_SPOTIFY_PLAY")
  fi
  OPTIONS+=("$OPT_SPOTIFY_NEXT" "$OPT_SPOTIFY_PREV" "$SEPARATOR")

  # Metadata for Header
  METADATA=$($SPOTIFYCTL metadata -f "{{trunc(default(artist, \"[Unknown]\"),25)}} - {{trunc(default(title, \"[Unknown]\"),50)}}" 2>/dev/null)
  HEADER="   ${METADATA:-No track info}"
else
  # Daemon Start Option
  OPTIONS+=("$OPT_DAEMON_START" "$SEPARATOR")
  HEADER=" - daemon is not running -"
fi

# Audio Options (Always there)
sink_muted && OPTIONS+=("$OPT_SPEAKER_UNMUTE") || OPTIONS+=("$OPT_SPEAKER_MUTE")
source_muted && OPTIONS+=("$OPT_MIC_UNMUTE") || OPTIONS+=("$OPT_MIC_MUTE")
OPTIONS+=("$OPT_MIXER")

# ===== UI =====
SELECTED="$(printf '%s\n' "${OPTIONS[@]}" |
  rofi -dmenu -p "${HEADER}" -theme-str 'entry { enabled: false; }')"

case "$SELECTED" in
"$OPT_DAEMON_START")
  # Startet daemon entkoppelt vom script
  spotify_player -d >/dev/null 2>&1 &
  disown
  notify-send "󰓇  spotify" "starting daemon"
  ;;
"$OPT_SPOTIFY_PLAY") $SPOTIFYCTL play ;;
"$OPT_SPOTIFY_PAUSE") $SPOTIFYCTL pause ;;
"$OPT_SPOTIFY_NEXT") $SPOTIFYCTL next ;;
"$OPT_SPOTIFY_PREV") $SPOTIFYCTL previous ;;
"$OPT_MIC_MUTE") wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 && notify-send "󰍭  microphone" "muted" ;;
"$OPT_MIC_UNMUTE") wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 && notify-send "󰍬  microphone" "unmuted" ;;
"$OPT_SPEAKER_MUTE") wpctl set-mute @DEFAULT_SINK@ 1 && notify-send "󰓄  speaker" "muted" ;;
"$OPT_SPEAKER_UNMUTE") wpctl set-mute @DEFAULT_SINK@ 0 notify-send "󰓃  speaker" "unmuted" ;;
"$OPT_MIXER") kitty --class wiremix -e wiremix ;;
esac
