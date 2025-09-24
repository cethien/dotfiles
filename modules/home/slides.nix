{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.slides;
in {
  options.deeznuts.programs.slides = {
    enable = mkEnableOption "slides";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [slides];
  };
}
