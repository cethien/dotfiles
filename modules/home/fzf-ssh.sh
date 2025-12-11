#!/usr/bin/env bash
set -euo pipefail

CONFIG="$HOME/.ssh/config"

ssh_list_hosts() {
  awk '
    /^Host[ \t]/ {
        for (i = 2; i <= NF; i++) {
            if ($i != "*" && $i !~ /\*/) print $i
        }
    }
  ' "$CONFIG"
}

ssh_show_block() {
  awk -v host="$1" '
    /^Host[ \t]/ {
        in_block = 0
        for (i = 2; i <= NF; i++) {
            if ($i == host) in_block = 1
        }
    }
    in_block { print }
  ' "$CONFIG"
}

# --- preview mode ------------------------------------------------------------
if [[ "${1:-}" == "--show-block" ]]; then
  ssh_show_block "$2"
  exit 0
fi

# --- interactive SSH picker --------------------------------------------------
host=$(
  ssh_list_hosts |
    fzf --cycle \
      --prompt="󰣀 ssh host > " \
      --preview "$0 --show-block {} | bat --color=always --plain --language=ssh_config" \
      --preview-label="connection info"
)

[ -n "$host" ] && exec ssh "$host"
