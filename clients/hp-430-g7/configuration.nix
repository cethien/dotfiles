{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  user = config.users.users.cethien;
in {
  imports = [
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ../_common/configuration.nix
    ../_common/disko.nix
    ../tms-bso/smb
  ];

  config = {
    services.tailscale = {
      enable = true;
      extraSetFlags = ["--operator=${user.name}"];
    };

    sops.age.sshKeyPaths = [
      "${user.home}/.ssh/id_ed25519"
      "${user.home}/.ssh/id_ed25519_tmsproshop_bsotnikow"
    ];

    services.tms-shares = {
      enable = true;
      automount = false;
      path = "${config.users.users.cethien.home}/tms-shares";
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
