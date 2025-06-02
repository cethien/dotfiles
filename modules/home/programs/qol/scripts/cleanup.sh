#!/usr/bin/env bash
set -u
CMD=""
command -v apt &>/dev/null && CMD="apt autoremove -y"
command -v nala &>/dev/null && CMD="nala autoremove -y"
command -v pacman &>/dev/null && CMD="pacman -Rns $(pacman -Qdtq)"
[[ -n $CMD ]] && sudo "$CMD"
nix-collect-garbage -d
echo "done cleaning up 🧹"
