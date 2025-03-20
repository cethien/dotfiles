{ lib, config, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.deeznuts.programs.kitty;
  enable = cfg.enable || config.deeznuts.desktop.hyprland.enable;
in
{
  options.deeznuts.programs.kitty = {
    enable = mkEnableOption "Enable kitty terminal";
  };

  config = mkIf enable {
    programs.kitty = {
      enable = true;

      settings = {
        window_padding_width = 6;
        update_check_interval = 0;
        scrollback_lines = 10000;
        enable_audio_bell = false;
      };

      keybindings = {
        "ctrl+shift+g" = "no_op";
      };
    };

    wayland.windowManager.hyprland.settings = {
      "$terminal" = "kitty";

      bind = [
        "SUPER, Q, exec, $terminal"
      ];
    };
  };
}
