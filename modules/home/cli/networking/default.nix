{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.networking;
in
{
  imports = [
    ./nmap
    ./termshark
    ./netscanner
  ];

  options.deeznuts.cli.networking = {
    enable = mkEnableOption "Enable networking CLI tools";
  };

  config = mkIf cfg.enable {
    deeznuts.cli.networking = {
      nmap.enable = true;
      termshark.enable = true;
      netscanner.enable = true;
    };
  };
}
