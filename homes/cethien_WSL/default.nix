{
  home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    username = "cethien";

    catppuccin.enable = true;

    cli = {
      enable = true;
      shell.bash.sourceNixProfile.enable = true;
    };
  };
}
