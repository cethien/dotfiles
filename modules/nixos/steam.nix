{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.steam;
in {
  config = lib.mkIf cfg.enable {
    programs.steam = {
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = true;
        };
        extraLibraries = p:
          with p; [
            atk
            libgdiplus
            openssl
          ];
      };
      extraPackages = with pkgs; [
        gamescope
      ];
      extraCompatPackages = [pkgs.proton-ge-bin];
      protontricks.enable = true;

      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
