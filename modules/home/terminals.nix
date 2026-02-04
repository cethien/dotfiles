{
  config,
  pkgs,
  ...
}: let
  script = pkgs.writeShellScriptBin "tmux-smart-attach" ''
    if [ "$(hyprctl activeworkspace -j | jq '.id')" -eq 1 ] && command -v tmux >/dev/null; then
      LAST_SESSION=$(tmux list-sessions -F "#{session_last_attached} #{session_name}" 2>/dev/null | sort -nr | head -n1 | awk '{print $2}')
      if [ -n "$LAST_SESSION" ]; then
        exec kitty --title "tmux-main" tmux attach-session -t "$LAST_SESSION"
      else
        exec kitty --title "tmux-main" tmux new-session -A -s main
      fi
    else
      exec kitty
    fi
  '';
in {
  programs.kitty = {
    settings = {
      window_padding_width = 2;
      update_check_interval = 0;
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
    keybindings = {
      "ctrl+shift+g" = "no_op";
    };
  };

  wayland.windowManager.hyprland.settings = {
    "$terminal" =
      if config.programs.tmux.enable
      then "${script}/bin/tmux-smart-attach"
      else "kitty";

    bind = [
      "SUPER, RETURN, exec, $terminal"
    ];
  };
}
