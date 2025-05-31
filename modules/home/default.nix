{
  imports = [
    ../../shared/nixpkgs
    ./programs
    ./assets
    ./stylix
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  news.display = "silent";
}
