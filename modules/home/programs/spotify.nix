{
  lib,
  config,
  pkgs,
  spicetify-nix,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.spotify;
in {
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  options.deeznuts.programs.spotify = {
    enable = mkEnableOption "spotify";
    hyprland.workspace = mkOption {
      type = types.int;
      default = 7;
      description = "default hyprland workspace";
    };
    hyprland.autostart.enable = mkEnableOption "autostart spotify daemon";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable ["spotify_player -d"];
      bind = [
        "SUPER SHIFT, M, exec, hyprland-spot"
      ];
    };

    stylix.targets.spicetify.enable = false;
    home.packages = with pkgs; [
      # spotify
      (mkIf config.wayland.windowManager.hyprland.enable (
        writeShellScriptBin "hyprland-spot" ''
          #!/usr/bin/env bash
          hyprctl clients | grep -q 'class:.*Spotify' &&
            hyprctl dispatch focuswindow class:Spotify ||
            kitty --class Spotify -e spotify_player &
        ''
      ))
    ];

    home.shellAliases.spot = "spotify_player";
    home.shellAliases.spotd = "spotify_player -d";
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

    programs.spicetify = let
      spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
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
