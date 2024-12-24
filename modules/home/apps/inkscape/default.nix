{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.inkscape.enable = lib.mkEnableOption "Enable inkscape";

  config = lib.mkIf config.deeznuts.apps.inkscape.enable {
    home.packages = with pkgs; [ inkscape ];
  };
}
