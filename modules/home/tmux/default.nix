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
          plugin = sysstat;
          extraConfig = ''
            set -g status-right-length 160
            set -g status-right '#{sysstat_cpu} // #{sysstat_mem} |#{online_status}%H:%M '

            set -g @sysstat_cpu_view_tmpl '#{cpu.pused}'
            set -g @sysstat_mem_view_tmpl '#{mem.used}'
          '';
        }

        {
          plugin = online-status;
          extraConfig = ''
            set -g @online_icon ' '
            set -g @offline_icon ' #[fg=orange]OFFLINE#[default] '
          '';
        }

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
          plugin = tmux-sm;
          extraConfig = ''
            set -g @session_manager_key 's'
            set -g @session_manager_height '70%'
            set -g @session_manager_width '80%'
            set -g @sessionizer_height '70%'
            set -g @sessionizer_width '80%'
          '';
        }
      ];

      keybindings = [
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
