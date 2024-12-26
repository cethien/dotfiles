{ lib, config, ... }:

{
  imports = [
    ./nmap
    ./termshark
    ./netscanner
  ];

  options.deeznuts.cli.networking.enable = lib.mkEnableOption "Enable networking tools";

  config = lib.mkIf config.deeznuts.cli.networking.enable {
    deeznuts.cli.networking = {
      nmap.enable = true;
      termshark.enable = true;
      netscanner.enable = true;
    };
  };
}
