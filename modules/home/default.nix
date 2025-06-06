{lib, ...}: {
  imports = [
    ./programs
    ./assets
    ./stylix
    ./sops.nix
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";

  deeznuts.stylix.enable = lib.mkDefault true;
}
