#!/usr/bin/env bash

# Launch spotify_player if not running
if ! hyprctl clients | grep -q 'class:.*Spotify'; then
  kitty --class Spotify -e spotify_player &
else
  hyprctl dispatch focuswindow class:Spotify
fi

# Launch cava if not running
if ! hyprctl clients | grep -q 'class:.*cava'; then
  kitty --class cava -e cava &
  # Wait for cava to appear
  for i in $(seq 1 20); do
    if hyprctl clients | grep -q 'class:.*cava'; then
      hyprctl dispatch focuswindow class:cava
      hyprctl dispatch pseudo class:cava
      hyprctl dispatch movewindow r
      hyprctl dispatch focuswindow class:Spotify
      hyprctl dispatch resizeactive 60% 100%
      break
    fi
    sleep 0.1
  done
fi
