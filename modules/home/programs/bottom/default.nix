{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.bottom;
in
{
  options.deeznuts.programs = {
    bottom.enable = mkEnableOption "bottom (cli monitoring tool)";
  };

  config = mkIf cfg.enable {
    programs.bottom = {
      enable = true;

      settings = {
        flags = {
          # basic = true;
          temperature_type = "c"; # Celsius
          tree = true;
          cpu_as_percentage = true;
          cpu_left_legend = true;
          disable_advanced_kill = true;
        };

        row = [
          # Row 1: Processes and CPU
          {
            child = [
              { type = "proc"; }
            ];
          }

          # Row 2: Graphs
          {
            child = [
              { type = "cpu"; }
              {
                child = [
                  { type = "mem"; default_mode = "table"; }
                  { type = "net"; default_mode = "table"; }
                ];
              }
            ];
          }

          # Row 3: Disks and Temp
          {
            child = [
              { type = "disk"; }
              { type = "temperature"; }
            ];
          }
        ];

      };
    };

    home.shellAliases = {
      top = "btm";
      htop = "btm";
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, p, exec, $terminal --class monitor -e btm"
      ];
    };
  };
}

