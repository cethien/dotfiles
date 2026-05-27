{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.desktopManager.gnome;
in {
  config = lib.mkIf cfg.enable {
    services.displayManager.gdm.enable = true;
    services.gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = false;
      games.enable = false;
    };

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
