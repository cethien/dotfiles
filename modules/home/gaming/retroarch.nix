{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
in {
  config = mkIf config.programs.retroarch.enable {
    programs.retroarch = {
      cores = {
        mgba.enable = true; #GB / GBC / GBA
        dolphin.enable = true; #GC / Wii
        melonds.enable = true; #NDS
        citra.enable = true; #N3DS
      };
    };

    services.syncthing.settings = mkIf config.services.syncthing.enable {
      folders.retroarch = {
        id = "retroach";
        path = "${config.home.homeDirectory}/.config/retroarch";
        devices = ["xiaomi-15" "tower-of-power"];
      };
    };

    home.file = mkIf config.services.syncthing.enable {
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

    wayland.windowManager.hyprland.settings.windowrule = pkgs.cethien.mkHyprGameWindowRule "match:class ^(com\.libretro\.RetroArch)$" "${toString ws}";
  };
}
