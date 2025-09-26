{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.programs.bottom.enable {
    programs.hyprpanel.settings.bar.workspaces.applicationIconMap.btm = "";
    programs.tmux.resurrectPluginProcesses = ["btm"];

    services.xremap.config.keymap = [
      {
        name = "apps";
        remap."SUPER-SHIFT-p".launch = ["hypr_btm"];
      }
    ];

    home.packages = [
      (pkgs.writeShellScriptBin "hypr_btm" ''
        #!/usr/bin/env bash
        hyprctl clients | grep -q 'class:.*btm' &&
          hyprctl dispatch focuswindow class:btm ||
          kitty --class btm -e btm --basic &
      '')
    ];

    home.shellAliases = {
      top = "btm --basic";
      htop = "btm --basic";
    };

    programs.bottom = {
      settings = {
        flags = {
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
