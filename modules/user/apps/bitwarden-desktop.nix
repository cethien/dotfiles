{ lib, config, pkgs, ... }:

{
  options.user.apps.bitwarden-desktop.enable = lib.mkEnableOption "Enable Bitwarden Desktop";

  config = lib.mkIf config.user.apps.bitwarden-desktop.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}