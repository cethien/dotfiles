{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.misc;
in
{
  options.deeznuts.programs.misc = {
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
