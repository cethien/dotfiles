{stateVersion, ...}: {
  imports = [
    ../../../modules/home
  ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";
  home.stateVersion = stateVersion;

  deeznuts.programs = {
    hyprland = {
      enable = true;
      hypridle.enable = true;
      monitors = [
        "HDMI-A-1, 2560x1440@60, 1920x0, 1"
        "eDP-1, 1920x1080@60, 0x1440, 1"
        "DP-1, 1920x1080@60, 1920x1440, 1"
      ];

      workspaces = [
        "1, monitor:DP-1, persistent:true" # browser
        "2, monitor:HDMI-A-1, persistent:true" # general
        "3, monitor:HDMI-A-1, persistent:true" # general
        "4, monitor:HDMI-A-1, persistent:true" # general
        "5, monitor:HDMI-A-1, persistent:true" # general

        "6, monitor:DP-1, persistent:true" # video
        "7, monitor:DP-1, persistent:true" # spotify
        "8, monitor:DP-1" # btm
        "9, monitor:DP-1" # discord
        "10, monitor:DP-1" # obs
      ];

      defaultWorkspaces = {
        browser = 1;
        gaming = 4;
      };
    };

    dev.chromium.enable = true;
    gaming.enable = true;
  };
}
