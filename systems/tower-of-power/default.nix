{
  pkgs,
  inputs,
  stateVersion,
  ...
}:
inputs.nixpkgs.lib.nixosSystem {
  specialArgs = {inherit inputs;};
  modules = [
    ./hardware.nix
    ../../modules/nixos
    {
      system.stateVersion = stateVersion;
      networking.hostName = "tower-of-power";
      boot.loader.grub.device = "/dev/nvme0n1";
      boot.kernelPackages = pkgs.linuxPackages_zen;

      deeznuts = {
        hardware = {
          nvidia-gpu.enable = true;
          logitech-peripherals.enable = true;
          stream-deck.enable = true;
          xbox-controller.enable = true;
        };

        programs.steam.enable = true;

        virtualisation = {
          docker.enable = true;
          kvm.enable = true;
        };
      };
    }
  ];
}
