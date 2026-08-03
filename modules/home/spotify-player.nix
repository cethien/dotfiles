{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.spotify-player;

  spotify-player-wrapper = pkgs.writeShellScriptBin "spotify-player-wrapper" ''
    if ! pgrep -f "spotify_player --daemon" >/dev/null; then
      ${pkgs.spotify-player}/bin/spotify_player --daemon &
      sleep 1
    fi
    exec ${pkgs.spotify-player}/bin/spotify_player "$@"
  '';

  exec = "${spotify-player-wrapper}/bin/spotify-player-wrapper";
in {
  config = mkIf cfg.enable {
    programs.spotify-player.settings = {
      enable_notify = false;
      pause_on_startup = true;
      device = {
        autoplay = true;
        audio_cache = true;
        normalization = true;
      };

      border_type = "Rounded";
      playback_format = "{track} {liked}\n{artists}\n{album}\n{status} {metadata}";
      play_icon = "󰐊";
      pause_icon = "󰏤";
      liked_icon = "󰥲";
      explicit_icon = "󰯹";
    };

    programs.tmux.keybindings = [
      {
        key = "M";
        action = "new-window -n 'spotify' '${exec}";
      }
    ];

    wayland.windowManager.hyprland.extraLuaFiles."99-spotify-player" =
      #lua
      ''
        Modal("spotify_player", {
            exec = "${exec}";
            binds = { "SUPER + M", "XF86Music" }
        })

        local pl = "spotify_player playback "

        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(pl .. "play-pause"), { locked = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd(pl .. "next"), { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(pl .. "previous"), { locked = true })

        hl.bind("SHIFT + XF86AudioNext", hl.dsp.exec_cmd(pl .. "seek 5000"), { locked = true })
        hl.bind("SHIFT + XF86AudioPrev", hl.dsp.exec_cmd(pl .. "seek -- -5000"), { locked = true })

        hl.bind("ALT + XF86AudioRaiseVolume", hl.dsp.exec_cmd(pl .. "volume --offset 2"), { locked = true })
        hl.bind("ALT + XF86AudioLowerVolume", hl.dsp.exec_cmd(pl .. "volume --offset -- -2"), { locked = true })
      '';
  };
}
