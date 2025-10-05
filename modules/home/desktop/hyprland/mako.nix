{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.mako.enable {
    services.mako = {
      settings = {
        "category=sysinfo" = {
          anchor = "top-center";
          height = 200;
          width = 1280;
        };
        actions = true;
        anchor = "top-left";
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

    home.packages = with pkgs; [
      (writeShellScriptBin "notify-info" (builtins.readFile ./notify-info.sh))
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, p, exec, notify-info"
      ];
    };
  };
}
