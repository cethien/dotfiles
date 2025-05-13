{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.jetbrains.rider;
  enabled = cfg.enable;
in
{
  options.deeznuts.programs.jetbrains.rider = {
    enable = mkEnableOption "jetbrains Rider";
  };

  config = mkIf enabled {
    home.packages = with pkgs; [
      jetbrains.rider
    ];
  };
}
