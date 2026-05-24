{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.bottom.enable {
    wayland.windowManager.hyprland.modals."btm".bind = "SUPER SHIFT, P";

    home.shellAliases = {
      top = "btm --basic";
      htop = "btm --basic";
    };

    programs.bottom = {
      settings = {
        flags = {
          basic = true;
          temperature_type = "c"; # Celsius
          tree = true;
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
