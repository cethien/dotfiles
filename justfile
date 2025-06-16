hostname := if env("WSL_DISTRO_NAME", "empty") == "empty" { lowercase(shell("hostname")) } else { "wsl" }

system := hostname
home := env("USER") + "@" + hostname

[private]
@default:
  just --list

[private]
@clear:
  clear

@check: clear
  nix flake check && nix flake show

@format:
  nixpkgs-fmt . && shfmt -w $(find . -name '*.sh')

@update: clear
  nix flake update

@build-iso iso="liveIso": clear
  nix build \
    .#nixosConfigurations.{{iso}}.config.system.build.isoImage

@switch: clear
  nix run nixpkgs#home-manager -- \
    switch --flake .#{{home}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

@switch-nixos: clear
  sudo nixos-rebuild switch --flake .#{{system}}

@install-nixos profile dest: clear
  nix run github:nix-community/nixos-anywhere -- \
      --flake .#{{profile}} \
      --generate-hardware-config nixos-generate-config ./systems/{{profile}}/hardware.nix \
       {{dest}}

@deploy-nixos *targets:
  nix run github:serokell/deploy-rs -- {{ if targets == "" { "." } else { "--targets " + targets } }}

@ansible playbook +hosts="":
  ansible-playbook {{ playbook }} \
    {{ if hosts != "" { "--extra-vars=\"hosts=" + hosts + "\"" } else { "" } }}

deploy dir:
  #!/usr/bin/env bash
  domain=$(basename "$(dirname {{dir}})")
  stack_name=$(basename {{dir}} | sed 's/[^a-z0-9-]/_/g')
  docker --context "$domain" stack deploy -c "{{dir}}/compose.yml" "$stack_name" --detach=false

remove dir:
  #!/usr/bin/env bash
  domain=$(basename "$(dirname {{dir}})")
  stack_name=$(basename {{dir}} | sed 's/[^a-z0-9-]/_/g')
  docker --context "$domain" stack rm "$stack_name" 

create-secret secret_name ctx="default":
  #!/usr/bin/env bash
  read -s -p "Enter secret value: " secret_value
  echo -e "\n"
  echo "$secret_value" | docker --context {{ctx}} secret create {{secret_name}} -

remove-secret secret_name ctx="default":
  #!/usr/bin/env bash
  docker --context {{ctx}} secret rm {{secret_name}}

[working-directory: 'services/potato-squad.de/minecraft-server']
deploy-minecraft-server:
  #!/usr/bin/env bash
  ssh potato-squad.de -t 'sudo mkdir -p /opt/minecraft-server/bluemap/web'
  rsync --rsync-path="sudo rsync" config potato-squad.de:/opt/minecraft-server/config 
  docker --context "potato-squad.de" stack deploy -c compose.yml minecraft-server --detach=false
