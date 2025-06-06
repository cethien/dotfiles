hostname := if env("WSL_DISTRO_NAME", "empty") == "empty" { lowercase(shell("hostname")) } else { "wsl" }

system := hostname
home := env("USER") + "@" + hostname

[private]
@default:
    just --list

@check:
    nix flake check && nix flake show

@format:
    nixpkgs-fmt . && shfmt -w $(find . -name '*.sh')

@update:
    clear && nix flake update

@rebuild:
    clear && nix run nixpkgs#home-manager -- switch --flake .#{{home}} -b bak-hm-$(date +%Y%m%d_%H%M%S)

@rebuild-nixos:
    clear && sudo nixos-rebuild switch --flake .#{{system}}

nixos-install profile dest:
    nix run github:nix-community/nixos-anywhere -- \
    --flake .#{{profile}} \
    --generate-hardware-config nixos-generate-config ./systems/{{profile}}/hardware.nix \
    {{dest}}

nixos-deploy *targets:
    nix run github:serokell/deploy-rs -- {{ if targets == "" { "." } else { "--targets " + targets } }}

@ansible-run playbook +hosts="":
    ansible-playbook {{ playbook }} \
    {{ if hosts != "" { "--extra-vars=\"hosts=" + hosts + "\"" } else { "" } }}

docker-deploy dir:
    #!/usr/bin/env bash
    domain=$(basename "$(dirname {{dir}})")
    stack_name=$(basename {{dir}} | sed 's/[^a-z0-9-]/_/g')
    docker --context "$domain" stack deploy -c "{{dir}}/compose.yml" "$stack_name" --detach=false

docker-remove dir:
    #!/usr/bin/env bash
    domain=$(basename "$(dirname {{dir}})")
    stack_name=$(basename {{dir}} | sed 's/[^a-z0-9-]/_/g')
    docker --context "$domain" stack rm "$stack_name" 

docker-create-secret secret_name ctx="default":
    #!/usr/bin/env bash
    read -s -p "Enter secret value: " secret_value
    echo -e "\n"
    echo "$secret_value" | docker --context {{ctx}} secret create {{secret_name}} -

docker-remove-secret secret_name ctx="default":
    #!/usr/bin/env bash
    docker --context {{ctx}} secret rm {{secret_name}}

