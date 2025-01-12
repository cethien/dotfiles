set dotenv-load

[private]
@default:
    just --list

@check:
    nix flake check && nix flake show

@format:
    nixpkgs-fmt .

@lint:
    nixpkgs-fmt --check .

@update:
    nix flake update

@rebuild profile='$HOMEMANAGER_CONFIG':
    home-manager switch --flake .#{{profile}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

@rebuild-nixos profile='$NIXOS_CONFIG':
    sudo nixos-rebuild switch --flake .#{{profile}}

@install profile dest:
    nix run github:nix-community/nixos-anywhere -- \
    --flake .#{{profile}} \
    --generate-hardware-config nixos-generate-config ./systems/{{profile}}/hardware.nix \
    {{dest}}

@deploy profile dest:
    nixos-rebuild switch \
    --flake .#{{profile}} \
    --target-host {{dest}} \
    --use-remote-sudo