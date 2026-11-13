#!/usr/bin/env bash

copy_args_or_stdin() {
	if [ "$#" -gt 0 ]; then
		printf '%s' "$*"
	else
		cat
	fi
}

if command -v wl-copy >/dev/null; then
	wl-copy "$@"
elif command -v xclip >/dev/null; then
	xclip -selection clipboard "$@"
elif command -v xsel >/dev/null; then
	copy_args_or_stdin "$@" | xsel --clipboard --input
elif command -v pbcopy >/dev/null; then
	copy_args_or_stdin "$@" | pbcopy
elif command -v clip.exe >/dev/null; then
	copy_args_or_stdin "$@" | clip.exe
else
	echo "No clipboard tool found" >&2
	exit 1
fi
