#!/usr/bin/env bash

if ! hyprctl clients | grep -q 'class:.*cmatrix'; then
  kitty --class cmatrix -e cmatrix
fi

hyprctl dispatch focuswindow class:cmatrix
