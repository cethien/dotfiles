{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.programs.tmux;
in {
  imports = [
    ./tmux-keybindings.nix
  ];

  options.programs.tmux = {
    resurrectPluginProcesses = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "list of processes that will be resurrects. will be concat into a long list";
    };
  };

  config = mkIf cfg.enable {
    xdg.configFile."autostart/tmux-server.desktop" = {
      text = ''
        [Desktop Entry]
        Name=Tmux Server
        Comment=Start tmux server inside graphical session to inherit environment and fonts
        Exec=${pkgs.tmux}/bin/tmux start-server
        Terminal=false
        Type=Application
        Categories=System;
      '';
    };

    programs.fzf.tmux.enableShellIntegration = true;

    programs.bash.initExtra = builtins.readFile ./tmux-bashinit.sh;
    home.shellAliases.tm = "tmux_new";

    programs.tmux = {
      clock24 = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      terminal = "tmux-256color";

      extraConfig = ''
        ${builtins.readFile ./tmux.conf}
      '';

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
            set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-processes '${lib.strings.concatStringsSep " " cfg.resurrectPluginProcesses}'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '5' # minutes
          '';
        }

        {
          plugin = tmux-fzf;
          extraConfig = ''
            TMUX_FZF_LAUNCH_KEY="C-f"
            TMUX_FZF_OPTIONS="-p -w 90% -h 90% -m"
            TMUX_FZF_ORDER="command|keybinding|session|window|pane"
            TMUX_FZF_SESSION_FORMAT="#{session_windows} windows"
          '';
        }
      ];

      keybindings = let
        tmuxFzfAction = action: ''
          run-shell -b "${pkgs.tmuxPlugins.tmux-fzf}/share/tmux-plugins/tmux-fzf/scripts/session.sh ${action}"
        '';
      in [
        {
          key = "s";
          action = tmuxFzfAction "switch";
        }
        {
          key = "k";
          action = tmuxFzfAction "kill";
        }
        {
          key = "r";
          action = "source-file ~/.config/tmux/tmux.conf";
        }

        # switch panes using Ctrl-Shift-arrow without prefix
        {
          noprefix = true;
          key = "C-S-Left";
          action = "select-pane -L";
        }
        {
          noprefix = true;
          key = "C-S-Right";
          action = "select-pane -R";
        }
        {
          noprefix = true;
          key = "C-S-Up";
          action = "select-pane -U";
        }
        {
          noprefix = true;
          key = "C-S-Down";
          action = "select-pane -D";
        }

        {
          noprefix = true;
          key = "M-f";
          action = "resize-pane -Z";
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
  };
}
