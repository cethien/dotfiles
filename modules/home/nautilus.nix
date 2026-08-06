{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.nautilus;
in {
  options.programs.nautilus.enable = lib.mkEnableOption "nautilus";

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.nautilus];

    xdg.mimeApps.defaultApplications."inode/directory" = [
      "org.gnome.Nautilus.desktop"
    ];

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-nautilus" =
        #lua
        ''
          hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus"))
        '';
    };
  };
}
