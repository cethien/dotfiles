{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.spotify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  enabled = cfg.enable;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./hyprland.nix
  ];

  options.deeznuts.programs.spotify = {
    enable = mkEnableOption "Enable Spotify";
  };

  config = mkIf enabled {
    programs.spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
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
  };
}
