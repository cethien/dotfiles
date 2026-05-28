{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
  hl = config.programs.hyprland.enable;
  gnome = config.services.desktopManager.gnome.enable;
  desktop = hl || gnome;
  u = config.users.users.cethien;
in {
  imports = [
    ../../shared/users/cethien.nix

    ./gnome.nix
    ./hyprland.nix
    ./pipewire.nix
    ./steam.nix
  ];

  config = {
    security.sudo.extraConfig = ''
      Defaults timestamp_timeout=30
      Defaults pwfeedback
      Defaults insults
    '';
    users.groups.nettools = {};
    security.wrappers = {
      ping = {
        owner = "root";
        group = "nettools";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.iputils.out}/bin/ping";
      };

      trippy-cap = {
        owner = "root";
        group = "nettools";
        permissions = "u=rx,g=rx,o="; # Only owner (root) and group (nettools) can execute
        capabilities = "cap_net_raw+ep";
        source = "${pkgs.trippy}/bin/trip";
      };

      tshark-cap = {
        owner = "root";
        group = "nettools";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw,cap_net_admin=ep";
        source = "${pkgs.tshark}/bin/dumpcap";
      };

      termshark-cap = {
        owner = "root";
        group = "nettools";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw,cap_net_admin+eip";
        source = "${pkgs.termshark}/bin/termshark";
      };
    };
    users.users.cethien.extraGroups =
      [
        "nettools"
      ]
      ++ lib.optionals desktop ["audio"]
      ++ lib.optionals (config.hardware.uinput.enable) ["uinput" "input"]
      ++ lib.optionals (config.hardware.sane.enable) ["scanner"];

    services.pipewire.enable = desktop;

    services.printing.enable = mkDefault true;

    hardware = {
      bluetooth.enable = mkDefault true;
      sane.enable = mkDefault true;
    };

    programs.virt-manager.enable = desktop && config.virtualisation.libvirtd.enable;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };
    };

    programs.command-not-found.enable = true;

    time.timeZone = "Europe/Berlin";
    console.keyMap = "de-latin1-nodeadkeys";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = let
      formattingLocale = "de_DE.UTF-8";
    in {
      # LC_TIME = formattingLocale;
      LC_MEASUREMENT = formattingLocale;
      LC_NUMERIC = formattingLocale;
      LC_NAME = formattingLocale;
      LC_IDENTIFICATION = formattingLocale;
      LC_TELEPHONE = formattingLocale;
      LC_ADDRESS = formattingLocale;
      LC_MONETARY = formattingLocale;
      LC_PAPER = formattingLocale;
    };

    users.users.cethien.enable = true;
    services.displayManager = lib.mkIf hl {
      autoLogin.user = u.name;
    };

    hardware.uinput.enable = mkDefault true;
    networking.networkmanager.enable = mkDefault true;
    networking.networkmanager.wifi.backend = mkDefault "iwd";

    nix = {
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      settings = {
        extra-experimental-features = "nix-command flakes";
        warn-dirty = false;
        trusted-users = ["@wheel"];
        allowed-users = ["@wheel"];
      };
    };

    boot = {
      loader = {
        efi.canTouchEfiVariables = mkDefault true;
        grub = {
          enable = mkDefault true;
          efiSupport = mkDefault true;
          timeoutStyle = mkDefault "hidden";
        };
        timeout = 0;
      };

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      plymouth = {
        enable = true;
      };
    };
  };
}
