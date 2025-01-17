{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./programs
    ./settings.nix
  ];

  options.deeznuts.desktop.hyprland = {
    enable = mkEnableOption "Enable hyprland desktop";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}
