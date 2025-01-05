{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./programs
    ./plugins
  ];

  options.deeznuts.desktop.hyprland = {
    enable = mkEnableOption "Enable hyprland desktop";
  };

  config = mkIf cfg.enable {
    catppuccin.hyprland.enable = true;
    wayland.windowManager.hyprland = {
      enable = true;

      settings = import ./settings.nix;
    };
  };
}
