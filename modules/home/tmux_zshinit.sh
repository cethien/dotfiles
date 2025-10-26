_tmux_session() {
  local name="$1"

  if [[ -z "$name" || "$name" == -* ]]; then
    name=$(basename "$PWD")
  fi

  local session
  session=$(echo "$name" | tr -c 'a-zA-Z0-9_' '_' | sed 's/_$//')

  [[ "$session" == "$USER" ]] && echo "deez_nuts" || echo "$session"
}

tmux_new() {
  local arg_f="$1"
  local tmux_args=("$@")
  local s=$(_tmux_session "$arg_f")

  if [[ -n "$arg_f" && "$arg_f" != -* ]]; then
    tmux_args=("${@:2}")
  fi

  if [[ -n "$TMUX" ]]; then
    # already inside tmux: create detached session
    tmux new-session -d -s "$s" "${tmux_args[@]}"
    echo "👻 created detached tmux session: '$s'"
  else
    # attach if exists, create if not
    tmux new-session -A -s "$s" "${tmux_args[@]}"
  fi
}
