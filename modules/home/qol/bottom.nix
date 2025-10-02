{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.bottom.enable {
    programs.tmux.resurrectPluginProcesses = ["btm"];

    wayland.windowManager.hyprland.settings.bind = [
      "SUPER SHIFT, P, exec, ${
        (pkgs.cethien.writeHyprLaunchTermScriptBin "btm").bin
      }"
    ];

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
