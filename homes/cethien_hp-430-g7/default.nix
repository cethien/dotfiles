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
          "1, monitor:eDP-1, persistent:true"
          "2, monitor:eDP-1, persistent:true"
          "3, monitor:eDP-1, persistent:true"
          "4, monitor:eDP-1, persistent:true"
          "5, monitor:eDP-1, persistent:true"
          "6, monitor:eDP-1, persistent:true"

          "7, monitor:DP-1, persistent:true"
          "8, monitor:DP-1, persistent:true"
        ];
      };

      cli.enable = true;

      basic.enable = true;
      zen-browser.hyprland.autostart.enable = true;
      spotify.hyprland.autostart.enable = true;

      retroarch.enable = true;
      pokemmo.enable = true;
    };
  };
}
