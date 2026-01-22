#!/usr/bin/env bash
# shellcheck disable=SC2154

# @describe tooling for deez nuts

# @cmd
hosts() { :; }

# @cmd
# @arg host[`_nixos_host_names`]
# @arg args* Pass-through flags for deploy-rs
hosts::deploy-nixos() {
  command nix run github:serokell/deploy-rs -- --targets ".#${argc_host:-}" "${argc_args[@]}"
}

# @cmd
# @arg host+[`_nixos_host_names`]
# @arg addr="192.168.1.115"
# @arg user="nixos"
hosts::install-nixos() {
  clear
  _log-info "checking if $argc_addr is reachable..."
  if ! ssh-keyscan -T 5 "$argc_addr" 2>/dev/null | grep -q .; then
    _log-error "$argc_addr is not reachable via ssh"
    return 1
  fi

  _confirm "install $argc_host to $argc_addr?"
  _log "📼 installing $argc_host to $argc_addr"
  command nix run github:nix-community/nixos-anywhere -- \
    --flake ".#$argc_host" \
    --generate-hardware-config nixos-generate-config ./hosts/$argc_host/hardware-configuration.nix \
    "$argc_user@$argc_addr"
}

_nixos_host_names() {
  _q '.hosts | with_entries(select(.value.os == null)) | keys | .[]'
}

# @cmd
# @arg os[`_hosts_os_names`]
hosts::list() {
  os="${argc_os:-}"
  if [ ! -z "$os" ]; then
    _hosts_by_os "$os"
    return
  fi
  _q '.hosts'
}

_hosts_os_names() {
  os=$1
  _q '.defaults.hosts.os as $def | .hosts | map(.os // $def) | unique | .[]'
}

_hosts_by_os() {
  OS="$1" _q '
    .defaults.hosts.os as $def
    | .hosts
    | with_entries(
        select((.value.os // $def) == env(OS))
      )
  '
}

# @cmd
# @meta require-tools docker
services() { :; }

# @cmd
services::list() {
  _q '.services'
}

# @cmd
# @arg service+[`_service_names`]
# @option --host <hostname>   Override host from inventory
services::deploy() {
  _resolve_service
  clear
  _confirm "deploy $SERVICE to $HOST ($ADDR)?" || exit 1
  _log "🚀 deploying $SERVICE on $HOST ($ADDR)"
  command docker stack deploy -c "services/$SERVICE/compose.yml" "$SERVICE" --detach=false
}

# @cmd
# @arg service+[`_service_names`]
# @option --host <hostname>   Override host from inventory
services::remove() {
  _resolve_service
  clear
  _confirm "remove $SERVICE from $HOST ($ADDR)?" || exit 1
  _log "💀 removing $SERVICE from $HOST ($ADDR)"
  command docker stack rm "$SERVICE"
}

_service_names() {
  _q '.services | keys | .[]'
}

_resolve_service() {
  export SERVICE="$argc_service"

  if [[ -n "${argc_host:-}" ]]; then
    HOST="$argc_host"
  else
    HOST=$(_q '.services[env(SERVICE)].host // .clusters[.services[env(SERVICE)].cluster].swarm_managers[0]')
  fi
  export HOST
  ADDR=$(
    export HOST
    _q '.hosts["'"$HOST"'"].address'
  )
  export DOCKER_HOST="ssh://$ADDR"
}

# @cmd
# @meta require-tools jq
switch() {
  local hostname
  [[ -n "${WSL_DISTRO_NAME:-}" ]] && hostname="wsl" || hostname=$(hostname | tr '[:upper:]' '[:lower:]')

  local flake_json
  flake_json=$(nix flake show --json . 2>/dev/null)

  clear

  if command -v nixos-rebuild &>/dev/null; then
    _log-success "nixos-rebuild found"
    if echo "$flake_json" | jq -e ".nixosConfigurations.\"$hostname\"" &>/dev/null; then
      _log-success "configuration $hostname found"
      _confirm "switch system?"
      sudo nixos-rebuild switch --flake ".#$hostname"
      return
    fi
    _log-info "no configuration for $hostname"
  fi

  local hm_user="${USER}@$hostname"
  if echo "$flake_json" | jq -e ".homeConfigurations.\"$hm_user\"" &>/dev/null; then
    _log-success "home-manager config for $hm_user found"
    if ! command -v home-manager &>/dev/null; then
      _log-error "'home-manager' missing."
      exit 1
    fi
    _confirm "switch home?"
    home-manager switch --flake ".#$hm_user" -b "bak-hm-$(date +%Y%m%d_%H%M%S)"
    return
  fi

  err_msg="no nixos config for $hostname"
  if command -v home-manager &>/dev/null; then
    err_msg+=" or home-manager config for $hm_user"
  fi
  _log-error "$err_msg found"
  exit 1
}

# -------
# HELPERS
# -------

_confirm() {
  [[ "${CI:-}" == "true" || "${NO_CONFIRM:-}" == "1" ]] && return 0
  read -rp "❓ $1 [y/N] " reply
  [[ "$reply" =~ ^[yY]$ ]]
}

_log() {
  echo "[$(date +'%H:%M:%S')] $*"
}

_log-info() {
  _log "ℹ️ $*"
}

_log-success() {
  _log "✅ $*"
}

_log-error() {
  _log "❌ ERROR: $*"
}

_log-warn() {
  _log "⚠️ $*"
}

_q() { command yq -oy "$1" inventory.toml; }

eval "$(argc --argc-eval "$0" "$@")"
