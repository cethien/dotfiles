{
  imports = [ ../../modules/home ];

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
          "1, monitor:eDP-1, persistent:true" # general
          "2, monitor:eDP-1, persistent:true" # general
          "3, monitor:eDP-1, persistent:true" # browser
          "4, monitor:eDP-1, persistent:true" # discord
          "5, monitor:eDP-1, persistent:true" # spotify
          "6, monitor:eDP-1, persistent:true" # monitoring

          "7, monitor:DP-1, persistent:true" # gaming
        ];

        defaultWorkspaces = {
          browser = 3;
          gaming = 7;
        };
      };

      cli.enable = true;
      basic.enable = true;
      zen-browser.hyprland.autostart.enable = true;
      spotify.hyprland.autostart.enable = true;

      chromium.enable = true;

      retroarch.enable = true;
      pokemmo.enable = true;
    };
  };
}
