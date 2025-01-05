{
  imports = [ ../../modules/home ];

  programs.home-manager.enable = true;


  deeznuts = {
    nixpkgs.allowUnfree = true;
    catppuccin.enable = true;
    programs.cli.enable = true;
    programs.bash.sourceNixProfile = true;
  };
}
