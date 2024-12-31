{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.networking;
in
{
  options.deeznuts.networking = {
    enable = mkEnableOption "Enable networking";

    networkManager = {
      enable = mkEnableOption "Enable networkmanager";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = cfg.networkManager.enable;
    };
  };
}
