#!/usr/bin/env bash

# @describe convert files
# @meta require-tools ffmpeg
# @option -f --format![?`_choice_format`] format
# @arg files*

_choice_format() {
  ffmpeg -v quiet -muxers | awk 'NR>4 {print $2}'
}

eval "$(argc --argc-eval "$0" "$@")"

for input in "${argc_files[@]}"; do
  if [ ! -f "$input" ]; then
    echo "⚠️ file not found: $input"
    continue
  fi

  base="${input%.*}"
  output="${base}.${argc_format}"

  echo "🎥 converting '$input' → '$output'..."
  if ffmpeg -i "$input" "$output" -y; then
    echo "✅ successfully converted '$input'!"
  else
    echo "❌ failed to convert '$input'."
  fi
done
