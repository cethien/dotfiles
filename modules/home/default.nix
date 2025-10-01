{
  imports = [
    ./assets
    ./stylix.nix
    ./sops.nix

    ./storage.nix

    ./desktop
    ./terminals.nix

    ./essentials.nix
    ./utils.nix
    ./utils-net.nix
    ./utils-remote.nix
    ./qol
    ./dev
    ./fun.nix

    ./logitech-peripherals.nix
    ./elgato-stream-deck.nix

    ./browser
    ./keepassxc.nix
    ./pim.nix

    ./spotify.nix
    ./discord.nix
    ./creative.nix
    ./gaming.nix
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";
  stylix.enable = true;
}
