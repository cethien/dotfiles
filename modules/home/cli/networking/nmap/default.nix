{ lib, config, pkgs, ... }:

{
  options.cli.networking.nmap.enable = lib.mkEnableOption "Enable nmap";

  config = lib.mkIf config.cli.networking.nmap.enable {
    home.packages = [ pkgs.nmap ];
  };
}
