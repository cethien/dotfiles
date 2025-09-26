{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf config.services.mako.enable {
    services.mako = {
      settings = {
        "actionable=true" = {
          anchor = "top-left";
        };
        actions = true;
        anchor = "top-center";
        border-radius = 4;
        default-timeout = 3000;
        ignore-timeout = false;
        height = 400;
        icons = true;
        layer = "top";
        margin = 12;
        padding = 8;
        markup = true;
        width = 400;
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
