{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.programs.steam;
  uname = config.home.username;

  autostartFile = pkgs.makeDesktopItem {
    exec = "steam -silent";
    name = "steam-autostart";
    desktopName = "Steam (Autostart)";
  };
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

    xdg.autostart.entries = lib.optionals cfg.autostart [
      "${autostartFile}/share/applications/steam-autostart.desktop"
    ];

    home.packages = with pkgs-unstable; [protonplus];

    programs.zen-browser = {
      profiles."${uname}".extensions.packages = with pkgs.firefox-addons; [
        steam-database
        augmented-steam
        protondb-for-steam
      ];
    };

    wayland.windowManager.hyprland.extraLuaFiles."99-steam" =
      # lua
      ''
        game_windowrule({
        	xdg_tag = "^proton-game$",
        	initial_title = "..*",
        })

        game_windowrule({
        	initial_class = "^Godot$",
        	initial_title = "..*",
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
