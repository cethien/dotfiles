{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkMerge mkIf elem;
  cfg = config.deeznuts.gaming;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
in {
  options.deeznuts.gaming = mkOption {
    type = types.listOf types.str;
    default = [];
  };

  config = {
    home.packages = mkMerge [
      (mkIf (elem "r2modman" cfg) [pkgs.r2modman])
      (mkIf (elem "minecraft" cfg) [pkgs.prismlauncher])
      (mkIf (elem "pokemmo" cfg) [pkgs.pokemmo-installer])
      (mkIf (elem "retroarch" cfg) [
        (pkgs.retroarch.withCores
          (cores:
            with cores; [
              mgba #GB / GBC / GBA
              dolphin #GC / Wii
              melonds #NDS
              citra #N3DS
            ]))
      ])
    ];

    services.syncthing.settings = mkIf (config.services.syncthing.enable
      && (elem "retroarch" cfg)) {
      folders.retroarch = {
        id = "retroach";
        path = "${config.home.homeDirectory}/.config/retroarch";
        devices = ["hp-430-g7" "xiaomi-15" "tower-of-power"];
      };
    };

    home.file = mkIf (config.services.syncthing.enable
      && (elem "retroarch" cfg)) {
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

    wayland.windowManager.hyprland.settings = {
      windowrulev2 = mkMerge [
        (mkIf (elem "steam" cfg) [
          "workspace ${toString ws}, title:^(steam)$"
        ])
        (mkIf (elem "retroarch" cfg) [
          "workspace ${toString ws}, class:^(com\.libretro\.RetroArch)$"
        ])
        (mkIf (elem "pokemmo" cfg) [
          "workspace ${toString ws}, title:PokeMMO"
          "fullscreen, title:PokeMMO"
        ])
        (mkIf (elem "minecraft" cfg) [
          "workspace ${toString ws}, class:org.prismlauncher.PrismLauncher"
          "workspace ${toString ws}, class:^Minecraft.*"
          "fullscreen, class:^Minecraft.*"
        ])
      ];
    };
  };
}
