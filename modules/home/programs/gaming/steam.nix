{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.gaming.steam;
in {
  options.deeznuts.programs.gaming.steam = {
    enable = mkEnableOption "steam additions (steam is managed on OS level)";

    hyprland = {
      autostart.enable = mkEnableOption "hyprland autostart";
      workspace = mkOption {
        type = types.int;
        default = config.deeznuts.desktop.hyprland.defaultWorkspaces.gaming;
        description = "default workspace";
      };
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(steam)$"
      ];

      exec-once = mkIf cfg.hyprland.autostart.enable [
        "[silent] steam -silent"
      ];
    };

    home.packages = with pkgs; [protonup];
    home.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "~/.stream/root/compatibilitytools.d";
    };
  };
}
