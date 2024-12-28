{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.networking.netscanner;
in
{
  options.deeznuts.cli.networking.netscanner = {
    enable = mkEnableOption "Enable netscanner";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ netscanner ];
  };
}
