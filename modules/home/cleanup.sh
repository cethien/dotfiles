#!/usr/bin/env bash
set -u

if command -v nala >/dev/null 2>&1; then
	sudo nala autoremove -y
elif command -v apt >/dev/null 2>&1; then
	sudo apt autoremove -y
elif command -v pacman >/dev/null 2>&1; then
	mapfile -t orphans < <(pacman -Qdtq 2>/dev/null || true)
	if ((${#orphans[@]} > 0)); then
		sudo pacman -Rns "${orphans[@]}"
	fi
fi

if command -v nix-collect-garbage >/dev/null 2>&1; then
	nix-collect-garbage -d
fi

echo "done cleaning up 🧹"
