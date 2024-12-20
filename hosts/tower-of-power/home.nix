{
  imports = [ ../../modules/home ];

  home.username = "cethien";
  home.homeDirectory = "/home/cethien";

  catppuccin.enable = true;

  apps = {
    easyeffects.enable = true;

    kitty.enable = true;

    firefox.enable = true;
    spotify.enable = true;
    vscode.enable = true;
    keepassxc.enable = true;
    drawio.enable = true;

    discord.enable = true;
    ocenaudio.enable = true;
    inkscape.enable = true;
    obs-studio.enable = true;
  };

  desktop = {
    theming = {
      gtk.enable = true;
      qt.enable = true;
    };

    wallpapers.enable = true;
  };

  gaming = {
    mangohud.enable = true;
    lutris.enable = true;
    protonge.enable = true;
    r2modman.enable = true;
    retroarch.enable = true;
    prism-launcher.enable = true;
  };
}
