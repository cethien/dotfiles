{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.deeznuts.networking;
in
{
  options.deeznuts.networking = {
    enable = mkEnableOption "Enable networking";

    hostName = mkOption {
      type = lib.types.str;
      default = "some-nixos";
      description = "The hostname of the machine";
    };

    networkManager = {
      enable = mkEnableOption "Enable networkmanager";
    };
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = cfg.hostName;
      networkmanager.enable = cfg.networkManager.enable;
    };
  };
}
