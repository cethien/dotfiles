#!/usr/bin/env bash
# shellcheck disable=SC2154

# @describe tooling for deez nuts
# @meta inherit-flag-options
# @flag -y --yes $SKIP_CONFIRM skip confirm messages

_confirm() {
	if [[ -n "${argc_yes:-}" ]]; then
		_log-warn "confirmation skipped"
		return 0
	fi

	gum confirm "$1"
}

_log-info() {
	gum log --time TimeOnly --level info "$*"
}

_log-success() {
	gum log --time TimeOnly --level info --prefix "SUCCESS" "$*"
}

_log-warn() {
	gum log --time TimeOnly --level warn "$*"
}

_log-error() {
	gum log --time TimeOnly --level error "$*"
}

# @cmd generate an age key from ssh key
generate-age-keys() {
	SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt"

	local key_dir
	key_dir=$(dirname "$SOPS_AGE_KEY_FILE")
	mkdir -p "$key_dir"
	touch "$SOPS_AGE_KEY_FILE"

	_log-info "scanning ~/.ssh for private keys..."

	mapfile -t ssh_keys < <(grep -l "PRIVATE KEY" ~/.ssh/* 2>/dev/null | grep -v "\.pub$")

	if [[ ${#ssh_keys[@]} -eq 0 ]]; then
		_log-error "no ssh-key found. generate one:"
		echo -e "   ssh-keygen -q -f ~/.ssh/id_ed25519 -C <your-email> -N \"\""
		exit 1
	fi

	echo -e "select keys:"
	mapfile -t selected_keys < <(gum choose --no-limit "${ssh_keys[@]}")

	if [[ ${#selected_keys[@]} -eq 0 ]]; then
		_log-warn "no keys selected"
		return 0
	fi

	for key in "${selected_keys[@]}"; do
		if [[ -n "$key" ]]; then
			local new_age_key
			new_age_key=$(ssh-to-age -private-key -i "$key" 2>/dev/null)

			if [[ -z "$new_age_key" ]]; then
				_log-error "failed to convert $key. is it passphrase protected?"
				continue
			fi

			if grep -qF "$new_age_key" "$SOPS_AGE_KEY_FILE"; then
				_log-warn "key from $key is already in $SOPS_AGE_KEY_FILE"
			else
				echo "$new_age_key" >>"$SOPS_AGE_KEY_FILE"
				local pubkey
				pubkey=$(echo "$new_age_key" | age-keygen -y 2>/dev/null)
				_log-success "added identity from $key"
				echo -e "public key: ${pubkey}"
			fi
		fi
	done
}

# @cmd bootstrap the sops age key from the nix-deploy key stored in KeePass
# @option --vault <PATH> KeePass database (default: ~/.keep/vault.kdbx)
# @option --entry <NAME> entry holding the SSH private key (default: nix-deploy@holzrussen.net)
bootstrap-sops() {
	local vault="${argc_vault:-$HOME/.keep/vault.kdbx}"
	local entry="${argc_entry:-nix-deploy@holzrussen.net}"
	local cache_dir="$HOME/.cache/dotfiles"
	local ssh_key="$cache_dir/nix-deploy"
	local age_keys="$HOME/.config/sops/age/keys.txt"

	if [[ ! -f "$vault" ]]; then
		_log-error "KeePass database not found: $vault"
		return 1
	fi

	local password
	read -rsp "KeePass password: " password || return 1
	echo

	local entry_info
	if ! entry_info=$(printf '%s\n' "$password" | keepassxc-cli show -q --show-attachments "$vault" "$entry" 2>/dev/null); then
		_log-error "could not open the vault or find entry '$entry'"
		unset password
		return 1
	fi

	local attachments
	attachments=$(printf '%s\n' "$entry_info" | awk '/^Attachments:/{f=1;next} f && /^  /{sub(/^  /,""); sub(/ \(.*\)$/,""); print}')

	local attachment=""
	if printf '%s\n' "$attachments" | grep -qx 'nix-deploy'; then
		attachment="nix-deploy"
	elif [[ -n "$attachments" ]] && [[ $(printf '%s\n' "$attachments" | wc -l) -eq 1 ]]; then
		attachment="$attachments"
	elif [[ -n "$attachments" ]]; then
		attachment=$(gum choose --header "select the SSH private key attachment" <<<"$attachments")
	fi

	if [[ -z "$attachment" ]]; then
		_log-error "no attachment on '$entry' — store the nix-deploy private key as an attachment"
		unset password
		return 1
	fi

	mkdir -p "$cache_dir"
	local tmp_key
	tmp_key=$(mktemp)
	if ! printf '%s\n' "$password" | keepassxc-cli attachment-export -q --stdout "$vault" "$entry" "$attachment" >"$tmp_key" 2>/dev/null; then
		_log-error "failed to export '$attachment' from '$entry'"
		rm -f "$tmp_key"
		unset password
		return 1
	fi
	unset password

	if ! grep -q 'PRIVATE KEY' "$tmp_key"; then
		_log-error "exported attachment '$attachment' is not an SSH private key"
		rm -f "$tmp_key"
		return 1
	fi

	mv "$tmp_key" "$ssh_key"
	chmod 600 "$ssh_key"
	_log-success "cached SSH key at $ssh_key"

	local age_key
	if ! age_key=$(ssh-to-age -private-key -i "$ssh_key" 2>/dev/null) || [[ -z "$age_key" ]]; then
		_log-error "could not derive an age key from $ssh_key"
		return 1
	fi

	mkdir -p "$(dirname "$age_keys")"
	touch "$age_keys"
	if grep -qF "$age_key" "$age_keys"; then
		_log-warn "age key already present in $age_keys"
	else
		echo "$age_key" >>"$age_keys"
		local pubkey
		pubkey=$(echo "$age_key" | age-keygen -y 2>/dev/null)
		_log-success "added sops age identity: $pubkey"
	fi
}

# @cmd build an iso
build-booty() {
	command nix build .#booty
}

_local_diff() {
	local target_host
	target_host=$(hostname | tr '[:upper:]' '[:lower:]')

	_log-info "Building dry-run for $target_host to compare changes..."

	if nixos-rebuild build --flake ".#$target_host"; then
		trap 'rm -f ./result' EXIT
		echo ""
		nvd diff /run/current-system ./result
	else
		_log-error "Failed to build system config for diff"
		return 1
	fi
}

# @cmd show diff between current system and local flake
diff() {
	_local_diff
}

# @cmd updates inputs
# @describe                            updates inputs [defaults to all apps & system base]
# @flag --repo                         update repo tooling only (disko, sops, deploy-rs)
# @flag --no-diff                      skip system diff after update
update() {
	local INPUTS=()

	if [ -n "$argc_repo" ]; then
		INPUTS+=(
			disko
			sops-nix
			deploy-rs
		)
		_log-info "Updating core repo inputs: ${INPUTS[*]}"
	else
		INPUTS+=(
			nixos-hardware
			nixpkgs
			determinate

			zen-browser
			nur
			spicetify-nix

			nixpkgs-unstable
			home-manager
			nix-index-database

			nixcord
			nix-gaming
			musnix
		)
		_log-info "Updating ALL system and app inputs: ${INPUTS[*]}"
	fi

	nix flake update "${INPUTS[@]}"

	if [ -z "$argc_no_diff" ]; then
		_local_diff
	fi
}

# @cmd switch to nixos-configuration / home-manager config
# @flag -b --boot use boot action to prepare config without switching (eg. kernel updates)
# @flag -p --pull git pull first
# @flag -d --diff show diff
# @arg args* Extra flags to pass directly to nixos-rebuild
switch() {
	if [[ -n "$argc_pull" ]]; then
		git pull --rebase --autostash
	fi

	if [[ -n "$argc_diff" ]]; then
		_local_diff
	fi

	local action="switch"
	if [ -n "$argc_boot" ]; then
		action="boot"
	fi

	export TARGET_HOST
	TARGET_HOST=$(hostname | tr '[:upper:]' '[:lower:]')

	local offline_flags=""
	# Sänk you for travelling with Deutsche Bahn
	if ! ping -c 1 -W 1 cache.nixos.org &>/dev/null; then
		_log-info "Network unreachable: forcing offline mode"
		offline_flags="--offline --option substitute false"
	fi

	if command -v nixos-rebuild &>/dev/null; then
		_confirm "switch system $TARGET_HOST?" || return 0

		sudo nixos-rebuild "$action" \
			--flake ".#$TARGET_HOST" \
			--fallback \
			--no-write-lock-file \
			$offline_flags \
			"${argc_args[@]}"
		return
	fi

	_log-error "no nixos config for '$TARGET_HOST'"
	return 1
}

# ----------------------------
# HOMELAB / HOST MANAGEMENT
# ----------------------------

_nixos_hosts() {
	local dir
	for dir in hosts/*; do
		[[ -f "$dir/configuration.nix" ]] || continue
		[[ "$(basename "$dir")" == _* ]] && continue
		basename "$dir"
	done
}

_diff-nixos-system() {
	local host="$1"
	_log-info "building local system for $host..."

	local new_system
	if ! new_system=$(nix build ".#nixosConfigurations.${host}.config.system.build.toplevel" --print-out-paths --no-link); then
		_log-error "failed to build configuration for $host"
		return 1
	fi

	_log-info "copying closure to $host..."
	nix copy --to "ssh://$host" "$new_system" || return 1

	_log-info "diff for $host:"
	ssh "$host" "nix store diff-closures /nix/var/nix/profiles/system $new_system"
}

# @cmd diff local nixos configuration against the remote host profile
# @arg host![`_nixos_hosts`]
diff-nixos-host() {
	_diff-nixos-system "$argc_host"
}

# @cmd deploy a host with deploy-rs
# @flag -b --boot prepare the new generation for next boot only
# @flag -d --diff show remote closure diff before deploying
# @arg host![`_nixos_hosts`]
deploy() {
	local extra_args=()
	[[ -n "${argc_boot:-}" ]] && extra_args+=("--boot")

	if [[ -n "${argc_diff:-}" ]]; then
		_diff-nixos-system "$argc_host" || return 1
	fi

	_confirm "deploy $argc_host?" || return 0

	command deploy "${extra_args[@]}" --targets ".#$argc_host"
}

# @cmd bootstrap nixos on a fresh machine with nixos-anywhere
# @arg host![`_nixos_hosts`]
# @arg addr! IP address or hostname of the target machine
# @arg user="root" ssh user for the initial install
# @option -i --key <KEY> ssh private key (default: $DOTFILES_DEPLOY_KEY, ~/.ssh/nix-deploy, or the cached KeePass key)
install-nixos() {
	local key="${argc_key:-${DOTFILES_DEPLOY_KEY:-}}"
	if [[ -z "$key" ]]; then
		if [[ -s "$HOME/.ssh/nix-deploy" ]]; then
			key="$HOME/.ssh/nix-deploy"
		else
			key="$HOME/.cache/dotfiles/nix-deploy"
		fi
	fi

	if [[ ! -s "$key" ]]; then
		_log-error "ssh private key not found: $key"
		return 1
	fi

	_log-info "checking if $argc_addr is reachable..."
	if ! ssh-keyscan -T 5 "$argc_addr" 2>/dev/null | grep -q .; then
		_log-error "$argc_addr is not reachable via ssh"
		return 1
	fi

	_confirm "install $argc_host on $argc_addr?" || return 1

	# Inject an age identity derived from the deploy ssh key for future sops secrets.
	local extra_files="/tmp/nixos-anywhere-secrets"
	mkdir -p "$extra_files/var/lib/sops"
	local age_key="$extra_files/var/lib/sops/key.txt"
	if ! ssh-to-age -private-key -i "$key" >"$age_key" 2>/dev/null || [[ ! -s "$age_key" ]]; then
		_log-warn "could not derive age key; skipping sops key injection"
		rm -f "$age_key"
		extra_files=""
	else
		chmod 600 "$age_key"
	fi

	local args=(
		--flake ".#$argc_host"
		-i "$key"
		--ssh-option "StrictHostKeyChecking=no"
		--ssh-option "UserKnownHostsFile=/dev/null"
	)
	[[ -n "$extra_files" ]] && args+=(--extra-files "$extra_files")

	command nixos-anywhere "${args[@]}" "$argc_user@$argc_addr"
}

eval "$(argc --argc-eval "$0" "$@")"
