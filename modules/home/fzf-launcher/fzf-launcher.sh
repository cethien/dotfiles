#!/usr/bin/env bash
# @describe TUI Launcher via fzf (Custom Tools + SSH Config)
# @option -c --config Config file path (default: ~/.config/fzf-launcher/config.toml)
# @flag --set-title Set terminal window title to selected item
# @flag --stdout Print command to stdout instead of executing it

# @cmd Interactive preview handler for fzf
# @option -c --config Config file path
# @arg item! The selected menu item
preview() {
	local config_file="${argc_config:-$HOME/.config/fzf-launcher/config.toml}"
	local item="$argc_item"

	if [[ "$item" == 󰣀\ \ ssh@* ]]; then
		local ssh_name
		ssh_name=$(echo "$item" | sed 's/^󰣀  ssh@//')
		if ssh -T -G "$ssh_name" &>/dev/null; then
			ssh -T -G "$ssh_name" | grep -iE '^(user|hostname|port|identityfile) ' | bat --color=always --plain --language=ssh_config
		else
			echo "Host: $ssh_name"
		fi
		exit 0
	fi

	if [[ -f "$config_file" ]]; then
		local preview_cmd
		preview_cmd=$(yq eval ".tools[] | select(.name == \"$item\") | .preview" "$config_file" 2>/dev/null || true)
		if [[ -n "$preview_cmd" && "$preview_cmd" != "null" ]]; then
			eval "$preview_cmd"
			exit 0
		fi
	fi
}

set_window_title() {
	local raw_title="$1"
	local clean_title
	clean_title=$(echo "$raw_title" | sed -E 's/^[^\x00-\x7F]+\s*//')
	printf "\033]2;%s\007" "$clean_title"
}

main() {
	local config_file="${argc_config:-$HOME/.config/fzf-launcher/config.toml}"
	local TAB=$'\t'
	local items=()

	if [[ -f "$config_file" ]]; then
		while IFS=$'\t' read -r name exec_cmd; do
			[[ -n "$name" && -n "$exec_cmd" ]] && items+=("${name}${TAB}${exec_cmd}")
		done < <(yq eval -o=tsv '.tools[] | [.name, .exec]' "$config_file" 2>/dev/null || true)
	fi

	if [[ -f "$HOME/.ssh/config" ]]; then
		while IFS= read -r host; do
			if [[ -n "$host" ]]; then
				local ssh_cmd="ssh -t ${host} 'tmux attach || tmux new-session'"
				items+=("󰣀  ssh@${host}${TAB}${ssh_cmd}")
			fi
		done < <(grep -iE '^Host[[:space:]]' "$HOME/.ssh/config" | cut -d' ' -f2- | tr ' ' '\n' | grep -v '*' || true)
	fi

	[[ ${#items[@]} -eq 0 ]] && exit 0

	local selected
	selected=$(printf "%s\n" "${items[@]}" | fzf \
		--prompt="launch > " \
		--delimiter="${TAB}" \
		--with-nth=1 \
		--preview "$0 preview --config \"$config_file\" {1}" \
		--preview-window "right:50%")

	[[ -z "$selected" ]] && exit 0

	local item_name cmd
	item_name=$(echo "$selected" | cut -d"${TAB}" -f1)
	cmd=$(echo "$selected" | cut -d"${TAB}" -f2-)

	if [[ -n "${argc_set_title:-}" ]]; then
		set_window_title "$item_name"
	fi

	if [[ -n "${argc_stdout:-}" ]]; then
		echo "$cmd"
	else
		eval "$cmd"
	fi
}

eval "$(argc --argc-eval "$0" "$@")"
