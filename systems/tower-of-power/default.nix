{ config, meta, ... }:

{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  # DO NOT CHANGE IF YOU DON'T KNOW WHAT YOU ARE DOING
  system.stateVersion = "25.05";

  deeznuts = {
    nix.enable = true;
    nixpkgs.allowUnfree = true;

    boot.grub = {
      enable = true;
      device = "/dev/nvme0n1";
    };

    networking = {
      enable = true;
      hostName = meta.hostname;
      networkManager.enable = true;
    };

    localization = {
      enable = true;
      timeZone = "Europe/Berlin";
      locale = "en_US.UTF-8";
      extraLocale = "de_DE.UTF-8";
    };

    keymapping = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "nodeadkeys";
      };
      keyMap = "de-latin1-nodeadkeys";
    };


    hardware = {
      nvidia-gpu.enable = true;

      pipewire.enable = true;

      logitech-peripherals.enable = true;
      stream-deck.enable = true;
      xbox-controller.enable = true;

      bluetooth.enable = true;
    };

    services = {
      ssh.enable = true;
      print.enable = true;
    };

    users = {
      cethien.enable = true;
    };

    catppuccin.enable = true;

    desktop = {
      plasma.enable = true;
      autoLogin.enable = true;
      autoLogin.user = config.users.users.cethien.name;
    };

    apps = {
      home-manager.enable = true;
      steam.enable = true;
    };

    virtualisation = {
      docker.enable = true;
      docker.liveRestore = true;
      docker.users = [ config.users.users.cethien.name ];

      kvm.enable = true;
      kvm.users = [ config.users.users.cethien.name ];
    };
  };
}
