#!/usr/bin/env bash

QUERY=$(echo "" | rofi -dmenu -p "󰖟 web search:" -theme-str 'listview {enabled: false;}')
[ -z "$QUERY" ] && exit 0
xdg-open "https://www.google.com/search?q=$(echo "$QUERY" | sed 's/ /+/g')"
