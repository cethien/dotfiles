{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.bottom;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-bottom" =
        # lua
        ''
          Modal("btm", { binds = {
          	"SUPER + P",
          } })
        '';
    };

    home.shellAliases = {
      top = "btm --basic";
      htop = "btm --basic";
    };

    programs.tmux.keybindings = [
      {
        key = "p";
        action = ''display-popup -w 90% -h 90% -E "btm"'';
      }
    ];

    programs.bottom = {
      settings = {
        flags = {
          # https://bottom.pages.dev/nightly/configuration/command-line-options/
          basic = true;
          rate = 5000;
          temperature_type = "c"; # Celsius
          tree = true;
          process_memory_as_value = true;
          cpu_as_percentage = true;
          cpu_left_legend = true;
          disable_advanced_kill = true;
          default_widget_type = "proc";
        };

        row = [
          {
            child = [
              {type = "proc";}
            ];
          }
          {
            child = [
              {type = "cpu";}
              {type = "mem";}
            ];
          }
          {
            child = [
              {type = "net";}
              {type = "disk";}
              {type = "temperature";}
            ];
          }
        ];
      };
    };
  };
}
