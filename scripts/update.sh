#!/usr/bin/env bash

sudo nala update && sudo nala upgrade -y
nix-channel --update
(cd "$HOME"/.config/home-manager && nix flake update)
