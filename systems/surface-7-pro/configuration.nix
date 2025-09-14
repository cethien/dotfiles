{
  imports = [
    ../../modules/nixos
  ];
  networking.hostName = "surface-7-pro";
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.plymouth.theme = "sphere";

  networking.networkmanager.wifi.backend = "iwd";
  hardware.enableRedistributableFirmware = true;

  services.openssh.enable = false;
  services.printing.enable = true;
  hardware = {
    bluetooth.enable = true;
  };

  deeznuts = {
    desktop = {
      gnome.enable = true;
    };
    audio.enable = true;
  };
}
