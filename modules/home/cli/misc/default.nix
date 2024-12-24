{ lib, config, pkgs, ... }:

{
  options.deeznuts.cli.misc.enable = lib.mkEnableOption "Enable misc cli tools";

  config = lib.mkIf config.deeznuts.cli.misc.enable {
    home.packages = with pkgs; [
      curl
      wget
      zip
      unzip
    ];
  };
}
