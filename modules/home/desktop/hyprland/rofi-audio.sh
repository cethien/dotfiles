#!/usr/bin/env bash

SEPARATOR="-----"

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

toggle_opt() {
  [ "$1" = true ] && echo "$2" || echo "$3"
}

spotify_status_opt() {
  [ "$($SPOTIFYCTL status 2>/dev/null)" = "Playing" ] && echo "$OPT_SPOTIFY_PAUSE" || echo "$OPT_SPOTIFY_PLAY"
}

sink_muted() {
  wpctl get-volume @DEFAULT_SINK@ | grep -q MUTED
}
source_muted() {
  wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q MUTED
}

get_status() {
  if $SPOTIFYCTL status >/dev/null 2>&1; then
    metadata=$($SPOTIFYCTL metadata -f "{{trunc(default(artist, \"[Unknown]\"),25)}} - {{trunc(default(title, \"[Unknown]\"),50)}}")
    echo "   $metadata"
  else
    echo " - nothing is playing -"
  fi
}

OPTIONS=()
OPTIONS+=("$(spotify_status_opt)")
OPTIONS+=("$OPT_SPOTIFY_NEXT" "$OPT_SPOTIFY_PREV" "$SEPARATOR")

OPTIONS+=("$(toggle_opt "$(sink_muted && echo true || echo false)" "$OPT_SPEAKER_UNMUTE" "$OPT_SPEAKER_MUTE")")
OPTIONS+=("$(toggle_opt "$(source_muted && echo true || echo false)" "$OPT_MIC_UNMUTE" "$OPT_MIC_MUTE")")

OPTIONS+=("$OPT_MIXER")

STATUS=$(get_status)
SELECTED="$(printf '%s\n' "${OPTIONS[@]}" |
  rofi -dmenu -p "${STATUS^}" -theme-str 'entry { enabled: false; }')"

case "$SELECTED" in
"$OPT_SPOTIFY_PLAY") $SPOTIFYCTL play 2>/dev/null ;;
"$OPT_SPOTIFY_PAUSE") $SPOTIFYCTL pause 2>/dev/null ;;
"$OPT_SPOTIFY_NEXT") $SPOTIFYCTL next 2>/dev/null ;;
"$OPT_SPOTIFY_PREV") $SPOTIFYCTL previous 2>/dev/null ;;
"$OPT_MIC_MUTE") wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 1 ;;
"$OPT_MIC_UNMUTE") wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 ;;
"$OPT_SPEAKER_MUTE") wpctl set-mute @DEFAULT_SINK@ 1 ;;
"$OPT_SPEAKER_UNMUTE") wpctl set-mute @DEFAULT_SINK@ 0 ;;
"$OPT_MIXER") kitty --class wiremix -e wiremix ;;
esac
