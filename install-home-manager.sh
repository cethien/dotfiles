#!/usr/bin/env bash

set -euo pipefail

# Color codes for clean terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}==> Starting Home Manager kickstart setup...${NC}"

# 1. Check system dependencies for Docker testing environments
if command -v apt-get &>/dev/null && [ "$USER" = "root" ]; then
	echo "Docker/Ubuntu environment detected. Installing minimal bootstrap dependencies..."
	export DEBIAN_FRONTEND=noninteractive
	apt-get update && apt-get install -y curl git xz-utils sudo || true
fi

HOME_DIR="$HOME"
ACTUAL_USER="${USER:-kollege}"

# 2. Install Nix in single-user mode (no sudo, no daemon required)
if ! command -v nix &>/dev/null; then
	echo -e "${BLUE}==> Installing Nix in single-user mode...${NC}"
	curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

	# Load Nix for the current script session immediately
	if [ -e "$HOME_DIR/.nix-profile/etc/profile.d/nix.sh" ]; then
		. "$HOME_DIR/.nix-profile/etc/profile.d/nix.sh"
	fi
else
	echo -e "${GREEN}==> Nix is already installed on this system.${NC}"
fi

# 3. Patch .bashrc to ensure Nix profile is loaded in non-interactive/WSL shells
echo -e "${BLUE}==> Patching .bashrc for Nix environment support...${NC}"
NIX_SOURCE_LINE="[ -e '\$HOME/.nix-profile/etc/profile.d/nix.sh' ] && . '\$HOME/.nix-profile/etc/profile.d/nix.sh'"
BASHRC="$HOME_DIR/.bashrc"

if [ -f "$BASHRC" ]; then
	if ! grep -Fq ".nix-profile/etc/profile.d/nix.sh" "$BASHRC"; then
		TEMP_BASHRC=$(mktemp)
		echo "$NIX_SOURCE_LINE" >"$TEMP_BASHRC"
		cat "$BASHRC" >>"$TEMP_BASHRC"
		mv "$TEMP_BASHRC" "$BASHRC"
	fi
else
	echo "$NIX_SOURCE_LINE" >"$BASHRC"
fi

# 4. Temporarily export experimental features to allow the initial flake command
export NIX_CONFIG="experimental-features = nix-command flakes"

# 5. Initialize the Home Manager template from the central dotfiles repository
HM_DIR="$HOME_DIR/home-manager"
echo -e "${BLUE}==> Initializing Home Manager directory from cethien/dotfiles...${NC}"
mkdir -p "$HM_DIR"

nix flake init -t "github:cethien/dotfiles#home-manager" --dir "$HM_DIR"

# 6. Automatically inject the current system username into flake.nix
if [ -f "$HM_DIR/flake.nix" ]; then
	echo -e "${BLUE}==> Setting local username ($ACTUAL_USER) inside flake.nix...${NC}"
	sed -i "s/<changeme>/$ACTUAL_USER/g" "$HM_DIR/flake.nix"
fi

echo -e "${GREEN}==> Bootstrap phase complete!${NC}"
echo "--------------------------------------------------------"

if [ -f "$HM_DIR/README.md" ]; then
	echo -e "${BLUE}==> Displaying documentation (README.md)...${NC}"
	echo "--------------------------------------------------------"
	cat "$HM_DIR/README.md"
	echo "--------------------------------------------------------"
else
	echo "Setup done. Please navigate to the configuration directory: cd ~/home-manager"
fi
