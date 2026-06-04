{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.spotify-player;
in {
  config = mkIf cfg.enable {
    programs.spotify-player = {
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

    wayland.windowManager.hyprland = {
      modals."spotify_player".binds = ["SUPER, M" ", XF86Music"];

      settings = {
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
    };
  };
}
