{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.hyprland;
  u = config.users.users.cethien;
in {
  config = lib.mkIf cfg.enable {
    services.getty.autologinUser = u.name;
    programs.hyprland.withUWSM = true;

    environment.loginShellInit = ''
      if [ "$(tty)" = "/dev/tty1" ]; then
        clear
        if uwsm check may-start >/dev/null 2>&1; then
          exec uwsm start hyprland-uwsm.desktop >/dev/null 2>&1
        fi
      fi
    '';

    services.udisks2.enable = true;
    services.upower.enable = true;

    programs.gpu-screen-recorder.enable = true;

    security.pam.services.hyprlock.fprintAuth = true;
  };
}
