#!/usr/bin/env bash
set -euo pipefail

RDP_DIR="$HOME/.rdp"

rdp_list() {
  for f in "$RDP_DIR"/*.rdp; do
    basename "${f%.*}" # name without extension
  done
}

rdp_path_from_name() {
  local name="$1"
  printf "%s/%s.rdp" "$RDP_DIR" "$name"
}

CHOICE=$(
  rdp_list | fzf \
    --prompt="󰢹 rdp connection > " \
    --preview 'bat --color=always --style=plain ~/.rdp/{}.rdp' \
    --preview-label="connection info"
)

[ -z "$CHOICE" ] && exit 0

PROFILE=$(rdp_path_from_name "$CHOICE")

if [ "${WAYLAND_DISPLAY:-}" != "" ]; then
  wlfreerdp $PROFILE
  return
fi

xfreerdp $PROFILE
