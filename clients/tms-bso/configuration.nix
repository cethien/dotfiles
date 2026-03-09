{
  pkgs,
  config,
  ...
}: let
  user = config.users.users.bsotnikow;
in {
  imports = [
    ../../modules/nixos
  ];
  services.fprintd.enable = true;

  security.pki.certificateFiles = [
    ./root_ca.crt
    ./intermediate_ca.crt
  ];

  services.tailscale = {
    enable = true;
    extraSetFlags = ["--operator=${user.name}"];
  };
  # services.pipewire.active-mic = "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback";

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
      autologinUser = "bsotnikow";
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
