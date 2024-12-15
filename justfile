@default:
    just --list

@format:
    nixpkgs-fmt .

@lint:
    nixpkgs-fmt --check .

@update:
    nix flake update