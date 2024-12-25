{ ... }:

{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    enable = true;

    useOSProber = true;
    device = "/dev/nvme0n1";
  };

  deeznuts = {
    nix.enable = true;

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

    desktop = {
      plasma.enable = true;
      autoLogin.enable = true;
      autoLogin.user = "cethien";
    };

    theming = {
      catppuccin.enable = true;
      fonts.enable = true;
    };

    apps = {
      home-manager.enable = true;
      steam.enable = true;
    };

    virtualisation = {
      docker.enable = true;
      docker.liveRestore = true;
      docker.users = [ "cethien" ];

      kvm.enable = true;
      kvm.users = [ "cethien" ];
    };
  };

  # home-manager = {
  #   extraSpecialArgs = { inherit inputs; };
  #   users."cethien" = import ./home.nix;
  #   backupFileExtension = "hm-backup-$(date +%Y%m%d_%H%M%S)";
  # };
}
