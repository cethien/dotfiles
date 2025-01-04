{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.hyprland;
in
{
  imports = [
    ./settings
    ./apps
    ./plugins.nix
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
