#!/usr/bin/env bash

# @describe create a new project
# @meta require-tools nix
# @arg dest! Destination
# @option -t --template=default <VARIANT> Specific template variant

eval "$(argc --argc-eval "$0" "$@")"

TEMPLATE="github:cethien/dotfiles#${argc_template}"
echo "🚀 Creating project at $argc_dest using $TEMPLATE..."
nix flake new -t "$TEMPLATE" "$argc_dest"
