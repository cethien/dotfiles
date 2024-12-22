{ lib, config, ... }:
{
  config = lib.mkIf config.desktop.hyprland.enable {
    programs.rofi = {
      enable = true;
    };
  };
}
