#!/usr/bin/env bash
# shellcheck disable=SC2154

# @describe tooling for deez nuts
# @meta inherit-flag-options
# @flag -y --yes $SKIP_CONFIRM skip confirm messages
# @flag -f --skip-validation $SKIP_VALIDATION skip inventory validation

# @cmd build an iso
build-booty() {
  command nix build .#booty
}

# @cmd updates inputs
# @describe                           updates inputs [defaults client modules]
# @flag --hosts                       exclusively update host related inputs
# @flag --nixpkgs                     also update nixpkgs / nixpkgs-unstable (defaults to nixpkgs-unstable, use with --hosts for nixpkgs)
# @flag --zen                         only zen and firefox addons
# @flag --tools                       update repo tooling
flake-update() {
  local INPUTS=()

  if [ -n "$argc_hosts" ]; then
    [ -n "$argc_nixpkgs" ] && INPUTS+=(nixpkgs)
  else
    [ -n "$argc_nixpkgs" ] && INPUTS+=(nixpkgs-unstable)
    INPUTS+=(
      nixos-hardware
      nix-gaming
      musnix
      home-manager
      stylix
      nvf
      spicetify-nix
      zen-browser
      firefox-addons
    )
  fi

  INPUTS+=(sops-nix)
  [ -n "$argc_tools" ] && INPUTS+=(flake-utils deploy-rs disko)

  [ -n "$argc_zen" ] && INPUTS=(zen-browser firefox-addons)

  echo "Updating: ${INPUTS[*]}"
  nix flake update "${INPUTS[@]}"
}

# @cmd switch to nixos-configuration / home-manager config
# @flag -b --boot use boot action to prepare config without switching (eg. kernel updates)
switch() {
  local action="switch"
  if [ -n "$argc_boot" ]; then
    action="boot"
  fi

  export TARGET_HOST
  TARGET_HOST=$(hostname | tr '[:upper:]' '[:lower:]')

  local offline_flags=""
  if ! ping -c 1 -W 1 cache.nixos.org &>/dev/null; then
    _log-info "Network unreachable: forcing offline mode"
    offline_flags="--offline --option substitute false"
  fi

  if command -v nixos-rebuild &>/dev/null; then
    _confirm "switch system $TARGET_HOST?"
    sudo nixos-rebuild "$action" --flake ".#$TARGET_HOST" --fallback --no-write-lock-file $offline_flags
    return
  fi

  if command -v nixos-rebuild &>/dev/null; then
    _log-error "no nixos config for '$TARGET_HOST'"
    return 1
  fi

  return 1
}

# @cmd
validate-inventory() {
  _validate-inventory
}

# -------
# HELPERS
# -------

_validate-inventory() {
  if [[ -n "${argc_skip_validation:-}" ]]; then
    _log-warn "validation skipped"
    return 0
  fi

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
