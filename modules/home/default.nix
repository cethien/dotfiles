{
  imports = [
    ../../shared/nixpkgs
    ./programs
    ./assets
    ./stylix
    ./sops.nix
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  news.display = "silent";
}
