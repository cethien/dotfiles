{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.programs.tmux;

  autostartFile = pkgs.makeDesktopItem {
    name = "tmux-autostart";
    exec = "tmux start-server";
    desktopName = "tmux server (autostart)";
  };
in {
  imports = [
    ./tmux-keybindings.nix
    ./tmux-launcher.nix
  ];

  options.programs.tmux = {
    resurrectPluginProcesses = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "list of processes that will be resurrects. will be concat into a long list";
    };
  };

  config = mkIf cfg.enable {
    programs.fzf.tmux.enableShellIntegration = true;

    xdg.autostart.entries = [
      "${autostartFile}/share/applications/tmux-autostart.desktop"
    ];

    programs.bash.initExtra = builtins.readFile ./tmux-bashinit.sh;
    home.shellAliases.tm = "tmux_new";

    programs.tmux = {
      sensibleOnTop = true;
      clock24 = true;
      baseIndex = 1;
      disableConfirmationPrompt = true;
      mouse = true;
      prefix = "C-a";
      terminal = "tmux-256color";

      newSession = true;
      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = sysstat;
          extraConfig = ''
            set -g status-left-length 160
            set -g status-left '#[fg=#{?client_prefix,black,green},bg=#{?client_prefix,green,default}] #S #[default] #{online_status}'
            set -g status-right-length 160
            set -g status-right '#{sysstat_cpu} - #{sysstat_mem} | %H:%M#{battery_icon}'

            set -g @sysstat_cpu_view_tmpl 'CPU #{cpu.pused}'
            set -g @sysstat_mem_view_tmpl 'MEM #{mem.used}/#{mem.total}'
          '';
        }

        {
          plugin = online-status;
          extraConfig = ''
            set -g @online_icon ' '
            set -g @offline_icon '#[fg=orange]NET_DOWN#[default]'
          '';
        }

        {
          plugin = battery;
          extraConfig = ''
            set -g @batt_icon_charge_tier8 ' 󰁹 '
            set -g @batt_icon_charge_tier7 ' 󰂂 '
            set -g @batt_icon_charge_tier6 ' 󰂁 '
            set -g @batt_icon_charge_tier5 ' 󰁿 '
            set -g @batt_icon_charge_tier4 ' 󰁾 '
            set -g @batt_icon_charge_tier3 ' 󰁽 '
            set -g @batt_icon_charge_tier2 ' 󰁻 '
            set -g @batt_icon_charge_tier1 ' 󰂃 '
            set -g @batt_icon_status_charged ' 󰂅 '
            set -g @batt_icon_status_charging ' 󰂄 '
            set -g @batt_icon_status_discharging ' 󰂌 '
            set -g @batt_icon_status_attached ' 󰚥 '
            set -g @batt_icon_status_unknown ' '
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

      extraConfig = ''
        # kitty
        set -as terminal-features 'xterm-kitty:clipboard,ccolour,overline,smso,sitm'

        set -g terminal-features "screen-256color:RGB"
        set -g allow-passthrough on
        set -g set-clipboard on
        set -g renumber-windows on

        # ------
        # aestheics
        # ------

        set -g message-style fg=black,bg=yellow
        set -g message-command-style fg=black,bg=yellow

        set -g status-style bg=default
        set -g status-position top
        set -g status-justify left

        set -g window-status-format '#[fg=dimgray,bg=default] #I:#W '
        set -g window-status-current-format '#[fg=white,bg=default] #I:#W '
        set -g window-style bg=default
        set -g window-active-style bg=default

        set -g pane-border-status off
        set -g pane-border-format ""
        set -g pane-border-style fg=white
        set -g pane-active-border-style fg=blue
        set -g pane-border-lines single
        set -g pane-border-indicators off
      '';

      keybindings = [
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
      ];
    };
  };
}
