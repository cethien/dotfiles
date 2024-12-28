{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.cli.misc;
in
{
  options.deeznuts.cli.misc = {
    enable = mkEnableOption "Enable misc cli tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      curl
      wget
      zip
      unzip
    ];
  };
}
