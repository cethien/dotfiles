{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.lib.deeznuts.hyprland) mkExecBind;
  cfg = config.programs.hyprshot;
in {
  config = mkIf cfg.enable {
    home.packages = [pkgs.gradia];

    wayland.windowManager.hyprland.settings.bind = let
      cmd = mode: "${pkgs.hyprshot}/bin/hyprshot -z -m ${mode}";
    in [
      (mkExecBind "Print" "${cmd "output"} -m active" {})
      (mkExecBind "ALT + Print" "${cmd "window"} -m active" {})
      (mkExecBind "SUPER + SHIFT" "${cmd "region"}" {})
    ];
  };
}
