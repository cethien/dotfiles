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

    programs.hyprshot.saveLocation = "${config.home.homeDirectory}/Pictures";

    wayland.windowManager.hyprland.settings.bind = let
      cmd = mode: "hyprshot -z -m ${mode}";
    in [
      (mkExecBind "Print" "${cmd "output"} -m active" {})
      (mkExecBind "ALT + Print" "${cmd "window"} -m active" {})
      (mkExecBind "SUPER + SHIFT + S" "${cmd "region"}" {})
    ];
  };
}
