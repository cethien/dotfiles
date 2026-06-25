{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.kitty;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-kitty" =
        # lua
        ''
          hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("kitty"))
        '';
    };

    programs.kitty = {
      settings = {
        clear_all_shortcuts = true;
        repaint_delay = 4;
        input_delay = 2;
        sync_to_monitor = true;
        window_padding_width = 2;
        update_check_interval = 0;
        scrollback_lines = 10000;
        enable_audio_bell = false;
      };
      keybindings = {
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+v" = "paste_from_clipboard";

        "ctrl+shift+up" = "no_op";
        "ctrl+shift+down" = "no_op";
        "ctrl+shift+left" = "no_op";
        "ctrl+shift+right" = "no_op";
      };
    };
  };
}
