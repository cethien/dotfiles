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

    services.gnome.core-apps.enable = false;
    services.gnome.core-developer-tools.enable = false;
    services.gnome.games.enable = false;
    environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];
  };
}
