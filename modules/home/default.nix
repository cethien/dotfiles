{lib, ...}:
with lib; {
  imports = [
    ./assets
    ./stylix
    ./sops.nix

    ./storage.nix

    ./desktop/hyprland
    ./desktop/gnome.nix
    ./terminals.nix

    ./qol
    ./dev
    ./fun.nix
    ./essentials
    ./utils-net.nix
    ./utils
    ./neovim
    ./fastfetch

    ./logitech-peripherals.nix
    ./elgato-stream-deck.nix

    ./browser
    ./keepassxc.nix
    ./pim.nix
    ./taskwarrior.nix
    ./slides.nix

    ./spotify.nix
    ./discord.nix
    ./creative.nix
    ./audio.nix

    ./gaming.nix
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";

  stylix.enable = mkDefault true;

  deeznuts = {
    dev.enable = mkDefault true;
    programs = {
      essentials.enable = mkDefault true;
      neovim.enable = mkDefault true;
      taskwarrior.enable = true;
      slides.enable = true;
      utils.enable = mkDefault true;
      net.enable = mkDefault true;

      qol.enable = mkDefault true;
      fun.enable = mkDefault true;
      fastfetch.enable = mkDefault true;
    };
  };
}
