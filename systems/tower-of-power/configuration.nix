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

  deeznuts = let
    user = "cethien";
  in {
    hardware = ["nvidia-gpu" "logitech" "elgato-stream-deck"];

    users = [user];
    virtualisation = {
      docker.enable = true;
      docker.users = [user];
      libvirt.enable = true;
      libvirt.users = [user];
    };

    desktop = {
      autologinUser = user;
      hyprland.enable = true;
    };
    audio.enable = true;
    steam.enable = true;
  };
}
