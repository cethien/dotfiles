#!/usr/bin/env bash

# Prompt for query
query=$(echo "" | rofi -dmenu -p "Search Web:")

# Exit if nothing entered
[ -z "$query" ] && exit 0

# Open browser with search
xdg-open "https://www.google.com/search?q=$(echo $query | sed 's/ /+/g')"
