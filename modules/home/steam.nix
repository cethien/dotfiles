{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption mkOption types;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces;
  cfg = config.programs.steam;
in {
  options = {
    programs.steam = {
      enable = mkEnableOption "steam stuff";
      autostart = mkEnableOption "autostart steam";
    };

    wayland.windowManager.hyprland.defaultWorkspaces.gaming = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "default gaming workspace";
    };
  };

  config = mkIf cfg.enable {
    xdg.desktopEntries.steam-friends-list = {
      name = "Steam Friends List";
      icon = "steam";
      exec = "xdg-open steam://open/friends";
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = mkIf cfg.autostart ["[silent] steam -silent"];

      windowrule =
        (config.lib.deeznuts.mkHyprGameWindowRules [
            "match:initial_class ^(steam_app_.*)$, match:initial_title ..*"
            "match:initial_class (?i).*\.exe$, match:initial_title ..*"
            "match:initial_class ^(Godot)$, match:initial_title ..*"
          ]
          ws.gaming)
        ++ (
          if ws.chat != null
          then ["match:class steam, match:title ^(Friends List)$, workspace ${toString ws.chat}"]
          else []
        );
    };
  };
}
