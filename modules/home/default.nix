{
  imports = [
    ../../shared/nixpkgs
    ./programs
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  news.display = "silent";
}
