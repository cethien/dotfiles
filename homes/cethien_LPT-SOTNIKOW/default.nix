{
  home.stateVersion = "25.05"; # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING

  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;

    user = {
      enable = true;
      name = "cethien";
    };

    catppuccin.enable = true;

    cli = {
      enable = true;
      shell.bash.sourceNixProfile.enable = true;
    };
  };
}
