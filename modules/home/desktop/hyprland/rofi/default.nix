{ lib, config, ... }:
{
  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
    programs.rofi = {
      enable = true;
    };
  };
}
