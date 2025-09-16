{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.deeznuts.terminal;
in {
  options.deeznuts.terminal = {
    kitty = {
      enable = mkEnableOption "kitty terminal";
    };
    wezterm = {
      enable = mkEnableOption "wezterm";
    };
  };

  config = {
    programs.kitty = {
      enable = cfg.kitty.enable;
      settings = {
        window_padding_width = 2;
        update_check_interval = 0;
        scrollback_lines = 10000;
        enable_audio_bell = false;
      };
      keybindings = {
        "ctrl+shift+g" = "no_op";
      };
    };

    programs.wezterm = {
      enable = cfg.wezterm.enable;
      extraConfig =
        #lua
        ''
          return {
             hide_tab_bar_if_only_one_tab = true;
          }
        '';
    };

    wayland.windowManager.hyprland.settings = {
      "$terminal" = "kitty";

      bind = [
        "SUPER, Q, exec, $terminal"
      ];
    };
  };
}
