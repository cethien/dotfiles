{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;
    catppuccin.enable = true;
    programs.cli.enable = true;
    programs.bash.sourceNixProfile = true;
  };
}
