{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.dbeaver;
in {
  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.extraLuaFiles."99-dbeaver" =
      # lua
      ''
        hl.window_rule({
            match = {
                initial_class = "^(DBeaver)$",
            },
            tile = true,
        })
      '';
  };
}
