{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.deeznuts.desktop.plasma6;
in
{
  options.deeznuts.desktop.plasma6 = {
    enable = mkEnableOption "Enable plasma desktop";
  };

  config = mkIf cfg.enable {
    programs.plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        lookAndFeel = "Catppuccin-Mocha-Mauve";
        iconTheme = "Tela-dracula-dark";
        cursor.theme = "Nordzy-cursors";
        wallpaper = "/home/cethien/Pictures/wallpapers/drippy-smiley.jpg";
      };

      shortcuts = {
        "services/org.wezfurlong.wezterm.desktop" = {
          "_launch" = "Ctrl+Alt+T";
        };
      };

      panels = [
        {
          screen = 1;
          location = "top";
          floating = true;

          height = 42;

          widgets = [
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
              digitalClock = {
                time.format = "24h";
                calendar.firstDayOfWeek = "monday";
                calendar.showWeekNumbers = true;
              };
            }
          ];
        }
        {
          screen = 0;
          location = "top";
          floating = true;

          height = 42;

          widgets = [
            "org.kde.plasma.kickoff"
            "org.kde.plasma.pager"
            "org.kde.plasma.panelspacer"
            {
              systemTray.items = {
                shown = [
                  "org.kde.plasma.volume"
                  "org.kde.plasma.bluetooth"
                ];
                hidden = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.networkmanagement"
                ];
              };
            }
            {
              digitalClock = {
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
