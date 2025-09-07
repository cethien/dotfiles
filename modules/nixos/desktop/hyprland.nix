{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.deeznuts.desktop;
in {
  options.deeznuts.desktop.hyprland = {
    enable = mkEnableOption "hyprland desktop";
  };

  config = mkIf cfg.hyprland.enable {
    # TODO: replace with simpler autologin without sddm.
    # so far greetd could autostart, getty could login, but could not use both
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };

      autoLogin = {
        enable = true;
        user = cfg.autologinUser;
      };
    };

    programs.hyprland.enable = true;
    services.udisks2.enable = true;
    services.upower.enable = true;
  };
}
