{
  imports = [
    ./stylix.nix
    ./sops.nix

    ./restic.nix

    ./bash.nix
    ./zsh.nix
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

    ./browser
    ./keepassxc.nix
    ./office.nix

    ./spotify.nix
    ./discord.nix
    ./creative.nix
    ./gaming

    ./freerdp.nix
  ];

  programs = {
    bash.enable = true;
    zsh.enable = true;
  };

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";
  stylix.enable = true;
}
