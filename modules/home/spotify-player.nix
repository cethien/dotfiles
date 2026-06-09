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
      modals."spotify_player".binds = ["SUPER + M" "XF86Music"];

      settings.bind = let
        inherit (config.lib.deeznuts.hyprland) mkExecBind;
        pl = "spotify_player playback";
      in [
        (mkExecBind "XF86AudioPlay" "${pl} play-pause" {locked = true;})
        (mkExecBind "XF86AudioNext" "${pl} next" {locked = true;})
        (mkExecBind "XF86AudioPrev" "${pl} previous" {locked = true;})

        (mkExecBind "XF86AudioRaiseVolume" "${pl} volume 0.05+" {locked = true;})
        (mkExecBind "XF86AudioLowerVolume" "${pl} volume 0.05-" {locked = true;})
        (mkExecBind "XF86AudioRaiseVolume" "${pl} volume --offset 5" {locked = true;})
        (mkExecBind "XF86AudioLowerVolume" "${pl} volume --offset -- -5" {locked = true;})
      ];
    };
  };
}
