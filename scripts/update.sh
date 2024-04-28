#!/bin/bash

nix-channel --update
(cd "$HOME"/.config/home-manager && nix flake update)
