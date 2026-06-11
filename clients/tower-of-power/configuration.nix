{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../_common/configuration.nix
    ./disko.nix
  ];
  config = {
    programs.steam.enable = true;

    };

    # nvidia gpu
    services.xserver.videoDrivers = ["nvidia"];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    # services.pipewire.active-mic = "alsa_input.usb-3142_Fifine_Microphone-00.mono-fallback";

    hardware = {
      enableRedistributableFirmware = true;
      enableAllFirmware = true;

      bluetooth.settings = {
        General = {
          SecureConnections = "off";
          JustWorksRepairing = "always";

          ControllerMode = "bredr";
          FastConnectable = "true";
        };
      };

      logitech.wireless.enable = true;
      xpadneo.enable = true;

      # scanner
      sane.extraBackends = [pkgs.hplip];
    };

    services.udev.packages = with pkgs; [
      game-devices-udev-rules
      logitech-udev-rules
    ];

    services.udev.extraRules = ''
      KERNEL=="hidraw\*", ATTRS{idProduct}=="6012", ATTRS{idVendor}=="2dc8", MODE="0660", GROUP="input"
      KERNEL=="hidraw*", ATTRS{idProduct}=="6012", ATTRS{idVendor}=="2dc8", MODE="0660", TAG+="uaccess"
      KERNEL=="hidraw\*", KERNELS=="\*2DC8:6012\*", MODE="0660", GROUP="input"
      KERNEL=="hidraw*", KERNELS=="*2DC8:6012*", MODE="0660", TAG+="uaccess"
    '';

    virtualisation = {
      docker.enable = true;
      libvirtd.enable = true;
    };

    boot = {
      plymouth = {
        theme = "rings_2";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["rings_2"];
          })
        ];
      };
    };
  };
}
