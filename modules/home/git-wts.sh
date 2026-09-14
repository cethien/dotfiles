#!/usr/bin/env bash

# @describe Manage git worktrees with automatic tmux sessions
# @meta require-tools git,tmux,gum

# @arg branch Branch name for the worktree

main() {
	local branch="$argc_branch"

	local repo_root
	repo_root=$(git rev-parse --show-toplevel 2>/dev/null)
	if [ -z "$repo_root" ]; then
		echo "❌ Not inside a git repository" >&2
		exit 1
	fi

	local parent_dir
	parent_dir=$(dirname "$repo_root")
	local repo_name
	repo_name=$(basename "$repo_root")
	local wts_base="$parent_dir/${repo_name}.wts"

	if [ -z "$branch" ]; then
		local branches
		branches=$(git branch -a --format='%(refname:short)' | sed 's#^origin/##' | sort -u)

		local selected
		selected=$(echo -e "[new branch]\n$branches" | gum filter --height 15 --placeholder "Select or filter branch...")

		if [ -z "$selected" ]; then
			exit 0
		fi

		if [ "$selected" = "[new branch]" ]; then
			branch=$(gum input --placeholder "Enter new branch name:")
			if [ -z "$branch" ]; then
				exit 0
			fi
		else
			branch="$selected"
		fi
	fi

	local safe_branch
	safe_branch=$(echo "$branch" | tr '/' '_')
	local wt_dir="$wts_base/$safe_branch"
	local session_name="${repo_name}__${safe_branch}"

	# Prüfen, ob der Branch bereits in irgendeinem Worktree aktiv ist
	local existing_wt
	existing_wt=$(git worktree list | grep -F "[$branch]" | awk '{print $1}')

	if [ -n "$existing_wt" ]; then
		wt_dir="$existing_wt"
	elif [ ! -d "$wt_dir" ]; then
		mkdir -p "$wts_base"

		if git show-ref --verify --quiet "refs/heads/$branch"; then
			git worktree add "$wt_dir" "$branch"
		elif git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
			git worktree add --track -b "$branch" "$wt_dir" "origin/$branch"
		else
			git worktree add -b "$branch" "$wt_dir"
		fi
	fi

	if [ -n "$TMUX" ]; then
		if ! tmux has-session -t "$session_name" 2>/dev/null; then
			tmux new-session -d -s "$session_name" -c "$wt_dir"
		fi
		tmux switch-client -t "$session_name"
	else
		tmux new-session -A -s "$session_name" -c "$wt_dir"
	fi
}

eval "$(argc --argc-eval "$0" "$@")"
