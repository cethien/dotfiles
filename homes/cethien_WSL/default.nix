{
  imports = [ ../../modules/home ];

  deeznuts = {
    nixpkgs.allowUnfree = true;
    stylix.enable = true;
    programs = {
      cli.enable = true;
      bash.sourceNixProfile = true;
    };
  };
}
