{
  lib,
  config,
  pkgs,
  spicetify-nix,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.spotify;
in {
  options.programs.spotify.enable = mkEnableOption "spotify";

  options.wayland.windowManager.hyprland = {
    defaultWorkspaces = {
      music = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = config.wayland.windowManager.hyprland.defaultWorkspaces.browser or null;
        description = "default music workspace";
      };
    };
  };

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
          autoplay = true;
          audio_cache = true;
          normalization = true;
        };
      };
    };

    wayland.windowManager.hyprland.modals."spotify_player".bind = "SUPER SHIFT, M";
    wayland.windowManager.hyprland.settings = {
      bindl = let
        # pl = "playerctl --player=spotify_player";
        pl = "spotify_player playback";
      in [
        ", XF86AudioPlay, exec, ${pl} play-pause"
        ", XF86AudioNext, exec, ${pl} next"
        ", XF86AudioPrev, exec, ${pl} previous"
        # ", XF86AudioRaiseVolume, exec, ${pl} volume 0.05+"
        # ", XF86AudioLowerVolume, exec, ${pl} volume 0.05-"
        ", XF86AudioRaiseVolume, exec, ${pl} volume --offset 5"
        ", XF86AudioLowerVolume, exec, ${pl} volume --offset -- -5"
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
        foreground = "#61AFEF";
      };
    };
  };
}
