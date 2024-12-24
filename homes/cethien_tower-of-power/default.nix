{
  imports = [ ../../modules/home ];

  deeznuts = {
    cli.enable = true;

    cli.shell.aliases = {
      nixosRebuild.enable = true;
      nixosRebuild.configName = "tower-of-power";

      homeManagerConfigName = "cethien@tower-of-power";
    };

    apps = {
      easyeffects.enable = true;

      firefox.enable = true;
      spotify.enable = true;
      vscode.enable = true;
      keepassxc.enable = true;
      drawio.enable = true;

      discord.enable = true;
      ocenaudio.enable = true;
      inkscape.enable = true;
      obs-studio.enable = true;

      gaming = {
        mangohud.enable = true;
        protonge.enable = true;

        r2modman.enable = true;
        retroarch.enable = true;
        prismlauncher.enable = true;
      };
    };

    desktop.plasma6.enable = true;

    theming = {
      catppuccin.enable = true;
      gtk.enable = true;
      qt.enable = true;
      wallpapers.enable = true;
    };
  };
}
