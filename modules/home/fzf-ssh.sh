#!/usr/bin/env bash
set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"
RDP_DIR="$HOME/.rdp"

# --- preview mode ---
if [[ "${1:-}" == "--preview" ]]; then
  line="$2"
  IFS=$'\t' read -r type prefixed_name <<<"$line"
  name=${prefixed_name:2}

  if [[ "$type" == "ssh" ]]; then
    awk -v host="$name" '/^Host[ 	]/ {
            in_block = 0
            for (i = 2; i <= NF; i++) {
                if ($i == host) in_block = 1
            }
        }
        in_block { print }' "$SSH_CONFIG" | bat --color=always --plain --language=ssh_config
  elif [[ "$type" == "rdp" ]]; then
    bat --color=always --style=plain --language=ini "$RDP_DIR/$name.rdp"
  fi
  exit 0
fi

list_ssh_connections() {
  if [ -f "$SSH_CONFIG" ]; then
    awk '/^Host[ 	]/ {
        for (i = 2; i <= NF; i++) {
            if ($i != "*" && $i !~ /\*/) print "ssh\t󰣀 " $i
        }
    }
' "$SSH_CONFIG"
  fi
}

list_rdp_connections() {
  if [ -d "$RDP_DIR" ]; then
    for f in "$RDP_DIR"/*.rdp; do
      [ -f "$f" ] && echo -e "rdp\t󰢹 $(basename "${f%.*}")"
    done
  fi
}

list_connections() {
  list_rdp_connections
  list_ssh_connections
}

# --- main logic ---
CHOICE=$(
  list_connections | fzf \
    --prompt="󰣀 connection > " \
    --delimiter='\t' --with-nth=2 \
    --preview "$0 --preview {}" \
    --preview-label="connection"
)

[ -z "$CHOICE" ] && exit 0

IFS=$'\t' read -r TYPE PREFIXED_NAME <<<"$CHOICE"
NAME=${PREFIXED_NAME:2}

case "$TYPE" in
ssh)
  exec ssh "$NAME"
  ;;
rdp)
  PROFILE="$RDP_DIR/$NAME.rdp"
  if [ -n "${WAYLAND_DISPLAY:-}" ]; then
    sdl-freerdp "$PROFILE"
  else
    xfreerdp "$PROFILE"
  fi
  ;;
esac
