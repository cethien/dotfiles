{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.netscanner;
in
{
  options.deeznuts.programs.netscanner = {
    enable = mkEnableOption "Enable netscanner";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ netscanner ];
  };
}
