{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.programs.yazi;
  enable = cfg.enable || config.deeznuts.desktop.hyprland.enable;
in
{
  config = mkIf enable {
    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, E, exec, $terminal --class yazi yazi"
      ];

      windowrulev2 = [
        "float, class:^(yazi)$"
        "center, class:^(yazi)$"
        "size 1640 990, class:^(yazi)$"
        "stayfocused, class:^(yazi)$"
      ];
    };
  };
}
