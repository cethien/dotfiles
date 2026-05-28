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
    sops-nix.nixosModules.sops
    ../_common/configuration.nix
    ../_common/disko.nix
    ./smb.nix
  ];

  programs.hyprland.enable = true;
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
  };

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

  boot = {
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
    };

    plymouth = {
      theme = "colorful_sliced";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["colorful_sliced"];
        })
      ];
    };
  };
}
