{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.programs.tmux;

  tmuxKeybindings = config.programs.tmux.keybindings or [];
  formatBind = binding: let
    table =
      if binding ? table
      then "-T ${binding.table} "
      else "";
    prefix =
      if binding.noprefix or false
      then "-n "
      else "";
    repeatable =
      if binding.repeat or false
      then "-r "
      else "";
    desc =
      if binding ? description
      then "-N \"${binding.description}\" "
      else "";
  in "bind ${table}${repeatable}${prefix}${desc}${binding.key} ${binding.action}";
in {
  options.programs.tmux = {
    keybindings = mkOption {
      type = types.listOf types.attrs;
      default = [];
    };
    resurrectPluginProcesses = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "list of processes that will be resurrects. will be concat into a long list";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once = ["tmux start-server"];

    home.shellAliases.tm = "tmux_new";
    programs.fzf.tmux.enableShellIntegration = true;
    programs.bash.initExtra = builtins.readFile ./tmux_bashinit.sh;
    programs.zsh.initContent = builtins.readFile ./tmux_zshinit.sh;

    programs.tmux = {
      baseIndex = 1;
      disableConfirmationPrompt = true;
      historyLimit = 5000;
      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      terminal = "tmux-256color";

      extraConfig = ''
        ${builtins.readFile ./tmux.conf}
        ${lib.concatStringsSep "\n" (map formatBind tmuxKeybindings)}
      '';

      sensibleOnTop = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        tmux-floax
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
