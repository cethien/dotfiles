#!/usr/bin/env bash

if [ $# -lt 2 ]; then
  echo "ℹ️ usage: ffmpeg-convert <target-format> <file> [<another-file> ...]"
  return 1
fi

ext="$1"
shift

for input in "$@"; do
  if [ ! -f "$input" ]; then
    echo "⚠️ file not found: $input"
    continue
  fi

  base="${input%.*}"
  output="${base}.${ext}"

  echo "🎥 converting '$input' → '$output'..."
  if ffmpeg -i "$input" "$output"; then
    echo "✅ successfully converted '$input'!"
  else
    echo "❌ failed to convert '$input'."
  fi
done
