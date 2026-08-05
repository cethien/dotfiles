#!/usr/bin/env bash

TARGET="${1:-}"

if [ -z "$TARGET" ]; then
	read -r -e -p "portscan target: " TARGET
else
	echo "portscan target: $TARGET"
fi

[ -z "$TARGET" ] && {
	echo "no target provided"
	exit 1
}

echo ""

if [[ "$TARGET" == *"/"* ]]; then
	exec nmap -F --open --min-rate 1000 "$TARGET"
fi

exec nmap -sV --version-light "$TARGET"
