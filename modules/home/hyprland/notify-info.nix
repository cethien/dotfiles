{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    wayland.windowManager.hyprland.settings.bind = let
      s = "${
        pkgs.writeShellScriptBin "notify-info" (builtins.readFile ./notify-info.sh)
      }/bin/notify-info";
    in [
      "SUPER, i, exec, ${s}"
    ];
  };
}
