{ lib, config, pkgs, ... }:

{
  options.deeznuts.desktop.plasma6.enable = lib.mkEnableOption "Enable Plasma desktop environment";

  config = lib.mkIf config.deeznuts.desktop.plasma6.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "Catppuccin-Mocha-Mauve";
        iconTheme = "Tela-dracula-dark";
        cursor.theme = "Nordzy-cursors";
        wallpaper = "/home/cethien/Pictures/wallpapers/drippy-smiley-cute-5120x2880.jpg";
      };

      panels = [
        {
          screen = 1;
          location = "top";
          floating = true;

          height = 42;

          widgets = [
            "org.kde.plasma.kickoff"
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
                time.showDate = false;
                time.format = "24h";
                calendar.firstDayOfWeek = "monday";
                calendar.showWeekNumbers = true;
              };
            }
          ];
        }
      ];
    };
  };

}
