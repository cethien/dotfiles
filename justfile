[private]
@default:
  just --list

[private]
@clear:
  clear

alias fmt := format
@format:
  nixpkgs-fmt . && shfmt -w $(find . -name '*.sh')

hostname := if env("WSL_DISTRO_NAME", "empty") == "empty" { lowercase(shell("hostname")) } else { "wsl" }
system := hostname
@switch: clear
  sudo -A nixos-rebuild switch --flake .#{{system}}

home := env("USER") + "@" + hostname
@switch-home: clear
  nix run nixpkgs#home-manager -- \
    switch --flake .#{{home}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

@install-nixos profile dest: clear
  nix run github:nix-community/nixos-anywhere -- \
      --flake .#{{profile}} \
      --generate-hardware-config nixos-generate-config ./systems/{{profile}}/hardware.nix \
       {{dest}}

@deploy-nixos *targets: clear
  nix run github:serokell/deploy-rs -- \
      {{ if targets == "" { "." } else { "--targets " + targets } }}

deploy-service service: clear
  #!/usr/bin/env bash
  tq="tq -f deploy.toml"
  hostname=$($tq services.{{service}}.host | tr -d '"')
  host=$($tq hosts."$hostname".address | tr -d '"')
  echo "🚀 deploying {{service}} to $hostname"
  DOCKER_HOST=ssh://"$host" docker stack deploy -c "services/{{service}}/compose.yml" "{{service}}" --detach=false


remove-service service: clear
  #!/usr/bin/env bash
  tq="tq -f deploy.toml"
  hostname=$($tq services.{{service}}.host | tr -d '"')
  host=$($tq hosts."$hostname".address | tr -d '"')
  echo "❌ removing {{service}} from $hostname"
  DOCKER_HOST=ssh://"$host" docker stack rm "{{service}}" 


