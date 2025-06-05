{
  nixpkgs,
  pkgs,
  stateVersion,
  ...
}: let
  user = "cethien";
in
  nixpkgs.lib.nixosSystem {
    inherit pkgs;
    modules = [
      ./hardware.nix
      ../../modules/nixos
      {
        system.stateVersion = stateVersion;
        networking.hostName = "hp-430-g7";
        boot.loader.grub.device = "/dev/nvme0n1";

        services.openssh.enable = false;
        services.printing.enable = true;
        hardware = {
          bluetooth.enable = true;
          xpadneo.enable = true;
        };

        deeznuts = {
          hardware.logitech-peripherals.enable = true;
          hyprland.enable = true;
          hyprland.autologinUser = user;
          audio.enable = true;
          steam.enable = true;

          docker.enable = true;
          docker.users = [user];
          kvm.enable = true;
          kvm.users = [user];
        };
      }
    ];
  }
