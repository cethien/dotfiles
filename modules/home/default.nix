{
  imports = [
    ../../shared/nixpkgs
    ./programs
    ./assets
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  news.display = "silent";
}
