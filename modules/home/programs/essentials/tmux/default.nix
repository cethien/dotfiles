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
    programs.fzf.tmux.enableShellIntegration = true;

    programs.tmux = {
      baseIndex = 1;
      disableConfirmationPrompt = true;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-SPACE";
      terminal = "tmux-256color";

      extraConfig = builtins.readFile ./tmux.conf;

      sensibleOnTop = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        {
          plugin = yank;
          extraConfig = ''
            set -g @yank_action 'paste'
            set -g @yank_selection 'clipboard'
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

        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY="C-f"
            TMUX_FZF_OPTIONS="-p -w 80% -h 80% -m"
            TMUX_FZF_ORDER="command|keybinding|session|window|pane"
            TMUX_FZF_SESSION_FORMAT="#{session_windows} windows"
            bind-key s run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh switch"
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
