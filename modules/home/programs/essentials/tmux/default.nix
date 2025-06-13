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
      tmls = "tmux ls";
      tmk = "tmux kill-session -t";
      tmks = "tmux kill-server";
    };

    programs.bash.initExtra = builtins.readFile ./tmux.sh;

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

        prefix-highlight
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-plugins "cpu-usage ram-usage time"
            set -g @dracula-show-empty-plugins false
            set -g @dracula-show-timezone false
            set -g @dracula-day-month true
            set -g @dracula-military-time true
            set -g @dracula-time-format "%F %R"

            set -g @dracula-show-flags true
            set -g @dracula-show-left-icon "#S"
            set -g @dracula-show-ssh-only-when-connected true
            set -g @dracula-left-icon-padding 1
            set -g @dracula-show-left-sep ""
            set -g @dracula-show-right-sep ""
            set -g @dracula-transparent-powerline-bg true
          '';
        }
        {
          plugin = resurrect;
          extraConfig = ''
            set -g @resurrect-capture-panel-contents 'on'
            set -g @resurrect-processes 'nvim ssh ~ssh spotify_player yazi btm'
            set -g @resurrect-processes '~ssh'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '10' # minutes
          '';
        }
      ];

      keybindings = [
        {
          key = "r";
          action = "source-file ~/.config/tmux/tmux.conf";
        }

        # switch panes using Ctrl-Alt-arrow without prefix
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

        # switch windows using Ctrl-Alt-Tab
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
