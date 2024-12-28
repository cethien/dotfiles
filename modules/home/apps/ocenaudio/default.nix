{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.ocenaudio;
in
{
  options.deeznuts.apps.ocenaudio = {
    enable = mkEnableOption "Enable ocenaudio";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ocenaudio ];
  };
}
