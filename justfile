[private]
@default:
    just --list

alias fmt := format
@format:
    nixpkgs-fmt .

alias l := lint
@lint:
    nixpkgs-fmt --check .

alias u := update
@update:
    nix flake update

alias r := rebuild
@rebuild profile:
    home-manager switch --flake .#{{profile}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

alias r-os := rebuild-nixos
@rebuild-nixos profile:
    sudo nixos-rebuild switch --flake .#{{profile}}

alias i := install
@install profile dest:
    nix run github:nix-community/nixos-anywhere -- \
    --flake .#{{profile}} \
    --generate-hardware-config nixos-generate-config ./hosts/{{profile}}/hardware-configuration.nix \
    {{dest}}

alias d := deploy
@deploy profile dest:
    nixos-rebuild switch \
    --flake .#{{profile}} \
    --target-host {{dest}} \
    --use-remote-sudo