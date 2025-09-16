{lib, ...}:
with lib; {
  imports = [
    ./assets
    ./stylix
    ./sops.nix

    ./programs/storage.nix

    ./programs/desktop/hyprland
    ./programs/desktop/gnome.nix
    ./programs/terminals.nix

    ./programs/qol
    ./programs/dev
    ./programs/fun.nix
    ./programs/essentials
    ./programs/utils-net.nix
    ./programs/utils
    ./programs/neovim
    ./programs/fastfetch

    ./programs/logitech-peripherals.nix
    ./programs/elgato-stream-deck.nix

    ./programs/browser
    ./programs/keepassxc.nix
    ./programs/pim.nix
    ./programs/taskwarrior.nix
    ./programs/slides.nix

    ./programs/spotify.nix
    ./programs/discord.nix
    ./programs/creative.nix
    ./programs/audio.nix

    ./programs/rnote.nix
    ./programs/gaming
  ];

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";

  deeznuts = {
    stylix.enable = mkDefault true;
    programs = {
      essentials.enable = mkDefault true;
      neovim.enable = mkDefault true;
      taskwarrior.enable = true;
      slides.enable = true;
      utils.enable = mkDefault true;
      net.enable = mkDefault true;

      qol.enable = mkDefault true;
      dev.enable = mkDefault true;
      fun.enable = mkDefault true;
      fastfetch.enable = mkDefault true;
    };
  };
}
