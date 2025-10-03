{pkgs, ...}: {
  imports = [
    ../../modules/nixos
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=0"
      "rd.systemd.show_status=false"
      "systemd.show_status=false"
      "vt.global_cursor_default=0"
    ];

    loader.grub.device = "/dev/nvme0n1";

    consoleLogLevel = 0;
    initrd.systemd.enable = true;
    initrd.verbose = false;
    plymouth.enable = true;
    plymouth.theme = "polaroid";
  };

  networking.hostName = "hp-430-g7";
  networking.networkmanager.wifi.backend = "iwd";

  # scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [pkgs.hplip];

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
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  deeznuts = {
    desktop = {
      autologinUser = "cethien";
      hyprland.enable = true;
    };
  };

  users.users.cethien.enable = true;
}
