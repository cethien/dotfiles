{
  pkgs,
  lib,
  ...
}: let
  user = "cethien";
in {
  imports = [
    ./users

    ./programs
    ./desktop
    ./hardware
    ./services
    ./virtualisation
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = true;
      efiSupport = true;
    };
  };

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

  networking.networkmanager.enable = true;
  programs.command-not-found.enable = true;
  hardware.bluetooth.enable = true;
  services.printing.enable = true;

  deeznuts = {
    services = {
      ssh.enable = true;
      pipewire.enable = true;
    };

    users.${user}.enable = true;

    desktop = {
      hyprland.enable = true;
      autoLogin.enable = true;
      autoLogin.user = user;
    };

    virtualisation = {
      docker = {
        enable = lib.mkDefault false;
        liveRestore = true;
        users = [user];
      };
      kvm = {
        enable = lib.mkDefault false;
        users = [user];
      };
    };
  };
}
