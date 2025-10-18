#!/usr/bin/env bash

set -euo pipefail

REPO=cethien/dotfiles
HOSTNAME=$(hostname -s | tr 'A-Z' 'a-z')
if [[ -n ${WSL_DISTRO_NAME:-} ]] || grep -qi microsoft /proc/version 2>/dev/null; then
  HOSTNAME=wsl
fi

if command -v nixos-rebuild >/dev/null 2>&1; then
  echo "❄️ detected NixOS, running nixos-rebuild for $HOSTNAME..."
  sudo nixos-rebuild switch --flake github:"$REPO#$HOSTNAME"
  exit 0
fi

echo "🏠 running home-manager for $(whoami)@$HOSTNAME..."
nix run nixpkgs#home-manager -- switch \
  --flake github:"$REPO#$(whoami)@$HOSTNAME" \
  -b "bak-hm-$(date +%Y%m%d_%H%M%S)" \
  --refresh
