#!/usr/bin/env bash

# @describe A smart note creator that prompts for a filename or accepts it via argument.
# @arg filename                        Optional filename. If omitted, gum will prompt you.

eval "$(argc --argc-eval "$0" "$@")"

TARGET_DIR="$HOME/docs"
mkdir -p "$TARGET_DIR" && cd "$TARGET_DIR" || exit 1

DEFAULT="$(date +%Y%m%d)_untitled"

if [ -z "$argc_filename" ]; then
	if ! INPUT=$(gum input \
		--prompt "󱓧 filename > " \
		--prompt.foreground "5" \
		--placeholder "$DEFAULT" \
		--placeholder.foreground "8" \
		--width 0); then
		exit 1
	fi
else
	INPUT="$argc_filename"
fi

FILE=$(echo "${INPUT:-$DEFAULT}" | tr '[:upper:]' '[:lower:]')
[[ "$FILE" != *.md ]] && FILE="${FILE}.md"

COUNTER=1
while [ -e "$FILE" ]; do
	DIR=$(dirname "$FILE")
	BASE=$(basename "$FILE" .md)
	BASE="${BASE%_[0-9]*}"

	if [ "$DIR" = "." ]; then
		FILE="${BASE}_${COUNTER}.md"
	else
		FILE="${DIR}/${BASE}_${COUNTER}.md"
	fi
	((COUNTER++))
done

ACTIVE_EDITOR="${EDITOR:-nvim}"
if [[ "$ACTIVE_EDITOR" =~ nvim ]]; then
	exec "$ACTIVE_EDITOR" +startinsert "$FILE"
else
	exec "$ACTIVE_EDITOR" "$FILE"
fi
