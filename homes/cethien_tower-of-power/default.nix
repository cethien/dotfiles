{
  imports = [ ../../modules/home ];

  deeznuts = {
    catppuccin.enable = true;
    desktop.plasma6.enable = true;

    cli.enable = true;

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

      terminals = {
        kitty.enable = true;
        wezterm.enable = true;
      };

      gaming = {
        mangohud.enable = true;
        protonge.enable = true;

        r2modman.enable = true;
        retroarch.enable = true;
        prismlauncher.enable = true;
      };
    };
  };
}
