{ lib, config, pkgs, ... }:

{
  options.cli.networking.termshark.enable = lib.mkEnableOption "Enable termshark";

  config = lib.mkIf config.cli.networking.termshark.enable {
    home.packages = with pkgs; [
      tshark
      termshark
    ];
  };
}
