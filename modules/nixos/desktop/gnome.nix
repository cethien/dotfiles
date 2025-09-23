{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.desktop;
in {
  options.deeznuts.desktop.gnome = {
    enable = mkEnableOption "gnome desktop";
  };

  config = mkIf cfg.gnome.enable {
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    services.gnome.core-apps.enable = true;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
      epiphany
      gnome-text-editor
      yelp
      totem
      geary
      gnome-maps
      gnome-music
      gnome-calendar
      gnome-calculator
      gnome-characters
      gnome-logs
      gnome-clocks
      gnome-console
      gnome-contacts
      gnome-font-viewer
      gnome-weather
      gnome-connections
      simple-scan
    ];
  };
}
