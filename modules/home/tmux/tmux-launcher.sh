#!/usr/bin/env bash
# @describe TUI Launcher via fzf (Custom Entries + SSH Config)
# @option -c --config Config file path (default: ~/.config/tmux/launcher.toml)

TAB=$'\t'

generate_toml_entries() {
	local config_file="$1"
	if [[ -f "$config_file" ]]; then
		while IFS=$'\t' read -r icon name hold exec_cmd preview_cmd; do
			if [[ -n "$name" && -n "$exec_cmd" ]]; then
				local display_name="${icon:+$icon }$name"

				if [[ "$hold" == "true" ]]; then
					exec_cmd="${exec_cmd}; echo -e '\\n[Finished] Press Ctrl+C to close...'; trap 'exit 0' INT; sleep infinity"
				fi

				printf "%s${TAB}%s${TAB}%s${TAB}%s\n" "$display_name" "$name" "$exec_cmd" "$preview_cmd"
			fi
		done < <(yq eval -o=tsv '.entries[] | [.icon // "", .name, .hold // false, .exec, .preview // ""]' "$config_file" 2>/dev/null || true)
	fi
}

generate_ssh_entries() {
	local ssh_config="$HOME/.ssh/config"
	if [[ -f "$ssh_config" ]]; then
		while IFS= read -r host; do
			if [[ -n "$host" ]]; then
				local icon="󰣀"
				local name="ssh@${host}"
				local display_name="${icon} ${name}"
				local exec_cmd="ssh -t ${host} 'tmux attach || tmux new-session || exec \$SHELL'"
				local preview_cmd="tmux-launcher-preview --type ssh --host \"${host}\""

				printf "%s${TAB}%s${TAB}%s${TAB}%s\n" "$display_name" "$name" "$exec_cmd" "$preview_cmd"
			fi
		done < <(grep -iE '^Host[[:space:]]' "$ssh_config" | cut -d' ' -f2- | tr ' ' '\n' | grep -v '*' || true)
	fi
}

generate_docker_entries() {
	local ssh_config="$HOME/.ssh/config"
	if [[ -f "$ssh_config" ]]; then
		awk '
            /^[ \t]*Host[ \t]+/ { host = $2 }
            /# *@docker/ { 
                if (host != "" && host != "*") { print host }
            }
        ' "$ssh_config" | while IFS= read -r host; do
			if [[ -n "$host" ]]; then
				local icon="󰡨"
				local name="docker@${host}"
				local display_name="${icon} ${name}"
				local exec_cmd="DOCKER_HOST=\"ssh://${host}\" lazydocker"
				local preview_cmd="tmux-launcher-preview --type docker --host \"${host}\""

				printf "%s${TAB}%s${TAB}%s${TAB}%s\n" "$display_name" "$name" "$exec_cmd" "$preview_cmd"
			fi
		done
	fi
}

main() {
	local config_file="${argc_config:-$HOME/.config/tmux/launcher.toml}"
	local entries=()

	while IFS= read -r line; do
		[[ -n "$line" ]] && entries+=("$line")
	done < <(
		generate_toml_entries "$config_file"
		generate_ssh_entries
		generate_docker_entries
	)

	[[ ${#entries[@]} -eq 0 ]] && exit 0

	local selected
	selected=$(printf "%s\n" "${entries[@]}" | fzf \
		--prompt="launch > " \
		--delimiter="${TAB}" \
		--with-nth=1 \
		--preview "eval {4}" \
		--preview-window "right:50%")

	[[ -z "$selected" ]] && exit 0

	local pure_name cmd
	pure_name=$(echo "$selected" | cut -d"${TAB}" -f2)
	cmd=$(echo "$selected" | cut -d"${TAB}" -f3)

	if [[ -n "${TMUX:-}" ]]; then
		tmux new-window -n "$pure_name" "$cmd"
	else
		eval "$cmd"
	fi
}

eval "$(argc --argc-eval "$0" "$@")"
