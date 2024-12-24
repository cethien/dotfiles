{ lib, config, pkgs, ... }:

{
  options.deeznuts.desktop.plasma6.enable = lib.mkEnableOption "Enable Plasma desktop environment";

  config = lib.mkIf config.deeznuts.desktop.plasma6.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "Catppuccin-Mocha-Mauve";
        cursor.theme = "Nordzy-cursors";
        iconTheme = "Tela-dracula-dark";
        wallpaper = "/home/cethien/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg";
      };

      hotkeys.commands."launch-konsole" = {
        name = "Launch Konsole";
        key = "Crtl+Alt+T";
        command = "konsole";
      };

      panels = [
        {
          location = "top";
          widgets = [
            "org.kde.plasma.appmenu"
            "org.kde.plasma.panelspacer"
            {
              plasmusicToolbar = {
                panelIcon = {
                  albumCover = {
                    useAsIcon = true;
                    radius = 0;
                  };
                  icon = "view-media-track";
                };
                playbackSource = "Spotify";
                musicControls.showPlaybackControls = true;
                songText = {
                  displayInSeparateLines = true;
                  maximumWidth = 800;
                  scrolling = {
                    behavior = "alwaysScroll";
                    speed = 3;
                  };
                };
              };
            }
            "org.kde.plasma.panelspacer"
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.bluetooth"
                ];
                hidden = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.networkmanagement"
                  "org.kde.plasma.volume"
                ];
              };
            }
            {
              digitalClock = {
                time.format = "24h";
                calendar.firstDayOfWeek = "monday";
              };
            }
          ];
        }
      ];
    };
  };

}
