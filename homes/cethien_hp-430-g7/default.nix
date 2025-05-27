{
  imports = [../../modules/home];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    stylix.enable = true;

    programs = {
      hyprland = {
        enable = true;
        hypridle.enable = true;
        monitors = [
          "eDP-1, 1920x1080@60, 0x0, 1.2"
          "DP-1, 1920x1080@144, 1920x0, 1.2"
        ];

        workspaces = [
          "1, monitor:DP-1, persistent:true" # browser
          "2, monitor:DP-1, persistent:true" # general
          "3, monitor:DP-1, persistent:true" # general
          "4, monitor:DP-1, persistent:true" # general
          "5, monitor:DP-1, persistent:true" # general

          "6, monitor:eDP-1, persistent:true" # video
          "7, monitor:eDP-1, persistent:true" # spotify
          "8, monitor:eDP-1" # btm
          "9, monitor:eDP-1"
          "10, monitor:eDP-1"
        ];

        defaultWorkspaces = {
          browser = 1;
          gaming = 4;
        };
      };

      dev.chromium.enable = true;

      desktop.enable = true;
      browser = {
        zen-browser.hyprland.autostart.enable = true;
      };
      spotify.hyprland.autostart.enable = true;

      media-tools.enable = true;

      retroarch.enable = true;
      pokemmo.enable = true;
    };
  };
}
