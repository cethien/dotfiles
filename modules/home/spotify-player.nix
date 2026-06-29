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

    wayland.windowManager.hyprland.extraLuaFiles."99-spotify-player" =
      #lua
      ''
        Modal("spotify_player", {
            binds = { "SUPER + M", "XF86Music" }
        })

        local pl = "spotify_player playback "

        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(pl .. "play-pause"), { locked = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd(pl .. "next"),       { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(pl .. "previous"),   { locked = true })

        hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(pl .. "volume 0.05+"), { locked = true })
        hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(pl .. "volume 0.05-"), { locked = true })
      '';
  };
}
