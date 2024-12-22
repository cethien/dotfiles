{ config, lib, pkgs, ... }:
{
  options.apps.home-manager.enable = lib.mkEnableOption "home-manager";

  config = lib.mkIf config.apps.home-manager.enable {
    environment.systemPackages = with pkgs; [ home-manager ];
  };
}
