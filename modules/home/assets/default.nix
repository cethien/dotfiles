{
  imports = [
    ./hollow-crown.nix
    ./notes.nix
  ];

  config = {
    home.file = {
      "Pictures/logo.png".source = ./logo.png;
      "Pictures/smiley.png".source = ./smiley.png;
    };
  };
}
