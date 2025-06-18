let
  user = "cethien";
in {
  imports = [
    ../../modules/nixos
  ];
  networking.hostName = "hp-430-g7";
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.networkmanager.wifi.backend = "iwd";
  hardware.enableRedistributableFirmware = true;

  services.openssh.enable = false;
  services.printing.enable = true;
  hardware = {
    bluetooth.enable = true;
    xpadneo.enable = true;
  };

  deeznuts = {
    hyprland.enable = true;
    hyprland.autologinUser = user;
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
