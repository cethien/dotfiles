{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.inkscape;
in
{
  options.deeznuts.programs.inkscape = {
    enable = mkEnableOption "Enable inkscape";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ inkscape ];
  };
}
