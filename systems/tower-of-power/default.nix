{ pkgs, ... }:
let
  user = "cethien";
  formattingLocale = "de_DE.UTF-8";
in
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    loader.grub = {
      enable = true;
      device = "/dev/nvme0n1";
    };
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  hardware.bluetooth.enable = true;

  services.printing.enable = true;

  deeznuts = {
    nix.enable = true;
    nixpkgs.allowUnfree = true;

    hardware = {
      nvidia-gpu.enable = true;

      pipewire.enable = true;

      logitech-peripherals.enable = true;
      stream-deck.enable = true;
      xbox-controller.enable = true;
    };

    services = {
      ssh.enable = true;
    };

    users = {
      cethien.enable = true;
    };

    catppuccin.enable = true;

    desktop = {
      hyprland.enable = true;

      autoLogin.enable = true;
      autoLogin.user = user;
    };

    apps = {
      steam.enable = true;
    };

    virtualisation = {
      docker = {
        enable = true;
        liveRestore = true;
        users = [ user ];
      };

      kvm = {
        enable = true;
        users = [ user ];
      };
    };
  };
}
