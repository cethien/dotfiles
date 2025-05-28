{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.clipse;
  enabled = cfg.enable || config.deeznuts.programs.hyprland.enable;
in {
  options.deeznuts.programs.clipse = {
    enable = mkEnableOption "clipse";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    services.clipse.enable = true;

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, V, exec, $terminal --class clipse -e clipse"
      ];
    };
  };
}
