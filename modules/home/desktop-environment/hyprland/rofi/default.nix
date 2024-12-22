{ lib, config, ... }:
{
  config = lib.mkIf config.desktop-environment.hyprland.enable {
    programs.rofi = {
      enable = true;
    };
  };
}
