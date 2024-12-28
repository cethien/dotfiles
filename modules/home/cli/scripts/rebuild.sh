#!/usr/bin/env bash

NIXOS=false

usage() {
    echo "Usage: $0 [-n] [-c <configuration>]"
    echo "  -n                  If set, rebuilds NixOS configuration"
    echo "  -c <configuration>  Configuration name for rebuild"
}

while getopts "nc:" opt; do
    case $opt in
    n)
        NIXOS=true
        ;;
    c)
        CONFIG=$OPTARG
        ;;
    *)
        usage
        exit 1
        ;;
    esac
done

if [[ -z $CONFIG ]]; then
    echo "Error: configuration cannot be empty"
    usage
fi

if $NIXOS; then
    if [[ -z $(command -v nixos-rebuild) ]]; then
        echo "Error: nixos-rebuild not found. Are you sure you are running on NixOS?"
        exit 1
    fi
    sudo nixos-rebuild switch --flake github:cethien/.files#"$CONFIG"
else
    if [[ -z $(command -v home-manager) ]]; then
        echo "Error: home-manager not found... wait, how did you get this to work?"
        exit 1
    fi
    home-manager switch --flake github:cethien/.files#"$CONFIG" -b bak-hm-"$(date +%Y%m%d_%H%M%S)"
fi
