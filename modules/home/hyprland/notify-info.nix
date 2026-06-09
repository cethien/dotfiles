{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.deeznuts.hyprland) mkExecBind;
in {
  config = {
    wayland.windowManager.hyprland.settings = {
      bind = let
        p = pkgs.writeShellScriptBin "notify-info" (builtins.readFile ./notify-info.sh);
      in [
        (mkExecBind "SUPER + i" "${p}/bin/notify-info" {})
      ];
    };
  };
}
