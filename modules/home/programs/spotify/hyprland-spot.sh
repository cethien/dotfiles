#!/usr/bin/env bash

hyprctl clients | grep -q 'class:.*Spotify' &&
  hyprctl dispatch focuswindow class:Spotify ||
  kitty --class Spotify -e spotify_player &
