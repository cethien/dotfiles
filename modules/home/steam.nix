{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.deeznuts.hyprland) mkGameWindowRules mkDefaultWorkspaceWindowRule mkAutostart;
  cfg = config.programs.steam;
in {
  options.programs.steam = {
    enable = mkEnableOption "steam stuff";
    autostart = mkEnableOption "autostart steam";
  };

  config = mkIf cfg.enable {
    xdg.desktopEntries.steam-friends-list = {
      name = "Steam Friends List";
      icon = "steam";
      exec = "xdg-open steam://open/friends";
    };

    home.packages = [pkgs.protonplus];

    wayland.windowManager.hyprland.settings = {
      on = mkIf cfg.autostart [(mkAutostart "steam -silent" {workspace = "unset silent";})];

      window_rule = [
        (mkGameWindowRules {
          initial_class = "^(steam_app_.*|Godot)$";
          initial_title = "..*";
        })
        (mkDefaultWorkspaceWindowRule "console_launcher" {
          class = "steam";
          title = "^(Steam Big Picture)$";
        })
        (mkDefaultWorkspaceWindowRule "chat" {
          class = "steam";
          title = "^(Friends List)$";
        })
      ];
    };
  };
}
