{
  imports = [ ../../modules/home ];

  cli.enable = true;

  apps = {
    easyeffects.enable = true;

    kitty.enable = true;

    firefox.enable = true;
    spotify.enable = true;
    vscode.enable = true;
    keepassxc.enable = true;
    rnote.enable = true;
  };

  desktop-environment.gnome.enable = true;

  theming = {
    catppuccin.enable = true;
    gtk.enable = true;
    qt.enable = true;
    wallpapers.enable = true;
  };
}
