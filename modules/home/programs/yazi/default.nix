{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.programs.yazi;
in
{
  options.deeznuts.programs.yazi = {
    enable = mkEnableOption "Enable yazi";
  };

  config = mkIf cfg.enable {
    programs.yazi.enable = true;

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER SHIFT, e, exec, $terminal --class yazi yazi"
      ];
    };
  };
}
