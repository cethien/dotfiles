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

alias fmt := format
@format:
  nixpkgs-fmt . && shfmt -w $(find . -name '*.sh')

@update: clear
  nix flake update

@build-iso iso="liveIso": clear
  nix build \
    .#nixosConfigurations.{{iso}}.config.system.build.isoImage

@switch-home: clear
  nix run nixpkgs#home-manager -- \
    switch --flake .#{{home}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

@switch: clear
  sudo nixos-rebuild switch --flake .#{{system}}

@install-nixos profile dest: clear
  nix run github:nix-community/nixos-anywhere -- \
      --flake .#{{profile}} \
      --generate-hardware-config nixos-generate-config ./systems/{{profile}}/hardware.nix \
       {{dest}}

@deploy-nixos *targets: clear
  nix run github:serokell/deploy-rs -- \
      {{ if targets == "" { "." } else { "--targets " + targets } }}

@get_host_ip host:
  ansible-inventory --host {{host}} | grep -v '^Using ' | jq -r '.ansible_host // empty'  

deploy dir target="home": clear
  #!/usr/bin/env bash
  dir="{{dir}}"
  host=$(just get_host_ip {{target}})
  stack_name=$(basename "$dir" | sed 's/[^a-z0-9-]/_/g')
  
  echo "🚀 deploying $stack_name to $host"
  DOCKER_HOST=ssh://"$host" docker stack deploy -c "$dir/compose.yml" "$stack_name" --detach=false

remove dir target="home": clear
  #!/usr/bin/env bash
  host=$(just get_host_ip {{target}})
  stack_name=$(basename {{dir}} | sed 's/[^a-z0-9-]/_/g')
  
  echo "❌ removing $stack_name from $host"
  DOCKER_HOST=ssh://"$host" docker stack rm "$stack_name" 

create-secret secret_name target="home": clear
  #!/usr/bin/env bash
  read -s -p "🔐 Enter secret value: " secret_value
  echo -e "\n"
  
  host=$(just get_host_ip {{target}})
  echo "$secret_value" | DOCKER_HOST=ssh://"$host" docker secret create {{secret_name}} -

@remove-secret secret_name target="home": clear
  host=$(just get_host_ip {{target}})
  echo "❌ deleting secret {{secret_name}} from $host"
  DOCKER_HOST=ssh://"$host" docker secret rm {{secret_name}}

