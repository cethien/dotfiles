#!/usr/bin/env bash
set -e

if command -v apt >/dev/null 2>&1; then
  echo "📦 speeding up apt with nala..."
  sudo apt update && sudo apt install -y nala curl git
  sudo nala upgrade -y
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "❄️ installing nix..."
  curl -fsSL https://nixos.org/nix/install | bash /dev/stdin --no-daemon

  # shellcheck source=/dev/null
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"

  mkdir -p "$HOME/.config/nix"
  echo "experimental-features = nix-command flakes" >>"$HOME/.config/nix/nix.conf"
  echo "warn-dirty = false" >>"$HOME/.config/nix/nix.conf"
fi

REPO_DIR="$HOME/dotfiles"
if [ ! -d "$REPO_DIR" ]; then
  echo "📥 cloning dotfiles..."
  git clone https://github.com/cethien/dotfiles.git "$REPO_DIR"
fi

cd "$REPO_DIR"

target="$(whoami)@$(hostname | tr '[:upper:]' '[:lower:]')"
echo "🚀 attempting bootstrap for $target..."

# we don't 'set -e' this part specifically so we can print a helpful message on failure
if ! nix run nixpkgs#home-manager -- switch --flake ".#$target" -b "initial"; then
  echo "❌ bootstrap failed. profile '$target' likely missing from homes/defaults.nix."
  echo "   fix it, then run: d hosts bootstrap-home"
  exit 1
fi

if command -v docker &>/dev/null; then
  sudo usermod -aG docker "$USER"
fi
echo "$USER ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USER" >/dev/null

echo "✅ bootstrap complete"
