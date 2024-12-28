{
  imports = [ ../../modules/home ];

  deeznuts = {
    catppuccin.enable = true;
    cli = {
      enable = true;
      shell.bash.sourceNixProfile.enable = true;
    };
  };
}
