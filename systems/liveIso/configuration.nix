{
  pkgs,
  modulesPath,
  ...
}: let
  user = "cethien";
in {
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ../../modules/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages;
  networking.networkmanager.enable = false;
  services.printing.enable = true;
  deeznuts = {
    audio.enable = true;
  };
}
