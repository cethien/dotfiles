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
