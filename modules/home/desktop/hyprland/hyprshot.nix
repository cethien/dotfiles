{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = [pkgs.gradia];

    wayland.windowManager.hyprland.settings.bind = let
      cmd = mode: "${pkgs.hyprshot}/bin/hyprshot -z -o ~/Pictures/Screenshots -m ${mode}";
    in [
      ", Print, exec, ${cmd "output"} -m active"
      "ALT, Print, exec, ${cmd "window"} -m active"
      "SUPER SHIFT, S, exec, ${cmd "region"}"
    ];
  };
}
