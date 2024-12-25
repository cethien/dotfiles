{ config, lib, ... }:

{
  imports = [
    ./settings
  ];

  config = lib.mkIf config.deeznuts.desktop.hyprland.enable {
    programs.waybar = {
      enable = true;
      style = builtins.readFile ./style.css;
    };
  };
}
