{
  lib,
  config,
  pkgs,
  sops-nix,
  ...
}: let
  u = config.users.users.cethien;
  uname = "bsotnikow";
in {
  imports = [
    ../../modules/nixos
    sops-nix.nixosModules.sops
    ./smb.nix
  ];

  users.users.cethien.name = uname;
  home-manager.users.cethien.home = {
    username = lib.mkForce uname;
    homeDirectory = lib.mkForce "/home/${uname}";
  };

  services.fprintd.enable = true;

  sops.age.sshKeyPaths = ["${u.home}/.ssh/id_ed25519"];

  security.pki.certificateFiles = [
    ./root_ca.crt
    ./intermediate_ca.crt
  ];

  services.tailscale = {
    enable = true;
    extraSetFlags = ["--operator=${u.name}"];
  };

  # services.pipewire.active-mic = "alsa_input.pci-0000_07_00.6.analog-stereo";

  musnix.kernel.realtime = false;

  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;

    bluetooth.enable = true;

    # scanner
    sane.enable = true;
  };
  services.printing.enable = true;

  hardware.printers = {
    ensurePrinters = [
      {
        name = "Epson_ET5880";
        location = "Office";
        description = "Epson EcoTank ET-5880";
        deviceUri = "ipp://10.102.99.208/ipp/print";
        model = "everywhere";
      }
    ];
    ensureDefaultPrinter = "Epson_ET5880";
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  deeznuts = {
    desktop = {
      autologinUser = "${u.name}";
      hyprland.enable = true;
    };
    net-tools.enable = true;
  };

  networking.networkmanager.wifi.backend = "iwd";

  boot = {
    loader.grub.splashImage = ./grub.jpg;
    plymouth = {
      enable = true;
      theme = "colorful_sliced";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["colorful_sliced"];
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
