{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  enabled = config.deeznuts.desktop.hyprland.enable;
in {
  config = mkIf config.wayland.windowManager.hyprland.enable {
    home.packages = with pkgs; [
      nautilus
      file-roller
      decibels
      gnome-calculator
    ];

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

    wayland.windowManager.hyprland.settings = {
      bind = [
        "SUPER, e, exec, nautilus"
      ];
    };

    xdg.mimeApps.defaultApplications = let
      categories = {
        audio = {
          desktop = "org.gnome.Decibels.desktop";
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
          ];
        };

        videos = {
          desktop = "umpv.desktop";
          types = [
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

        files = {
          desktop = "org.gnome.Nautilus.desktop";
          types = ["inode/directory"];
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
