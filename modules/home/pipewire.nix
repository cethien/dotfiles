{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.wiremix;
in {
  options.programs.wiremix.enable = mkEnableOption "wiremix";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wiremix
    ];

    wayland.windowManager.hyprland = {
      modals."wiremix".binds = [
        "SUPER SHIFT, M"
        "SHIFT, XF86Music"

        "SHIFT, XF86Tools"
      ];

      settings.bindl = let
        makeToggleScript = {
          name,
          targets,
          iconOn,
          iconOff,
          msgOn ? "unmuted",
          msgOff ? "muted",
        }: let
          wpctl = "${pkgs.wireplumber}/bin/wpctl";
          grep = "${pkgs.gnugrep}/bin/grep";
          notify-send = "${pkgs.libnotify}/bin/notify-send";
          wpctlCmds = lib.strings.concatMapStringsSep "\n" (t: "${wpctl} set-mute ${t} toggle") targets;
          firstTarget = builtins.head targets;
        in
          pkgs.writeShellScriptBin "toggle-${name}"
          #bash
          ''
            ${wpctlCmds}

            if ${wpctl} get-volume "${firstTarget}" | ${grep} -q MUTED; then
              ${notify-send} "${iconOff} ${name}" "${msgOff}"
            else
              ${notify-send} "${iconOn} ${name}" "${msgOn}"
            fi
          '';

        toggleIn = "${makeToggleScript {
          name = "mic";
          targets = ["@DEFAULT_AUDIO_SOURCE@"];
          iconOn = "󰍬";
          iconOff = "󰍭";
        }}/bin/toggle-mic";

        toggleOut = "${makeToggleScript {
          name = "speakers";
          targets = ["@DEFAULT_AUDIO_SINK@"];
          iconOn = "󰓃";
          iconOff = "󰓄";
        }}/bin/toggle-speakers";

        toggleInOut = "${makeToggleScript {
          name = "afk";
          targets = ["@DEFAULT_AUDIO_SOURCE@" "@DEFAULT_AUDIO_SINK@"];
          iconOn = "󰟀";
          msgOn = "welcome back";
          iconOff = "󰩈";
          msgOff = "goodbye";
        }}/bin/toggle-afk";
      in [
        ", XF86AudioMicMute, exec, ${toggleIn}"
        "SUPER ALT, F9, exec, ${toggleIn}"
        "ALT, XF86AudioMute, exec, ${toggleIn}"

        "SUPER SHIFT, F9, exec, ${toggleOut}"
        "SHIFT, XF86AudioMute, exec, ${toggleOut}"

        "SUPER, F9, exec, ${toggleInOut}"
        ", XF86AudioMute, exec, ${toggleInOut}"
      ];
    };
  };
}
