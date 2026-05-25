{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf optionals;
  cfg = config.programs.retroarch;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
  st = config.services.syncthing.enable;
in {
  config = mkIf cfg.enable {
    programs.retroarch = {
      cores = {
        mgba.enable = true; #GB / GBC / GBA
        dolphin.enable = true; #GC / Wii
        melonds.enable = true; #NDS
        citra.enable = true; #N3DS
      };
    };

    services.syncthing.settings = mkIf st {
      folders.retroarch = {
        id = "retroach";
        path = "${config.home.homeDirectory}/.config/retroarch";
        devices = ["xiaomi-15" "tower-of-power"];
      };
    };

    home.file = mkIf st {
      ".config/retroarch/.stignore".text = ''
        assets
        autoconfig
        config
        !config/remaps/
        !config/remaps/**
        content_favorites.lpl
        content_history.lpl
        content_image_history.lpl
        content_music_history.lpl
        content_video_history.lpl
        cores
        database
        !database/rdb/
        !database/rdb/**
        downloads
        filters
        logs
        overlays
        playlists
        records
        records_config
        retroarch.cfg
        screenshots
        shaders
        thumbnails
      '';
    };

    wayland.windowManager.hyprland.settings.windowrule =
      config.lib.deeznuts.mkHyprGameWindowRules [
        "match:class ^(com\.libretro\.RetroArch)$"
      ]
      ws;
  };
}
