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
        networking.hostName = "tower-of-power";
        boot.loader.grub.device = "/dev/nvme0n1";
        boot.kernelPackages = pkgs.linuxPackages_zen;

        services.printing.enable = true;
        hardware = {
          bluetooth.enable = true;
          xpadneo.enable = true;
        };

        deeznuts = {
          hardware = {
            nvidia-gpu.enable = true;
            logitech-peripherals.enable = true;
            elgato-stream-deck.enable = true;
          };

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
