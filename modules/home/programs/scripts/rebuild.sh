#!/usr/bin/env bash

NIXOS=false

usage() {
    echo "Usage: $0 [-n]"
    echo "  -n                  If set, rebuilds NixOS configuration"
}

while getopts ":n" opt; do
    case $opt in
    n)
        NIXOS=true
        ;;
    *)
        usage
        exit 1
        ;;
    esac
done

REPO=cethien/dotfiles
HOSTNAME=$(hostname | tr 'A-Z' 'a-z')

if [[ ! -z $WSL_DISTRO_NAME ]]; then
    HOSTNAME=wsl
fi

if $NIXOS; then
    if [[ -z $(command -v nixos-rebuild) ]]; then
        echo "Error: nixos-rebuild not found. Are you sure you are running on NixOS?"
        exit 1
    fi
    sudo nixos-rebuild switch --flake github:"$REPO#$HOSTNAME"
else
    nix run nixpkgs#home-manager -- switch --flake github:"$REPO#$(whoami)@$HOSTNAME" -b bak-hm-"$(date +%Y%m%d_%H%M%S) --refresh"
fi
