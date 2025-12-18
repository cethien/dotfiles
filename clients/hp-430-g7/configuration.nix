{
  pkgs,
  nixos-hardware,
  ...
}: {
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    ../../modules/nixos
  ];

  programs.zsh.enable = true;
  users.users.cethien.enable = true;
  users.users.cethien.shell = pkgs.zsh;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.grub.device = "/dev/nvme0n1";

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

  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = ["--operator=cethien"];
  services.tailscale.extraUpFlags = ["--accept-routes"];

  deeznuts = {
    desktop = {
      autologinUser = "cethien";
      hyprland.enable = true;
    };
  };
}
