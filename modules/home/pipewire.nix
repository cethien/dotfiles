{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.wiremix;
in {
  options.programs.wiremix.enable = mkEnableOption "wiremix";

  config = mkIf cfg.enable {
    home.packages = [pkgs.wiremix];
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-pipewire".content = ./pipewire.lua;
    };
  };
}
