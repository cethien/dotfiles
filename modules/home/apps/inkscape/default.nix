{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.inkscape;
in
{
  options.deeznuts.apps.inkscape = {
    enable = mkEnableOption "Enable inkscape";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ inkscape ];
  };
}
