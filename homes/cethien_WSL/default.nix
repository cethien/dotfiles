{
  imports = [ ../../modules/home ];

  programs.home-manager.enable = true;

  deeznuts = {
    nixpkgs.allowUnfree = true;

    catppuccin.enable = true;

    cli = {
      enable = true;
      shell.bash.sourceNixProfile.enable = true;
    };
  };
}
