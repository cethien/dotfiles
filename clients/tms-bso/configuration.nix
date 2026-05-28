{
  lib,
  config,
  pkgs,
  stateVersion,
  ...
}: let
  u = config.users.users.cethien;
in {
  imports = [
    ../_common/configuration.nix
    ../_common/disko.nix
    ./smb.nix
  ];
  users.users.cethien.name = "bsotnikow";
  home-manager.users.cethien = {
    home.username = lib.mkForce "bsotnikow";
    home.homeDirectory = lib.mkForce "/home/bsotnikow";
    # home = {inherit stateVersion;};
  };
  programs.hyprland.enable = true;
  services.fprintd.enable = true;

  sops.age.sshKeyPaths = ["${u.home}/.ssh/id_ed25519"];
  sops.defaultSopsFile = ./secrets.yml;

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
