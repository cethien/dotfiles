{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nixos
  ];

  users.users.cethien.enable = true;

  programs.steam.enable = true;

  # nvidia gpu
  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  services.pipewire.active-mic = "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback";

  services.printing.enable = true;
  hardware = {
    enableRedistributableFirmware = true;
    enableAllFirmware = true;

    bluetooth.enable = true;
    bluetooth.settings = {
      General = {
        ControllerMode = "bredr";
        FastConnectable = "true";
      };
    };

    logitech.wireless.enable = true;
    xpadneo.enable = true;

    # scanner
    sane.enable = true;
    sane.extraBackends = [pkgs.hplip];
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  deeznuts = {
    desktop = {
      autologinUser = "cethien";
      hyprland.enable = true;
    };
    net-tools.enable = true;
  };

  networking.hostName = "tower-of-power";

  boot = {
    loader.grub.splashImage = ./grub.jpg;
    plymouth = {
      enable = true;
      theme = "rings_2";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["rings_2"];
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

      "btusb.enable_autosuspend=n"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };
}
