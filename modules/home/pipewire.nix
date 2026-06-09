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
        "SUPER + SHIFT + M"
        "SHIFT + XF86Music"
        "SHIFT + XF86Tools"
      ];

      settings.bind = let
        inherit (config.lib.deeznuts.hyprland) mkExecBind;
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
        # Mic Mute
        (mkExecBind "XF86AudioMicMute" "${toggleIn}" {locked = true;})
        (mkExecBind "SUPER + ALT + F9" "${toggleIn}" {locked = true;})
        (mkExecBind "ALT + XF86AudioMute" "${toggleIn}" {locked = true;})

        # Speakers Mute
        (mkExecBind "SUPER + SHIFT + F9" "${toggleOut}" {locked = true;})
        (mkExecBind "SHIFT + XF86AudioMute" "${toggleOut}" {locked = true;})

        # Master AFK Mute (Both)
        (mkExecBind "SUPER + F9" "${toggleInOut}" {locked = true;})
        (mkExecBind "XF86AudioMute" "${toggleInOut}" {locked = true;})
      ];
    };
  };
}
