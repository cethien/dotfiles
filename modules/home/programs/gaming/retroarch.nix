{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.deeznuts.programs.gaming.retroarch;
in {
  options.deeznuts.programs.gaming.retroarch = {
    enable = mkEnableOption "retroarch";
    hyprland.workspace = mkOption {
      type = types.int;
      default = config.deeznuts.desktop.hyprland.defaultWorkspaces.gaming;
      description = "default hyprland workspace";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings = {
      windowrulev2 = [
        "workspace ${toString cfg.hyprland.workspace}, class:^(com\.libretro\.RetroArch)$"
      ];
    };

    services.syncthing.settings = mkIf config.services.syncthing.enable {
      folders.retroarch = {
        id = "retroach";
        path = "${config.home.homeDirectory}/.config/retroarch";
        devices = ["xiaomi-15"];
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

    home.packages = let
      retroarchWithCores = pkgs.retroarch.withCores (cores:
        with cores; [
          mgba #GB / GBC / GBA
          dolphin #GC / Wii
          melonds #NDS
          citra #N3DS
        ]);
    in [
      retroarchWithCores
    ];
  };
}
