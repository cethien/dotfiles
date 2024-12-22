@default:
    just --list

alias fmt := format
@format:
    nixpkgs-fmt .

@lint:
    nixpkgs-fmt --check .

@update:
    nix flake update

@install profile dest:
    nix run github:nix-community/nixos-anywhere -- \
    --flake .#{{profile}} \
    --generate-hardware-config nixos-generate-config ./hosts/{{profile}}/hardware-configuration.nix \
    {{dest}}

@install-tower-vm ip:
    nix run github:nix-community/nixos-anywhere -- \
    --flake .#tower-of-power \
    --generate-hardware-config nixos-generate-config ./hosts/tower-vm/hardware-configuration.nix \
    nixos@{{ip}}

@deploy profile dest:
    nixos-rebuild switch \
    --flake .#{{profile}} \
    --target-host {{dest}} \
    --use-remote-sudo