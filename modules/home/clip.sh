#!/usr/bin/env bash

if command -v wl-copy >/dev/null; then
  wl-copy "$@"
elif command -v xclip >/dev/null; then
  xclip -selection clipboard "$@"
elif command -v xsel >/dev/null; then
  xsel --clipboard --input
elif command -v pbcopy >/dev/null; then
  pbcopy
elif command -v clip.exe >/dev/null; then
  clip.exe
else
  echo "No clipboard tool found" >&2
  return 1
fi
