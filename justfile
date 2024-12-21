@default:
    just --list

alias fmt := format
@format:
    nixpkgs-fmt .

@lint:
    nixpkgs-fmt --check .

@update:
    nix flake update

@install-on-remote profile dest:
    nix run nixpkgs#nixos-anywhere -- \
    --flake .#{{profile}} \
    --generate-hardware-config nixos-generate-config ./hosts/{{profile}}/hardware-configuration.nix \
    {{dest}}