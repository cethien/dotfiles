{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf elem mkMerge mkOption types;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.chat;
in {
  options.wayland.windowManager.hyprland = {
    defaultWorkspaces = {
      chat = mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "default chat workspace";
      };
    };
  };

  config = {
    stylix.targets.vesktop.enable = false;
    stylix.targets.nixcord.enable = false;

    wayland.windowManager.hyprland.settings = let
      auto = elem "discord" config.wayland.windowManager.hyprland.autostart;
    in {
      exec-once = mkIf auto (mkMerge [
        (mkIf config.programs.discord.enable ["[silent] discord --start-minimized"])
        (mkIf config.programs.vesktop.enable ["[silent] vesktop --start-minimized"])
      ]);

      windowrule = mkIf (!isNull ws) (mkMerge [
        (mkIf (config.programs.discord.enable) ["match:initial_class discord, workspace ${toString ws}"])
        (mkIf (config.programs.vesktop.enable) ["match:initial_class vesktop, workspace ${toString ws}"])
      ]);
    };
  };
}
