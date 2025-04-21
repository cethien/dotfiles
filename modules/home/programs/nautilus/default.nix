{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.nautilus;
  enabled = cfg.enable || config.deeznuts.programs.hyprland.enable;
in
{
  options.deeznuts.programs.nautilus = {
    enable = mkEnableOption "nautilus";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      nautilus
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, E, exec, nautilus"
      ];
    };
  };
}
