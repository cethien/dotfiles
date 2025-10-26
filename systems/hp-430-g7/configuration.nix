{
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    ./hardware.nix
    nixos-hardware.nixosModules.common-pc-laptop
    ../../modules/nixos
  ];

  users.users.cethien.enable = true;

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
  networking.firewall = {
    allowedTCPPorts = [
      53317 # localsend
      24727 # ausweisapp
    ];
    allowedUDPPorts = [
      53317 # localsend
      24727 # ausweisapp
    ];
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
      ];
    };
    bluetooth.enable = true;

    # scanner
    sane.enable = true;
    sane.extraBackends = [pkgs.hplip];
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
}
