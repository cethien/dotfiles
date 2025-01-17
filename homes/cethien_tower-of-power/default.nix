{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;
    stylix.enable = true;
    desktop.hyprland = {
      enable = true;
      monitors = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 0x1440, 1"
      ];

      workspaces = [
        "1, monitor:DP-1, persistent:true, default:false"
        "2, monitor:DP-1, persistent:true, default:true"
        "3, monitor:DP-1, persistent:true, default:false"
        "4, monitor:DP-1, persistent:true, default:false"
        "5, monitor:DP-1, persistent:true, default:false"

        "6, monitor:HDMI-A-1, persistent:true, default:true"
        "7, monitor:HDMI-A-1, persistent:true, default:false"
        "8, monitor:HDMI-A-1, persistent:true, default:false"
        "9, monitor:HDMI-A-1, persistent:true, default:false"
        "10, monitor:HDMI-A-1, persistent:true, default:false"
      ];

      hyprpanel = {
        barLayouts = {
          "0" = {
            left = [ "windowtitle" ];
            middle = [ "workspaces" ];
            right = [ "media" "clock" ];
          };
          "1" = {
            left = [ "windowtitle" ];
            middle = [ "workspaces" ];
            right = [ "media" "systray" "volume" "bluetooth" "network" "notifications" "dashboard" "clock" ];
          };
        };
      };
    };
    programs = {
      cli.enable = true;
      basic.enable = true;
      gaming.enable = true;
      discord.enable = true;
      obs-studio.enable = true;
      firefox-devedition.enable = true;
    };
  };
}
