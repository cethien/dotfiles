{
  lib,
  pkgs,
  pkgs-unstable,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.programs.retroarch;
  st = config.services.syncthing.enable;
in {
  config = mkIf cfg.enable {
    programs.retroarch = {
      # package = pkgs-unstable.retroarch;

      cores = {
        mgba.enable = true; # gb / gbc / gba
        dolphin.enable = true; # gc / wii
        melonds.enable = true; # nds
        desmume.enable = true; # nds alternative
        citra.enable = true; # n3ds
      };

      settings = {
        video_driver = "vulkan";
        video_fullscreen = "true";
        video_windowed_fullscreen = "true";
        video_vsync = "true";
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

    wayland.windowManager.hyprland.extraLuaFiles = {
      "99-retroarch" =
        # lua
        ''
          game_windowrule({ class = "^(com%.libretro%.RetroArch)$" })

          hl.window_rule({
              match = {
                  class = "^(com%.libretro%.RetroArch)$",
                  title = "^(RetroArch)$",
              },
              workspace = hl.defaultWorkspace.game,
          })
        '';
    };
  };
}
