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

  gaming.nvidia.enable = system.profile.isHomePC;
  
  gaming.steam.enable = system.profile.isHomePC;
  gaming.retroarch.enable = system.profile.isHomePC;
}