{ lib, config, pkgs, ... }:

{
  options.user.apps.drawio.enable = lib.mkEnableOption "Enable Draw.io";

  config = lib.mkIf config.user.apps.drawio.enable {
    home.packages = with pkgs; [
      drawio
    ];
  };
}
