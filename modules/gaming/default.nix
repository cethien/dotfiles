{ system, ... }:

{
  imports = [
    ./nvidia.nix
    ./steam.nix
    ./retroarch.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  gaming.steam.enable = !system.profile.isSurface;
  gaming.nvidia.enable = !system.profile.isSurface;
  gaming.retroarch.enable = !system.profile.isSurface;
}