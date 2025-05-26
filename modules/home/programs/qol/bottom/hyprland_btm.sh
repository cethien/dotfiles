#!/usr/bin/env bash

hyprctl clients | grep -q 'class:.*btm' &&
  hyprctl dispatch focuswindow class:btm ||
  kitty --class btm -e btm &
