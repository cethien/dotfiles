{ lib, config, pkgs, ... }:

{
  options.apps.inkscape.enable = lib.mkEnableOption "Enable inkscape";

  config = lib.mkIf config.apps.inkscape.enable {
    home.packages = with pkgs; [ inkscape ];
  };
}
