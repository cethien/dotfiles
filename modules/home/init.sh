#!/usr/bin/env bash

# @describe nixify or init projects
# @meta require-tools nix,git

# @meta inherit-flag-options
# @option -t --template Specific template variant
# @flag -l --local-only Only add flake locally without tracking it in the main repository

resolve_target_dir() {
	local input="$1"
	local fallback_name="$2"

	if [ -z "$input" ]; then
		echo "$HOME/$fallback_name"
		return
	fi

	if [[ "$input" =~ ^(/|\./|\.\./|~) ]]; then
		echo "${input/#\~/$HOME}"
		return
	fi

	echo "$HOME/$input"
}

# @cmd Create or initialize a local project
main() {
	local fallback="new-project"
	if [ -n "$argc_template" ]; then
		fallback="new-${argc_template}-project"
	fi

	TARGET_DIR=$(resolve_target_dir "$argc_dest" "$fallback")

	if [ -f "$TARGET_DIR/flake.nix" ]; then
		echo "⚠️ skipping: folder contains flake.nix"
		exit 0
	fi

	MSG="📦 added flake to $TARGET_DIR"
	if [ -n "$argc_template" ]; then
		MSG="📦 added ${argc_template}-flake to $TARGET_DIR"
	fi

	if [ ! -d "$TARGET_DIR" ]; then
		MSG="🚀 creating $TARGET_DIR"
		mkdir -p "$TARGET_DIR"
	fi

	cd "$TARGET_DIR" || exit

	if [ ! -d ".git" ]; then
		git init -q
	fi

	setup_flake_and_git "$TARGET_DIR" "$argc_template" "$argc_local_only" "$MSG"
	finalize_setup "$TARGET_DIR"
}

# @cmd clone a repository and initialize a flake
# @arg giturl! Git repository URL
# @arg dest destination directory (Default: $HOME/[repo-name])
clone() {
	local fallback
	fallback=$(basename "$argc_giturl" .git)
	TARGET_DIR=$(resolve_target_dir "$argc_dest" "$fallback")

	if [ -f "$TARGET_DIR/flake.nix" ]; then
		echo "⚠️ skipping: folder contains flake.nix"
		exit 0
	fi

	MSG="🚀 cloning repo and initializing in $TARGET_DIR"
	if [ -d "$TARGET_DIR" ]; then
		MSG="📦 folder exists, initializing in $TARGET_DIR"
	else
		git clone "$argc_giturl" "$TARGET_DIR"
	fi

	cd "$TARGET_DIR" || exit

	setup_flake_and_git "$TARGET_DIR" "$argc_template" "$argc_local_only" "$MSG"
	finalize_setup "$TARGET_DIR"
}

setup_flake_and_git() {
	local target_dir="$1"
	local template_var="${2:-default}"
	local local_only="$3"
	local msg="$4"

	if [ -n "$local_only" ]; then
		mkdir -p .git/info
		local excludes=(
			"flake.nix"
			"flake.lock"
			".envrc"
			".direnv/"
			"shell.nix"
		)
		printf '%s\n' "${excludes[@]}" >>.git/info/exclude
	fi

	local template="github:cethien/dotfiles#${template_var}"
	if [[ "$template_var" == *#* || "$template_var" == *:* ]]; then
		template="$template_var"
	fi

	nix flake init -t "$template"
	echo "$msg"

	if [ -z "$local_only" ]; then
		git add .
	fi
}

finalize_setup() {
	local target_dir="$1"

	if [ -f ".envrc" ] && command -v direnv &>/dev/null; then
		direnv allow .
	fi

	if [ -z "$TMUX" ]; then
		return
	fi

	local session_name
	session_name=$(basename "$target_dir" | tr '.' '_')

	if ! tmux has-session -t "$session_name" 2>/dev/null; then
		tmux new-session -d -s "$session_name" -c "$target_dir"
	fi

	tmux switch-client -t "$session_name"
}

eval "$(argc --argc-eval "$0" "$@")"
