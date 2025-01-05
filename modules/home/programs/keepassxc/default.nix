{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.keepassxc;
in
{
  options.deeznuts.programs.keepassxc = {
    enable = mkEnableOption "Enable keepassxc";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
