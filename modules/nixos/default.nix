{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
  user = "cethien";
in {
  imports = [
    ./users
    ./ansible.nix
    ./deployrs.nix
    ./hardware
    ./virtualisation
    ./audio.nix
    ./hyprland.nix
    ./steam.nix
    ./ai.nix
    ./monitoring.nix
  ];

  deeznuts.users.${user}.enable = true;

  services.openssh = {
    enable = mkDefault true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

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

  networking.networkmanager.enable = mkDefault true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      extra-experimental-features = "nix-command flakes";
      warn-dirty = false;
      trusted-users = ["@wheel"];
      allowed-users = ["@wheel"];
    };
  };

  boot = {
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
    loader.efi.canTouchEfiVariables = mkDefault true;
    loader.grub = {
      enable = mkDefault true;
      efiSupport = mkDefault true;
    };
  };
}
