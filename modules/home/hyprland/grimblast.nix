{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.grimblast;
in {
  options.programs.grimblast.enable = mkEnableOption "grimblast";

  config = mkIf cfg.enable {
    home.packages = [pkgs-unstable.gradia pkgs-unstable.grimblast];

    wayland.windowManager.hyprland.extraLuaFiles."99-grimblast" =
      #lua
      ''
        local cmd = "DEFAULT_TARGET_DIR=$HOME/Pictures/ grimblast -fno copysave area"
        hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd(cmd))
      '';
  };
}
