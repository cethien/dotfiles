{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.imv;
  enable = cfg.enable || config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.programs.imv = {
    enable = mkEnableOption "Enable imv";
  };

  config = mkIf enable {
    programs.imv = {
      enable = true;
    };
  };
}
