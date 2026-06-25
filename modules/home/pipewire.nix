{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.wiremix;

  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  notify-send = "${pkgs.libnotify}/bin/notify-send";

  makeToggleScript = {
    name,
    target,
    iconOn,
    iconOff,
  }:
    pkgs.writeShellScript "toggle-${name}" ''
      ${wpctl} set-mute ${target} toggle
      if ${wpctl} get-volume ${target} | grep -q MUTED; then
        ${notify-send} "${iconOff} ${name}" "muted"
      else
        ${notify-send} "${iconOn} ${name}" "unmuted"
      fi
    '';

  tMic = makeToggleScript {
    name = "mic";
    target = "@DEFAULT_AUDIO_SOURCE@";
    iconOn = "󰍬";
    iconOff = "󰍭";
  };
  tSpk = makeToggleScript {
    name = "speakers";
    target = "@DEFAULT_AUDIO_SINK@";
    iconOn = "󰓃";
    iconOff = "󰓄";
  };

  makeAfkScript = {
    iconOn,
    iconOff,
  }:
    pkgs.writeShellScript "toggle-afk" ''
      if ${wpctl} get-volume @DEFAULT_AUDIO_SOURCE@ | grep -qv MUTED || ${wpctl} get-volume @DEFAULT_AUDIO_SINK@ | grep -qv MUTED; then
        ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 1
        ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 1
        ${notify-send} "${iconOff} afk" "goodbye"
      else
        ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 0
        ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0
        ${notify-send} "${iconOn} afk" "welcome back"
      fi
    '';

  tAfk = makeAfkScript {
    iconOn = "󰟀";
    iconOff = "󰩈";
  };
in {
  options.programs.wiremix.enable = mkEnableOption "wiremix";

  config = mkIf cfg.enable {
    home.packages = [pkgs.wiremix];

    wayland.windowManager.hyprland.extraLuaFiles."99-wiremix" =
      # lua
      ''
        Modal("wiremix", {
            binds = {
                "SUPER + SHIFT + M",
                "SHIFT + XF86Music",
                "SHIFT + XF86Tools"
            }
        })

        local toggle_mic = hl.dsp.exec_cmd("${tMic}")
        local toggle_spk = hl.dsp.exec_cmd("${tSpk}")
        local toggle_afk = hl.dsp.exec_cmd("${tAfk}")

        hl.bind("XF86AudioMicMute", toggle_mic, { locked = true })
        hl.bind("SUPER + ALT + F9", toggle_mic, { locked = true })
        hl.bind("ALT + XF86AudioMute", toggle_mic, { locked = true })

        hl.bind("SUPER + SHIFT + F9", toggle_spk, { locked = true })
        hl.bind("SHIFT + XF86AudioMute", toggle_spk, { locked = true })

        hl.bind("SUPER + F9", toggle_afk, { locked = true })
        hl.bind("XF86AudioMute", toggle_afk, { locked = true })
      '';
  };
}
