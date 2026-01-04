{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkOption types mkMerge mkIf;
  cfg = config.deeznuts.gaming;
  ws = config.wayland.windowManager.hyprland.defaultWorkspaces.gaming;
  as = config.wayland.windowManager.hyprland.autostart;
in {
  options.deeznuts.gaming = mkOption {
    type = types.listOf types.str;
    default = [];
  };

  config = {
    home.packages = mkMerge [
      (mkIf (builtins.elem "r2modman" cfg) [pkgs.r2modman])
      (mkIf (builtins.elem "minecraft" cfg) [pkgs.prismlauncher])
      (mkIf (builtins.elem "pokemmo" cfg) [pkgs.pokemmo-installer])
      (mkIf (builtins.elem "retroarch" cfg) [
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
      && (builtins.elem "retroarch" cfg)) {
      folders.retroarch = {
        id = "retroach";
        path = "${config.home.homeDirectory}/.config/retroarch";
        devices = ["xiaomi-15" "tower-of-power"];
      };
    };

    home.file = mkIf (config.services.syncthing.enable
      && (builtins.elem "retroarch" cfg)) {
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
      exec-once = mkIf (builtins.elem "steam" as) ["steam -silent"];

      windowrulev2 = mkMerge [
        (mkIf (builtins.elem "steam" cfg) [
          "workspace ${toString ws}, initialClass:^(steam_app_.*)$"
          "immediate, initialClass:^(steam_app_.*)$"
        ])
        (mkIf (builtins.elem "retroarch" cfg) [
          "workspace ${toString ws}, class:^(com\.libretro\.RetroArch)$"
        ])
        (mkIf (builtins.elem "pokemmo" cfg) [
          "workspace ${toString ws}, title:^(.*PokeMMO.*)$"
          "fullscreen, title:^(.*PokeMMO.*)$"
          "immediate, title:^(.*PokeMMO.*)$"
        ])
        (mkIf (builtins.elem "minecraft" cfg) [
          "workspace ${toString ws}, class:^(Minecraft.*)$"
          "fullscreen, class:^(Minecraft.*)$"
          "immediate, class:^(Minecraft.*)$"
        ])
      ];
    };
  };
}
