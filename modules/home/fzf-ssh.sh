#!/usr/bin/env bash
set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"

# --- preview mode ---
if [[ "${1:-}" == "--preview" ]]; then
  name="$2"
  # Extrahiert den Host-Block aus der Config für die Vorschau
  awk -v host="$name" '/^Host[ 	]/ {
          in_block = 0
          for (i = 2; i <= NF; i++) {
              if ($i == host) in_block = 1
          }
      }
      in_block { print }' "$SSH_CONFIG" | bat --color=always --plain --language=ssh_config
  exit 0
fi

list_ssh_connections() {
  if [ -f "$SSH_CONFIG" ]; then
    # Filtert Wildcards wie '*' aus der Liste
    awk '/^Host[ 	]/ {
        for (i = 2; i <= NF; i++) {
            if ($i != "*" && $i !~ /\*/) print $i
        }
    }' "$SSH_CONFIG"
  fi
}

# --- main logic ---
CHOICE=$(
  list_ssh_connections | fzf \
    --prompt="󰣀 ssh > " \
    --preview "$0 --preview {}" \
    --preview-label="config"
)

[ -z "$CHOICE" ] && exit 0

exec ssh "$CHOICE"
