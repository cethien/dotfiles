#!/usr/bin/env bash
# shellcheck disable=SC2154

# @describe tooling for deez nuts
# @flag -y --yes $SKIP_CONFIRM skip confirm messages

# @cmd
deploy() { :; }

# @cmd
list() { :; }

# @cmd
# @arg host[`_nixos_host_names`]
# @arg args* Pass-through flags for deploy-rs
deploy::hosts() {
  _validate-inventory
  command nix run github:serokell/deploy-rs -- --targets ".#${argc_host:-}" "${argc_args[@]}"
}

# @cmd
# @arg host+[`_nixos_host_names`]
# @arg addr="192.168.1.115"
# @arg user="nixos"
deploy::nixos-installation() {
  clear
  _validate-inventory
  _log-info "checking if $argc_addr is reachable..."
  if ! ssh-keyscan -T 5 "$argc_addr" 2>/dev/null | grep -q .; then
    _log-error "$argc_addr is not reachable via ssh"
    return 1
  fi

  _confirm "install $argc_host to $argc_addr?" || exit 1
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
list::hosts() {
  _validate-inventory
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
# @arg service+[`_service_names`]
# @option --host <hostname>   Override host from inventory
deploy::service() {
  _validate-inventory
  _resolve_service
  clear
  _confirm "deploy $SERVICE to $HOST ($ADDR)?" || exit 1
  command docker stack deploy -c "services/$SERVICE/compose.yml" "$SERVICE" --detach=false
}

# @cmd
list::services() {
  _validate-inventory
  _q '.services'
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

# @cmd switch to nixos-configuration / home-manager config
switch() {
  export TARGET_HOST
  TARGET_HOST=$(hostname | tr '[:upper:]' '[:lower:]')
  clear

  if command -v nixos-rebuild &>/dev/null &&
    _q '.clients | has(env(TARGET_HOST))' &>/dev/null; then
    _log-success "nixos: configuration '$TARGET_HOST' found"
    _confirm "switch system?"
    sudo nixos-rebuild switch --flake ".#$TARGET_HOST"
    return
  fi

  local hm_config="$USER@$TARGET_HOST"
  if command -v home-manager &>/dev/null &&
    _q '.homes.[env(TARGET_HOST)].user == env(USER)' &>/dev/null; then
    _log-success "home-manager: configuration '$hm_config' found"
    _confirm "switch home?"
    home-manager switch --flake ".#$hm_config" -b "bak-hm-$(date +%Y%m%d_%H%M%S)"
    return
  fi

  if command -v nixos-rebuild &>/dev/null; then
    _log-error "no nixos config for '$TARGET_HOST'"
    return 1
  fi
  if command -v home-manager &>/dev/null; then
    _log-error "no home-manager config for '$hm_config'"
    return 1
  fi

  _log-error "neither nixos-rebuild nor home-manager found"
  return 1
}

# @cmd for when i forgor to add bootstrap profile
# @arg profile Overwrite the default user@hostname profile
bootstrap-home() {
  local target="${argc_profile:-$(whoami)@$(hostname | tr '[:upper:]' '[:lower:]')}"

  _log "🚀 bootstrapping home-manager for $target"

  if ! _q '.homes.[env(TARGET_HOST)].user == env(USER)' &>/dev/null; then
    _log-error "config $target not found in local flake."
    _log-info "edit inventory.toml and try again."
    return 1
  fi

  nix run .#homeConfigurations."$target".activationPackage
}

# @cmd
validate-inventory() {
  _validate-inventory
}

# -------
# HELPERS
# -------

_validate-inventory() {
  if python3 validate_inventory.py; then
    _log-success "inventory validation passed"
  else
    _log-error "inventory validation failed"
    return 1
  fi
}

_confirm() {
  if [[ -n "${argc_yes:-}" ]]; then
    _log-warn "confirmation skipped"
    return 0
  fi

  read -rp "$(_log "❓ $1 [y/N] > ")" reply
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

_q() { command yq -eoy "$1" inventory.toml; }

eval "$(argc --argc-eval "$0" "$@")"
