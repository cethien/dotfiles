{ lib, config, pkgs, ... }:

{
  options.cli.misc.enable = lib.mkEnableOption "Enable misc cli tools";

  config = lib.mkIf config.cli.misc.enable {
    home.packages = with pkgs; [
      curl
      wget
      zip
      unzip
    ];
  };
}
