#!/usr/bin/env bash

adjust_windows() {
  for i in $(seq 1 20); do
    if hyprctl clients | grep -q 'class:.*Spotify' &&
      hyprctl clients | grep -q 'class:.*cava'; then

      hyprctl dispatch focuswindow class:cava
      hyprctl dispatch movewindow r
      hyprctl dispatch focuswindow class:Spotify
      hyprctl dispatch resizeactive 60% 100%
      break
    fi
    sleep 0.1
  done
}

launched=false

# Launch spotify_player if not running
if ! hyprctl clients | grep -q 'class:.*Spotify'; then
  kitty --class Spotify -e spotify_player &
  launched=true
fi

# Launch cava if not running
if ! hyprctl clients | grep -q 'class:.*cava'; then
  kitty --class cava -e cava &
  launched=true
fi

$launched && adjust_windows

hyprctl dispatch focuswindow class:Spotify
