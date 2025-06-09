let
  user = "cethien";
in {
  imports = [
    ../../modules/nixos
  ];

  networking.hostName = "tower-of-power";
  boot.loader.grub.device = "/dev/nvme0n1";

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

    virtualisation = {
      docker.enable = true;
      docker.users = [user];
      libvirt.enable = true;
      libvirt.users = [user];
    };
  };
}
