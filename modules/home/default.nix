{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./stylix.nix
    ./sops.nix

    ./restic.nix

    ./desktop
    ./terminals.nix

    ./tmux.nix
    ./ssh.nix
    ./neovim.nix
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
    ./slack.nix
  ];

  programs = {
    bash.enable = true;
    tmux.enable = true;
    nvf.enable = true;
    ssh.enable = true;
  };

  home.packages = with pkgs; [
    curl
    wget
  ];

  stylix.enable = true;

  xdg.mimeApps.enable = true;
  programs.home-manager.enable = true;
  services.home-manager.autoExpire = {
    enable = true;
    frequency = "weekly";
  };
  news.display = "silent";
}
