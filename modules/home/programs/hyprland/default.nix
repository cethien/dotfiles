{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.hyprland;
in
{
  imports = [
    ./programs
    ./settings.nix
  ];

  options.deeznuts.programs.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}
