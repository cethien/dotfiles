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

          "4, monitor:eDP-1, persistent:true" # youtube
          "5, monitor:eDP-1, persistent:true" # spotify
          "6, monitor:eDP-1, persistent:true" # btm
          "7, monitor:eDP-1, persistent:true" # discord
        ];

        defaultWorkspaces = {
          browser = 1;
          gaming = 3;
        };
      };

      dev.chromium.enable = true;

      desktop.enable = true;
      browser = {
        zen-browser.hyprland.autostart.enable = true;
        picture-in-picture.hyprland.workspace = 4;
      };
      spotify.hyprland.autostart.enable = true;

      retroarch.enable = true;
      pokemmo.enable = true;
    };
  };
}
