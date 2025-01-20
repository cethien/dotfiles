{ pkgs, ... }:
let
  user = "cethien";
  formattingLocale = "de_DE.UTF-8";
in
{
  imports = [
    ../../modules/nixos
    ./hardware.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;

    loader.efi.canTouchEfiVariables = true;
    loader.grub = {
      enable = true;
      efiSupport = true;
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

    services = {
      ssh.enable = true;
      pipewire.enable = true;
    };

    users = {
      cethien.enable = true;
    };

    desktop = {
      hyprland.enable = true;

      autoLogin.enable = true;
      autoLogin.user = user;
    };

    programs = {
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
