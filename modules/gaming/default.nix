{ system, ... }:

{
  imports = [
    ./nvidia.nix
    ./steam.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  steam.enable = !system.profile.isPortableDevice;
  nvidia.enable = !system.profile.isPortableDevice;
}