{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem mkMerge;
in {
  config = {
    wayland.windowManager.hyprland.settings = let
      auto = elem "discord" config.wayland.windowManager.hyprland.autostart;
    in {
      exec-once = mkIf auto (mkMerge [
        (mkIf config.programs.discord.enable ["[silent] discord --start-minimized"])
        (mkIf config.programs.vesktop.enable ["[silent] vesktop --start-minimized"])
      ]);
    };
  };
}
