{ inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "tower-of-power";

  hardware.bluetooth.enable = true;
  audio.pipewire.enable = true;

  desktop = {
    fonts.enable = true;
    theming.enable = true;
    environment.plasma.enable = true;
  };

  peripherals = {
    print.enable = true;
    logitech.enable = true;
    xbox-controller.enable = true;
    streamdeck.enable = true;
  };

  gaming = {
    opengl.enable = true;
    nvidia.enable = true;
    steam.enable = true;
  };

  virtualizing = {
    vms.enable = true;
    vms.users = [ "cethien" ];

    docker.enable = true;
    docker.liveRestore = true;
    docker.users = [ "cethien" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."cethien" = import ./home.nix;
    backupFileExtension = "hm-backup-$(date +%Y%m%d_%H%M%S)";
  };
}
