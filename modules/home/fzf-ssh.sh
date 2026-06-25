#!/usr/bin/env bash
set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"
HISTORY_FILE="$HOME/.ssh/sshz_history"
touch "$HISTORY_FILE"

if [[ "${1:-}" == "--preview" ]]; then
	name="$2"
	if ssh -T -G "$name" &>/dev/null; then
		ssh -T -G "$name" | grep -iE '^(user|hostname|port|identityfile) ' | bat --color=always --plain --language=ssh_config
	else
		echo "Ad-hoc connection: No configuration stored."
	fi
	exit 0
fi

connect_ssh() {
	local target="$1"
	local tmux_mode="${2:-window}"

	local cmd="TERM=xterm-256color ssh -t \"$target\" 'if command -v tmux >/dev/null; then tmux a || tmux; else \$SHELL; fi'"

	if [ -n "${TMUX:-}" ]; then
		if [[ "$tmux_mode" == "split" ]]; then
			tmux split-window -h "$cmd"
		else
			tmux new-window -n "ssh@${target}" "$cmd"
		fi
	else
		exec bash -c "$cmd"
	fi
}

if [ $# -gt 0 ]; then
	# Use the last argument as the history entry (usually the host)
	TARGET="${*:$#}"

	if ! grep -qxF "$TARGET" "$HISTORY_FILE"; then
		echo "$TARGET" >>"$HISTORY_FILE"
	fi

	connect_ssh "window" "$@"
	exit 0
fi

list_ssh_connections() {
	if [ -f "$SSH_CONFIG" ]; then
		grep -iE '^Host[[:space:]]' "$SSH_CONFIG" | cut -d' ' -f2- | tr ' ' '\n' | grep -v '\*'
	fi
	cat "$HISTORY_FILE"
}

FZF_OPTS=(
	--prompt="󰣀  ssh > "
	--preview "$0 --preview {}"
	--footer="ctrl-x: delete history"
	--bind 'ctrl-x:print(ctrl-x)+accept'
)

if [ -n "${TMUX:-}" ]; then
	FZF_OPTS+=(--footer="ctrl-s: split | ctrl-x: delete history")
	FZF_OPTS+=(--bind 'ctrl-s:print(ctrl-s)+accept')
fi

while true; do
	RESULT=$(list_ssh_connections | fzf "${FZF_OPTS[@]}")
	[ -z "$RESULT" ] && exit 0

	KEY=$(head -1 <<<"$RESULT")

	if [[ "$KEY" == "ctrl-x" ]]; then
		TO_DELETE=$(sed -n '2p' <<<"$RESULT")
		if [ -n "$TO_DELETE" ]; then
			sed -i "\#^${TO_DELETE}\$#d" "$HISTORY_FILE"
		fi
		continue
	elif [[ "$KEY" == "ctrl-s" ]]; then
		CHOICE=$(sed -n '2p' <<<"$RESULT")
		MODE="split"
		break
	else
		CHOICE="$KEY"
		MODE="window"
		break
	fi
done

[ -z "$CHOICE" ] && exit 0

connect_ssh "$CHOICE" "$MODE"
