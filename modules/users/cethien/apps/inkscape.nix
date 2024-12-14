{ lib, config, pkgs, ... }:

{
  options.user.apps.inkscape.enable = lib.mkEnableOption "Enable inkscape";

  config = lib.mkIf config.user.apps.inkscape.enable {
    home.packages = with pkgs; [
      inkscape
    ];
  };
}
