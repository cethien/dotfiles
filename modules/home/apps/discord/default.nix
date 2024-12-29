{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.discord;
in
{
  options.deeznuts.apps.discord = {
    enable = mkEnableOption "Enable Discord";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      [
        (discord-canary.override {
          withVencord = true;
          # withOpenASAR = true;
        })
      ];
  };
}
