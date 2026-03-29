{
  lib,
  config,
  pkgs,
  nix-gaming,
  ...
}: let
  cfg = config.programs.steam;
in {
  imports = [
    nix-gaming.nixosModules.platformOptimizations
  ];

  config = lib.mkIf cfg.enable {
    programs.steam = {
      platformOptimizations.enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = "1";
          STEAM_FRAME_FORCE_CLOSE = "1";
          GAMEMODERUN_PATH = "${pkgs.gamemode}/bin/gamemoderun";
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
      extraCompatPackages = with pkgs; [proton-ge-bin];
      protontricks.enable = true;

      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
