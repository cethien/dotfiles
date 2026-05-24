#!/usr/bin/env bash

if [ -n "$1" ]; then
  TARGET="$1"
else
  read -p "target ip: " TARGET
fi

if [ -z "$TARGET" ]; then
  echo "No target provided. Aborting."
  exit 1
fi

clear
echo -e "\033[1;33m====================================================\033[0m"
echo -e "\033[1;33m SCANNING TARGET: $TARGET\033[0m"
echo -e "\033[1;33m====================================================\033[0m\n"

rustscan --no-banner --ulimit 5000 -a "$TARGET"
