{
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

  users.users.cethien.enable = true;

  deeznuts = {
    hardware = ["nvidia-gpu" "logitech" "elgato-stream-deck"];

    virtualisation = {
      docker.enable = true;
      libvirt.enable = true;
    };

    desktop = {
      autologinUser = "cethien";
      hyprland.enable = true;
    };
    audio.enable = true;
    steam.enable = true;
  };
}
