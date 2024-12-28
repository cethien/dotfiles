{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.apps.keepassxc;
in
{
  options.deeznuts.apps.keepassxc = {
    enable = mkEnableOption "Enable keepassxc";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
