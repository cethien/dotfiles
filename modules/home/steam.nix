{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
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

    xdg.configFile."autostart/steam.desktop" = mkIf cfg.autostart {
      text = ''
        [Desktop Entry]
        Name=Steam
        Comment=Link on Valve Steam
        Exec=steam -silent
        Icon=steam
        Terminal=false
        Type=Application
        Categories=Network;FileTransfer;Game;
      '';
    };

    home.packages = with pkgs; [protonplus];

    wayland.windowManager.hyprland.extraLuaFiles."99-steam" =
      # lua
      ''
        hl.window_rule({
            match = {
                initial_class = "^(steam_app_.*|Godot)$",
                initial_title = "..*",
            },
            content = "game",
            workspace = hl.defaultWorkspace.game,
        })

        hl.window_rule({
            match = {
                class = "steam",
                title = "^(Steam Big Picture)$",
            },
            workspace = hl.defaultWorkspace.game_launcher,
        })

        hl.window_rule({
            match = {
                class = "steam",
                title = "^(Friends List)$",
            },
            workspace = hl.defaultWorkspace.chat,
        })
      '';
  };
}
