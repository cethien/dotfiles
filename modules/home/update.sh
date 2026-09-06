#!/usr/bin/env bash
set -euo pipefail

# @describe System update script (NixOS via Flake or APT/Nala fallback)
# @meta require-tools nixos-rebuild,nvd,gum
# @meta show-help-with gum format

# @cmd
# @flag -y --yes Skip confirmation prompt
main() {
	_check_sudo

	if _is_nixos; then
		_update_nixos
	else
		_update_fallback
	fi
}

_check_sudo() {
	if [[ $EUID -ne 0 ]]; then
		gum log --time TimeOnly --level error "This script must be run with sudo."
		exit 1
	fi
}

_is_nixos() {
	[[ -d /run/current-system ]] && command -v nixos-rebuild &>/dev/null
}

_update_nixos() {
	local target_host flake_uri
	target_host=$(hostname | tr '[:upper:]' '[:lower:]')
	flake_uri="github:cethien/dotfiles#${target_host}"

	gum log --time TimeOnly --level info "Building system closure for ${target_host}..."

	nixos-rebuild build --flake "${flake_uri}" --fallback

	nvd diff /run/current-system ./result

	if [[ -z "${argc_yes:-}" ]]; then
		if ! gum confirm "Apply configuration to ${target_host}?"; then
			gum log --time TimeOnly --level warn "Aborted."
			rm -f ./result
			exit 0
		fi
	fi

	nixos-rebuild switch --flake "${flake_uri}" --fallback
	rm -f ./result
}

_update_fallback() {
	local extra_pm=""

	if command -v nala &>/dev/null; then
		extra_pm="nala"
	elif command -v apt &>/dev/null; then
		extra_pm="apt"
	fi

	if [[ -n "$extra_pm" ]]; then
		gum log --time TimeOnly --level info "Updating via ${extra_pm}..."
		"$extra_pm" update && "$extra_pm" upgrade -y
	else
		gum log --time TimeOnly --level info "Nothing to update."
	fi
}

eval "$(argc --argc-eval "$0" "$@")"
