{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.networking.nmap.enable = lib.mkEnableOption "Enable nmap";

  config = lib.mkIf config.deeznuts.cli.networking.nmap.enable {
    home.packages = [ pkgs.nmap ];
  };
}
