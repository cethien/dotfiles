{ config, lib, pkgs, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.apps.home-manager;
in
{
  options.deeznuts.apps.home-manager = {
    enable = mkEnableOption "Enable home-manager";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ home-manager ];
  };
}
