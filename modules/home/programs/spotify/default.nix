{ lib, config, inputs, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.spotify;
  enabled = cfg.enable;
in
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  options.deeznuts.programs.spotify = {
    enable = mkEnableOption "spotify";
    hyprland.autostart.enable = mkEnableOption "autostart spotify daemon";
    hyprland.workspace = mkOption {
      type = types.int;
      default = 5;
      description = "default hyprland workspace";
    };
  };

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(Spotify)$"
      ];
      exec-once = mkIf cfg.hyprland.autostart.enable [ "spotify_player -d" ];
      bind = [
        "SUPER SHIFT, M, exec, $terminal --class Spotify -e spotify_player"
      ];
    };

    home.packages = with pkgs; [
      spotify
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
  };
}
