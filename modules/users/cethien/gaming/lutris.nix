{ lib, config, pkgs, ... }:

{
    options.user.gaming.lutris.enable = lib.mkEnableOption "Enable lutris";

    config = lib.mkIf config.user.gaming.lutris.enable {
        home.packages = with pkgs; [ lutris ];
    };
}