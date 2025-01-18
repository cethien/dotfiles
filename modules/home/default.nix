{
  imports = [
    ../../shared/nixpkgs
    ./programs
    ./desktop
  ];

  programs.home-manager.enable = true;
}
