#!/usr/bin/env bash

ICON="󰌀 "
TITLE="search web"
ROFI_THEME="
listview{enabled:false;}
entry{placeholder:'$TITLE';}
"
QUERY=$(echo "" | rofi -dmenu -p "$ICON" -theme-str "$ROFI_THEME")
[ -z "$QUERY" ] && exit 0
xdg-open "https://www.google.com/search?q=$(echo "$QUERY" | sed 's/ / +/g')"
