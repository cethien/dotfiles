{
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    ../../modules/nixos
  ];

  services.pipewire.active-mic = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source";

  services.tailscale = {
    enable = true;
    extraSetFlags = ["--operator=cethien"];
    extraUpFlags = ["--accept-routes"];
  };

  users.users.cethien.enable = true;

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

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

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

  deeznuts = {
    desktop = {
      autologinUser = "cethien";
      hyprland.enable = true;
    };
    net-tools.enable = true;
  };

  networking.hostName = "hp-430-g7";

  boot = {
    loader.grub.device = "/dev/nvme0n1";

    loader.grub.splashImage = ./grub.jpg;
    plymouth = {
      enable = true;
      theme = "polaroid";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["polaroid"];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
}
