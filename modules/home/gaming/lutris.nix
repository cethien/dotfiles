{ lib, config, pkgs, ... }:

{
  options.gaming.lutris.enable = lib.mkEnableOption "Enable lutris";

  config = lib.mkIf config.gaming.lutris.enable {
    home.packages = with pkgs; [ lutris ];
  };
}
