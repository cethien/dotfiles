{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.spotify;
  enabled = cfg.enable;
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
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

  config = mkIf enabled {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(Spotify)$"
        "workspace ${toString cfg.hyprland.workspace}, class:^(cava)$"
        "pseudo, class:^(cava)$"
      ];
      exec-once = mkIf cfg.hyprland.autostart.enable ["spotify_player -d"];
      bind = [
        "SUPER SHIFT, M, exec, hyprshot-spot"
        # "SUPER SHIFT, M, exec, hyprshot-spot-cava"
      ];
    };

    home.packages = with pkgs; [
      spotify
      # (pkgs.writeShellScriptBin "hyprland-spot-cava" (builtins.readFile ./hyprland-spot-cava.sh))
      (pkgs.writeShellScriptBin "hyprland-spot" (builtins.readFile ./hyprland-spot.sh))
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
