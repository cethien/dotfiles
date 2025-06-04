{
  pkgs,
  home-manager,
  stateVersion,
  user ? "cethien",
  sops-nix,
  stylix,
  hyprpanel,
  zen-browser,
  nvf,
  ...
}:
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = {
    inherit sops-nix stylix nvf hyprpanel zen-browser;
  };
  module = [
    ../../modules/home
    {
      home.stateVersion = stateVersion;
      home.username = user;
      home.homeDirectory = "/home/${user}";

      deeznuts.programs = {
        hyprland = {
          enable = true;
          monitors = [
            "DP-1, 2560x1440@240, 0x0, 1.25"
            "HDMI-A-1, 1920x1080@100, 0x1440, 1"
          ];

          workspaces = [
            "1, monitor:DP-1, persistent:true" # general
            "2, monitor:DP-1, persistent:true" # general
            "3, monitor:DP-1, persistent:true" # gaming

            "4, monitor:HDMI-A-1, persistent:true" # browser
            "5, monitor:HDMI-A-1, persistent:true" # obs
            "6, monitor:HDMI-A-1, persistent:true" # discord
            "7, monitor:HDMI-A-1, persistent:true" # spotify
            "8, monitor:HDMI-A-1, persistent:true" # monitoring
          ];

          hyprpanel = {
            layout.battery = false;
          };

          hyprlock = {
            monitor = "DP-1";
          };
        };

        hyprland.defaultWorkspaces = {
          browser = 4;
          gaming = 3;
        };

        cli.enable = true;
        bottom.hyprland.workspace = 8;

        basic.enable = true;
        zen-browser.hyprland.autostart.enable = true;
        spotify.hyprland.autostart.enable = true;
        spotify.hyprland.workspace = 7;
        discord.hyprland.autostart.enable = true;
        discord.hyprland.workspace = 6;

        gaming.enable = true;
        steam.hyprland.autostart.enable = true;

        obs-studio.enable = true;
        obs-studio.hyprland.workspace = 5;
      };
    }
  ];
}
