{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.tmux;
in
{
  options.deeznuts.programs.tmux = {
    enable = mkEnableOption "tmux";
  };

  config = mkIf cfg.enable {
    programs.tmux.enable = true;
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

        # switch panes using Alt-arrow without prefix
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # switch windows using Ctrl-Alt-arrow without prefix
        bind -n C-M-Left previous-window
        bind -n C-M-Right next-window

        # don't rename windows automatically
        set-option -g allow-rename off

        # reload config file (change file location to your the tmux.conf you want to use)
        bind r source-file ~/.config/tmux/tmux.conf
      '';

      plugins = with pkgs.tmuxPlugins; [
        sensible
        yank
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
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
    };

    home.shellAliases = {
      tm = "tmux";
      tmls = "tmux ls";
      tma = "tmux attach";
      tmas = "tmux attach -t";
      tmk = "tmux kill-session -t";
    };
  };
}
