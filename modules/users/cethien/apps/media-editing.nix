{ lib, config, pkgs, ... }:

{
  options.user.apps.media-editing.enable = lib.mkEnableOption "Enable media editing (inkscape, ocenaudio)";

  config = lib.mkIf config.user.apps.media-editing.enable {
    home.packages = with pkgs; [
      inkscape
      ocenaudio
    ];
  };
}