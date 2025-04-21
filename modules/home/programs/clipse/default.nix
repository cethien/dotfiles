{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.clipse;
  enabled = cfg.enable || config.deeznuts.programs.hyprland.enable;
in
{
  options.deeznuts.programs.clipse = {
    enable = mkEnableOption "clipse";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      wl-clipboard
      clipse
    ];

    wayland.windowManager.hyprland.settings = {
      exec-once = [ "clipse -listen" ];

      bind = [
        "SUPER SHIFT, V, exec, $terminal --class clipse clipse"
      ];
    };
  };
}
