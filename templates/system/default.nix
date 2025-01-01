{ meta, ... }:
let
  user = "cethien";
in
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
    };

    hostname = meta.hostname;

    networking = {
      enable = true;
      networkManager.enable = true;
    };

    localization = {
      timeZone = "Europe/Berlin";
      locale = "en_US.UTF-8";
      extraLocale = "de_DE.UTF-8";
    };

    keymapping = {
      xkb = {
        layout = "de";
        variant = "nodeadkeys";
      };
    };

    services = {
      ssh.enable = true;
    };

    users = {
      cethien.enable = true;
    };

    virtualisation = {
      docker.enable = true;
      docker.users = [ user ];
    };
  };

}
