{ lib, config, pkgs, ... }:

{
  options.deeznuts.apps.drawio.enable = lib.mkEnableOption "Enable Draw.io";

  config = lib.mkIf config.deeznuts.apps.drawio.enable {
    home.packages = with pkgs; [
      drawio
    ];
  };
}
