{ lib, config, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop;
in
{
  config = mkIf (cfg.gnome.enable || cfg.plasma6.enable || cfg.hyprland.enable) {
    qt = {
      enable = true;

      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    catppuccin.kvantum.enable = true;
  };
}
