#!/usr/bin/env bash

set -e

## nala, a wrapper for apt for speed
if command -v apt >/dev/null 2>&1; then
  echo "📦 installing nala..."
  sudo apt update &&
    sudo apt install -y nala curl &&
    sudo nala update &&
    sudo nala upgrade -y
fi

NIXCONF_PATH="$HOME/.config/nix/nix.conf"

if ! command -v nixos-rebuild >/dev/null 2>&1; then
  echo "📦 installing nix package manager..."
  curl -fsSL https://nixos.org/nix/install | bash /dev/stdin --no-daemon

  mkdir -p "$(dirname "$NIXCONF_PATH")"

  if ! grep -qxF "experimental-features = nix-command flakes" "$NIXCONF_PATH"; then
    echo "experimental-features = nix-command flakes" >>"$NIXCONF_PATH"
  fi

  if ! grep -qxF "warn-dirty = false" "$NIXCONF_PATH"; then
    echo "warn-dirty = false" >>"$NIXCONF_PATH"
  fi
fi

CONFIGURATION="$(whoami)@$(hostname)"

if [ -n "$WSL_DISTRO_NAME" ]; then
  CONFIGURATION="$(whoami)@wsl"
fi

echo "installing home-manager profile"
. "$HOME/.nix-profile/etc/profile.d/nix.sh"
nix run nixpkgs#home-manager -- \
  switch --flake github:cethien/dotfiles#"$CONFIGURATION" -b hm-bak-"$(date +%Y%m%d-%H%M%S)" --refresh

if [ -n "$WSL_DISTRO_NAME" ]; then
  if command -v docker &>/dev/null; then
    sudo usermod -aG docker "$USER"
  fi
  echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USER" >/dev/null
  echo "rebooting system"
  sudo reboot
fi
