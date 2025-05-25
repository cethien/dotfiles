{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.gimp;
in
{
  options.deeznuts.programs.gimp = {
    enable = mkEnableOption "Enable gimp";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ gimp ];
  };
}
