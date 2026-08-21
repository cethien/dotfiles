{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}: let
  cfg = config.programs.steam;
in {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  config = lib.mkIf cfg.enable {
    programs.steam = {
      platformOptimizations.enable = true;

      package = pkgs-unstable.steam.override {
        extraEnv = {
          OBS_VKCAPTURE = "1";
          STEAM_FRAME_FORCE_CLOSE = "1";
        };
        extraLibraries = p:
          with p; [
            atk
            libgdiplus
            openssl
          ];
      };

      extraPackages = with pkgs-unstable; [
        gamescope
      ];

      protontricks.enable = true;

      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };

    programs.gamemode = {
      # package = pkgs-unstable.gamemode;
      enable = true;
      enableRenice = true;
    };

    environment.systemPackages = [pkgs-unstable.gamemode];

    # security.caps.lockdown.enable = false;
    programs.gamescope.capSysNice = true;
  };
}
