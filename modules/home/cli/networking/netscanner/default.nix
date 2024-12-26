{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.networking.netscanner.enable = lib.mkEnableOption "Enable netscanner";

  config = lib.mkIf config.deeznuts.cli.networking.netscanner.enable {
    home.packages = with pkgs; [ netscanner ];
  };
}
