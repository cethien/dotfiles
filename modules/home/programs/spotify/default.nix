{ lib, config, inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.spotify;
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
    home.shellAliases.spot = "spotify_player";

    home.packages = with pkgs; [
      spotify
    ];

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
