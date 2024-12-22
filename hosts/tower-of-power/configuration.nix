{ inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  users = {
    cethien.enable = true;
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

  desktop-environment.gnome.enable = true;

  theming = {
    catppuccin.enable = true;
    fonts.enable = true;
  };

  apps = {
    steam.enable = true;
  };

  virt = {
    docker.enable = true;
    docker.liveRestore = true;
    docker.users = [ "cethien" ];

    kvm.enable = true;
    kvm.users = [ "cethien" ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users."cethien" = import ./home.nix;
    backupFileExtension = "hm-backup-$(date +%Y%m%d_%H%M%S)";
  };
}
