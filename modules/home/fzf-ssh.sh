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
    awk '/^Host[ 	]/ {
        for (i = 2; i <= NF; i++) {
            if ($i != "*" && $i !~ /\*/) print $i
        }
    }' "$SSH_CONFIG"
  fi
}

FZF_OPTS=(--prompt="   ssh > " --preview "$0 --preview {}")

if [ -n "${TMUX:-}" ]; then
  FZF_OPTS+=(--header="Enter: New Window | Ctrl-s: Split")
  FZF_OPTS+=(--bind 'ctrl-s:print(ctrl-s)+accept')
fi

RESULT=$(list_ssh_connections | fzf "${FZF_OPTS[@]}")

KEY=$(head -1 <<<"$RESULT")
if [[ "$KEY" == "ctrl-s" ]]; then
  CHOICE=$(sed -n '2p' <<<"$RESULT")
else
  CHOICE="$KEY"
  KEY="window"
fi

[ -z "$CHOICE" ] && exit 0

CMD="TERM=xterm-256color ssh -t $CHOICE 'if command -v tmux >/dev/null; then tmux a || tmux; else \$SHELL; fi'"

if [ -n "${TMUX:-}" ]; then
  if [[ "$KEY" == "ctrl-s" ]]; then
    tmux split-window -h "$CMD"
  else
    tmux new-window -n "ssh@$CHOICE" "$CMD"
  fi
else
  exec bash -c "$CMD"
fi
