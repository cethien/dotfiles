{
  lib,
  config,
  pkgs,
  spicetify-nix,
  ...
}: let
  inherit (lib) mkEnableOption mkIf elem;
  cfg = config.programs.spotify;
  as = elem "spotify" config.wayland.windowManager.hyprland.autostart;
in {
  options.programs.spotify.enable = mkEnableOption "spotify";

  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    programs.spicetify = let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        autoSkipVideo
        hidePodcasts
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
      ];
      enabledSnippets = with spicePkgs.snippets; [
        pointer
        fixMainViewWidth
      ];
    };
    stylix.targets.spicetify.enable = false;

    programs.spotify-player = {
      enable = true;
      settings = {
        client_id = "9b20bf81c95d4710bee28bff24db41f9";
        enable_notify = false;
        device = {
          audio_cache = true;
          normalization = true;
        };
      };
    };
    programs.tmux.resurrectPluginProcesses = ["spotify_player"];

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf as ["spotify_player -d"];

      bind = [
        "SUPER SHIFT, M, exec, ${
          (pkgs.cethien.writeHyprlandTermLaunchScriptBin "spotify_player").bin
        }"
      ];

      bindl = let
        pl = "playerctl --player=spotify_player";
      in [
        ", XF86AudioPlay, exec, ${pl} play-pause"
        ", XF86AudioNext, exec, ${pl} next"
        ", XF86AudioPrev, exec, ${pl} previous"
        ", XF86AudioRaiseVolume, exec, ${pl} volume 0.05+"
        ", XF86AudioLowerVolume, exec, ${pl} volume 0.05-"
      ];
    };

    programs.cava.enable = true;
    programs.cava.settings = {
      general = {
        framerate = 120;
        sensitivity = 33;
      };
      smoothing = {
        noise_reduction = 66;
        monstercat = 1;
        # waves = 1;
      };
      output = {
        reverse = 1;
      };
      color = {
        # background = "#000000";
        foregrund = "#61AFEF";
      };
    };
  };
}
