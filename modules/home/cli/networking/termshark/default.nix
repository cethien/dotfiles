{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.networking.termshark.enable = lib.mkEnableOption "Enable termshark";

  config = lib.mkIf config.deeznuts.cli.networking.termshark.enable {
    home.packages = with pkgs; [
      tshark
      termshark
    ];
  };
}
