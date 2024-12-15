{ lib, config, pkgs, ... }:

{
  options.user.apps.keepassxc.enable = lib.mkEnableOption "Enable keepassxc";

  config = lib.mkIf config.user.apps.keepassxc.enable {
    home.packages = [ pkgs.keepassxc ];
  };
}
