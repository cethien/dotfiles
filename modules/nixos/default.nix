{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    ./users/cethien.nix

    ./ansible.nix
    ./deployrs.nix
    ./hardware
    ./virtualisation
    ./audio.nix
    ./desktop
    ./steam.nix
    ./ai.nix
    ./monitoring.nix
    ./ssh.nix
  ];

  environment.systemPackages = with pkgs; [
    vim
    tmux
    htop
  ];
  programs.command-not-found.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = let
    formattingLocale = "de_DE.UTF-8";
  in {
    LC_ADDRESS = formattingLocale;
    LC_IDENTIFICATION = formattingLocale;
    LC_MEASUREMENT = formattingLocale;
    LC_MONETARY = formattingLocale;
    LC_NAME = formattingLocale;
    LC_NUMERIC = formattingLocale;
    LC_PAPER = formattingLocale;
    LC_TELEPHONE = formattingLocale;
    LC_TIME = formattingLocale;
  };
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  console.useXkbConfig = true;

  hardware.uinput.enable = mkDefault true;

  networking.networkmanager.enable = mkDefault true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
    settings = {
      extra-experimental-features = "nix-command flakes";
      warn-dirty = false;
      trusted-users = ["@wheel"];
      allowed-users = ["@wheel"];
    };
  };

  boot = {
    loader.efi.canTouchEfiVariables = mkDefault true;
    loader.grub = {
      enable = mkDefault true;
      efiSupport = mkDefault true;
      timeoutStyle = mkDefault "hidden";
    };

    plymouth = {
      themePackages = mkDefault (with pkgs; [
        nixos-bgrt-plymouth
      ]);
      theme = mkDefault "bgrt";
    };
  };
}
