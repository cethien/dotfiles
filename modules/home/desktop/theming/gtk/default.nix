{ lib, config, pkgs, ... }:
let
  inherit (lib) mkIf;
  cfg = config.deeznuts.desktop;
in
{
  config = mkIf (cfg.gnome.enable || cfg.plasma6.enable || cfg.hyprland.enable) {
    gtk = {
      enable = true;

      iconTheme = {
        name = "Tela-dracula-dark";
        package = pkgs.tela-icon-theme;
      };

      cursorTheme = {
        name = "Nordzy-cursors";
        package = pkgs.nordzy-cursor-theme;
      };
    };

    catppuccin.gtk = {
      enable = true;
      gnomeShellTheme = true;

      tweaks = [ "rimless" ];
    };
  };
}
