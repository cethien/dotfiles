{
  imports = [ ../../modules/home ];

  deeznuts = {
    cli.enable = true;
    cli.shell.bash = {
      loadNixProfile = true;
    };

    cli.shell.aliases = {
      apt.enable = true;
      homeManagerConfigName = "cethien@LPT-SOTNIKOW";
    };

    theming.catppuccin.enable = true;
  };
}
