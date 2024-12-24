{ config, lib, pkgs, ... }:
{
  options.deeznuts.apps.home-manager.enable = lib.mkEnableOption "home-manager";

  config = lib.mkIf config.deeznuts.apps.home-manager.enable {
    environment.systemPackages = with pkgs; [ home-manager ];
  };
}
