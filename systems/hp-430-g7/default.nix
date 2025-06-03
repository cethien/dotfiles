{
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
      networking.hostName = "hp-430-g7";
      boot.loader.grub.device = "/dev/nvme0n1";
      deeznuts = {
        hardware.logitech-peripherals.enable = true;
        hardware.xbox-controller.enable = true;
        programs.steam.enable = true;
        virtualisation.docker.enable = true;
      };
    }
  ];
}
