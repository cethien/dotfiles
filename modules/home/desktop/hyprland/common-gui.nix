{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  enabled = config.wayland.windowManager.hyprland.enable;
in {
  config = mkIf enabled {
    home.packages = with pkgs; [
      file-roller
      geary
    ];

    wayland.windowManager.hyprland.settings = let
      ws = config.wayland.windowManager.hyprland.defaultWorkspaces.browser;
    in {
      windowrule = mkIf (!isNull ws) ["match:initial_class geary, workspace ${toString ws}"];
    };

    programs = {
      imv.enable = true;
      mpv = {
        enable = true;
        config = {
          keep-open = true;
          ytdl-format = "bestvideo+bestaudio";
        };
      };
      zathura.enable = true;
    };

    xdg.mimeApps.defaultApplications = let
      categories = {
        videos = {
          desktop = "umpv.desktop";
          types = [
            "audio/mpeg"
            "audio/x-wav"
            "audio/vnd.wave"
            "audio/flac"
            "audio/x-flac"
            "audio/ogg"
            "audio/aac"
            "audio/webm"
            "audio/mp4"

            "video/mp4"
            "video/webm"
            "video/x-matroska"
            "video/ogg"
            "video/x-msvideo"
          ];
        };

        images = {
          desktop = "imv-dir.desktop";
          types = [
            "image/png"
            "image/jpeg"
            "image/webp"
            "image/gif"
            "image/svg+xml"
          ];
        };

        pdf = {
          desktop = "org.pwmt.zathura.desktop";
          types = ["application/pdf"];
        };

        archives = {
          desktop = "org.gnome.FileRoller.desktop";
          types = [
            "application/zip"
            "application/x-tar"
            "application/x-compressed-tar"
            "application/x-bzip-compressed-tar"
            "application/x-xz-compressed-tar"
            "application/x-7z-compressed"
            "application/x-rar"
            "application/x-cpio"
          ];
        };
      };

      mkHandlers = {
        types,
        desktop,
      }:
        builtins.listToAttrs (map (t: {
            name = t;
            value = [desktop];
          })
          types);

      handlers = builtins.foldl' (
        acc: cat:
          acc // mkHandlers cat
      ) {} (builtins.attrValues categories);
    in
      handlers;
  };
}
