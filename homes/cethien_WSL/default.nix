{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;
    catppuccin.enable = true;
    programs = {
      cli.enable = true;
      bash.sourceNixProfile = true;
    };
  };
}
