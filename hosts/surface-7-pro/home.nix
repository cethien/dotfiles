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
    rnote.enable = true;
  };

  desktop = {
    theming = {
      gtk.enable = true;
      qt.enable = true;
    };

    gnome = {
      dconf-settings.enable = true;
      keybindings.enable = true;
      extensions.enable = true;
    };

    wallpapers.enable = true;
  };
}
