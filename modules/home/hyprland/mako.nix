{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.services.mako;
in {
  config = mkIf cfg.enable {
    stylix.targets.mako.opacity.enable = false;

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-mako" =
        #lua
        ''
          hl.bind("SUPER + A", hl.dsp.exec_cmd("makoctl dismiss -a"))
        '';
    };

    services.mako.settings = {
      "urgency=critical" = {
        border-color = "#ff0000";
        default-timeout = 0;
      };

      actions = true;
      anchor = "top-center";
      border-radius = 4;
      default-timeout = 6000;
      ignore-timeout = false;
      height = 400;
      icons = true;
      layer = "overlay";
      margin = "16,8,8";
      padding = 16;
      markup = true;
      width = 600;
    };
  };
}
