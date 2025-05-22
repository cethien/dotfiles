{
  imports = [
    ../../shared/nixpkgs
    ./nix

    ./users

    ./programs
    ./desktop
    ./hardware
    ./services
    ./virtualisation
  ];

  programs.command-not-found.enable = true;
}
