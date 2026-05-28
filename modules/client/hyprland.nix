{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland;
in {
  config = lib.mkIf cfg.enable {
    # TODO: replace with simpler autologin without sddm.
    # so far greetd could autostart, getty could login, but could not use both
    services.displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
      autoLogin.enable = true;
    };

    services.udisks2.enable = true;
    services.upower.enable = true;

    programs.gpu-screen-recorder.enable = true;

    security.pam.services.hyprlock.fprintAuth = true;
  };
}
