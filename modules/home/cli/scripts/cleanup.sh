#!/usr/bin/env bash

EXTRA_PACKAGE_MANAGER=""

# check if apt is installed
if command -v apt &>/dev/null; then
    EXTRA_PACKAGE_MANAGER="apt"
fi

# check if nala is installed
if command -v nala &>/dev/null; then
    EXTRA_PACKAGE_MANAGER="nala"
fi

if [[ -n $EXTRA_PACKAGE_MANAGER ]]; then
    sudo $EXTRA_PACKAGE_MANAGER autoremove -y
fi

nix-store --gc
nix-env --delete-generations 3d

echo "done cleaning up 🧹"
