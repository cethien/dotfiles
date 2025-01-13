{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.firefox-devedition;
in

{
  options.deeznuts.programs.firefox-devedition = {
    enable = mkEnableOption "Enable Firefox Dev Edition";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      firefox-devedition
    ];
  };
}
