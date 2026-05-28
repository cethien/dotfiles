{
  pkgs,
  config,
  nixos-hardware,
  ...
}: let
  user = config.users.users.cethien;
in {
  imports = [
    nixos-hardware.nixosModules.common-pc-laptop
    ../_common/configuration.nix
    ../_common/disko.nix
  ];

  config = {
    programs.hyprland.enable = true;

    security.pki.certificateFiles = [
      ../tms-bso/root_ca.crt
      ../tms-bso/intermediate_ca.crt
    ];

    services.tailscale = {
      enable = true;
      extraSetFlags = ["--operator=${user.name}"];
    };

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

    # services.pipewire.active-mic = "alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__Mic1__source";

    hardware = {
      enableRedistributableFirmware = true;
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
        ];
      };

      # scanner
      sane.extraBackends = [pkgs.hplip];
    };
    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    boot = {
      loader.grub.splashImage = ./grub.jpg;
      plymouth = {
        theme = "polaroid";
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override {
            selected_themes = ["polaroid"];
          })
        ];
      };
    };
  };
}
