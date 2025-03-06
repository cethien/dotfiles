{ lib, config, ... }:
let
  inherit (lib) mkIf;
  enabled = config.deeznuts.desktop.hyprland.enable;
in
{
  programs.zathura = mkIf enabled {
    enable = true;
  };
}
