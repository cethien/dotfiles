{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    stylix = {
      enable = true;
      sizes = {
        cursor = 20;
        applications = 12;
        terminal = 14;
        desktop = 15;
        popups = 10;
      };
    };

    desktop.hyprland = {
      enable = true;
      monitors = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 0x1440, 1"
      ];

      workspaces = [
        "1, monitor:DP-1, persistent:true"
        "2, monitor:DP-1, persistent:true"
        "3, monitor:DP-1, persistent:true"
        "4, monitor:DP-1, persistent:true"
        "5, monitor:DP-1, persistent:true"

        "6, monitor:HDMI-A-1, persistent:true"
        "7, monitor:HDMI-A-1, persistent:true"
        "8, monitor:HDMI-A-1, persistent:true"
        "9, monitor:HDMI-A-1, persistent:true"
        "10, monitor:HDMI-A-1, persistent:true"
      ];

      hyprpanel = {
        layout.battery = false;
      };

      hyprlock = {
        monitor = "DP-1";
      };

      programs = {
        zen-browser.autostart = {
          enable = true;
          workspace = 6;
        };
        spotify.autostart = {
          enable = true;
        };
        steam.autostart.enable = true;
      };
    };

    programs = {
      cli.enable = true;
      basic.enable = true;
      gaming.enable = true;
      discord.enable = true;
      vscode.enable = true;
      obs-studio.enable = true;
    };
  };
}
