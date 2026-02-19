{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.mako.enable {
    stylix.targets.mako.opacity.enable = false;

    services.mako = {
      settings = {
        "category=sysinfo" = {
          height = 200;
          width = 1280;
        };

        actions = true;
        anchor = "top-center";
        border-radius = 4;
        default-timeout = 3000;
        ignore-timeout = false;
        height = 400;
        icons = true;
        layer = "top";
        margin = 8;
        padding = 16;
        markup = true;
        width = 600;
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, p, exec, ${
          pkgs.writeShellScriptBin "notify-info" (builtins.readFile ./notify-info.sh)
        }/bin/notify-info"
      ];

      exec-once = [
        "${
          pkgs.writeShellScriptBin "notify-battery" (builtins.readFile ./notify-battery.sh)
        }/bin/notify-battery"
      ];
    };
  };
}
