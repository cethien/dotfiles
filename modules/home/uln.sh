#!/usr/bin/env bash
set -euo pipefail

if [ ! $# -eq 1 ]; then
  echo "usage: $0 <symlink>"
  exit 1
fi

FILE="$1"
if [ ! -L "$FILE" ]; then
  echo "'$FILE' is not a symlink"
  exit 1
fi

cp "$FILE" "$FILE-copy"
rm "$FILE"
cat "$FILE-copy" >"$FILE"
rm "$FILE-copy"
