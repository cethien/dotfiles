#!/usr/bin/env bash

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ffmpeg-convert <file> <target-format>"
  return 1
fi

input="$1"
ext="$2"
base="${input%.*}"
output="${base}.${ext}"

ffmpeg -i "$input" "$output"
