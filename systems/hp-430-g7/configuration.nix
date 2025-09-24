{pkgs, ...}: {
  imports = [
    ../../modules/nixos
  ];
  networking.hostName = "hp-430-g7";
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth.theme = "polaroid";

  networking.networkmanager.wifi.backend = "iwd";

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.openssh.enable = false;
  services.printing.enable = true;
  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
    bluetooth.enable = true;
  };
  virtualisation.docker.enable = true;
  users.users.cethien.enable = true;

  deeznuts = {
    desktop = {
      autologinUser = "cethien";
      hyprland.enable = true;
    };
    audio.enable = true;
  };
}
