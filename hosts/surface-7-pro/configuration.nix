{ inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
      inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "surface-7-pro";
}
