{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.lib.deeznuts.hyprland) mkGameWindowRules mkWorkspaceRules;
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
      exec-once = mkIf cfg.autostart ["[silent] steam -silent"];

      windowrule = let
        customGames = [];
        customGameMatches =
          map (
            game: "match:initial_class ^(${game})$, match:initial_title ..*"
          )
          customGames;

        defaultGameMatches = [
          "match:initial_class ^(steam_app_.*)$, match:initial_title ..*"
          "match:initial_class ^(Godot)$, match:initial_title ..*"
        ];
      in
        (mkGameWindowRules (defaultGameMatches ++ customGameMatches))
        ++ (mkWorkspaceRules "consoleLauncher" ["match:class steam, match:title ^(Steam Big Picture)$"])
        ++ (mkWorkspaceRules "chat" ["match:class steam, match:title ^(Friends List)$"]);
    };
  };
}
