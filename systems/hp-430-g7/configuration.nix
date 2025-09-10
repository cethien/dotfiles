{pkgs, ...}: let
  user = "cethien";
in {
  imports = [
    ../../modules/nixos
  ];
  networking.hostName = "hp-430-g7";
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth.theme = "polaroid";

  networking.networkmanager.wifi.backend = "iwd";
  hardware.enableRedistributableFirmware = true;

  services.openssh.enable = false;
  services.printing.enable = true;
  hardware = {
    bluetooth.enable = true;
    xpadneo.enable = true;
  };

  deeznuts = {
    desktop = {
      autologinUser = user;
      hyprland.enable = true;
    };

    audio.enable = true;
    steam.enable = true;

    virtualisation = {
      docker.enable = true;
      docker.users = [user];
      libvirt.enable = true;
      libvirt.users = [user];
    };
  };
}
