{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.tmux;
in {
  imports = [
    ./option-keymaps.nix
  ];

  config = mkIf cfg.enable {
    home.shellAliases = {
      tm = "tmux_new";
      tmd = "tmux_newd";
      tmls = "tmux ls";
      tmk = "tmux kill-session -t";
    };

    programs.bash.initExtra =
      # bash
      ''
        _tmux_session() {
          if [ -n "$1" ] && [[ "$1" != -* ]]; then
          	echo "$1" | tr -c 'a-zA-Z0-9_' '_'
          else
          	basename "$PWD" | tr -c 'a-zA-Z0-9_' '_'
          fi
        }

        tmux_new() {
          local s=$(_tmux_session "$1")
          if [ -n "$1" ] && [[ "$1" != -* ]]; then shift; fi
          tmux new-session -A -s "$s" "$@"
        }

        tmux_newd(){
          local s=$(_tmux_session "$1")
          if [ -n "$1" ] && [[ "$1" != -* ]]; then shift; fi
          tmux new-session -d -s "$s" "$@"
        }
      '';

    programs.tmux = {
      clock24 = true;
      baseIndex = 1;
      terminal = "screen-256color";

      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      disableConfirmationPrompt = true;

      extraConfig = ''
        # Turn on Xterm Keys for modifier keys pass through
        set -s extended-keys on
        set-option -g xterm-keys on
        set -as terminal-features 'xterm*:extkeys'

        # Allow-passthrough for advanced features
        # (wezterm features mainly)
        set-option -g allow-passthrough on

        # don't rename windows automatically
        set-option -g allow-rename off
      '';

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-stategy-nvim 'session'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '10' # minutes
          '';
        }
        prefix-highlight
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "ram-usage cpu-usage"
            set -g @dracula-show-flags true
            set -g @dracula-show-left-icon "#h"
            set -g @dracula-show-ssh-only-when-connected true
            set -g @dracula-show-left-sep ""
            set -g @dracula-show-right-sep ""
            set -g @dracula-transparent-powerline-bg true
          '';
        }
      ];

      keybindings = [
        {
          key = "r";
          action = "source-file ~/.config/tmux/tmux.conf";
        }

        # switch panes using Alt-arrow without prefix
        {
          noprefix = true;
          key = "M-Left";
          action = "select-pane -L";
        }
        {
          noprefix = true;
          key = "M-Right";
          action = "select-pane -R";
        }
        {
          noprefix = true;
          key = "M-Up";
          action = "select-pane -U";
        }
        {
          noprefix = true;
          key = "M-Down";
          action = "select-pane -D";
        }
        # resize pane using Shift-Alt-arrow without prefix
        {
          noprefix = true;
          key = "S-M-Left";
          action = "select-pane -L";
        }
        {
          noprefix = true;
          key = "S-M-Right";
          action = "select-pane -R";
        }
        {
          noprefix = true;
          key = "S-M-Up";
          action = "select-pane -U";
        }
        {
          noprefix = true;
          key = "S-M-Down";
          action = "select-pane -D";
        }

        # switch windows using Ctrl-Alt-arrow without prefix
        {
          noprefix = true;
          key = "C-M-Right";
          action = "next-window";
        }
        {
          noprefix = true;
          key = "C-M-Left";
          action = "previous-window";
        }

        {
          key = "m";
          action = "copy-mode -u";
        }
      ];
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = ["tmux start-server"];
    };
  };
}
