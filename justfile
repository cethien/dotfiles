hostname := if env("WSL_DISTRO_NAME", "empty") == "empty" { lowercase(shell("hostname")) } else { "wsl" }

system := hostname
home := env("USER") + "@" + hostname

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

@rebuild:
    nix run nixpkgs#home-manager -- switch --flake .#{{home}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

@rebuild-nixos:
    sudo nixos-rebuild switch --flake .#{{system}}

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
