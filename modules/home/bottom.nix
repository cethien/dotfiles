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
    wayland.windowManager.hyprland.modals."btm".binds = ["SUPER SHIFT, P"];

    home.shellAliases = {
      top = "btm --basic";
      htop = "btm --basic";
    };

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
