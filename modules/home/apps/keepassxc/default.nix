{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.keepassxc.enable = lib.mkEnableOption "Enable keepassxc";

  config = lib.mkIf config.deeznuts.apps.keepassxc.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
