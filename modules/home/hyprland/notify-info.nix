{
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-notify-info" = let
        pkg = pkgs.writeShellScriptBin "notify-info" (
          builtins.readFile ./notify-info.sh
        );
        notify-info = "${pkg}/bin/notify-info";
      in
        # lua
        ''
          hl.bind("SUPER + I", hl.dsp.exec_cmd("${notify-info}"))
        '';
    };
  };
}
