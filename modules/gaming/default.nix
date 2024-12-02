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

  steam.enable = !system.profile.isSurface;
  nvidia.enable = !system.profile.isSurface;
}