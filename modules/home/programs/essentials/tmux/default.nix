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
      terminal = "tmux-256color";

      keyMode = "vi";
      mouse = true;
      prefix = "C-a";
      disableConfirmationPrompt = true;

      extraConfig = ''
        # Turn on Xterm Keys for modifier keys pass through
        set -s extended-keys on
        set-option -g xterm-keys on
        set -as terminal-features 'xterm*:extkeys'

        # kitty terminal feautes
        set -as terminal-features 'xterm-kitty:clipboard,ccolour,overline,smso,sitm'

        # Allow-passthrough for advanced features
        # (wezterm features mainly)
        set-option -g allow-passthrough on

        # Clipboard & paste handling
        set -g set-clipboard on
        # set -g allow-paste on

        # don't rename windows automatically
        set-option -g allow-rename off

      '';

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

        urlview
        prefix-highlight

        {
          plugin = dracula;
          extraConfig = ''
            set-option -g status-position top

            set -g @dracula-show-empty-plugins false
            set -g @dracula-plugins "ram-usage cpu-usage network battery time"

            set -g @dracula-narrow-plugins "compact-alt ram-usage cpu-usage network battery time"
            set -g @dracula-compact-min-width 50

            set -g @dracula-ram-usage-label " "
            set -g @dracula-cpu-usage-label " "

            set -g @dracula-network-ethernet-label "󰈀 Eth"
            set -g @dracula-network-offline-label "󱍢 "
            set -g @dracula-network-wifi-label " "

            set -g @dracula-battery-label false
            set -g @dracula-show-battery-status true
            set -g @dracula-no-battery-label false
            set -g @dracula-battery-label ""

            set -g @dracula-show-timezone false
            set -g @dracula-day-month true
            set -g @dracula-military-time true
            set -g @dracula-time-format "%F  %R"

            set -g @dracula-show-flags true
            set -g @dracula-show-left-icon "#S"
            set -g @dracula-show-ssh-only-when-connected true
            set -g @dracula-left-icon-padding 1
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
