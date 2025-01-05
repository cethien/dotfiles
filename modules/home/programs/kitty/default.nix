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

      font.name = "MesloLGM Nerd Font Mono";
      font.size = 14;
    };

    wayland.windowManager.hyprland.settings = {
      "$terminal" = "kitty";

      bind = [
        "SUPER, Q, exec, $terminal"
      ];

      windowrulev2 = [
        "float, class:^(kitty)$"
        "center, class:^(kitty)$"
        "size 1640 990, class:^(kitty)$"
      ];
    };
  };
}
