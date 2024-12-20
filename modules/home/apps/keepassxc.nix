{ lib, config, pkgs, ... }:

{
  options.apps.keepassxc.enable = lib.mkEnableOption "Enable keepassxc";

  config = lib.mkIf config.apps.keepassxc.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
