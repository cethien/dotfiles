{ lib, config, inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.spotify;
  enabled = cfg.enable;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.deeznuts.programs.spotify = {
    enable = mkEnableOption "spotify";
    hyprland.autostart.enable = mkEnableOption "autostart spotify_player daemon";
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.hyprland.autostart.enable [
        "spotify_player -d"
      ];
      bind = [
        "SUPER SHIFT, M, exec, $terminal --class spotify -e spotify_player"
      ];
    };

    home.shellAliases.spot = "spotify_player";
    home.shellAliases.spotd = "spotify_player -d";
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
