{
  imports = [ ../../modules/home ];

  deeznuts = {
    cli = {
      enable = true;
      shell.bash.sourceNixProfile.enable = true;
    };

    theming.catppuccin.enable = true;
  };
}
