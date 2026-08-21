{
  lib,
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  hostName,
  stateVersion,
  ...
}: let
  inherit (lib) mkDefault optionals;
  hl = config.programs.hyprland.enable;
  virt = config.virtualisation.libvirtd.enable;
  docker = config.virtualisation.docker.enable;
  gnome = config.services.desktopManager.gnome.enable;
  desktop = hl || gnome;
  username = "cethien";
  u = config.users.users.cethien;
in {
  imports = [
    ../../modules/client
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    users.users.cethien.name = mkDefault username;
    home-manager = {
      useUserPackages = true;
      backupFileExtension = "hm-bak";
      extraSpecialArgs = {inherit inputs pkgs-unstable;};

      sharedModules = [
        ../../modules/home
        inputs.sops-nix.homeManagerModules.sops
      ];

      users."${username}" = {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = config.nixpkgs.overlays;

        imports = [
          inputs.spicetify-nix.homeManagerModules.default
          ./home
          ../${hostName}/home.nix
        ];
        home.username = username;
        home.homeDirectory = "/home/${username}";
        home = {inherit stateVersion;};
        home.enableNixpkgsReleaseCheck = false;

        services.udiskie.enable = config.services.udisks2.enable;
        services.udiskie.tray = "never";

        wayland.windowManager.hyprland = {
          enable = mkDefault hl;
          package = config.programs.hyprland.package;
          portalPackage = config.programs.hyprland.portalPackage;
          # https://wiki.hypr.land/Useful-Utilities/Systemd-start/#uwsm
          systemd.enable = !config.programs.hyprland.withUWSM;
        };
        programs.steam.enable = config.programs.steam.enable;
        programs.lazydocker.enable = docker;
        programs.vm-curator.enable = virt;
      };
    };

    programs.hyprland.enable = mkDefault true;

    users.groups.net-caps = {};

    security.wrappers = {
      trip = {
        owner = "root";
        group = "net-caps";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs-unstable.trippy}/bin/trip";
      };

      dumpcap = {
        owner = "root";
        group = "net-caps";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw,cap_net_admin+ep";
        source = "${pkgs-unstable.wireshark-cli}/bin/dumpcap";
      };

      arp-scan = {
        owner = "root";
        group = "net-caps";
        permissions = "u=rx,g=rx,o=";
        capabilities = "cap_net_raw+ep";
        source = "${pkgs-unstable.arp-scan}/bin/arp-scan";
      };
    };
    users.users.cethien.extraGroups =
      [
        "net-caps"
      ]
      ++ optionals desktop ["audio"]
      ++ optionals (config.hardware.uinput.enable) ["uinput" "input"]
      ++ optionals (config.hardware.sane.enable) ["scanner"];

    security.sudo.extraConfig = ''
      Defaults:${u.name} pwfeedback
      Defaults:${u.name} insults
      Defaults:${u.name} timestamp_timeout=30
    '';

    security.sudo.extraRules = [
      {
        users = [u.name];
        commands = [
          {
            command = "/run/current-system/sw/bin/nixos-rebuild switch *";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    services.pipewire.enable = desktop;

    services.printing.enable = mkDefault true;

    hardware = {
      bluetooth.enable = mkDefault true;
      sane.enable = mkDefault true;
    };

    programs.virt-manager.enable = desktop && virt;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        qemu = {
          package = pkgs-unstable.qemu_kvm;
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
      autoLogin.user = username;
    };

    hardware.uinput.enable = mkDefault true;
    networking.networkmanager.enable = mkDefault true;
    networking.networkmanager.wifi.backend = mkDefault "iwd";

    networking.firewall = let
      hmConfig = config.home-manager.users.${username};

      kdeConnectEnabled = hmConfig.services.kdeconnect.enable;
      localSendEnabled = hmConfig.programs.localsend.enable or hmConfig.programs.jocalsend.enable;
      userPkgs = hmConfig.home.packages or [];
      hasAusweisApp = builtins.any (pkg: pkg.pname or "" == "ausweisapp") userPkgs;
    in {
      allowedTCPPorts =
        optionals localSendEnabled [53317]
        ++ optionals hasAusweisApp [24727];

      allowedUDPPorts =
        optionals localSendEnabled [53317]
        ++ optionals hasAusweisApp [24727];

      allowedTCPPortRanges = optionals kdeConnectEnabled [
        {
          from = 1714;
          to = 1764;
        }
      ];

      allowedUDPPortRanges = optionals kdeConnectEnabled [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };

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
        systemd-boot.enable = mkDefault true;
        efi.canTouchEfiVariables = mkDefault true;
        timeout = 0;
      };
      plymouth.enable = true;

      consoleLogLevel = 3;
      initrd.verbose = false;

      kernelPackages = pkgs-unstable.linuxPackages_latest;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
        "vt.global_cursor_default=0"
        "plymouth.ignore-serial-consoles"
      ];
    };
  };
}
