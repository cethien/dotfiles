{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.programs.aerc;
  execAerc = "${cfg.package}/bin/aerc";
in {
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      w3m
      xdg-utils
    ];

    programs.tmux.keybindings = [
      {
        key = "m";
        action = "new-window -an aerc ${execAerc}";
      }
    ];

    # xdg.desktopEntries.aerc = {
    #   name = "aerc";
    #   genericName = "Email Client";
    #   exec = execAerc;
    #   terminal = true;
    #   icon = "mail";
    #   categories = ["Network" "Email"];
    # };
    #
    # wayland.windowManager.hyprland.extraLuaFiles."99-aerc" = lib.mkIf (config.wayland.windowManager.hyprland.enable or false) ''
    #   hl.bind("SUPER + SHIFT + F12", hl.dsp.exec_cmd("kitty -e ${execAerc}"))
    #   hl.bind("SHIFT + XF86Mail", hl.dsp.exec_cmd("kitty -e ${execAerc}"))
    # '';
  };
}
