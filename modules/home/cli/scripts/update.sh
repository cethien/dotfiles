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
    echo "Updating via $EXTRA_PACKAGE_MANAGER"
    sudo $EXTRA_PACKAGE_MANAGER update && sudo $EXTRA_PACKAGE_MANAGER upgrade -y
    echo "done updating via $EXTRA_PACKAGE_MANAGER"
else
    echo "nothing to update"
fi

echo "if you want to update your nix packages, please update the repository flake"
