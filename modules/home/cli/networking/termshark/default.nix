{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.networking.termshark;
in
{
  options.deeznuts.cli.networking.termshark = {
    enable = mkEnableOption "Enable termshark";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tshark
      termshark
    ];
  };
}
