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

if [[ "$($playerctl status 2>/dev/null)" == "Playing" ]]; then
  TOGGLE=" pause"
else
  TOGGLE=" play"
fi

STATUS=$(status_function)

# Options
NEXT=" next"
PREV=" previous"
SEEK_MINUS=" go back 15 seconds"
SEEK_PLUS=" go ahead 15 seconds"

# Variable passed to rofi
OPTIONS="$TOGGLE\n$NEXT\n$PREV\n$SEEK_PLUS\n$SEEK_MINUS\n"

SELECTED="$(echo -e "$OPTIONS" | rofi -dmenu -p "${STATUS^}" -selected-row 0 -theme-str 'entry { enabled: false; }')"
case $SELECTED in
"$TOGGLE")
  playerctl -p spotify_player play-pause
  ;;
"$NEXT")
  playerctl -p spotify_player next
  ;;
"$PREV")
  playerctl -p spotify_player previous
  ;;
"$SEEK_MINUS")
  playerctl -p spotify_player position 15-
  ;;
"$SEEK_PLUS")
  playerctl -p spotify_player position 15+
  ;;
esac
