{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.imv;
  enable = cfg.enable || config.deeznuts.programs.hyprland.enable;
in
{
  options.deeznuts.programs.imv = {
    enable = mkEnableOption "Enable imv";
  };

  config = mkIf enable {
    programs.imv = {
      enable = true;
    };

    xdg.mimeApps.defaultApplications = {
      # Image files
      "image/png" = [ "imv-dir.desktop" ];
      "image/jpeg" = [ "imv-dir.desktop" ];
      "image/webp" = [ "imv-dir.desktop" ];
      "image/gif" = [ "imv-dir.desktop" ];
      "image/svg+xml" = [ "imv-dir.desktop" ];
    };
  };
}
