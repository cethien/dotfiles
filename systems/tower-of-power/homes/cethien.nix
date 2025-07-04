{
  stateVersion,
  user ? "cethien",
  ...
}: {
  imports = [
    ../../../modules/home
  ];

  home.stateVersion = stateVersion;
  home.username = user;
  home.homeDirectory = "/home/${user}";

  deeznuts.programs = {
    hyprland = {
      enable = true;
      hypridle.enable = true;
      monitors = [
        "DP-1, 2560x1440@240, 0x0, 1"
        "HDMI-A-1, 1920x1080@100, 640x1440, 1"
      ];

      workspaces = [
        "1, monitor:eDP-1, persistent:true" # browser
        "2, monitor:HDMI-A-1, persistent:true" # general
        "3, monitor:HDMI-A-1, persistent:true" # general
        "4, monitor:HDMI-A-1, persistent:true" # general
        "5, monitor:HDMI-A-1, persistent:true" # general

        "6, monitor:eDP-1, persistent:true" # video
        "7, monitor:eDP-1, persistent:true" # spotify
        "8, monitor:eDP-1" # btm
        "9, monitor:eDP-1" # discord
        "10, monitor:eDP-1" # obs
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
