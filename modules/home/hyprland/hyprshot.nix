{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.hyprshot;
in {
  config = mkIf cfg.enable {
    home.packages = [pkgs.gradia];

    programs.hyprshot.saveLocation = "${config.home.homeDirectory}/Pictures";

    wayland.windowManager.hyprland.extraLuaFiles."99-hyprshot" =
      #lua
      ''
        local cmd = "hyprshot -z -m "
        hl.bind("Print", hl.dsp.exec_cmd(cmd .. "output -m active"))
        hl.bind("ALT + Print", hl.dsp.exec_cmd(cmd .. "window -m active"))
        hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(cmd .. "region"))
      '';
  };
}
