_tmux_session() {
  local name
  if [ -n "$1" ] && [[ "$1" != -* ]]; then
    name="$1"
  else
    name=$(basename "$PWD")
  fi
  local session=$(echo "$name" | tr -c 'a-zA-Z0-9_' '_' | sed 's/_$//')
  [ "$session" = "$USER" ] && echo "deez_nuts" || echo "$session"
}

tmux_new() {
  local arg_f="$1"
  local tmux_args=("$@")
  local s=$(_tmux_session "$arg_f")
  if [ -n "$arg_f" ] && [[ "$arg_f" != -* ]]; then tmux_args=("${@:2}"); fi
  if [ -n "$TMUX" ]; then
    tmux new-session -d -s "$s" "${tmux_args[@]}"
    echo "Created detached tmux session: '$s'"
  else
    tmux new-session -A -s "$s" "${tmux_args[@]}"
  fi
}
