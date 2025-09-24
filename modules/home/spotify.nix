{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf elem;
  cfg = config.programs.spotify;
  hypr = elem "spotify" config.wayland.windowManager.hyprland.autostart;
in {
  options.programs.spotify.enable = mkEnableOption "spotify";

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf hypr ["spotify_player -d"];
      bind = [
        "SUPER SHIFT, M, exec, hypr_spot"
      ];
    };

    home.packages = with pkgs; [
      # spotify
      (mkIf config.wayland.windowManager.hyprland.enable (
        writeShellScriptBin "hypr_spot" ''
          #!/usr/bin/env bash
          hyprctl clients | grep -q 'class:.*Spotify' &&
            hyprctl dispatch focuswindow class:Spotify ||
            kitty --class Spotify -e spotify_player &
        ''
      ))
    ];

    stylix.targets.spicetify.enable = false;
    programs.spicetify = let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      enable = true;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        ncsVisualizer
      ];
      enabledSnippets = with spicePkgs.snippets; [
        rotatingCoverart
        pointer
      ];

      theme = spicePkgs.themes.nightlight;
    };

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
