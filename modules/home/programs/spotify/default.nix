{ lib, config, pkgs, inputs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.spotify;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./hyprland.nix
    ./gnome.nix
  ];

  options.deeznuts.programs.spotify = {
    enable = mkEnableOption "Enable Spotify";
    spotify-player.enable = mkEnableOption "Enable Spotify Player (tui)";
  };

  config = {
    programs.spicetify = mkIf cfg.enable {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        hidePodcasts
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };


    programs.spotify-player = mkIf cfg.spotify-player.enable {
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
