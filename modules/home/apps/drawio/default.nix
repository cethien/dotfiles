{ lib, config, pkgs, ... }:

{
  options.apps.drawio.enable = lib.mkEnableOption "Enable Draw.io";

  config = lib.mkIf config.apps.drawio.enable {
    home.packages = with pkgs; [
      drawio
    ];
  };
}
