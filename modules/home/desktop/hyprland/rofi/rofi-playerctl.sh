#!/usr/bin/env bash

playerctl="playerctl -p spotify_player"

status_function() {
  local icon=""

  if $playerctl status >/dev/null 2>&1; then
    local metadata=$($playerctl metadata -f "{{trunc(default(artist, \"[Unknown]\"), 25)}} - {{trunc(default(title, \"[Unknown]\"), 25)}}")
    echo " $icon $metadata"
  else
    echo " - nothing is playing -"
  fi
}

player_status=$($playerctl status 2>/dev/null)
if [[ "$player_status" == "Playing" ]]; then
  toggle=" pause" # Pause-Icon
else
  toggle=" play" # Play-Icon
fi

status=$(status_function)

# Options
next=" next"
prev=" previous"
seekminus=" go back 15 seconds"
seekplus=" go ahead 15 seconds"

# Variable passed to rofi
options="$toggle\n$next\n$prev\n$seekplus\n$seekminus"

chosen="$(echo -e "$options" | rofi -dmenu -p "${status^}" -selected-row 0 -theme-str 'entry { enabled: false; }')"
case $chosen in
$toggle)
  playerctl -p spotify_player play-pause
  ;;
$next)
  playerctl -p spotify_player next
  ;;
$prev)
  playerctl -p spotify_player previous
  ;;
$seekminus)
  playerctl -p spotify_player position 15-
  ;;
$seekplus)
  playerctl -p spotify_player position 15+
  ;;
esac
